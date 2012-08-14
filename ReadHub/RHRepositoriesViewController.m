#import "RHRepositoriesViewController.h"
#import "RHAccount.h"
#import "RHRepository.h"

@implementation RHRepositoriesViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.repositories = [RHRepository allRepositories];
    }
    return self;
}

- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)refresh
{
    RHAccount *account = [RHAccount currentAccount];
    NSString *apiPath = account.organization ?
        [NSString stringWithFormat:@"/orgs/%@/repos", account.organization.login] :
        @"/user/repos";
    
    [RHGitHubOperation callAPI:apiPath
                        method:ISHTTPMethodGET
                       handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
                           if (error || response.statusCode != 200) {
                               return;
                           }
                           NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
                           
                           // add
                           NSMutableArray *array = [NSMutableArray arrayWithArray:self.repositories];
                           for (NSDictionary *dictionary in object) {
                               if (![RHRepository repositoryForID:[dictionary objectForKey:@"id"]]) {
                                   RHRepository *repository = [RHRepository repositoryWithDictionary:dictionary];
                                   if (repository) {
                                       [array addObject:repository];
                                       [context insertObject:repository];
                                   }
                               }
                           }
                           self.repositories = [NSArray arrayWithArray:array];
                           // TODO: remove
                           
                           // save and reload
                           [[ISDataManager sharedManager] saveContext];
                           [self.tableView reloadData];
                       }];
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repositories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Repository";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    RHRepository *repository = [self.repositories objectAtIndex:indexPath.row];
    cell.textLabel.text = repository.name;
    cell.detailTextLabel.text = repository.descriptor;
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

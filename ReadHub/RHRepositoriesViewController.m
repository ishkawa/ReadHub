#import "RHRepositoriesViewController.h"
#import "RHAccount.h"
#import "RHRepository.h"

@implementation RHRepositoriesViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self updateAccountContext];
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

- (void)updateAccountContext
{
    RHAccount *account = [RHAccount currentAccount];
    if (account.organization) {
        self.accountContext = account.organization;
    } else {
        self.accountContext = account.user;
    }
    self.repositories = [self.accountContext.repositories allObjects];
    [self.tableView reloadData];
}

- (void)refresh
{
    [self updateAccountContext];
    
    NSString *apiPath = @"/user/repos";
    if ([self.accountContext isKindOfClass:[RHOrganization class]]) {
        apiPath = [NSString stringWithFormat:@"/orgs/%@/repos", self.accountContext.login];
    }
    [RHGitHubOperation callAPI:apiPath
                        method:ISHTTPMethodGET
                       handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
                           if (error || response.statusCode != 200) {
                               return;
                           }
                           NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
                           
                           for (NSDictionary *dictionary in object) {
                               if (![RHRepository repositoryForID:[dictionary objectForKey:@"id"]]) {
                                   RHRepository *repository = [RHRepository repositoryWithDictionary:dictionary];
                                   if (repository) {
                                       [context insertObject:repository];
                                       [self.accountContext addRepositoriesObject:repository];
                                   }
                               }
                           }
                           [self updateAccountContext];
                           // TODO: remove
                           
                           // save and reload
                           [[ISDataManager sharedManager] saveContext];
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

#import "RHAccountContextsViewController.h"
#import "RHAccount.h"
#import "RHOrganization.h"

// displays {personal|organization} account

@implementation RHAccountContextsViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self loadAccountContexts];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)loadAccountContexts
{
    RHAccount *account = [RHAccount currentAccount];
    if (!account) {
        return;
    }
    NSArray *contexts = [NSArray arrayWithObject:account];
    if ([account.organizations count]) {
        contexts = [contexts arrayByAddingObjectsFromArray:[account.organizations allObjects]];
    }
}

- (void)refresh
{
    [RHGitHubOperation callAPI:@"/user/orgs"
                        method:ISHTTPMethodGET
                       handler:^(NSURLResponse *response, id object, NSError *error) {
                           if (error || ![object isKindOfClass:[NSArray class]]) {
                               return;
                           }
                           RHAccount *account = [RHAccount currentAccount];
                           NSMutableArray *array = [NSMutableArray array];
                           
                           // add
                           for (NSDictionary *dictionary in object) {
                               RHOrganization *organization = [RHOrganization organizationWithDictionary:dictionary];
                               [array addObject:organization];
                               if (![account.organizations containsObject:organization]) {
                                   [account addOrganizationsObject:organization];
                               }
                           }
                           
                           // remove
                           for (RHOrganization *organization in [account.organizations allObjects]) {
                               if (![array containsObject:organization]) {
                                   [account removeOrganizationsObject:organization];
                               }
                           }
                           
                           // save and reload
                           [[ISDataManager sharedManager] saveContext];
                           [self loadAccountContexts];
                           [self.tableView reloadData];
                       }];
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.accountContexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    id accountContext = [self.accountContexts objectAtIndex:indexPath.row];
    cell.textLabel.text = [accountContext description];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

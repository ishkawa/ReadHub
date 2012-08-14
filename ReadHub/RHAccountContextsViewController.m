#import "RHAccountContextsViewController.h"
#import "RHAccount.h"
#import "RHAccountContext.h"
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
    NSMutableArray *contexts = [NSMutableArray array];
    if (account.user) {
        [contexts addObject:account.user];
    }
    NSArray *organizations = [RHOrganization allOrganizations];
    if ([organizations count]) {
        [contexts addObjectsFromArray:organizations];
    }
    self.accountContexts = contexts;
}

- (void)refresh
{
    [RHGitHubOperation callAPI:@"/user/orgs"
                        method:ISHTTPMethodGET
                       handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
                           if (error || ![object isKindOfClass:[NSArray class]]) {
                               return;
                           }
                           NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
                           NSArray *receivedIDs = [object valueForKey:@"id"];
                           
                           // add
                           for (NSDictionary *dictionary in object) {
                               if (![RHOrganization organizationForID:[dictionary objectForKey:@"id"]]) {
                                   RHOrganization *organization = [RHOrganization organizationWithDictionary:dictionary];
                                   [context insertObject:organization];
                               }
                           }
                           
                           // remove
                           for (RHOrganization *organization in [RHOrganization allOrganizations]) {
                               if (![receivedIDs containsObject:organization.identifier]) {
                                   [context deleteObject:organization];
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
    RHAccount *account = [RHAccount currentAccount];
    
    id <RHAccountContext> accountContext = [self.accountContexts objectAtIndex:indexPath.row];
    cell.textLabel.text = accountContext.login;
    
    BOOL isOrganization = [accountContext isKindOfClass:[RHOrganization class]];
    RHOrganization *organization = isOrganization ? (RHOrganization *)accountContext : nil;
    if (organization == account.organization) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    RHAccount *account = [RHAccount currentAccount];
    id accountContext = [self.accountContexts objectAtIndex:indexPath.row];
    if ([accountContext isKindOfClass:[RHAccount class]]) {
        account.organization = nil;
    } else {
        account.organization = (RHOrganization *)accountContext;
    }
    [[ISDataManager sharedManager] saveContext];
    [self.tableView reloadData];
}

@end

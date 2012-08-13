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
                           RHAccount *account = [RHAccount currentAccount];
                           NSArray *receivedIDs = [object valueForKey:@"id"];
                           
                           // add
                           for (NSDictionary *dictionary in object) {
                               if (![RHOrganization organizationForID:[dictionary objectForKey:@"id"]]) {
                                   RHOrganization *organization = [RHOrganization organizationWithDictionary:dictionary];
                                   [context insertObject:organization];
                                   [account addOrganizationsObject:organization];
                               }
                           }
                           
                           // remove
                           for (RHOrganization *organization in [account.organizations allObjects]) {
                               if (![receivedIDs containsObject:organization.identifier]) {
                                   [context deleteObject:organization];
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

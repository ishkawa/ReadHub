#import "RHAccountContextsViewController.h"

// displays {personal|organization} account

@implementation RHAccountContextsViewController

- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)refresh
{
    [RHGitHubOperation callAPI:@"/user/orgs"
                        method:ISHTTPMethodGET
                       handler:^(NSURLResponse *response, id object, NSError *error) {
                           NSLog(@"%@", object);
                       }];
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end

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

@end

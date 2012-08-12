#import "RHHomeViewController.h"
#import "RHGitHubAuthViewController.h"

@implementation RHHomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"ReadHub";
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Account"
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(presentSettingView)];
    }
    return self;
}

- (void)presentSettingView
{
    RHGitHubAuthViewController *viewController = [[RHGitHubAuthViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.viewControllers = @[ viewController ];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end

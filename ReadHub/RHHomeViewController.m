#import "RHHomeViewController.h"
#import "RHAccount.h"
#import "RHGitHubAuthViewController.h"
#import "RHAccountContextsViewController.h"

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
        
        RHAccount *account = [RHAccount currentAccount];
        NSString *title = [NSString stringWithFormat:@"Context: %@", account];
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:title
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(presentAccountContextsView)];
    }
    return self;
}

- (void)presentAccountContextsView
{
    if (self.acccountContextsPopoverController) {
        [self.acccountContextsPopoverController dismissPopoverAnimated:YES];
        self.acccountContextsPopoverController = nil;
        return;
    }
    RHAccountContextsViewController *viewController = [[RHAccountContextsViewController alloc] init];
    self.acccountContextsPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [self.acccountContextsPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                                   permittedArrowDirections:UIPopoverArrowDirectionUp
                                                                   animated:YES];
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

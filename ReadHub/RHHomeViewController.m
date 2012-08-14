#import "RHHomeViewController.h"
#import "RHAccount.h"
#import "RHOrganization.h"
#import "RHGitHubAuthViewController.h"
#import "RHAccountContextsViewController.h"
#import "RHFeedViewController.h"
#import "RHRepositoriesViewController.h"

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
        NSString *title = [NSString stringWithFormat:@"Context: %@", account.organization ? account.organization.login : account.user.login];
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:title
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(presentAccountContextsView)];
        
        self.feedViewController = [[RHFeedViewController alloc] init];
        self.repositoriesViewController = [[RHRepositoriesViewController alloc] init];
        self.viewControllers = @[ self.feedViewController, self.repositoriesViewController ];
    }
    return self;
}

- (void)updateAccountContext
{
    RHAccount *account = [RHAccount currentAccount];
    NSString *title = [NSString stringWithFormat:@"Context: %@", account.organization ? account.organization.login : account.user.login];
    self.navigationItem.rightBarButtonItem.title = title;
    [self.repositoriesViewController refresh];
}

- (void)presentAccountContextsView
{
    if (self.acccountContextsPopoverController) {
        [self updateAccountContext];
        [self.acccountContextsPopoverController dismissPopoverAnimated:YES];
        self.acccountContextsPopoverController = nil;
        return;
    }
    RHAccountContextsViewController *viewController = [[RHAccountContextsViewController alloc] init];
    self.acccountContextsPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    self.acccountContextsPopoverController.delegate = self;
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

#pragma mark - popover controller delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.acccountContextsPopoverController = nil;
    [self updateAccountContext];
}

@end

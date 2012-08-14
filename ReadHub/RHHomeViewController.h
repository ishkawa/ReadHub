#import <UIKit/UIKit.h>

@class RHRepositoriesViewController;

@interface RHHomeViewController : UISplitViewController <UIPopoverControllerDelegate>

@property (strong, nonatomic) RHRepositoriesViewController *repositoriesViewController;
@property (strong, nonatomic) UIPopoverController *acccountContextsPopoverController;

@end

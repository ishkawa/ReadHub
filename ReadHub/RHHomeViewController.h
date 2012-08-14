#import <UIKit/UIKit.h>

@class RHFeedViewController;
@class RHRepositoriesViewController;

@interface RHHomeViewController : UISplitViewController <UIPopoverControllerDelegate>

@property (strong, nonatomic) RHFeedViewController *feedViewController;
@property (strong, nonatomic) RHRepositoriesViewController *repositoriesViewController;
@property (strong, nonatomic) UIPopoverController *acccountContextsPopoverController;

@end

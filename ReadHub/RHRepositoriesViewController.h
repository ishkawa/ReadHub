#import <UIKit/UIKit.h>
#import "RHAccountContext.h"

@interface RHRepositoriesViewController : UIViewController

<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id <RHAccountContext> accountContext;
@property (strong, nonatomic) NSArray *repositories;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

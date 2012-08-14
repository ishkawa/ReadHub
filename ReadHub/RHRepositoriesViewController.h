#import <UIKit/UIKit.h>

@interface RHRepositoriesViewController : UIViewController

<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *repositories;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

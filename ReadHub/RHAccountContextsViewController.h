#import <UIKit/UIKit.h>

@interface RHAccountContextsViewController : UIViewController

<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *accountContexts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

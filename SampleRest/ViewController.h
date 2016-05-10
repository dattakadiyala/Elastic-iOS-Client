

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tblShops;
@property (strong, nonatomic) IBOutlet UITextField *txtZipcode;

-(void)postDataToUrl:(NSString*)urlString withJson:(NSString*)jsonString;
- (IBAction)btnGetShops:(id)sender;

@end




#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

NSArray *tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)postDataToUrl:(NSString*)urlString withJson:(NSString*)jsonString
{
    NSData* responseData = nil;
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    responseData = [NSMutableData data] ;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"the final output is:%@",responseString);
                NSError *lerror = nil;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&lerror];
                
                if (error != nil) {
                    NSLog(@"Error parsing JSON.");
                }
                else {
                    NSLog(@"Dict: %@", jsonDict);
                    NSMutableArray *arrData = [NSMutableArray arrayWithCapacity:2];
                    
                    
                    
                    for (NSDictionary *dict in jsonDict[@"hits"][@"hits"]) {
                        [arrData addObject:dict[@"_source"][@"shopname"]];
                    }
                    
                    tableData = [NSArray arrayWithArray:arrData];
                    [self.tblShops setDataSource:self];
                    [self.tblShops reloadData];
                    
                }
                
            }] resume];
}

- (IBAction)btnGetShops:(id)sender {
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"query\":{\"bool\":{\"filter\":[{\"term\":{\"zip\":\"%@\"}}]}}}",[self.txtZipcode text]];
    
    [self postDataToUrl:@"https://manoj:rapxkgfn7qndu4l0eq@148932977deec4eb3965dcd2d6237e72.ap-southeast-1.aws.found.io:9243/attractions/_search" withJson:jsonRequest];
    
    [self.view setNeedsLayout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

@end

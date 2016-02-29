//
//  LCTableViewController.m
//  TableView
//
//  Created by zhangguang on 16/2/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "LCTableViewController.h"
#import "LCPlay.h"
#import "LCQuotation.h"



@interface LCTableViewController ()

@property (nonatomic,strong) NSMutableArray* plays;

@property (nonatomic,strong) NSMutableArray* sectionInfoArray;

@end

#pragma mark - *** Static Var ***
static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

#pragma mark - *** MACROS ***
#define DEFAULT_ROW_HEIGHT 88
#define HEADER_HEIGHT 48

@implementation LCTableViewController




#pragma mark - *** Properties ***
-(NSMutableArray*)plays
{
    if (!_plays) {
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"PlaysAndQuotations" withExtension:@"plist"];
        NSArray* playDictionariesArray = [[NSArray alloc] initWithContentsOfURL:url];
        _plays = [[NSMutableArray alloc] initWithCapacity:[playDictionariesArray count]];
        for (NSDictionary* itemDic in playDictionariesArray) {
            LCPlay* play = [[LCPlay alloc] init];
            play.name = [itemDic objectForKey:@"playName"];
            NSArray* quotationsDicArray = [itemDic objectForKey:@"quotations"];
            NSMutableArray* quotations = [[NSMutableArray alloc] initWithCapacity:[quotationsDicArray count]];
            for (NSDictionary* quotationDic in quotations) {
                LCQuotation* quotation = [[LCQuotation alloc] init];
                [quotation setValuesForKeysWithDictionary:quotationDic];
                [quotations addObject:quotation];
            }
            play.quotations = quotations;
        }
    }
    
    return _plays;
}


#pragma mark - *** Init View ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib* nib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.sectionInfoArray == nil ||
        self.sectionInfoArray.count != [self numberOfSectionsInTableView:self.tableView]) {
        NSMutableArray* infoArray = [[NSMutableArray alloc] init];
        for (LCPlay* play in self.plays) {
            
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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
#import "LCSectionInfo.h"
#import "LCQuoteCell.h"
#import "LCSectionHeaderView.h"


@interface LCTableViewController () <LCSectionHeaderViewDelegate>

@property (nonatomic,strong) NSMutableArray* plays;

@property (nonatomic,strong) NSMutableArray* sectionInfoArray;

@property (nonatomic,assign) NSUInteger openSectionIndex;

@property (nonatomic,strong) NSIndexPath* pinchedIndexPath;

@property (nonatomic,assign) NSUInteger initialPichedHeight;

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
            for (NSDictionary* quotationDic in quotationsDicArray) {
                LCQuotation* quotation = [[LCQuotation alloc] init];
                [quotation setValuesForKeysWithDictionary:quotationDic];
                [quotations addObject:quotation];
            }
            play.quotations = quotations;
            [_plays addObject:play];
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
    
    

    self.tableView.sectionHeaderHeight = 48;
    UINib* nib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    self.openSectionIndex = NSNotFound;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.sectionInfoArray == nil ||
        self.sectionInfoArray.count != [self numberOfSectionsInTableView:self.tableView]) {
        NSMutableArray* infoArray = [[NSMutableArray alloc] init];
        for (LCPlay* play in self.plays) {
            LCSectionInfo* sectionInfo = [[LCSectionInfo alloc] init];
            sectionInfo.play = play;
            sectionInfo.open = NO;
            
            NSNumber* defaultRowHeight = @(DEFAULT_ROW_HEIGHT);
            NSUInteger countOfQuotations = sectionInfo.play.quotations.count;
            for (int i = 0; i < countOfQuotations; i++) {
                [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
            }
            [infoArray addObject:sectionInfo];
        }
        self.sectionInfoArray = infoArray;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LCSectionInfo* sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    NSInteger countOfQuotations = [sectionInfo.play.quotations count];
    return sectionInfo.isOpen ? countOfQuotations : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* quoteCellIdentifier = @"QuoteCellIdentifier";
    
    LCQuoteCell *cell = [tableView dequeueReusableCellWithIdentifier:quoteCellIdentifier forIndexPath:indexPath];
    
    LCSectionInfo* sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    
    cell.quotation = sectionInfo.play.quotations[indexPath.row];
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LCSectionHeaderView* sectionView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    LCSectionInfo* sectionInfo = self.sectionInfoArray[section];
    
    sectionView.titleLabel.text = sectionInfo.play.name;
    
    sectionInfo.headerView = sectionView;
    
    sectionView.delegate = self;
    
    sectionView.section = section;
    
    return sectionView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCSectionInfo* sectionInfo = self.sectionInfoArray[indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
}

#pragma mark - *** LCSectionHeaderViewDelegate ***

- (void)sectionHeaderView:(LCSectionHeaderView *)headview sectionOpened:(NSUInteger)section
{
    LCSectionInfo* sectionInfo = self.sectionInfoArray[section];
    
    sectionInfo.open = YES;
    
    NSUInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
    NSMutableArray* indexPathsToInsert = [[NSMutableArray alloc] initWithCapacity:countOfRowsToInsert];
    
    for (NSUInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    NSMutableArray* indexPathsToDelete = [[NSMutableArray alloc] init];
    NSUInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        LCSectionInfo* previousSectionInfo = self.sectionInfoArray[previousOpenSectionIndex];
        previousSectionInfo.open = NO;
        [previousSectionInfo.headerView toggleOpenWithUserAction:NO];
        NSUInteger countOfRowsToDelete = [[[self.sectionInfoArray[previousOpenSectionIndex] play] quotations] count];
        for (NSUInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (self.openSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else{
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = section;
    
}


- (void)sectionHeaderView:(LCSectionHeaderView *)headview sectionClosed:(NSUInteger)section
{
    LCSectionInfo* sectionInfo = self.sectionInfoArray[section];
    sectionInfo.open = NO;
    
    NSUInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:section];
    if (countOfRowsToDelete>0) {
        NSMutableArray* indexPathsToDelete = [[NSMutableArray alloc] initWithCapacity:countOfRowsToDelete];
        for (int i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }

    self.openSectionIndex = NSNotFound;
}

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

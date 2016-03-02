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
#import <MessageUI/MessageUI.h>


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
    
    UIPinchGestureRecognizer* pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.tableView addGestureRecognizer:pgr];

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
    
    if ([MFMailComposeViewController canSendMail]) {
        if (!cell.longPressRecognizer) {
            UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            cell.longPressRecognizer = lpgr;
        }
    }
    else{
        cell.longPressRecognizer = nil;
    }
    
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

#pragma mark - *** Gesture Selector ***

- (void)handlePinch:(UIPinchGestureRecognizer*)pgr
{
    if (UIGestureRecognizerStateBegan == pgr.state ) {
        CGPoint location = [pgr locationInView:self.tableView];
        self.pinchedIndexPath =  [self.tableView indexPathForRowAtPoint:location];
        
        LCSectionInfo* sectionInfo = self.sectionInfoArray[self.pinchedIndexPath.section];
        
        self.initialPichedHeight = [[sectionInfo objectInRowHeightsAtIndex:self.pinchedIndexPath.row] floatValue];
        [self updateForPinchScale:pgr.scale atIndexPath:self.pinchedIndexPath];
    }
    else if(UIGestureRecognizerStateChanged == pgr.state){
        [self updateForPinchScale:pgr.scale atIndexPath:self.pinchedIndexPath];
    }
    else if(UIGestureRecognizerStateCancelled == pgr.state || UIGestureRecognizerStateEnded == pgr.state)
    {
        self.pinchedIndexPath = nil;
    }
}

- (void)updateForPinchScale:(CGFloat)scale atIndexPath:(NSIndexPath*)indexpath
{
    if (indexpath && indexpath.section != NSNotFound && indexpath.row != NSNotFound) {
        CGFloat newHeight = round(MAX(self.initialPichedHeight * scale, DEFAULT_ROW_HEIGHT));
        LCSectionInfo* sectionInfo = self.sectionInfoArray[indexpath.section];
        [sectionInfo replaceObjectInRowHeightsAtIndex:indexpath.row withObject:@(newHeight)];
        
        BOOL animationEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [UIView setAnimationsEnabled:animationEnabled];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
       
        NSIndexPath* pressedIndexPath = [self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]];
        if (pressedIndexPath && pressedIndexPath.row != NSNotFound && pressedIndexPath.row != NSNotFound) {
            //UIMenuController 不显示是应为，self ，或者cell  拒绝成为第一响应者。重写self或者cell的canBecomeFirstResponder方法，返回YES；
            //，还要重写canPerformAction：withSender:
            [self becomeFirstResponder];
            CGRect cellRect = [self.tableView rectForRowAtIndexPath:pressedIndexPath];
            NSString* emailTitle = NSLocalizedString(@"Email", @"Email menu title");
            UIMenuItem* menuItem = [[UIMenuItem alloc] initWithTitle:emailTitle action:@selector(emailMenuButtonPressed:)];
            UIMenuController* mc = [UIMenuController sharedMenuController];
            mc.menuItems = @[menuItem];
            
            cellRect.origin.y += 40;
            [mc setTargetRect:cellRect inView:self.tableView];
            [mc setMenuVisible:YES animated:YES];
            
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(emailMenuButtonPressed:) ){
        return YES;
    }
    return NO;
}
#pragma mark - *** MenuItem Action***
- (void)emailMenuButtonPressed:(UIMenuItem*)item
{
    
}

@end

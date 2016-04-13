//
//  MultipleSelectionEditTableViewController.m
//  TableView
//
//  Created by zhangguang on 16/3/24.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "MultipleSelectionEditTableViewController.h"

@interface MultipleSelectionEditTableViewController ()

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic,strong) NSMutableArray* arraySource;
@property (nonatomic,strong) NSMutableSet* deleteSet;

@end

@implementation MultipleSelectionEditTableViewController

#pragma mark - *** Propertyes ***

- (NSMutableArray*)arraySource
{
    if (!_arraySource) {
        _arraySource = [[NSMutableArray alloc] initWithCapacity:100];
        for ( int i = 0; i < 100; i++) {
            [_arraySource addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    return _arraySource;
}

- (NSMutableSet*)deleteSet
{
    if (!_deleteSet) {
        _deleteSet = [[NSMutableSet alloc] initWithCapacity:100];
    }
    return _deleteSet;
}

#pragma mark - *** Init View***
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    //self.tableView.allowsSelection = YES;
    
    self.toolbar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    [self.navigationController.view addSubview:self.toolbar];
}

#pragma mark - *** Helper ***
-(UIColor*)randomColor
{
    switch (arc4random() % 5) {
        case 0:return [UIColor greenColor];
        case 1:return [UIColor blueColor];
        case 2:return [UIColor orangeColor];
        case 3:return [UIColor redColor];
        case 4:return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

#pragma mark - *** Target Action ***
- (IBAction)editItemClicked:(UIBarButtonItem *)sender {
    CGRect frame;
    if ([sender.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"取消"];
        frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }
    else
    {
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"编辑"];
        frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    }
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.toolbar.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                      }
     ];
}

- (IBAction)deleteItemClicked:(id)sender {
    
    if (self.tableView.editing) {

        NSMutableIndexSet* indexSets = [[NSMutableIndexSet alloc] init];
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSString* each in self.deleteSet) {
            NSInteger index = [each integerValue];
            [indexSets addIndex:index];
            [array addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        [self.deleteSet removeAllObjects];
        [self.arraySource removeObjectsAtIndexes:[indexSets copy]];
        [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraySource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditCell" forIndexPath:indexPath];
    cell.textLabel.text = self.arraySource[indexPath.row];
    //cell.backgroundColor = [self randomColor];
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor cyanColor];
    cell.selectedBackgroundView =view;
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        [self.deleteSet removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        [self.deleteSet addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MultipleSelectionEditTableViewController* __weak weakSelf = self;
    UITableViewRowAction* deleteAction  = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf.arraySource removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    
    UITableViewRowAction* topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf.arraySource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        NSIndexPath* firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        [weakSelf.tableView reloadData]; //reloadData可以让置顶的UITableViewRowAction隐藏，暂时没有找到好的方法
    }];
    
    topAction.backgroundColor = [UIColor lightGrayColor];
    
    return @[deleteAction,topAction];
}



@end

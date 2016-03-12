//
//  ToolbarViewController.m
//  TableView
//
//  Created by birneysky on 16/3/9.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "ToolbarViewController.h"

@interface ToolbarViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (nonatomic,strong) UIVisualEffectView* effectView;

@property (weak, nonatomic) IBOutlet UITextView *textview;

@property (strong,nonatomic) NSMutableArray* arraySource;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation ToolbarViewController

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

- (UIVisualEffectView*)effectView
{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        //_effectView.backgroundColor = [UIColor greenColor];
       // _effectView.alpha = 0.5;
    }
    return _effectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.textview.textContainerInset = UIEdgeInsetsMake(6, 0, 4, 0);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.tableViewBottomConstraint.constant = 258;
//        [self.view layoutIfNeeded];
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textview resignFirstResponder];
}



#pragma mark - notification selector
- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardRect;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    
    NSNumber* duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber* curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect bottomFrame = self.bottomView.frame;
    
    bottomFrame.origin.y = self.view.frame.size.height - keyboardRect.size.height - bottomFrame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    
    // set views with new info
    //self.bottomView.frame = bottomFrame;
    self.toolbarBottomConstraint.constant = keyboardRect.size.height ;
    self.tableViewBottomConstraint.constant = keyboardRect.size.height;
    [self.view layoutIfNeeded];
    //[self.tableview layoutIfNeeded];
    // commit animations
    [UIView commitAnimations];
    
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.arraySource.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //[self.bottomView setNeedsUpdateConstraints];
    
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    NSNumber* duration =[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber* curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect bottomFram = self.bottomView.frame;
    bottomFram.origin.y = self.view.frame.size.height - bottomFram.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    //self.bottomView.frame = bottomFram;
    self.toolbarBottomConstraint.constant = 0 ;
    self.tableViewBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark - text delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        //send text
        return NO;
    }
    else
    {
        return YES;
    }
}

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

#pragma mark - *** Tableview Data Source***

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arraySource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hello"];
    cell.textLabel.text = self.arraySource[indexPath.row];
    cell.backgroundColor = [self randomColor];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     [self.textview resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

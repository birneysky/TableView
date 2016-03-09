//
//  ToolbarViewController.m
//  TableView
//
//  Created by birneysky on 16/3/9.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "ToolbarViewController.h"

@interface ToolbarViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;

@property (nonatomic,strong) UIVisualEffectView* effectView;


@end

@implementation ToolbarViewController

- (UIVisualEffectView*)effectView
{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _effectView.alpha = 0.5;
    }
    return _effectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.toolbarHeightConstraint.constant = 60;
    //self.toolbarBottomConstraint.constant = 255;
    //self.bottomView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [self.bottomView addSubview:self.effectView];
    //
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.bottomView.frame = bottomFrame;
    //self.bottomViewSuperViewVerticalSpaceConstraint.constant = keyboardRect.size.height ;
    // commit animations
    [UIView commitAnimations];
    
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
    self.bottomView.frame = bottomFram;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

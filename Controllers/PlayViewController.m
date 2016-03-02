//
//  PlayViewController.m
//  TableView
//
//  Created by zhangguang on 16/3/2.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UIImageView *backView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fadeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flipButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bounceButton;

@property (nonatomic, strong) NSArray *priorConstraints;

@end

@implementation PlayViewController

- (NSArray*)constrainSubView:(UIView*)subview toMathSuperView:(UIView*)superView
{
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(subview);
    
    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|"
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:viewsDictionary]];
    [superView addConstraints:constraints];
    
    return constraints;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.frontView];
    
    _priorConstraints = [self constrainSubView:self.frontView toMathSuperView:self.view];
    
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem*  barButtomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
    self.toolbarItems = @[barButtomItem,self.fadeButton,self.flipButton,self.bounceButton,barButtomItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** Helper ***
- (void)performTransition:(UIViewAnimationOptions)options
{
    UIView* fromView;
    UIView* toView;
    
    if (self.frontView.superview) {
        fromView = self.frontView;
        toView = self.backView;
    }
    else{
        fromView = self.backView;
        toView = self.frontView;
    }

     NSArray *priorConstraints = self.priorConstraints;
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:1.0
                       options:options
                    completion:^(BOOL finished) {
        [self.view removeConstraints:priorConstraints];
    }];
    _priorConstraints = [self constrainSubView:toView toMathSuperView:self.view];
}


#pragma mark - *** Target Action ***
- (IBAction)fateBtnClicked:(id)sender {
    [self performTransition:UIViewAnimationOptionTransitionCrossDissolve];
}

- (IBAction)flipBtnClicked:(id)sender {
    UIViewAnimationOptions options = [self.frontView superview] ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    [self performTransition:options];
}

@end

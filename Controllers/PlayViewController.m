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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

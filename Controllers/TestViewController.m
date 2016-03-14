//
//  TestViewController.m
//  TableView
//
//  Created by birneysky on 16/3/13.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "TestViewController.h"
#import "LCMenu.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    
    imageView.frame = CGRectMake((self.view.frame.size.width - imageView.image.size.width )/2, 200, imageView.image.size.width, imageView.image.size.height);
    [self.view addSubview:imageView];
    
    NSLog(@"imageView frame = %@",NSStringFromCGRect(imageView.frame));
    
    
    UIImage* normal = [UIImage imageNamed:@"chatto_bg_normal"];
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 35)];
    
    UIImageView* testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 400, normal.size.width, normal.size.height)];
    testImageView.image = normal;
    [self.view addSubview:testImageView];

    UIImageView* imageViewMask = [[UIImageView alloc] initWithImage:normal];
    imageViewMask.frame = CGRectInset(imageView.bounds, 0.0f, 0.0f);
    NSLog(@"imageView Mask = %@",NSStringFromCGRect(imageViewMask.frame));
    imageView.layer.mask = imageViewMask.layer;
    
    //LCMenu* menu = [[LCMenu alloc] initWithFrame:CGRectMake(20, 500, 30, 30)];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

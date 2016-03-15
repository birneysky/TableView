//
//  LCMenu.m
//  TableView
//
//  Created by zhangguang on 16/3/14.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "LCMenu.h"

@implementation LCMenu

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 0)];
    [path addLineToPoint:CGPointMake(10, 10)];
    [path addLineToPoint:CGPointMake(30, 10)];
    [[UIColor redColor] setFill];
    [path fill];
    

}

@end

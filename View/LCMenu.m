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
    [path addLineToPoint:CGPointMake(12, 10)];
    [path addLineToPoint:CGPointMake(28, 10)];
    [[UIColor redColor] setFill];
    [path fill];
    
    CGRect rect1 = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - 10);
    UIBezierPath* rectPath = [UIBezierPath bezierPathWithRoundedRect:rect1 cornerRadius:5.0f];
    [[UIColor redColor] setFill];
    [rectPath fill];
}

@end

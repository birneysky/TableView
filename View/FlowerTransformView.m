//
//  FlowerTransformView.m
//  TableView
//
//  Created by birneysky on 16/4/13.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "FlowerTransformView.h"

@implementation FlowerTransformView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    [[UIColor whiteColor] setStroke];
    [[UIColor redColor] setFill];
    UIBezierPath* path  = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(0, -1) radius:1 startAngle:-M_PI endAngle:0 clockwise:YES];
    [path addArcWithCenter:CGPointMake(1, 0) radius:1 startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    [path addArcWithCenter:CGPointMake(0, 1) radius:1 startAngle:0 endAngle:M_PI clockwise:YES];
    [path addArcWithCenter:CGPointMake(-1, 0) radius:1 startAngle:M_PI_2 endAngle: - M_PI_2 clockwise:YES];
    [path closePath];
    
    CGFloat scale = floorf(MIN(size.width, size.height) / 4);
    CGAffineTransform transfrom = CGAffineTransformMake(scale, 0.f, 0.f, scale, size.width / 2, size.height / 2);
    [path applyTransform:transfrom];
    
    [path stroke];
    [path fill];
}

/*
  CGAffineTransformMake (CGFloat a,CGFloat b,CGFloat c,CGFloat d,CGFloat tx,CGFloat ty);
  为了把二维图形的变化统一在一个坐标系里，引入了齐次坐标的概念，即把一个图形用一个三维矩阵表示，其中第三列总是(0,0,1)，用来作为坐标系的标准。所以所有的变化都由前两列完成
 以上参数在矩阵中的表示为：
 |a    b    0|
 |c    d    0|
 |tx   ty   1|
 
 运算原理：原坐标设为（X,Y,1）;
 
                |a    b    0|
   [X,Y,1]   *  |c    d    0|  = [aX + cY + tx, bX + dY + ty, 1]
                |tx   ty   1|
 
 设a=d=1, b=c=0. [X + tx, Y + ty, 1],这个时候坐标按照向量[tx,ty]平移
 设b=c=tx=ty=0， 【aX, dY ,1] X按照a缩放，Y按照d缩放，a，d为XY的比例系数
 
 
 */

@end

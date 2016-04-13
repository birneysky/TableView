//
//  FlowerView.m
//  TableView
//
//  Created by birneysky on 16/4/3.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "FlowerView.h"

@implementation FlowerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    CGFloat margin = 10.0f;
    CGFloat radius = rintf(MIN(size.height - margin, size.width - margin) / 4);
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    CGFloat offset = rintf((size.height - size.width)/2);
    if (offset > 0) {
        yOffset = offset + rintf(margin / 2);
        xOffset = rintf(margin / 2);
    }
    else{
        xOffset = -offset + rintf(margin / 2);
        yOffset = rintf(margin / 2);
    }
    
    [[UIColor redColor] setFill];
    [[UIColor whiteColor] setStroke];
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(xOffset + 2 * radius, yOffset + radius) radius:radius startAngle:-M_PI endAngle:0 clockwise:YES];
    [path addArcWithCenter:CGPointMake(xOffset + 3 * radius, yOffset + 2 * radius) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    [path addArcWithCenter:CGPointMake(xOffset + 2 * radius, yOffset + 3 * radius) radius:radius startAngle:0 endAngle:M_PI clockwise:YES];
    [path addArcWithCenter:CGPointMake(xOffset + radius, yOffset + 2 * radius) radius:radius startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:YES];
    [path closePath];
    [path stroke];
    //[path fill];
    
}


@end

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
    if (offset) {
       
    }
}


@end

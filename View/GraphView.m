//
//  GraphView.m
//  TableView
//
//  Created by birneysky on 16/4/14.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "GraphView.h"




@interface GraphView ()

@property (nonatomic,strong) NSMutableArray* yValues;

@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation GraphView

#pragma mark - *** inline helper ***
static inline CGAffineTransform CGAffineformMakeScaleTranslate(CGFloat sx, CGFloat sy,
                                                               CGFloat dx, CGFloat dy){
    return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

#pragma makr - *** Properties***
- (NSMutableArray*) yValues
{
    if (!_yValues) {
        _yValues = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _yValues;
}

- (dispatch_source_t)timer
{
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    }
    return _timer;
}

#pragma mark - *** Configure ***
- (void)awakeFromNib
{
    for (NSInteger i = 0; i < 100; i++) {
        NSInteger y = arc4random() % lrintf( self.bounds.size.height);
        [self.yValues addObject:@(y)];
    }
    
    
}

#pragma mark - *** Draw code ***

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 30);
    CGPathAddLineToPoint(path, nil, 10, 10);
    NSUInteger index = 1;
    for (NSUInteger x = 1; x < self.bounds.size.width; x+=10) {
        NSInteger y = [self.yValues[index] integerValue];
        CGPathAddLineToPoint(path, nil, x, y);
        index ++;
    }
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextStrokePath(context);
}


@end

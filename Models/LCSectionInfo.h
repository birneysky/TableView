//
//  LCSectionInfo.h
//  TableView
//
//  Created by zhangguang on 16/2/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCPlay;
@class LCSectionHeaderView;

@interface LCSectionInfo : NSObject

@property (nonatomic,assign,getter=isOpen) BOOL open;

@property (nonatomic,strong) LCPlay* play;

@property (nonatomic,strong) LCSectionHeaderView* headerView;

@property (nonatomic,strong) NSMutableArray* rowHeights;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)index;
- (void)insertObject:(id)object inRowHeightsAtIndex:(NSUInteger)index;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)index;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)index withObject:(id)object;
- (void)insertRowHeights:(NSArray *)array atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)array;

@end

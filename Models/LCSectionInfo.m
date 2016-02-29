//
//  LCSectionInfo.m
//  TableView
//
//  Created by zhangguang on 16/2/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "LCSectionInfo.h"

@implementation LCSectionInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _rowHeights = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)countOfRowHeights
{
    return [self.rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)index
{
    return self.rowHeights[index];
}

- (void)insertObject:(id)object inRowHeightsAtIndex:(NSUInteger)index
{
    [self.rowHeights insertObject:object atIndex:index];
}

- (void)insertRowHeights:(NSArray *)array atIndexes:(NSIndexSet *)indexes
{
    [self.rowHeights insertObjects:array atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)index
{
    [self.rowHeights removeObjectAtIndex:index];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes
{
    [self.rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)index withObject:(id)object
{
    self.rowHeights[index] = object;
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)array
{
    [self.rowHeights replaceObjectsAtIndexes:indexes withObjects:array];
}

@end

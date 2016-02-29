//
//  LCSectionHeaderView.h
//  TableView
//
//  Created by zhangguang on 16/2/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSectionHeaderViewDelegate;

@interface LCSectionHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *disclosureButton;

@property (nonatomic,assign) NSUInteger section;

@property (nonatomic, assign) id<LCSectionHeaderViewDelegate> delegate;

@end


@protocol LCSectionHeaderViewDelegate <NSObject>

@optional

- (void)sectionHeaderView:(LCSectionHeaderView*)headview sectionOpened:(NSUInteger)section;

- (void)sectionHeaderView:(LCSectionHeaderView*)headview sectionClosed:(NSUInteger)section;

@end
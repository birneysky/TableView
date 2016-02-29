//
//  LCQuoteCell.h
//  TableView
//
//  Created by zhangguang on 16/2/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCQuotation;

@interface LCQuoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;

@property (weak, nonatomic) IBOutlet UILabel *actAndSceneLabel;

@property (weak, nonatomic) IBOutlet UITextView *quotationTextView;

@property (nonatomic,strong) LCQuotation* quotation;

@property (nonatomic,strong) UILongPressGestureRecognizer* longPressRecognizer;

@end

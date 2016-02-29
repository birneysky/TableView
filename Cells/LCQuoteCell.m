//
//  LCQuoteCell.m
//  TableView
//
//  Created by zhangguang on 16/2/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "LCQuoteCell.h"
#import "LCQuotation.h"

@implementation LCQuoteCell


- (void)setQuotation:(LCQuotation *)quotation
{
    if (_quotation != quotation) {
        _quotation = quotation;
        
        self.characterLabel.text = _quotation.character;
        self.actAndSceneLabel.text = [NSString stringWithFormat:@"Act %lu, Secene %lu",_quotation.act,_quotation.scene];
        self.quotationTextView.text = _quotation.quotation;
    }
}

- (void)setLongPressRecognizer:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (_longPressRecognizer != longPressRecognizer) {
        if (_longPressRecognizer != nil) {
            [self removeGestureRecognizer:_longPressRecognizer];
        }
        
        if (longPressRecognizer != nil) {
            [self addGestureRecognizer:longPressRecognizer];
        }
        
        _longPressRecognizer = longPressRecognizer;
    }
}

@end

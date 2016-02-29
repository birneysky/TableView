//
//  LCSectionHeaderView.m
//  TableView
//
//  Created by zhangguang on 16/2/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "LCSectionHeaderView.h"

@implementation LCSectionHeaderView


- (void)awakeFromNib
{
    [self.disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
    
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tgr];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];

}

- (void)toggleOpenWithUserAction:(BOOL)userAction
{
    self.disclosureButton.selected = !self.disclosureButton.selected;
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else{
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}

@end

//
//  SendTableViewCellSeven.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCellSeven.h"

@implementation SendTableViewCellSeven

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.myBtn == nil) {
        self.myBtn = [[UIButton alloc]init];
        self.myBtn.frame = CGRectMake(10, 40, WIDTH-20, 50);
        self.myBtn.backgroundColor = THEME_COLOR;
        self.myBtn.layer.cornerRadius = 2;
        self.myBtn.layer.masksToBounds = YES;
        [self.myBtn setTitle:NSLocalizedString(@"确定下单", nil) forState:UIControlStateNormal];
        [self addSubview:self.myBtn];
    }
}

@end

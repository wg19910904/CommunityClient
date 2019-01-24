//
//  JHHMSelectButton.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/9/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHMSelectButton.h"

@implementation JHHMSelectButton
- (instancetype)init{
    if(self = [super init]){
        [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.cornerRadius = 4.0f;
        self.layer.borderWidth = 0.5f;
        self.clipsToBounds = YES;
        self.title = [UILabel new];
        self.title.font = FONT(12);
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.right.offset = 0;
            make.top.offset = 0;
            make.bottom.offset = 0;
        }];
        
        self.manImg = [UIImageView new];
        self.manImg.image = IMAGE(@"man");
        [self addSubview:self.manImg];
        [self.manImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 5;
            make.top.offset = 5;
            make.bottom.offset = -5;
            make.width.offset = 20;
        }];
        
        self.selectImg = [UIImageView new];
        [self addSubview:self.selectImg];
        [self.selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = 0;
            make.bottom.offset = 0;
            make.height.offset = 15;
            make.width.offset = 15;
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        self.title.textColor = THEME_COLOR;
        self.layer.borderColor = THEME_COLOR.CGColor;
        self.selectImg.image = IMAGE(@"time_select_yes");
    }else{
        self.title.textColor = HEX(@"333333", 1.0f);
        self.layer.borderColor = LINE_COLOR.CGColor;
        self.selectImg.image = IMAGE(@"time_select_default");
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if(userInteractionEnabled){
        self.title.textColor = HEX(@"333333", 1.0f);
        self.manImg.hidden = YES;
        self.layer.borderColor = LINE_COLOR.CGColor;
        self.selectImg.image = IMAGE(@"time_select_default");
    }else{
        self.title.textColor = [UIColor colorWithRed:179 / 255.0 green:179 / 255.0  blue:179 / 255.0  alpha:1.0f];
        self.manImg.hidden = NO;
        self.layer.borderColor = LINE_COLOR.CGColor;
        self.selectImg.image = IMAGE(@"time_select_no");
    }
}

@end

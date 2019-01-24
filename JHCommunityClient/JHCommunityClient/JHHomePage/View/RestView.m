//
//  RestView.m
//  JHCommunityClient
//
//  Created by jianghu1 on 16/10/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "RestView.h"

@implementation RestView
{
    UIImageView *cancelIV;
    UIView *centerV;
    UIImageView *remindIV;
    UILabel *msgL;
    UIButton *backBtn;
    UIButton *continueBtn;
    
}
- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = HEX(@"000000", 0.4f);
        self.frame = [UIScreen mainScreen].bounds;
        //设置ui
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    
    centerV = [[UIView alloc] initWithFrame:FRAME(0, 0, 240, 320)];
    centerV.center = self.center;
    centerV.layer.cornerRadius = 5;
    centerV.clipsToBounds = YES;
    centerV.backgroundColor = [UIColor whiteColor];
    
    cancelIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 40, 62)];
    cancelIV.center = CGPointMake(self.center.x, self.center.y-190);
    cancelIV.image = IMAGE(@"icon－close");
    UITapGestureRecognizer *cancelGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    cancelIV.userInteractionEnabled = YES;
    [cancelIV addGestureRecognizer:cancelGes];
    [self addSubview:cancelIV];
    
    remindIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 240, 160)];
    remindIV.image = IMAGE(@"pic－dayang");
    [centerV addSubview:remindIV];
    
    msgL = [[UILabel alloc] initWithFrame:FRAME(0, 160, 240, 20)];
    msgL.text = NSLocalizedString(@"本店休息中,暂不接受订单", nil);
    msgL.textAlignment = NSTextAlignmentCenter;
    msgL.font = FONT(16);
    msgL.textColor = HEX(@"666666", 1.0);
    [centerV addSubview:msgL];
    
    backBtn = [[UIButton alloc] initWithFrame:FRAME(40, 203, 160, 40)];
    [backBtn setTitle:NSLocalizedString(@"返回上一页", nil) forState:(UIControlStateNormal)];
    [backBtn setTitleColor:HEX(@"ff6600", 1.0) forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = FONT(15);
    backBtn.layer.cornerRadius = 20;
    backBtn.clipsToBounds = YES;
    backBtn.layer.borderColor = [HEX(@"ff6600", 1.0) CGColor];
    backBtn.layer.borderWidth = 1.0f;
    [backBtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [centerV addSubview:backBtn];
    
    continueBtn = [[UIButton alloc] initWithFrame:FRAME(0, 270, 240, 20)];
    [continueBtn setTitle:NSLocalizedString(@"继续逛店 >>", nil) forState:(UIControlStateNormal)];
    [continueBtn setTitleColor:HEX(@"59c181", 1.0) forState:(UIControlStateNormal)];
    continueBtn.titleLabel.font = FONT(14);
    [continueBtn addTarget:self action:@selector(hidden) forControlEvents:(UIControlEventTouchUpInside)];
    [centerV addSubview:continueBtn];
    
    [self addSubview:centerV];
}
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
}
- (void)hidden
{
    [self removeFromSuperview];
}
- (void)back
{
    [self removeFromSuperview];
    if (_backBlock) {
        _backBlock();
    }
}
@end

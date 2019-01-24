//
//  UITableView+ShowEmpty.m
//  JHCommunityClient
//
//  Created by xixixi on 16/5/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "UITableView+XHShowEmpty.h"
#import <objc/runtime.h>
@implementation UITableView (XHShowEmpty)
static char BlankPageViewKey;
- (void)configBlankPageWithType:(XHBlankPageType)type withBlock:(void (^)())block
{
    switch (type) {
        case XHBlankPageHaveNoData: //没有数据
        {
            if (!self.blankPageView) {
                self.blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            }
            self.blankPageView.hidden = NO;
            [self addSubview:self.blankPageView];
            [self.blankPageView configWithType:type withBlock:block];
        }
            break;
        case XHBlankPageNetError: //服务器出错
        {
            if (!self.blankPageView) {
                self.blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            }
            self.blankPageView.hidden = NO;
            NSLog(@"0000000%@",self.backgroundView);
            [self addSubview:self.blankPageView];
            [self.blankPageView configWithType:type withBlock:block];
        }
            break;
        case XHBlankpageHaveData: //有数据时
        {
            if (self.blankPageView) {
                self.blankPageView.hidden = YES;
                [self.blankPageView removeFromSuperview];
            }
        }
            break;
            
        default:
            
            break;
    }
}
- (BlankPageView *)blankPageView
{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}
- (void)setBlankPageView:(BlankPageView *)blankPageView
{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self,
                             &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}
@end



@implementation BlankPageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100,150, 110)];
        self.backIV.center = CGPointMake(self.center.x, self.backIV.center.y);
        
        self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, WIDTH, 40)];
        self.msgLabel.font = [UIFont systemFontOfSize:15];
        self.msgLabel.textColor = [UIColor grayColor];
        self.msgLabel.textAlignment = NSTextAlignmentCenter;
        
        self.reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 240, 100, 35)];
        self.reloadBtn.backgroundColor = THEME_COLOR;
        self.reloadBtn.center = CGPointMake(WIDTH / 2, 240);
        self.reloadBtn.layer.cornerRadius = 3;
        self.reloadBtn.layer.masksToBounds = YES;
        [self.reloadBtn addTarget:self action:@selector(clickReloadBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.reloadBtn setTitle:NSLocalizedString(@"重新加载", nil) forState:(UIControlStateNormal)];
        [self.reloadBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self addSubview:_backIV];
        [self addSubview:_msgLabel];
        [self addSubview:_reloadBtn];
    }
    return self;
}

- (void)configWithType:(XHBlankPageType)type withBlock:(void (^)())block
{
    switch (type) {
        case XHBlankPageHaveNoData: //无数据时
        {
            self.backIV.image = [UIImage imageNamed:@"none_data"];
            _reloadBlock = block;
        }
            break;
        case XHBlankPageNetError: //网络发生错误时
        {
            self.backIV.image = [UIImage imageNamed:@"none_networkService"];
            _reloadBlock = block;
        }
            break;
            
        default:
            break;
    }
}
- (void)clickReloadBtn:(UIButton *)sender
{
//    self.hidden = YES;
//    [self removeFromSuperview];
    if (_reloadBlock) {
        _reloadBlock();
    }
}
@end

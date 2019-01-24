//
//  UITableView+ShowEmpty.h
//  JHCommunityClient
//
//  Created by xixixi on 16/5/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlankPageView;
typedef NS_ENUM(NSInteger, XHBlankPageType)
{
    XHBlankPageHaveNoData = 0,
    XHBlankPageNetError,
    XHBlankpageHaveData
};
@interface UITableView (XHShowEmpty)
@property(nonatomic,strong)BlankPageView *blankPageView;
- (void)configBlankPageWithType:(XHBlankPageType)type withBlock:(void(^)())block;
@end

@interface BlankPageView : UIView
@property(nonatomic,strong)UIImageView *backIV;
@property(nonatomic,strong)UILabel *msgLabel;
@property(nonatomic,strong)UIButton *reloadBtn;
@property(nonatomic,copy)void(^reloadBlock)();
- (void)configWithType:(XHBlankPageType)type withBlock:(void(^)())block;
@end
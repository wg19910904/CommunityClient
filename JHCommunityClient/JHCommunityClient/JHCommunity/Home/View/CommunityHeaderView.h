//
//  CommunityHeaderView.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBannnerPlayer.h"

typedef void(^ClickAD)(NSInteger index,BOOL is_bottom);//点击轮播  is_bottom 为是否是上面的广告
typedef void(^ClickMsg)(NSInteger index);//点击通知
typedef void(^ClickKind)(NSInteger index);//点击btn

@interface CommunityHeaderView : UIView
@property(nonatomic,copy)ClickAD clickADs;
@property(nonatomic,copy)ClickMsg clickMsg;
@property(nonatomic,copy)ClickKind clickKind;
@property(nonatomic,strong)MJBannnerPlayer *adView;

/**
 *  修改通知的str
 */
@property(nonatomic,copy)NSString *typeStr;

/**
 *  修改通知的背景颜色
 */
@property(nonatomic,copy)NSString *typeColor;

-(CommunityHeaderView *)initViewWith:(NSArray *)adImages kinds:(NSArray *)kinds scrArr:(NSArray *)scrArr bottomAds:(NSArray *)botArr  time:(NSTimeInterval)time scrollH:(CGFloat)scrollH;


@end

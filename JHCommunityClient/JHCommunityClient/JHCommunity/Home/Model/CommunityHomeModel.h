//
//  CommunityHomeModel.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearShopModel.h"

@class CommunityHomeModel;

typedef void(^GetHomeData)(CommunityHomeModel *model,NSString *msg);

@interface CommunityHomeModel : NSObject
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSArray *banner_list;//下部的广告位
@property(nonatomic,strong)NSArray *nav_list;
@property(nonatomic,strong)NSArray *news_list;
@property(nonatomic,strong)NSArray *adv_list;//广告轮播

/**
 *  获取小区的首页信息
 *
 *  @param yezhu_id  业主id
 *  @param block     回调的blcok
 */
+(void)getHomeDataWithYezhu_id:(NSString *)yezhu_id block:(GetHomeData)block;
@end

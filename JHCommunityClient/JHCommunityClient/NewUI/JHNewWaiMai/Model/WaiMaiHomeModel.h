//
//  WaiMaiHomeModel.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/5.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaiMaiShopperModel.h"

@class WaiMaiHomeModel;

//typedef void(^ModelBlock)(WaiMaiHomeModel *model,NSString *msg);

@interface WaiMaiHomeModel : NSObject
@property(nonatomic,strong)NSArray *items;
/*
 {
 "item_id": "519",
 "adv_id": "13",
 "title": "外卖首页右一",
 "link": "",
 "thumb": "photo/201704/20170401_FDA0612ADF9BDEE53C4437D24C3C83E7.jpg"
 }
 */
@property(nonatomic,strong)NSArray *advs;
/*
 {
 "adv_id" = 0;
 link = "###";
 thumb = "default/index_banner.png";
 title = "\U9ed8\U8ba4\U56fe\U7247";
 }
 */
@property(nonatomic,strong)NSArray *banners;
/*
 {
 "item_id": "527",
 "adv_id": "14",
 "title": "更多",
 "link": "",
 "thumb": "photo/201704/20170401_51F918507370B56F2368FAE67ECAFFEF.png"
 },
 */
@property(nonatomic,strong)NSArray *index_cate;


/**
 获取外卖首页数据

 @param page 分页
 @param block 回调的block
 */
+(void)getHomeListWith:(int)page block:(ModelBlock)block;


@end

//
//  JHTempHomePageModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/5.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTempHomePageModel : NSObject
@property(nonatomic,strong)NSArray *advs;//存放广告的
@property(nonatomic,strong)NSArray *banners;//轮播的
@property(nonatomic,strong)NSArray *index_cate;//分类
@property(nonatomic,strong)NSArray *tools;//工具数组
@property(nonatomic,strong)NSArray *shop_items;//商家的数组
@property(nonatomic,strong)NSArray *news;//新闻的数组
@property(nonatomic,strong)NSArray *toutiao;//头条数组
@property(nonatomic,copy)NSString *qiandao_url;//签到的url
@property(nonatomic,copy)NSString *qianghb_url;//抢红包的url
@property(nonatomic,copy)NSString *msg_new_count;//是否有新消息
@property(nonatomic,copy)NSString *hongbao_link;//抢红包的url
//新加
@property(nonatomic,strong)NSArray *top_line;//头条广告
@property(nonatomic,strong)NSArray *fileds;//精选团购
@property(nonatomic,strong)NSDictionary *tender;//首页精招标广告
@property(nonatomic,strong)NSArray *merchants;//首页精选商家
@property(nonatomic,strong)NSArray *nearby;//附近商家
@property(nonatomic,strong)NSArray *lifes;//首页分类信息
@property(nonatomic,strong)NSArray *items;//商家列表
@property(nonatomic,copy)NSString *life_link;

@end

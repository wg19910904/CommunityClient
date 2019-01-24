//
//  JHShareModel.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineCommunityModel.h"
#import "Reachability.h"
@interface JHShareModel : NSObject
/**
 *   单例外部引用
 */
+(instancetype)shareModel;
@property (nonatomic,strong)Reachability*hostReach;//断网
//首次定位的城市名和城市code
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@property(nonatomic,copy)NSString *lastCommunity;

@property(nonatomic,copy)NSString *city_id;
@property(nonatomic,strong)MineCommunityModel *communityModel;//选择的小区
@property(nonatomic,copy)NSString *chooseCityName;//首页城市选择的时候选择的city

//存储商家分类,距离数据
@property(nonatomic,copy)NSArray *shopCate_array;
//存储商圈
@property(nonatomic,copy)NSArray *commercialDataArray;
//存储外卖商家分类
@property(nonatomic,copy)NSArray *waimaiShopCate_array;
//用于储存用户手机号码
@property(nonatomic,copy)NSString *phone;
//存储客服电话
@property(nonatomic,copy)NSString *serviseMobile;
//用于存储用户的搜索历史数组(最多保存10条)
@property(nonatomic,copy)NSMutableArray *historyArray;
//抢红包的链接
@property(nonatomic,copy)NSString *qianghb_url;
//判断是否登录的token
@property(nonatomic,copy)NSString *token;

//JHTempWebViewShare
//@property(nonatomic,strong)NSString *shareLink;//分享的link
//@property(nonatomic,strong)NSString *shareText;//分享text
//@property(nonatomic,strong)NSString *shareTitle;//分享标题
//@property(nonatomic,strong)NSURL *imageUrl;//分享的图片

@property(nonatomic,assign)BOOL isShop;
@property(nonatomic,assign)BOOL isNotUpdate;//是否强制升级
@property(nonatomic,assign)BOOL have_staff;// 是否有服务类的
@property(nonatomic,assign)BOOL have_weidian;//是否有商城
@property(nonatomic,copy)NSArray *payment; //平台支持的付款方式
/*
 "add_function" =         {
     "have_gongqiu" = 1;
     "have_staff" = 1;
     "have_weidian" = 1;
     "have_xiaoqu" = 1;
 };
 */
@property(nonatomic,strong)NSDictionary *add_function;
/**
 保存当前版本
 */
@property(nonatomic,copy)NSString *version;
@property(nonatomic,copy)NSString *WXSecret;
//存储默认的区号
@property(nonatomic,copy)NSString *def_code;
- (void)addReachability;
@end

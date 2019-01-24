//
//  WaiMaiShopperModel.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

// model中需要用到的block
typedef void(^DataBlock)(NSArray *arr,NSString *msg);
typedef void(^MsgBlock)(BOOL success,NSString *msg);

@interface WaiMaiShopperModel : NSObject

@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *city_id;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *banner;//横幅
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *views;//浏览次数
@property(nonatomic,copy)NSString *orders;//订单数
@property(nonatomic,copy)NSString *comments;//评论数
@property(nonatomic,copy)NSString *praise_num;//好评数
@property(nonatomic,copy)NSString *score;//综合总评分
@property(nonatomic,copy)NSString *score_fuwu;//服务评分
@property(nonatomic,copy)NSString *score_kouwei;//口味评分

@property(nonatomic,copy)NSString *min_amount;//起送价
@property(nonatomic,copy)NSString *freight;//收取用户费用
@property(nonatomic,copy)NSString *pei_amount;//商家付给配送员
@property(nonatomic,copy)NSString *pei_distance;//配送距离
@property(nonatomic,assign)int pei_type;//配送类型 0:自己送,1:第三方送，2:第三方代购及配送 3:用户自提单 4:堂食
@property(nonatomic,copy)NSString *pei_time;//平均等待时间
@property(nonatomic,copy)NSString *pei_time_lable;//平均等待时间
@property(nonatomic,copy)NSString *yy_stime;//开始营业时间
@property(nonatomic,copy)NSString *yy_ltime;//打烊时间
@property(nonatomic,copy)NSString *yy_xiuxi;//中间休息时间
@property (nonatomic,copy)NSString *yy_status;//营业状态
@property(nonatomic,copy)NSString *is_new;//是否新店铺 1:表示新店
@property(nonatomic,copy)NSString *online_pay;
@property(nonatomic,copy)NSString *info;
@property(nonatomic,copy)NSString *delcare;//商家公告
@property(nonatomic,copy)NSString *verify_name;//0:未验证,1:已验证
@property(nonatomic,copy)NSString *dateline;
@property(nonatomic,copy)NSString *tmpl_type;//显示模板类型：market:商超,waimai:外卖
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *is_daofu;//是否支持货到付款，0不支持，1支持
@property(nonatomic,copy)NSString *is_ziti;//是否支持到店自提，0不支持，1支持
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lng;
@property(nonatomic,copy)NSString *orderby;
@property(nonatomic,copy)NSString *cate_title;//分类名称
@property(nonatomic,copy)NSString *freight_price;//最低运费
@property(nonatomic,copy)NSString *yysj_status;//商家是否营业 1：营业 0：打烊
@property(nonatomic,copy)NSArray *activity_list;//活动集合 [{"first_amount": "新用户首单优惠12元"}]
@property(nonatomic,copy)NSString *juli;
@property(nonatomic,copy)NSString *juli_label;
@property(nonatomic,strong)NSArray *subtitle;// 商家支持的功能

@property(nonatomic,copy)NSString *shop_cate_title;
@property(nonatomic,copy)NSString *business_name;
@property(nonatomic,copy)NSString *avg_amount;//人均消费
@property(nonatomic,assign)BOOL showYouHui;

//新增
@property(nonatomic,copy)NSString *avg_score;//平均分



/**
 获取筛选的商家列表

 @param page 分页
 @param cate_id 分类id
 @param area_id 地区id
 @param title 搜索关键词
 @param buiness_id 商圈id
 @param paixu_id 排序id
 @param block 回调的block
 */
+(void)getShopFilterListWith:(int)page cate_id:(NSString *)cate_id title:(NSString *)title area_id:(NSString *)area_id paixu_id:(NSString *)paixu_id buiness:(NSString *)buiness_id block:(DataBlock)block;
@end

//
//  WMCreateOrderModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/10.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JHWaimaiMineAddressListDetailModel.h"

@interface WMCreateOrderModel : NSObject
// 商家信息
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *shop_title;
@property(nonatomic,copy)NSString *shop_lat;
@property(nonatomic,copy)NSString *shop_lng;
@property(nonatomic,copy)NSString *shop_addr;
@property(nonatomic,assign)BOOL is_daofu;// 1 支持货到付款 0 不支持
@property(nonatomic,assign)BOOL online_pay;// 1支持在线支付 0 不支持
@property(nonatomic,assign)BOOL is_ziti;// 1 支持自提 0 不支持自提
@property(nonatomic,copy)NSString *products;

// 红包和优惠劵
@property(nonatomic,copy)NSString *coupon_id;
@property(nonatomic,copy)NSString *coupon_amount;
@property(nonatomic,strong)NSArray *coupons;
@property(nonatomic,copy)NSString *hongbao_id;
@property(nonatomic,copy)NSString *hongbao_amount;
/*
 {
 amount = "1.00";
 "hongbao_id" = 649;
 "min_amount" = "20.00";
 }
 */
@property(nonatomic,strong)NSArray *hongbaos;
// 订单的优惠信息
/*
 {
 title:
 color:
 word:
 amount:
 }
 */
@property(nonatomic,strong)NSArray *youhui;
@property(nonatomic,strong)NSString *shopinfo;

// 商品的总价格
@property(nonatomic,copy)NSString *product_price;
// 商品总数
@property(nonatomic,copy)NSString *product_number;
// 打包费
@property(nonatomic,copy)NSString *package_price;
// 配送费
@property(nonatomic,copy)NSString *freight_stage;
// 商品的结算价格（需支付金额）
@property(nonatomic,copy)NSString *amount;

/*
 {
     num = 2;
     price = "10.00";
     "spec_id" = 0;
     "spec_name" = "";
     title = "\U9e21\U817f\U996d";
 }

 */
@property(nonatomic,strong)NSArray *product_lists;
/*
 "shop": {
     "title": "皇后娘娘庙",
     "lat": "31.784349",
     "lng": "117.323640",
 }
 */
@property(nonatomic,strong)NSDictionary *shop;
//@property(nonatomic,strong)JHWaimaiMineAddressListDetailModel *m_addr;

/*
 [
     {
     "date": "2017-03-31",
     "day": "今天(周五)"
     }
 ]
 */
@property(nonatomic,strong)NSArray *day_dates;
/**
"set_time_date": {
    "set_time": [ ],// 今天的时间
    "nomal_time": [ ],// 之后的时间
 }
 */
@property(nonatomic,strong)NSDictionary *yy_peitime;

#pragma mark ======自定义属性=======
//// 选择货到付款的金额
//@property(nonatomic,copy)NSString *no_onlinePay_amount;
//// 自提的金额 在线支付
//@property(nonatomic,copy)NSString *ziti_amount;
//// 自提的金额 货到付款
//@property(nonatomic,copy)NSString *ziti_amount_no_youhui;


/**
  获取订单的支付金额

 @param on_linePay 是否在线支付
 @param is_ziti 是否自提
 @return 支付金额
 */
//-(NSString *)getOrderAmountWith:(BOOL)on_linePay ziti:(BOOL)is_ziti;

// 是不是的时间处理
-(NSArray *)getTimesArr:(BOOL)is_ziti;

/**
 获取订单信息

 @param shop_id 商家id
 @param block 回调的block
 */
//+(void)getCreateOrderDetailWith:(NSString *)shop_id block:(ModelBlock)block;

/**
 修改订单优惠劵接口

 @param orderModel 需要修改的订单
 @param coupon_id 将要修改的优惠劵id
 @param block 回调的block
 */
//+(void)changeCouponWith:(WMCreateOrderModel *)orderModel coupon_id:(NSString *)coupon_id block:(ModelBlock)block;

/**
 创建订单

 @param dic 订单信息
 @param block 回调的blcok
 */
//+(void)getOrder_idWith:(NSDictionary *)dic block:(MsgBlock)block;
+(WMCreateOrderModel *)shareAdvModelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end

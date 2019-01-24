//
//  JHWaiMaiModel.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWaiMaiModel : NSObject
@property(nonatomic,assign)int online_pay;
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,assign)int order_status;
@property(nonatomic,assign)int pay_status;
@property(nonatomic,assign)int comment_status;
@property(nonatomic,copy)NSString *total_price;  // 订单总价
@property(nonatomic,copy)NSString *amount;       // 三方支付金额
@property(nonatomic,copy)NSString *money;        // 余额支付金额
@property(nonatomic,copy)NSString *real_pay;     // 实际支付金额 = 余额支付 + 三方支付
@property(nonatomic,copy)NSString *order_status_label;
@property(nonatomic,copy)NSString *shop_title;    // 外卖商家标题
@property(nonatomic,copy)NSString *shop_logo;     // 外卖商家logo
@property(nonatomic,copy)NSString *product_number;// 商品数量
@property(nonatomic,copy)NSString *product_title; // 商品标题
@property(nonatomic,copy)NSString *spend_number;  // 自提码
@property(nonatomic,assign)int spend_status;      // 自提码核销状态
@property(nonatomic,copy)NSString *ticket_url;    // 查看券码 链接
@property(nonatomic,copy)NSString *tuikuan_url;   // 钱款去向 链接
@property(nonatomic,copy)NSString *dateline;      // 下单时间
@property(nonatomic,copy)NSString *limit_time;    // 剩余支付时间

/*
 action = "money_direction";
 enable = 1;
 highlight = 0;
 title = "\U94b1\U6b3e\U53bb\U5411";
 */
@property(nonatomic,strong)NSArray *order_button; // 订单显示的按钮信息

#pragma mark ====== 订单详情 =======
@property(nonatomic,copy)NSString *progress_url;  // 订单状态记录
@property(nonatomic,copy)NSString *coupon_id;
@property(nonatomic,copy)NSString *coupon;        // 优惠金额
@property(nonatomic,copy)NSString *hongbao_id;
@property(nonatomic,copy)NSString *hongbao;       // 红包金额
@property(nonatomic,copy)NSString *order_youhui;  // 满减优惠
@property(nonatomic,copy)NSString *first_youhui;  // 首单优惠
@property(nonatomic,assign)float o_lng;           // 商家经度（取货地址）
@property(nonatomic,assign)float o_lat;
@property(nonatomic,copy)NSString *contact;       // 联系人
@property(nonatomic,copy)NSString *mobile;        // 下单手机
@property(nonatomic,copy)NSString *addr;          // 下单地址
@property(nonatomic,copy)NSString *house;         // 具体地址
@property(nonatomic,assign)float lng;             // 送货地址经度
@property(nonatomic,assign)float lat;
@property(nonatomic,copy)NSString *intro;         // 备注
@property(nonatomic,copy)NSString *pay_code;      // 支付方式
@property(nonatomic,copy)NSString *pay_time;      // 支付时间
@property(nonatomic,copy)NSString *pei_type;      // 配送方式 0商家送，1平台送，3自提，4堂食
@property(nonatomic,copy)NSString *pei_time;      // 配送时间
@property(nonatomic,copy)NSString *zhuohao_id;    // 桌号ID
@property(nonatomic,copy)NSString *freight;       // 运费
@property(nonatomic,copy)NSString *product_price; // 商品总价
@property(nonatomic,copy)NSString *package_price; // 打包费
@property(nonatomic,copy)NSString *order_status_warning;// 订单状态说明
/*
 shop_phone    string    商家电话
 staff_phone    string    配送员电话
 */
@property(nonatomic,strong)NSArray *phones;   // 联系电话
@property(nonatomic,assign)float shop_lng;         // 商家经度
@property(nonatomic,assign)float shop_lat;         // 商家纬度
/*
 staff_id    int    配送员ID
 name    string    配送员姓名
 mobile    string    配送员手机
 face    string    配送员头像
 lng    int    配送员经度
 lat    int    配送员纬度
 */
@property(nonatomic,strong)NSDictionary *staff;         // 配送员信息 如果没有配送员数据，返回staff_id=>0的数组
/*
 product_id    int    商品ID
 product_name    string    商品名称（包括规格名称）
 product_price    number    商品价格
 package_price    number    打包费
 product_number    int    商品数量
 spec_name    string    规格名称
 product_photo
 product_name_simple    string    商品名称（不带规格）
 */
@property(nonatomic,strong)NSArray *products;     // 所点的所有商品
@property(nonatomic,assign)BOOL show_map;         // 是否显示地图
/*
 title:jalkdfj
 link:adlsfjla
 */
@property(nonatomic,strong)NSArray *complaint;    // 投诉数组

#pragma mark ====== 自定义属性 =======
@property(nonatomic,strong)NSArray *youhui_arr;         // 优惠信息
@property(nonatomic,strong)NSArray *packageAndSendMoney_arr;  // 配送费和打包费
@property(nonatomic,copy)NSString *limit_time_str; // 剩余支付时间
/**
 获取外卖订单列表
 
 @param type    类型 0全部 1待评价 2退款
 @param page    页码
 @param block   回调的block
 */
+(void)getWMOrderList:(NSInteger)type page:(int)page block:(DataBlock)block;


/**
 获取外卖订单详情
 
 @param order_id    订单id
 @param block       回调的block
 */
+(void)getWMOrderDetail:(NSString *)order_id block:(ModelBlock)block;

/**
 取消订单
 
 @param order_id    订单id
 @param block       回调的block
 */
+(void)cancelOrderWith:(NSString *)order_id block:(MsgBlock)block;

/**
 退款订单
 
 @param order_id    订单id
 @param block       回调的block
 */
+(void)refundOrderWith:(NSString *)order_id block:(MsgBlock)block;

/**
 催单
 
 @param order_id    订单id
 @param block       回调的block
 */
+(void)cuiOrderWith:(NSString *)order_id block:(MsgBlock)block;

/**
 确认送达
 
 @param order_id    订单id
 @param block       回调的block
 */
+(void)sureSendedOrderWith:(NSString *)order_id block:(MsgBlock)block;

@end

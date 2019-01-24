//
//  JHGroupOrderModel.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHGroupOrderModel : NSObject

@property(nonatomic,copy)NSString *tuan_title;
@property(nonatomic,copy)NSString *tuan_photo;
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,assign)int order_status;// 订单状态
@property(nonatomic,assign)int pay_status;  // 支付状态
@property(nonatomic,copy)NSString *total_price;// 订单总价
@property(nonatomic,copy)NSString *amount;  // 三方支付金额
@property(nonatomic,copy)NSString *money;   // 余额支付金额
@property(nonatomic,copy)NSString *real_pay;// 实际支付金额 = 余额支付 + 三方支付
@property(nonatomic,assign)int comment_status;// 评论状态
@property(nonatomic,copy)NSString *order_status_label;
@property(nonatomic,copy)NSString *tuan_number;
@property(nonatomic,assign)int ticket_status;// 券码状态 0 未消费 1已消费 -1退款成功
@property(nonatomic,copy)NSString *tuan_ltime;// 团购截止时间
@property(nonatomic,copy)NSString *ticket_ltime;// 券码失效时间
@property(nonatomic,copy)NSString *ticket_use_time; //券码使用时间
/*
 action = "money_direction";
 enable = 1;
 highlight = 0;
 title = "\U94b1\U6b3e\U53bb\U5411";
 */
@property(nonatomic,strong)NSArray *order_button; // 订单显示的按钮信息

#pragma mark ====== 订单详情 =======
@property(nonatomic,copy)NSString *hongbao_id;
@property(nonatomic,copy)NSString *hongbao;// 红包金额
@property(nonatomic,copy)NSString *coupon_id; 
@property(nonatomic,copy)NSString *coupon;  //优惠券金额
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *pay_code;// 支付方式
@property(nonatomic,copy)NSString *dateline;// 下单时间
@property(nonatomic,copy)NSString *tuan_id; //
@property(nonatomic,copy)NSString *order_status_warning;// 订单状态说明
@property(nonatomic,copy)NSString *shop_title;
@property(nonatomic,copy)NSString *shop_logo;
@property(nonatomic,copy)NSString *shop_addr;
@property(nonatomic,copy)NSString *shop_phone;
@property(nonatomic,assign)float lng;
@property(nonatomic,assign)float lag;
@property(nonatomic,copy)NSString *juli_label;
@property(nonatomic,copy)NSString *price;//团购市场价
@property(nonatomic,copy)NSString *tuan_price;// 团购价格
@property(nonatomic,copy)NSString *link;// 图文链接
@property(nonatomic,copy)NSString *ticket_number;// 团购券码
@property(nonatomic,copy)NSString *site_phone;//站点客服电话
@property(nonatomic,copy)NSString *ticket_url;// 查看券码 链接
@property(nonatomic,copy)NSString *tuikuan_url;// 钱款去向 链接


#pragma mark ====== 自定义属性 =======
@property(nonatomic,strong)NSArray *orderInfoArr;
@property(nonatomic,assign)BOOL haveCouponOrRedWrap;// 是否有红包或者优惠劵

/**
 获取团购订单列表

 @param type    类型 0全部 1待付款 2待使用 3待评价 4退款
 @param page    页码
 @param block   回调的block
 */
+(void)getGroupOrderList:(NSInteger)type page:(int)page block:(DataBlock)block;


/**
 获取团购订单详情

 @param order_id    订单id
 @param block       回调的block
 */
+(void)getGroupOrderDetail:(NSString *)order_id block:(ModelBlock)block;


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
@end

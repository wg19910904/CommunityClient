//
//  JHMaidanListCellModel.h
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHMaiDanModel : NSObject
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,assign)int order_status;
@property(nonatomic,assign)int pay_status;
@property(nonatomic,assign)int comment_status;
@property(nonatomic,copy)NSString *total_price;     // 订单总额
@property(nonatomic,copy)NSString *order_youhui;    // 买单优惠金额
@property(nonatomic,copy)NSString *money;           // 使用余额
@property(nonatomic,copy)NSString *amount;          // 在线支付金额
@property(nonatomic,copy)NSString *order_status_label;
@property(nonatomic,copy)NSString *real_pay;
@property(nonatomic,copy)NSString *shop_title;
@property(nonatomic,copy)NSString *shop_logo;
/*
 action = "money_direction";
 enable = 1;
 highlight = 0;
 title = "\U94b1\U6b3e\U53bb\U5411";
 */
@property(nonatomic,strong)NSArray *order_button; // 订单显示的按钮信息

#pragma mark ====== 订单详情 =======
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *dateline;
@property(nonatomic,copy)NSString *coupon_id;
@property(nonatomic,copy)NSString *coupon;         // 优惠券金额
@property(nonatomic,copy)NSString *shop_phone;
@property(nonatomic,copy)NSString *unyouhui;       // 不优惠金额
@property(nonatomic,assign)float lng;
@property(nonatomic,assign)float lat;
@property(nonatomic,copy)NSString *juli;
@property(nonatomic,copy)NSString *juli_label;
@property(nonatomic,copy)NSString *intro;         // 优惠规则

/**
 获取买单订单列表
 
 @param type    类型 0全部 1待付款 2待使用 3待评价 4退款
 @param page    页码
 @param block   回调的block
 */
+(void)getMDOrderListPage:(int)page block:(DataBlock)block;


/**
 获取买单订单详情
 
 @param order_id    订单id
 @param block       回调的block
 */
+(void)getMDOrderDetail:(NSString *)order_id block:(ModelBlock)block;

@end

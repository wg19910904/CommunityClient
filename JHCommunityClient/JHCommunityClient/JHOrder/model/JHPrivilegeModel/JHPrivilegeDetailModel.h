//
//  JHPrivilegeDetailModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPrivilegeDetailModel : NSObject
@property(nonatomic,copy)NSString * amount;//实际支付的价格
@property(nonatomic,copy)NSString * dateline;//下单时间
@property(nonatomic,copy)NSString * order_id;//订单号
@property(nonatomic,copy)NSString * order_status;//判断订单状态的
@property(nonatomic,copy)NSString * order_status_label;//显示订单状态的
@property(nonatomic,copy)NSString * order_youhui;//商家优惠的金额
@property(nonatomic,copy)NSString * addr;//地址
@property(nonatomic,copy)NSString * pay_status;//地址
@property(nonatomic,copy)NSString * title;//商家名
@property(nonatomic,copy)NSString * lat;//商家纬度
@property(nonatomic,copy)NSString * lng;//商家经度
@property(nonatomic,copy)NSString * mobile;//商家电话
@property(nonatomic,copy)NSString * money; //余额支付的钱
@property(nonatomic,copy)NSString * comment_status; //判断是否已经评论
@property(nonatomic,copy)NSString * photo; //图片
@property(nonatomic,copy)NSString * jifen;
@property(nonatomic,copy)NSString * phone;//客户电话
@property(nonatomic,copy)NSString *total_price; //总价
+(JHPrivilegeDetailModel *)shareJHPrivilegeDetailModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

//
//  JHPrivilegeListModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPrivilegeListModel : NSObject
@property(nonatomic,copy)NSString * title;//显示店铺的名字的
@property(nonatomic,copy)NSString * amount;//实际支付的价格
@property(nonatomic,copy)NSString * order_youhui;//优惠的价格
@property(nonatomic,copy)NSString * dateline;//显示店铺的名字的
@property(nonatomic,copy)NSString * order_status;//判断订单状态的
@property(nonatomic,copy)NSString * order_status_label;//显示订单当前的状态的
@property(nonatomic,copy)NSString * pay_status;//判断支付状态的
@property(nonatomic,copy)NSString * photo;//显示照片的
@property(nonatomic,copy)NSString * jifen;//可以获得的积分
@property(nonatomic,copy)NSString * order_id;//订单号
@property(nonatomic,copy)NSString * comment_status;//判断是否评价的
@property(nonatomic,copy)NSString *total_price;//消费总价
@property(nonatomic,copy)NSString *money;//余额支付的钱
+(JHPrivilegeListModel *)shareJHPrivilegeListModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

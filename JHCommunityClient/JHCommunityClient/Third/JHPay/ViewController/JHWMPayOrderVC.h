//
//  JHWMPayOrderVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHWMPayOrderVC : JHBaseVC
@property(nonatomic,copy)NSString *order_id;//订单号
@property(nonatomic,copy)NSString *amount;//支付金额
@property(nonatomic,assign)BOOL isDetailVC;//是否是从详情进入的
//@property(nonatomic,copy)NSString *jumpVcStr;//支付成功后需要跳转的控制器
@property(nonatomic,copy)MsgBlock paySuccessBlock;// 支付成功的回调
@property (nonatomic,assign)BOOL isTuan;//团购是or否
@property (nonatomic,assign)BOOL isWeiXiu;//维修
@property (nonatomic,assign)BOOL isHouse;//家政
@property (nonatomic,assign)BOOL isOrder;//订单界面
@property (nonatomic,assign)BOOL isBuy;//帮我买
@property (nonatomic,assign)BOOL isSong;//送
@property (nonatomic,assign)BOOL isPaiDui;//排队
@property (nonatomic,assign)BOOL isPet;//宠物
@property (nonatomic,assign)BOOL isSeat;//占座
@property (nonatomic,assign)BOOL isOther;//其他
@property (nonatomic,assign)BOOL isWM;//是外卖界面
@property (nonatomic,assign)BOOL isHui;//是优惠买单
@property (nonatomic,assign)BOOL isIntegration;//积分订单
// 是否是混合支付（其他支付方式可以包含余额）
@property(nonatomic,assign)BOOL is_contain_money;
//点击支付界面,返回按钮的回调
@property(nonatomic,copy)void(^clickBackBlock)();
@end

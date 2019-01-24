//
//  JHOrderStatusActionProtocol.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JHOrderStatusActionProtocol <NSObject>
@optional
// 钱款去向
-(void)moneyDirectionWithOrder_id:(NSString *)order_id tuikuan_url:(NSString *)url;
// 取消订单
-(void)cancleOrderWithOrder_id:(NSString *)order_id;
// 去支付
-(void)payOrderWithOrder_id:(NSString *)order_id amount:(NSString *)amount;
// 退款
-(void)refundOrderWithOrder_id:(NSString *)order_id;
// 查看券码
-(void)viewCodeWithOrder_id:(NSString *)order_id ticket_url:(NSString *)url;
// 去评价
-(void)commentOrderWithOrder_id:(NSString *)order_id;
// 再来一单
-(void)againOrderWithOrder:(id)order;
// 催单
-(void)cuiOrderWithOrder_id:(NSString *)order_id;
// 确认送达
-(void)confirmOrderWithOrder_id:(NSString *)order_id;
// 查看评价
-(void)viewCommentWithOrder_id:(NSString *)order_id pei_type:(NSString *)pei_type;


@end

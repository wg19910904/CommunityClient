//
//  JHAllOrderStatusDealTool.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/26.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHAllOrderStatus) {
    JHAllOrderStatusWaitPay,            // 待支付
    JHAllOrderStatusWaitTakeOrder,      // 待接单
    JHAllOrderStatusWaitUse,            // 待使用(团购单)
    JHAllOrderStatusWaitSendOrder,      // 待配送
    JHAllOrderStatusSendingOrder,       // 配送中
    JHAllOrderStatusSendedOrder,        // 配送完成
    JHAllOrderStatusCancel,             // 取消
    JHAllOrderStatusRefund,             // 退款成功
    JHAllOrderStatusWaitComment,        // 待评价
    JHAllOrderStatusComplete,           // 已完成
};

@interface JHAllOrderStatusDealTool : NSObject

/**
 获取订单状态
 */
+(JHAllOrderStatus)getOrderStatus:(id)order from:(NSString *)from;

/**
 获取订单对应的按钮数组
 */
+(NSArray *)getOrderStatusBtnTitleArr:(id)order from:(NSString *)from;

@end

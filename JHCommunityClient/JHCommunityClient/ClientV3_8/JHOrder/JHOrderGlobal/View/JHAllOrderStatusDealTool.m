//
//  JHAllOrderStatusDealTool.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/26.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHAllOrderStatusDealTool.h"
#import <objc/message.h>

@implementation JHAllOrderStatusDealTool

/**
 获取订单状态
 */
+(JHAllOrderStatus)getOrderStatus:(id)order from:(NSString *)from{
    
//    // 订单状态
//    Ivar order_status_var = class_getInstanceVariable([order class], "_order_status");
//    int order_status = (int)object_getIvar(order, order_status_var);
//    // 支付状态
//    Ivar pay_status_var = class_getInstanceVariable([order class], "_pay_status");
//    int pay_status = (int)object_getIvar(order, pay_status_var);
//    // 评价状态
//    Ivar comment_status_var = class_getInstanceVariable([order class], "_comment_status");
//    int comment_status = (int)object_getIvar(order, comment_status_var);
//    // 是否在线支付
//    Ivar online_pay_var = class_getInstanceVariable([order class], "_online_pay");
//    int online_pay = (int)object_getIvar(order, online_pay_var);
//    
//    // 堂食的桌号
//    Ivar zhuohao_id_var = class_getInstanceVariable([order class], "_zhuohao_id");
//    NSString *zhuohao_id = (NSString *)object_getIvar(order, zhuohao_id_var);
//    
//    if ([from isEqualToString:@"waimai"]) {
//        
//    }else if ([from isEqualToString:@"maidan"]){
//        
//        if (order_status == -1) { // 已取消
//            return JHAllOrderStatusCancel;
//        } else if ((order_status == 0) && (pay_status == 0)) { // 待支付
//            return JHAllOrderStatusWaitPay;
//        } else if ((order_status == 8) && (comment_status == 0)) { // 待评价
//            return JHAllOrderStatusWaitComment;
//        } else if ((order_status == 8) && (comment_status == 1)) { // 已评价
//            return JHAllOrderStatusComplete;
//        } else {
//            return JHAllOrderStatusComplete;
//        }
//        
//    }else if ([from isEqualToString:@"tuan"]){
//        
//        if (order_status == -2) { // 退款成功
//            return JHAllOrderStatusRefund;
//        } else if (order_status == -1) {// 订单取消
//            return JHAllOrderStatusCancel;
//        } else if ((order_status == 0) && ( pay_status ==0 )) { // 待支付
//            return JHAllOrderStatusWaitPay;
//        } else if (order_status == 5) { // 待使用
//            return JHAllOrderStatusWaitUse;
//        } else if (order_status == 8 && comment_status == 0) { // 待评价
//            return JHAllOrderStatusWaitComment;
//        } else if (order_status == 8 && comment_status == 1) { // 已评价/已完成
//            return JHAllOrderStatusComplete;
//        }else{  // 已完成
//            return JHAllOrderStatusComplete;
//        }
//        
//    }

    return JHAllOrderStatusCancel;
}

/**
 获取订单对应的按钮数组
 */
+(NSArray *)getOrderStatusBtnTitleArr:(id)order from:(NSString *)from{
    
    JHAllOrderStatus orderStatus = [self getOrderStatus:order from:from];
    switch (orderStatus) {
        case JHAllOrderStatusWaitPay:            // 待支付
            break;
        case JHAllOrderStatusWaitTakeOrder:      // 待接单
            break;
        case JHAllOrderStatusWaitUse:            // 待使用
            break;
        case JHAllOrderStatusWaitSendOrder:      // 待配送
            break;
        case JHAllOrderStatusSendingOrder:       // 配送中
            break;
        case JHAllOrderStatusSendedOrder:        // 配送完成
            break;
        case JHAllOrderStatusCancel:             // 取消
            break;
        case JHAllOrderStatusRefund:             // 退款成功
            break;
        case JHAllOrderStatusWaitComment:        // 待评价
            break;
        case JHAllOrderStatusComplete:           // 已完成
            break;
        default:
            break;
    }
    
    return @[];
}

@end

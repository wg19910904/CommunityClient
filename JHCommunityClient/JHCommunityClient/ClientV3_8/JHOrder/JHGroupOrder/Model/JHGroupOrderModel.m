//
//  JHGroupOrderModel.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHGroupOrderModel.h"
 

@implementation JHGroupOrderModel

-(NSArray *)orderInfoArr{
    if (!_orderInfoArr) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@{@"title": NSLocalizedString(@"订单号:", NSStringFromClass([self class])),
                         @"center":@"",
                         @"right":_order_id}];
        
        [arr addObject:@{@"title": NSLocalizedString(@"下单时间:", NSStringFromClass([self class])),
                         @"center":@"",
                         @"right":_dateline}];
        
        [arr addObject:@{@"title": NSLocalizedString(@"购买手机号:", NSStringFromClass([self class])),
                         @"center":@"",
                         @"right":_mobile}];
        
        [arr addObject:@{@"title": NSLocalizedString(@"数量:", NSStringFromClass([self class])),
                         @"center":@"",
                         @"right":[NSString stringWithFormat:@"x%@",_tuan_number]}];
        
        if ([_coupon_id intValue] != 0) {
            [arr addObject:@{@"title": NSLocalizedString(@"优惠劵:", NSStringFromClass([self class])),
                             @"center":@"",
                             @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"-¥", nil),_coupon]}];
        }
        if ([_hongbao_id intValue] != 0) {
            [arr addObject:@{@"title": NSLocalizedString(@"红包:", NSStringFromClass([self class])),
                             @"center":@"",
                             @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"-¥", nil),_hongbao]}];
        }
        
        [arr addObject:@{@"title": NSLocalizedString(@"总价:", NSStringFromClass([self class])),
                         @"center":@"",
                         @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥ ", nil),_total_price]}];
        
        [arr addObject:@{@"title": NSLocalizedString(@"实付:", NSStringFromClass([self class])),
                         @"center":@"",
                         @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥ ", nil),_real_pay]}];

        return arr.copy;
    }
    
    return _orderInfoArr;
}

-(BOOL)haveCouponOrRedWrap{
    return ([_coupon_id intValue] != 0 || [_hongbao_id intValue] != 0);
}


+(void)getGroupOrderList:(NSInteger)type page:(int)page block:(DataBlock)block{
    [HttpTool postWithAPI:@"client/v3/tuan/order/items" withParams:@{@"type":@(type),@"page":@(page)} success:^(id json) {
        NSLog(@"团购订单列表 =======  %@",json);
        if (ISPostSuccess) {
            NSArray *arr = [JHGroupOrderModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error : %@",error.description);
        block(nil,NOTCONNECT_STR);
    }];
}

+(void)getGroupOrderDetail:(NSString *)order_id block:(ModelBlock)block{
    [HttpTool postWithAPI:@"client/v3/tuan/order/detail" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"团购订单详情 =======  %@",json);
        if (ISPostSuccess) {
            JHGroupOrderModel *model = [JHGroupOrderModel mj_objectWithKeyValues:json[@"data"]];
            block(model,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error : %@",error.description);
        block(nil,NOTCONNECT_STR);
    }];
}


+(void)cancelOrderWith:(NSString *)order_id block:(MsgBlock)block{
    [HttpTool postWithAPI:@"client/v3/order/cancel" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"取消团购订单 =======  %@",json);
        if (ISPostSuccess) {
            block(YES, Error_Msg);
        }else{
            block(NO,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error : %@",error.description);
        block(nil,NOTCONNECT_STR);
    }];
}

+(void)refundOrderWith:(NSString *)order_id block:(MsgBlock)block{
    [HttpTool postWithAPI:@"client/v3/order/refund" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"退款团购订单 =======  %@",json);
        if (ISPostSuccess) {
            block(YES, Error_Msg);
        }else{
            block(NO,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error : %@",error.description);
        block(nil,NOTCONNECT_STR);
    }];
}

@end

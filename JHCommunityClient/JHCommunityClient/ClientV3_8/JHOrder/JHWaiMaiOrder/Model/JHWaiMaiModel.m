//
//  JHWaiMaiModel.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWaiMaiModel.h"
 

@implementation JHWaiMaiModel

-(void)setLimit_time:(NSString *)limit_time{
    _limit_time = limit_time;
    if (_limit_time == 0) {
       _limit_time_str = @"";
    }else{
        int mint = [_limit_time intValue] / 60;
        int sec = [_limit_time intValue] % 60;
        if (mint == 0 ) {
            _limit_time_str =  [NSString stringWithFormat: NSLocalizedString(@"剩余%02d秒", NSStringFromClass([self class])),sec];
        }else{
           _limit_time_str =  [NSString stringWithFormat: NSLocalizedString(@"剩余%02d分%02d秒", NSStringFromClass([self class])),mint,sec];
        }
 
    }
}

-(NSArray *)packageAndSendMoney_arr{
    if (!_packageAndSendMoney_arr) {
        NSMutableArray *arr = [NSMutableArray array];
        if ([_package_price floatValue] != 0) {
            [arr addObject:@{@"title": NSLocalizedString(@"打包费", NSStringFromClass([self class])),
                             @"center":@"",
                             @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", nil),_package_price]}];
        }
        if ([_freight floatValue] != 0) {
            [arr addObject:@{@"title": NSLocalizedString(@"配送费", NSStringFromClass([self class])),
                             @"center":@"",
                             @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", nil),_freight]}];
        }
        return arr.copy;
    }
    return _packageAndSendMoney_arr;
}

-(NSArray *)youhui_arr{
    if (!_youhui_arr) {
        NSMutableArray *arr = [NSMutableArray array];
        if ([_first_youhui floatValue] != 0) {
            [arr addObject:@{@"title": NSLocalizedString(@"首单立减", NSStringFromClass([self class])),
                             @"center":@"",
                             @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"-¥", nil),_first_youhui]}];
        }
        if ([_order_youhui floatValue] != 0) {
            [arr addObject:@{@"title": NSLocalizedString(@"满减", NSStringFromClass([self class])),
                             @"center":@"",
                             @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"-¥", nil),_order_youhui]}];
        }
        
        if ([_coupon_id intValue] != 0) {
            [arr addObject:@{@"title": NSLocalizedString(@"优惠劵", NSStringFromClass([self class])),
                             @"center":@"",
                             @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"-¥", nil),_coupon]}];
        }
        if ([_hongbao_id intValue] != 0) {
            [arr addObject:@{@"title": NSLocalizedString(@"红包", NSStringFromClass([self class])),
                             @"center":@"",
                             @"right":[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"-¥", nil),_hongbao]}];
        }
        return arr.copy;
    }
    return _youhui_arr;
}

+(void)getWMOrderList:(NSInteger)type page:(int)page block:(DataBlock)block{
    [HttpTool postWithAPI:@"client/v3/waimai/order/items" withParams:@{@"type":@(type),@"page":@(page)} success:^(id json) {
        NSLog(@"外卖订单列表 =======  %@",json);
        if (ISPostSuccess) {
            NSArray *arr = [JHWaiMaiModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else{
            block(nil,Error_Msg);
        }
    } failure:^(NSError *error) {
        NSLog(@"error : %@",error.description);
        block(nil,NOTCONNECT_STR);
    }];
}

+(void)getWMOrderDetail:(NSString *)order_id block:(ModelBlock)block{
    [HttpTool postWithAPI:@"client/v3/waimai/order/detail" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"外卖订单详情 =======  %@",json);
        if (ISPostSuccess) {
            JHWaiMaiModel *model = [JHWaiMaiModel mj_objectWithKeyValues:json[@"data"]];
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
        NSLog(@"取消外卖订单 =======  %@",json);
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
        NSLog(@"退款外卖订单 =======  %@",json);
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

+(void)cuiOrderWith:(NSString *)order_id block:(MsgBlock)block{
    [HttpTool postWithAPI:@"client/v3/waimai/order/cuidan" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"催单外卖订单 =======  %@",json);
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

+(void)sureSendedOrderWith:(NSString *)order_id block:(MsgBlock)block{
    [HttpTool postWithAPI:@"client/v3/order/confirm" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"确认送达外卖订单 =======  %@",json);
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

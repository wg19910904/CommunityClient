//
//  JHRunModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRunModel.h"

@implementation JHRunModel
+(JHRunModel *)creatJHRunModelWithDictionry:(NSDictionary * )dic{
    return [[JHRunModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        self.addr = dic[@"order"][@"o_addr"];
        self.o_addr = dic[@"addr"];
        self.mobile = dic[@"mobile"];
        self.intro = dic[@"intro"];
        self.o_mobile = dic[@"order"][@"o_mobile"];
        self.pay_status = dic[@"pay_status"];
        self.order_status = dic[@"order_status"];
        self.comment_status = dic[@"comment_status"];
        self.staff_id = dic[@"staff_id"];
        self.order_status_label = dic[@"order_status_label"];
        self.type = dic[@"order"][@"type"];
        self.order_id = dic[@"order_id"];
        self.dateline = dic[@"dateline"];
        self.hongbao = dic[@"hongbao"];
        self.amount = dic[@"amount"];
        self.paotui_amount = dic[@"order"][@"paotui_amount"];
        self.jiesuan_amount = dic[@"order"][@"jiesuan_amount"];
        self.danbao_amount = dic[@"order"][@"danbao_amount"];
        self.jifen = dic[@"jifen"];
        self.chajia = [NSString stringWithFormat:@"%.2f",[_jiesuan_amount floatValue] - [_danbao_amount floatValue]];
    }
    return self;
}
@end

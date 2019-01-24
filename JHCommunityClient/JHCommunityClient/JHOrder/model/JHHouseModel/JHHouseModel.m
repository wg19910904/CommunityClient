//
//  JHHouseModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseModel.h"

@implementation JHHouseModel
+(JHHouseModel * )creatJHHouseModelWithDictiionary:(NSDictionary *)dic{
    return [[JHHouseModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        self.addr = dic[@"addr"];
        self.dateline = dic[@"dateline"];
        self.order_status_label = dic[@"order_status_label"];
        self.order_status = dic[@"order_status"];
        self.pay_status = dic[@"pay_status"];
        self.staff_id = dic[@"staff_id"];
        self.order_id = dic[@"order_id"];
        self.intro = dic[@"intro"];
        self.comment_status = dic[@"comment_status"];
        self.cate_icon = dic[@"order"][@"icon"];
        self.cate_title = dic[@"order"][@"cate_title"];
        self.danbao_amount = dic[@"order"][@"danbao_amount"];
        self.jifen = dic[@"jifen"];
        self.jiesuan_price = dic[@"order"][@"jiesuan_price"];
        self.hongbao = dic[@"hongbao"];
        self.chajia = [NSString stringWithFormat:@"%.2f",[_jiesuan_price floatValue] - [_danbao_amount floatValue]-self.hongbao.floatValue];
        self.amount = dic[@"amount"];
        
    }
    return self;
}
@end

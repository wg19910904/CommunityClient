//
//  JHTakeyawayModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTakeyawayModel.h"

@implementation JHTakeyawayModel
+(JHTakeyawayModel *)creatJHTakeyawayWithDictionary:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    return [[JHTakeyawayModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary * )dic{
    self = [super init];
    if (self) {
        self.dateline = dic[@"dateline"];
        self.product_number = dic[@"order"][@"product_number"];
        self.product_price = dic[@"order"][@"product_price"];
        self.order_id =  dic[@"order_id"];
        self.order_status_label = dic[@"order_status_label"];
        self.order_status_warning = dic[@"order_status_warning"];
        self.staff_id = dic[@"staff_id"];
        self.pay_status = dic[@"pay_status"];
        self.product_photo = [dic[@"waimai_logo"] isKindOfClass:[NSDictionary class]] ? dic[@"waimai_logo"][@"logo"] : @"";
        self.product_name = [dic[@"waimai_title"] isKindOfClass:[NSDictionary class]] ?  dic[@"waimai_title"][@"title"] : @"";
        self.order_status = dic[@"order_status"];
        self.comment_status = dic[@"comment_status"];
        self.package_price = dic[@"order"][@"package_price"];
        self.amount = dic[@"amount"];
        self.hongbao = dic[@"hongbao"];
        self.order_youhui = dic[@"order_youhui"];
        self.hongbao_id = dic[@"hongbao_id"];
        self.freight = dic[@"order"][@"freight"];
        self.jifen = dic[@"jifen"];
        self.shop_mobile = dic[@"shop"][@"mobile"];
        self.pei_type = dic[@"pei_type"];
        self.online_pay = dic[@"online_pay"];
        self.first_youhui = dic[@"first_youhui"];
    }
    return self;
}
@end

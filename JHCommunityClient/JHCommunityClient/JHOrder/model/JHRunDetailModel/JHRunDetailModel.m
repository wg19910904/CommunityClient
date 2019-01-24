//
//  JHRunDetailModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRunDetailModel.h"

@implementation JHRunDetailModel
+(JHRunDetailModel *)creatJHRunDetailModelWithDictionary:(NSDictionary *)dic{
    return [[JHRunDetailModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        self.order_status = dic[@"order_status"];
        self.order_status_label = dic[@"order_status_label"];
        self.order_status_warning = dic[@"order_status_warning"];
        self.type = dic[@"detail"][@"type"];
        self.order_id = dic[@"detail"][@"order_id"];
        self.dateline = [self returnTimeWithNum:dic[@"dateline"]];
        self.contact = dic[@"contact"];
        self.mobile = dic[@"mobile"];
        self.addr = dic[@"addr"];
        self.time = [self returnTimeWithNum:dic[@"detail"][@"time"]];
        self.o_time = [self returnTimeWithNum:dic[@"detail"][@"o_time"]];
        self.intro = dic[@"intro"];
        self.paotui_amount = dic[@"detail"][@"paotui_amount"];
        self.danbao_amount = dic[@"detail"][@"danbao_amount"];
        self.jiesuan_amount = dic[@"detail"][@"jiesuan_amount"];
        self.jiesuan_amount = dic[@"detail"][@"expected_price"];
        self.pay_status = dic[@"pay_status"];
        self.o_name  = dic[@"staff"][@"name"];
        self.o_dateline = [self returnTimeWithNum:@(MAX([dic[@"staff"][@"dateline"] integerValue], [dic[@"staff"][@"updatetime"] integerValue])).stringValue];
        self.o_mobile = dic[@"staff"][@"mobile"];
        self.hongbao = dic[@"hongbao"];
        self.photo = dic[@"photos"][0][@"photo"];
        self.voice_time = dic[@"voice"][0][@"voice_time"];
        self.voice= dic[@"voice"][0][@"voice"];
        self.house = dic[@"house"];
        self.contact = dic[@"contact"];
        self.mobile = dic[@"mobile"];
        self.o_addr = dic[@"detail"][@"o_addr"];
        self.o_house = dic[@"detail"][@"o_house"];
        self.o_contact = dic[@"detail"][@"o_contact"];
        self.oo_mobile = dic[@"detail"][@"o_mobile"];
        self.staff_id = dic[@"staff_id"];
        self.comment_status = dic[@"detail"][@"comment_status"];
        self.total_price = dic[@"detail"][@"total_price"];
    }
    return self;
}
-(NSString *)returnTimeWithNum:(NSString *)dateline{
    NSInteger num = [dateline integerValue];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}

@end

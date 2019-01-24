//
//  JHRunProgressModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRunProgressModel.h"

@implementation JHRunProgressModel
+(JHRunProgressModel * )creatJHRunProgressModelWithDictionary:(NSDictionary *)dic{
    return [[JHRunProgressModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary * )dic{
    if (self == [super init]) {
        self.modelArray = [NSMutableArray array];
        self.dateline = [self returnTimeWithNum:dic[@"dateline"]];
        self.order_id = dic[@"order_id"];
        self.comment_status = dic[@"comment_status"];
        self.intro = dic[@"intro"];
        self.addr = dic[@"addr"];
        self.mobile = dic[@"mobile"];
        self.order_status = dic[@"order_status"];
        self.order_status_label = dic[@"order_status_label"];
        self.order_status_warning = dic[@"order_status_warning"];
        self.pay_status = dic[@"pay_status"];
        self.staff_id = dic[@"staff_id"];
        self.mobile_shop = dic[@"shop"][@"mobile"];
        self.mobile_staff = dic[@"staff"][@"mobile"];
        self.lat_shop = dic[@"shop"][@"lat"];
        self.lng_shop = dic[@"shop"][@"lng"];
        self.lat_staff = dic[@"staff"][@"lat"];
        self.lng_staff = dic[@"staff"][@"lng"];
        self.danbao_amount = dic[@"danbao_amount"];
        self.paotui_amount = dic[@"paotui_amount"];
        self.jifen = [NSString stringWithFormat:@"%ld",[dic[@"amount"] integerValue] * [dic[@"jifen_ratio"] integerValue]];
        self.amount = dic[@"danbao_amount"];
        self.jiesuan_price = dic[@"jiesuan_amount"];
        self.chajia = [NSString stringWithFormat:@"%f",[dic[@"jiesuan_amount"] floatValue ] - [dic[@"danbao_amount"] floatValue]];
        NSArray * tempArray = dic[@"log"];
        for (NSDictionary * dictionary in tempArray) {
            JHRModel * model = [JHRModel creatJHRModelWithDictionary:dictionary];
            [self.modelArray addObject:model];
        }
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
@implementation JHRModel
+(JHRModel * )creatJHRModelWithDictionary:(NSDictionary *)dic{
    return [[JHRModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary * )dic{
    if (self == [super init]) {
        self.dateline = [self returnTimeWithNum:dic[@"dateline"]];
        self.text = dic[@"log"];
        self.status = dic[@"status"];
        self.from = dic[@"from"];
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
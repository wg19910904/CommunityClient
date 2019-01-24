//
//  JHHouseProgressModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseProgressModel.h"

@implementation JHHouseProgressModel
+(JHHouseProgressModel *)creatJHHouseProgressModelWithDictionary:(NSDictionary *)dic{
    return [[JHHouseProgressModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
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
        self.danbao_amount  = dic[@"danbao_amount"];
        self.jifen = [NSString stringWithFormat:@"%ld",[dic[@"amount"] integerValue] * [dic[@"jifen_ratio"] integerValue]];
        self.amount = dic[@"amount"];
        self.jiesuan_price = dic[@"jiesuan_price"];
        self.hongbao = dic[@"hongbao"];
        self.chajia = [NSString stringWithFormat:@"%f",[dic[@"jiesuan_price"] floatValue ] - [dic[@"amount"] floatValue]-self.hongbao.floatValue];
        NSArray * tempArray = dic[@"log"];
        for (NSDictionary * dictionary in tempArray) {
            JHHModel * model = [JHHModel creatJHHModelWithDictionary:dictionary];
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
@implementation JHHModel
+(JHHModel * )creatJHHModelWithDictionary:(NSDictionary *)dic{
    return [[JHHModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary * )dic{
    if (self == [super init]) {
        self.dateline = [self returnTimeWithDateLine:dic[@"dateline"]];
        self.text = dic[@"log"];
        self.status = dic[@"status"];
        self.from = dic[@"from"];
    }
    return self;
}
-(NSString * )returnTimeWithDateLine:(NSString *)dateline{
    NSInteger num = [dateline integerValue];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}
@end

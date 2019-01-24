//
//  JHHouseDetailModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseDetailModel.h"

@implementation JHHouseDetailModel
+(JHHouseDetailModel *)creatJHHouseDetailModelWithDictionary:(NSDictionary *)dic{
    return [[JHHouseDetailModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        self.photoArray = [NSMutableArray array];
        self.order_status_label = dic[@"order_status_label"];
        self.order_status_warning = dic[@"order_status_warning"];
        self.order_status = dic[@"order_status"];
        self.pay_status = dic[@"pay_status"];
        self.order_id = dic[@"detail"][@"order_id"];
        self.comment_status = dic[@"comment_status"];
        self.dateline = [self returnTimeWithNum:dic[@"dateline"]];
        self.contact = dic[@"contact"];
        self.mobile = dic[@"mobile"];
        self.addr = dic[@"addr"];
        self.fuwu_time = [self returnTimeWithNum:dic[@"detail"][@"fuwu_time"]];
        self.online_pay = dic[@"online_pay"];
        self.intro = dic[@"intro"];
        self.voice_time = dic[@"voice"][0][@"voice_time"];
        self.voice= dic[@"voice"][0][@"voice"];
        for (NSDictionary * dictionary in dic[@"photos"]) {
            NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dictionary[@"photo"]];
            [self.photoArray addObject:url];
        }
        self.danbao_amount = dic[@"detail"][@"danbao_amount"];
        self.name = dic[@"staff"][@"name"];
        self.mobile_service = dic[@"staff"][@"mobile"];
        self.hongbao = dic[@"hongbao"];
        self.jiesuan_price = dic[@"detail"][@"jiesuan_price"];
        self.amount = dic[@"amount"];
        self.staff_id = dic[@"staff_id"];
        self.pay_code = dic[@"pay_code"];
        self.cate_title = dic[@"detail"][@"cate_title"];
    }
    return self;
}
-(NSString *)online_pay{
    if (_pay_code.length > 1) {
        return _pay_code;
    }else{
       // return [_online_pay integerValue] == 1? NSLocalizedString(@"在线支付", nil):NSLocalizedString(@"在线支付", nil);
        return NSLocalizedString(@"等待支付", nil);
    }

    
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

//
//  JHGroupDetailModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGroupDetailModel.h"
#import "GaoDe_Convert_BaiDu.h"
@implementation JHGroupDetailModel
+(JHGroupDetailModel *)creatJHGroupDetailModelWithDictionary:(NSDictionary *)dic{
    return [[JHGroupDetailModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary * )dic{
    if (self == [super init]) {
        self.modelArray = [NSMutableArray array];
        self.tuan_photo = dic[@"shop"][@"logo"];
        self.tuan_title = dic[@"shop"][@"title"];
        self.amount = dic[@"amount"];
        self.tuan_number = dic[@"detail"][@"tuan_number"];
        self.tuan_price = dic[@"detail"][@"tuan_price"];
        self.order_status = dic[@"order_status"];
        self.pay_status = dic[@"pay_status"];
        self.type = dic[@"detail"][@"type"];
        self.title = dic[@"shop"][@"title"];
        self.hongbao = dic[@"detail"][@"hongbao"];
        self.coupon = dic[@"detail"][@"coupon"];
        double lat;
        double lng;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[dic[@"shop"][@"lat"] doubleValue]
                                                     WithBD_lon:[dic[@"shop"][@"lng"] doubleValue]
                                                     WithGD_lat:&lat WithGD_lon:&lng];

        self.lat = @(lat).description;
        self.lng = @(lng).description;
        self.addr = dic[@"shop"][@"addr"];
        self.shopMobile = dic[@"shop"][@"mobile"];
        self.order_id = dic[@"detail"][@"order_id"];
        self.mobile = dic[@"mobile"];
        self.pay_time = dic[@"detail"][@"pay_time"];
        self.shop_id = dic[@"shop_id"];
        self.tuan_id = dic[@"detail"][@"tuan_id"];
        self.comment_status = dic[@"comment_status"];
        self.jifen = dic[@"jifen"];
        NSArray * tempArray = dic[@"quan"];
        if (tempArray.count != 0) {
            for (NSDictionary * dictionary in tempArray) {
                JHOModel * model = [JHOModel creatJHModelWithDictionry:dictionary];
                [self.modelArray addObject:model];
            }
        }else{
            NSLog(@"数组是空的");
            if (self.pay_status.integerValue > 0) {
                [self.modelArray addObject:[JHOModel new]];
            }
        }
    }
    return self;
}
-(NSString *)returnTimeWithDateLine:(NSString *)dateline{
    NSInteger num = [dateline integerValue];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}
-(NSString *)pay_time{
    NSLog(@"%@",_pay_time);
  if ([_pay_time isEqualToString:@"0"]) {
      if ([_pay_status integerValue] == 0 && [_order_status integerValue] != -1) {
           return NSLocalizedString(@"待支付", nil);
      }else{
          return NSLocalizedString(@"用户已取消订单", nil);
      }
   
  }
    return [self returnTimeWithDateLine:_pay_time];
}
@end

@implementation JHOModel

+(JHOModel *)creatJHModelWithDictionry:(NSDictionary * )dic{
    return [[JHOModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary * )dic{
    if (self == [super init]) {
        
            self.ltime = [self returnTimeWithDateLine:dic[@"ltime"]];
            self.status = dic[@"status"];
            self.number = dic[@"number"];
            self.count = dic[@"count"];
}
    return self;
}
-(NSString *)returnTimeWithDateLine:(NSString *)dateline{
    NSInteger num = [dateline integerValue];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}
@end

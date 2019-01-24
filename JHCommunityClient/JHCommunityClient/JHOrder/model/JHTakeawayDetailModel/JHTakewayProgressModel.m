//
//  JHTakewayProgressModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTakewayProgressModel.h"
#import "GaoDe_Convert_BaiDu.h"
@implementation JHTakewayProgressModel
+(JHTakewayProgressModel * )creatJHTakewayProgressModelWithDictionary:(NSDictionary *)dic{
    return [[JHTakewayProgressModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary * )dic{
    if (self == [super init]) {
        self.modelArray = [NSMutableArray array];
        self.dateline = dic[@"dateline"];
        self.order_id = dic[@"order_id"];
        self.comment_status = dic[@"comment_status"];
        self.intro = dic[@"intro"];
        self.addr = dic[@"addr"];
        self.mobile = dic[@"mobile"];
        self.spend_number = dic[@"spend_number"];
        self.order_status = dic[@"order_status"];
        self.order_status_label = dic[@"order_status_label"];
        self.order_status_warning = dic[@"order_status_warning"];
        self.pay_status = dic[@"pay_status"];
        self.staff_id = dic[@"staff_id"];
        self.mobile_shop = dic[@"shop"][@"mobile"];
        self.mobile_staff = dic[@"staff"][@"mobile"] ? dic[@"staff"][@"mobile"] : @"";
        double lat;
        double lng;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[dic[@"staff"][@"lat"] doubleValue]
                                                     WithBD_lon:[dic[@"staff"][@"lng"] doubleValue]
                                                     WithGD_lat:&lat WithGD_lon:&lng];
        double lat1;
        double lng1;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[dic[@"shop"][@"lat"] doubleValue]
                                                     WithBD_lon:[dic[@"shop"][@"lng"] doubleValue]
                                                     WithGD_lat:&lat1 WithGD_lon:&lng1];
        double lat2;
        double lng2;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[dic[@"lat"] doubleValue]
                                                     WithBD_lon:[dic[@"lng"] doubleValue]
                                                     WithGD_lat:&lat2 WithGD_lon:&lng2];
        self.lat_shop = @(lat1).description;
        self.lng_shop = @(lng1).description;
        self.lat_staff = @(lat).description;
        self.lng_staff = @(lng).description;
        self.lat = @(lat2).description;
        self.lng = @(lng2).description;
        self.online_pay = dic[@"online_pay"];
        if ([dic[@"spend_status"] integerValue] == 0) {
            self.spend_status = NSLocalizedString(@"待商家核销", nil);
        }else{
            self.spend_status = NSLocalizedString(@"商家已核销", nil);
        }
        self.amount =dic[@"amount"];
        self.freight = dic[@"freight"];
        self.package_price = dic[@"package_price"];
        self.product_price = dic[@"product_price"];
        self.pei_type = dic[@"pei_type"];
        self.first_youhui = dic[@"first_youhui"];
        self.order_youhui = dic[@"order_youhui"];
        self.hongbao = dic[@"hongbao"];
        self.jifen = [NSString stringWithFormat:@"%ld",[dic[@"jifen_ratio"] integerValue] * [dic[@"amount"] integerValue]];
        NSArray * tempArray = dic[@"log"];
        for (NSDictionary * dictionary in tempArray) {
            JHOtherModel * model = [JHOtherModel creatJHOtherModelWithDcitionary:dictionary];
            [self.modelArray addObject:model];
        }
    }
    return self;
}
@end
@implementation JHOtherModel
+(JHOtherModel *)creatJHOtherModelWithDcitionary:(NSDictionary *)dic{
    return [[JHOtherModel alloc]initWithDictionry:dic];
}
-(id)initWithDictionry:(NSDictionary * )dic{
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

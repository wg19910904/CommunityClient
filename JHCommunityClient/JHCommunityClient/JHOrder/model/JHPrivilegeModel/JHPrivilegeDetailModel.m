//
//  JHPrivilegeDetailModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegeDetailModel.h"
#import "GaoDe_Convert_BaiDu.h"
@implementation JHPrivilegeDetailModel
+(JHPrivilegeDetailModel *)shareJHPrivilegeDetailModelWithDictionary:(NSDictionary *)dic{
    return [[JHPrivilegeDetailModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        self.amount = dic[@"amount"];
        self.dateline = dic[@"dateline"];
        self.order_id = dic[@"order_id"];
        self.order_status = dic[@"order_status"];
        self.order_status_label = dic[@"order_status_label"];
        self.order_youhui = dic[@"order_youhui"];
        self.addr =   dic[@"shop"][@"addr"];
        self.title =  dic[@"shop"][@"title"];
        double lat;
        double lng;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[dic[@"shop"][@"lat"] doubleValue]
                                                     WithBD_lon:[dic[@"shop"][@"lng"] doubleValue]
                                                     WithGD_lat:&lat WithGD_lon:&lng];
        
        self.lat = @(lat).description;
        self.lng = @(lng).description;
        self.mobile = dic[@"shop"][@"mobile"];
        self.comment_status = dic[@"comment_status"];
        self.photo = dic[@"shop"][@"logo"];
        self.pay_status = dic[@"pay_status"];
        self.jifen = dic[@"jifen"];
        self.phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        self.total_price = dic[@"total_price"];
        self.money = dic[@"money"];
    }
    return self;
}
@end

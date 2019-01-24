//
//  JHPrivilegeListModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegeListModel.h"

@implementation JHPrivilegeListModel
+(JHPrivilegeListModel *)shareJHPrivilegeListModelWithDictionary:(NSDictionary *)dic{
    return [[JHPrivilegeListModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"shop"][@"title"];
        self.amount = dic[@"amount"];
        self.order_youhui = dic[@"order_youhui"];
        self.dateline = dic[@"dateline"];
        self.order_status = dic[@"order_status"];
        self.order_status_label = dic[@"order_status_label"];
        self.pay_status = dic[@"pay_status"];
        self.photo = dic[@"shop"][@"logo"];
        self.jifen = dic[@"jifen"];
        self.order_id = dic[@"order_id"];
        self.comment_status = dic[@"comment_status"];
        self.total_price = dic[@"total_price"];
        self.money = dic[@"money"];
    }
    return self;
}
@end

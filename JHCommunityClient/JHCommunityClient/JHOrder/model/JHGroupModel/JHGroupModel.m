//
//  JHGroupModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGroupModel.h"

@implementation JHGroupModel
+(JHGroupModel * )creatJHGroupModelWithDictionary:(NSDictionary * )dic{
    return [[JHGroupModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        self.dateline = dic[@"dateline"];
        self.tuan_number = dic[@"order"][@"tuan_number"];
        self.tuan_price = dic[@"order"][@"tuan_price"];
        self.order_id = dic[@"order"][@"order_id"];
        self.order_status_label = dic[@"order_status_label"];
        self.staff_id = dic[@"staff_id"];
        self.pay_status = dic[@"pay_status"];
        self.photo = dic[@"shop"][@"logo"];
        self.tuan_title = dic[@"shop"][@"title"];
        self.order_status = dic[@"order_status"];
        self.comment_status = dic[@"comment_status"];
        self.type = dic[@"order"][@"type"];
        self.jifen = dic[@"jifen"];
        self.photoOther = dic[@"photo"];
        self.total_price = dic[@"total_price"];
//        NSString * price = [NSString stringWithFormat:@"%ld",[dic[@"amount"] integerValue]/[dic[@"ticket"][@"count"] integerValue]];
//        self.dictionary = @{@"amount":dic[@"amount"],
//                            @"code":dic[@"ticket"][@"number"],
//                            @"ltime":dic[@"ticket"][@"ltime"],
//                            @"number":dic[@"ticket"][@"count"],
//                            @"order_id":dic[@"order_id"],
//                            @"price":price,
//                            @"stime":dic[@"dateline"],
//                            @"title":dic[@"order"][@"tuan_title"]};
//        NSLog(@"%@",self.dictionary);
}
    return self;
}
@end

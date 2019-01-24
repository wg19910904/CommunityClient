
//  JHIntegrationOrderListModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/9/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHIntegrationOrderListModel : NSObject
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *city_id;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *from;
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *online_pay;
@property (nonatomic,copy)NSString *pay_status;
@property (nonatomic,copy)NSString *trade_no;
@property (nonatomic,copy)NSString *total_price;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *contact;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *addr;
@property (nonatomic,copy)NSString *house;
@property (nonatomic,copy)NSString *lng;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *day;
@property (nonatomic,copy)NSString *intro;
@property (nonatomic,copy)NSString *pay_code;
@property (nonatomic,copy)NSString *pay_time;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *lasttime;
@property (nonatomic,copy)NSString *from_name;
@property (nonatomic,copy)NSString *order_status_label;
@property (nonatomic,copy)NSString *order_status_warning;
@property (nonatomic,copy)NSString *product_jifen;
@property (nonatomic,copy)NSString *product_price;
@property (nonatomic,copy)NSString *freight;
@property (nonatomic,strong)NSArray *product_list;
@property (nonatomic,strong)NSMutableArray *productArray;
@end

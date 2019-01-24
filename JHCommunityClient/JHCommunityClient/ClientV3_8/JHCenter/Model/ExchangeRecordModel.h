//
//  ExchangeRecordModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeRecordModel : NSObject
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *product_id;
@property (nonatomic,copy)NSString *product_number;
@property (nonatomic,copy)NSString *product_name;
@property (nonatomic,copy)NSString *contact;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *addr;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *product_jifen;
@property (nonatomic,copy)NSString *photo;
@end

//
//  JHIntegrationOrderListModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/9/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHIntegrationOrderProductModel : NSObject
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *product_id;
@property (nonatomic,copy)NSString *product_name;
@property (nonatomic,copy)NSString *product_photo;
@property (nonatomic,copy)NSString *product_price;
@property (nonatomic,copy)NSString *product_jifen;
@property (nonatomic,copy)NSString *product_number;
@end

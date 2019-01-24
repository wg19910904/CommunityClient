//
//  iIntegrationMallModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegrationMallModel : NSObject
@property (nonatomic,copy)NSString *product_id;
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *photo;
@property (nonatomic,copy)NSString *jifen;
@property (nonatomic,copy)NSString *info;
@property (nonatomic,copy)NSString *views;
@property (nonatomic,copy)NSString *sales;
@property (nonatomic,copy)NSString *sku;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *freight;
@end

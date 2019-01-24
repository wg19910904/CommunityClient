//
//  JHProductDetailSpecsModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/31.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHProductDetailSpecsModel : NSObject
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *product_id;
@property (nonatomic,copy)NSString *sale_count;
@property (nonatomic,copy)NSString *sale_sku;
@property (nonatomic,copy)NSString *spec_id;
@property (nonatomic,copy)NSString *spec_name;
@property (nonatomic,copy)NSString *spec_photo;
@property (nonatomic,copy)NSString *package_price;

@end

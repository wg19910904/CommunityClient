//
//  JHProductDetailModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/31.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHProductDetailModel : NSObject


@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *clientip;
@property (nonatomic,copy)NSString *closed;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *intro;
@property (nonatomic,copy)NSString *is_spec;
@property (nonatomic,copy)NSString *min_amount;
@property (nonatomic,copy)NSString *orderby;
@property (nonatomic,copy)NSString *package_price;
@property (nonatomic,strong)NSArray *spec_photos;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *product_id;
@property (nonatomic,copy)NSString *sale_count;
@property (nonatomic,copy)NSString *sale_sku;
@property (nonatomic,copy)NSString *sale_type;
@property (nonatomic,copy)NSString *sales;
@property (nonatomic,copy)NSString *shop_id;
@property (nonatomic,strong)NSArray *specs;
@property (nonatomic,copy)NSString *title;
@end

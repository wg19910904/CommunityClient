//
//  JHMenuSpecialModel.h
//  JHCommunityClient
//
//  Created by xixixi on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//  外卖和商超多规格商品页model

#import <Foundation/Foundation.h>

@interface JHMenuSpecialModel : NSObject
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *product_id;
@property(nonatomic,copy)NSString *sale_count;
@property(nonatomic,copy)NSString *sale_sku;
@property(nonatomic,copy)NSString *spec_id;
@property(nonatomic,copy)NSString *spec_name;
@property(nonatomic,copy)NSString *spec_photo;
@end

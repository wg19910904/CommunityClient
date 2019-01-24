//
//  JHProductDetailVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ShopCartAnimationVC.h"
#import "JHWaimaiMenuRightModel.h"
typedef void(^RefreshBlock)();
@interface JHProductDetailVC : ShopCartAnimationVC
@property(nonatomic,copy)NSString *product_id;
@property(nonatomic,copy)NSString *shop_id;

@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *productPrice;
@property(nonatomic,copy)NSString *package_price;
@property(nonatomic,copy)RefreshBlock refreshBlock;
@property(nonatomic,copy)NSString *max_num;
@property(nonatomic,assign)CGFloat min_amount;
@end

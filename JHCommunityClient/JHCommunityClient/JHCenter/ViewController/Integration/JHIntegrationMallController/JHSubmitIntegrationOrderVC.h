//
//  JHExchangeIntegrationVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ShopCartAnimationVC.h"

typedef void(^RefreshBlock)();

@interface JHSubmitIntegrationOrderVC : ShopCartAnimationVC
@property (nonatomic,copy)RefreshBlock refreshBlock;
@property (nonatomic,copy)NSString *product_id;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSString *shopName;
@property (nonatomic,copy)NSString *jifen;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *addr_id;
@end

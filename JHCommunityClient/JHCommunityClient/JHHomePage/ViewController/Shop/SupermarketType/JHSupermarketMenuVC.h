//
//  JHShopMenuVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ShopCartAnimationVC.h"
#import "JHSupermarketMainVC.h"
@interface JHSupermarketMenuVC : ShopCartAnimationVC

@property(nonatomic,copy)NSString *shop_id;
//外部传入cate_id
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *yy_stime;
@property(nonatomic,copy)NSString *yy_ltime;
@property(nonatomic,copy)NSString *yy_status;
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,weak)JHSupermarketMainVC *fatherVC;
//刷新数据
- (void)loadNewData;

@end

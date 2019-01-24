//
//  JHWaiMaiMenuVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ShopCartAnimationVC.h"
#import "JHWaiMaiMainVC.h"
@interface JHWaiMaiMenuVC : ShopCartAnimationVC
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *yy_stime;
@property(nonatomic,copy)NSString *yy_ltime;
@property(nonatomic,copy)NSString *yy_status;
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,weak)JHWaiMaiMainVC *fatherVC;
@end

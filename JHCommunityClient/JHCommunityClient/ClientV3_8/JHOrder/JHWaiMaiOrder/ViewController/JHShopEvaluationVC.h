//
//  JHEvaluationVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^ShopEvaluationSuccess)();
@interface JHShopEvaluationVC : JHBaseVC

@property (nonatomic,copy)NSString *order_id;//订单号
@property (nonatomic,copy)ShopEvaluationSuccess shopEvaluationSuccess;

@end

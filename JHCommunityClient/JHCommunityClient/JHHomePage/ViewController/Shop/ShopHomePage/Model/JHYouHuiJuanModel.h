//
//  JHYouHuiJuanModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/3.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHYouHuiJuanModel : NSObject
@property(nonatomic,strong)NSDictionary *coupon;
@property(nonatomic,strong)NSArray *coupons;
@property(nonatomic,copy)NSString *coupon_id;
@property(nonatomic,copy)NSString *need_pay;
@property(nonatomic,copy)NSString *youhui_lable;
@end

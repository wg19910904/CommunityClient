//
//  JHYouHuiJuanDetailModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/3.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHYouHuiJuanDetailModel : NSObject
//"coupon_amount" = 0;
//"coupon_id" = 0;
//"coupon_id" = "\U6682\U65e0\U53ef\U7528\U4f18\U60e0\U5238";
//"order_amount" = "";
//"use_lable" = "\U6682\U65e0\U53ef\U7528\U4f18\U60e0\U5238";
@property(nonatomic,copy)NSString *coupon_amount;
@property(nonatomic,copy)NSString *coupon_id;
@property(nonatomic,copy)NSString *deduct_lable;
@property(nonatomic,copy)NSString *order_amount;
@property(nonatomic,copy)NSString *use_lable;
@end

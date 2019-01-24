//
//  JHTakeyawayModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTakeyawayModel : NSObject
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * product_number;
@property(nonatomic,copy)NSString * product_price;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * order_status_label;
@property(nonatomic,copy)NSString * order_status_warning;
@property(nonatomic,copy)NSString * staff_id;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,copy)NSString * product_photo;
@property(nonatomic,copy)NSString * product_name;
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * package_price;
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * hongbao_id;
@property(nonatomic,copy)NSString * hongbao;
@property(nonatomic,copy)NSString * freight;
@property(nonatomic,copy)NSString * jifen;
@property(nonatomic,copy)NSString * shop_mobile;
@property(nonatomic,copy)NSString * pei_type;
@property(nonatomic,copy)NSString * online_pay;
@property(nonatomic,copy)NSString * order_youhui;
@property(nonatomic,copy)NSString * first_youhui;
+(JHTakeyawayModel *)creatJHTakeyawayWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary * )dic;
@end

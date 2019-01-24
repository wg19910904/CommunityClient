//
//  JHTakewayProgressModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHOtherModel;
@interface JHTakewayProgressModel : NSObject
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * intro;
@property(nonatomic,copy)NSString * addr;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * order_status_label;
@property(nonatomic,copy)NSString * order_status_warning;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,retain)NSMutableArray * modelArray;
@property(nonatomic,copy)NSString * staff_id;
@property(nonatomic,copy)NSString * mobile_staff;
@property(nonatomic,copy)NSString * mobile_shop;
@property(nonatomic,copy)NSString * lat_shop;
@property(nonatomic,copy)NSString * lng_shop;
@property(nonatomic,copy)NSString * lat_staff;
@property(nonatomic,copy)NSString * lng_staff;
@property(nonatomic,copy)NSString * lat;//订单地址lat
@property(nonatomic,copy)NSString * lng;//订单地址lng
@property(nonatomic,copy)NSString * amount;//实际支付
@property(nonatomic,copy)NSString * freight;//配送费
@property(nonatomic,copy)NSString * package_price;//打包费
@property(nonatomic,copy)NSString * product_price;//物品总价
@property(nonatomic,copy)NSString * pei_amount;//配送费
@property(nonatomic,copy)NSString * jifen;//积分
@property(nonatomic,copy)NSString * pei_type;
@property(nonatomic,copy)NSString * spend_number;
@property(nonatomic,copy)NSString * spend_status;
@property(nonatomic,copy)NSString * online_pay;
@property(nonatomic,copy)NSString * first_youhui;
@property(nonatomic,copy)NSString * hongbao;
@property(nonatomic,copy)NSString * order_youhui;
+(JHTakewayProgressModel * )creatJHTakewayProgressModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary * )dic;
@end
@interface JHOtherModel : NSObject
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * text;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * from;
+(JHOtherModel *)creatJHOtherModelWithDcitionary:(NSDictionary *)dic;
-(id)initWithDictionry:(NSDictionary * )dic;
@end
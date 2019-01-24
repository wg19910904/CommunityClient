//
//  JHGroupDetailModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHOModel;
@interface JHGroupDetailModel : NSObject
@property(nonatomic,copy)NSString *hongbao;
@property(nonatomic,copy)NSString * tuan_photo;
@property(nonatomic,copy)NSString * tuan_title;
@property(nonatomic,copy)NSString * tuan_number;
@property(nonatomic,copy)NSString * tuan_price;
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * tuan_id;
@property(nonatomic,copy)NSString * shop_id;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * lat;
@property(nonatomic,copy)NSString * lng;
@property(nonatomic,copy)NSString * addr;
@property(nonatomic,copy)NSString * shopMobile;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * pay_time;
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,copy)NSString * jifen;
@property(nonatomic,copy)NSString *coupon;
@property(nonatomic,retain)NSMutableArray * modelArray;
+(JHGroupDetailModel *)creatJHGroupDetailModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary * )dic;
@end
@interface JHOModel : NSObject
@property(nonatomic,copy)NSString * ltime;
@property(nonatomic,copy)NSString * number;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * count;
+(JHOModel *)creatJHModelWithDictionry:(NSDictionary * )dic;
-(id)initWithDictionary:(NSDictionary * )dic;
@end

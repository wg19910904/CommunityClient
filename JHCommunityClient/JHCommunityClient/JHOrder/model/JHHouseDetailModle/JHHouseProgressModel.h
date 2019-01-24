//
//  JHHouseProgressModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHHModel;
@interface JHHouseProgressModel : NSObject
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
@property(nonatomic,copy)NSString * danbao_amount;
@property(nonatomic,copy)NSString *hongbao;
@property(nonatomic,copy)NSString * jifen;
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * jiesuan_price;
@property(nonatomic,copy)NSString * chajia;
+(JHHouseProgressModel *)creatJHHouseProgressModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end
@interface JHHModel : NSObject
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * text;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * from;
+(JHHModel * )creatJHHModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary * )dic;
@end

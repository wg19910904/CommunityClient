//
//  JHHouseModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHHouseModel : NSObject
@property(nonatomic,copy)NSString * addr;
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * order_status_label;
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,copy)NSString * staff_id;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * intro;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * cate_icon;
@property(nonatomic,copy)NSString * cate_title;
@property(nonatomic,copy)NSString * danbao_amount;
@property(nonatomic,copy)NSString * jifen;
@property(nonatomic,copy)NSString * jiesuan_price;
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * chajia;
@property(nonatomic,copy)NSString *hongbao;

+(JHHouseModel * )creatJHHouseModelWithDictiionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

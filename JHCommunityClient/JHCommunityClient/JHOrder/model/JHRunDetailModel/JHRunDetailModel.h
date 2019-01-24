//
//  JHRunDetailModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHRunDetailModel : NSObject
@property(nonatomic,copy)NSString * order_status_label;
@property(nonatomic,copy)NSString * order_status_warning;
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * addr;//收货地址
@property(nonatomic,copy)NSString * house;//收货门牌号
@property(nonatomic,copy)NSString * contact;//收货联系人
@property(nonatomic,copy)NSString * mobile;//收货联系电话
@property(nonatomic,copy)NSString * o_addr;//取货地址
@property(nonatomic,copy)NSString * o_house;//取货门牌号
@property(nonatomic,copy)NSString * o_contact;//取货联系人
@property(nonatomic,copy)NSString * oo_mobile;//取货联系电话
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString * o_time;
@property(nonatomic,copy)NSString * intro;
@property(nonatomic,copy)NSString * paotui_amount;
@property(nonatomic,copy)NSString * danbao_amount;
@property(nonatomic,copy)NSString * jiesuan_amount;
@property(nonatomic,copy)NSString *total_price;
@property(nonatomic,copy)NSString * hongbao;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,copy)NSString * o_name;//服务人员姓名
@property(nonatomic,copy)NSString * o_mobile;//服务人员电话
@property(nonatomic,copy)NSString * o_dateline;//跑腿时间
@property(nonatomic,copy)NSString * photo;
@property(nonatomic,copy)NSString * voice;
@property(nonatomic,copy)NSString * voice_time;
@property(nonatomic,copy)NSString * staff_id;
@property(nonatomic,copy)NSString * expected_price;
+(JHRunDetailModel *)creatJHRunDetailModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

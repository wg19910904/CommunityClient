//
//  JHRunModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHRunModel : NSObject
@property(nonatomic,copy)NSString * addr;
@property(nonatomic,copy)NSString * o_addr;
@property(nonatomic,copy)NSString * intro;
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * o_mobile;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * order_status_label;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * paotui_amount;
@property(nonatomic,copy)NSString * danbao_amount;
@property(nonatomic,copy)NSString * jiesuan_amount;
@property(nonatomic,copy)NSString * hongbao;
@property(nonatomic,copy)NSString * staff_id;
@property(nonatomic,copy)NSString * jifen;
@property(nonatomic,copy)NSString * chajia;//需要补得差价
+(JHRunModel *)creatJHRunModelWithDictionry:(NSDictionary * )dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

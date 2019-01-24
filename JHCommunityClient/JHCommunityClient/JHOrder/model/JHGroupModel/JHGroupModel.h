//
//  JHGroupModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JHGroupModel : NSObject
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * tuan_number;
@property(nonatomic,copy)NSString * tuan_price;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * order_status_label;
@property(nonatomic,copy)NSString * staff_id;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,copy)NSString * photo;
@property(nonatomic,copy)NSString * tuan_title;
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * jifen;
@property(nonatomic,copy)NSString * photoOther;
@property(nonatomic,copy)NSString * total_price;
@property(nonatomic,retain)NSDictionary * dictionary;
+(JHGroupModel * )creatJHGroupModelWithDictionary:(NSDictionary * )dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

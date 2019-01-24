//
//  JHWaimaiMenuLeftModel.h
//  JHCommunityClient
//
//  Created by xixixi on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//  外卖menu页面左侧数据model

#import <Foundation/Foundation.h>

@interface JHWaimaiMenuLeftModel : NSObject
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSArray *child;
@property(nonatomic,copy)NSString *dateline;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *orderby;
@property(nonatomic,copy)NSString *parent_id;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *type;
@end

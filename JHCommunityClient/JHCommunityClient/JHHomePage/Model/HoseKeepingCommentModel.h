//
//  HoseKeepingCommentModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/24.
//  Copyright © 2016年 JiangHu. All rights reserved.
//阿姨详情评论模型

#import <Foundation/Foundation.h>

@interface HoseKeepingCommentModel : NSObject
@property (nonatomic,copy)NSString *clientip;
@property (nonatomic,copy)NSString *comment_id;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *reply;
@property (nonatomic,copy)NSString *reply_ip;
@property (nonatomic,copy)NSString *reply_time;
@property (nonatomic,copy)NSString *score;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)NSString *staff_name;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *nickname;
@end

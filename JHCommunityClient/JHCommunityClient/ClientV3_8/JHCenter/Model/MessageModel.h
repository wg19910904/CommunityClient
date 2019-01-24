//
//  MessageModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic,copy)NSString *message_id;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *is_read;
@property (nonatomic,copy)NSString *dateline;
@end

//
//  NeighbourCommentModel.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReplyBlock)(NSString *msg);

@interface NeighbourCommentModel : NSObject
@property(nonatomic,copy)NSString *reply_id;
@property(nonatomic,copy)NSString *tieba_id;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,strong)NSDictionary *member;
@property(nonatomic,copy)NSString *at_reply_id;
@property(nonatomic,copy)NSString *at_uid;
@property(nonatomic,strong)NSDictionary *at_member;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)NSInteger dateline;

/**
 *  回复评论
 *
 *  @param infoDic 回复的信息
 *  @param block   回调的block
 */
+(void)replyCommentWithInfoDic:(NSDictionary *)infoDic block:(ReplyBlock)block;
@end

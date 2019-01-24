//
//  NeighbourModel.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeighbourModel.h"
#import "NeighbourCommentModel.h"

@class NeighbourModel;

typedef void(^NeighbourBlock)(NSArray *arr,NSString *msg);
typedef void(^DetailBlock)(NeighbourModel *model,NSString *msg);

@interface NeighbourModel : NSObject
@property(nonatomic,copy)NSString *tieba_id;
@property(nonatomic,copy)NSString *city_id;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,assign)NSInteger dateline;//发表时间 UNXITIME
@property(nonatomic,copy)NSString *from;//话题类型 topic:话题, trade:交易
@property(nonatomic,assign)NSInteger lasttime;//最后回复时间 UNXITIME
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *likes;
@property(nonatomic,copy)NSString *views;
@property(nonatomic,copy)NSString *replys;
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@property(nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *dateline_label;//发布时间
/**
 *  face = "default/face.png";
    nickname = "\U533f\U540d";
    uid = 0;
 */
@property(nonatomic,strong)NSDictionary *member;
@property(nonatomic,strong)NSArray *photos;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *xiaoqu_id;
@property(nonatomic,copy)NSString *xiaoqu_title;

/**
 *  评论列表
 */
@property(nonatomic,strong)NSArray *items;


/**
 *  获取邻里圈列表
 *
 *  @param page  分页
 *  @param block 回调的block
 */
+(void)getNeighbourModelListWithPage:(int)page block:(NeighbourBlock)block;

/**
 *  邻里圈点赞
 *
 *  @param tieba_id 贴吧id
 *  @param block    回调的blcok
 */
+(void)likeTiebaWithId:(NSString *)tieba_id block:(NeighbourBlock)block;

/**
 *  获取圈子详情
 *
 *  @param tieba_id 贴吧id
 *  @param block    回调的block
 */
+(void)getNeighbourModelDeatilWithId:(NSString *)tieba_id block:(DetailBlock)block;

/**
 *  获取评论列表
 *
 *  @param page     分页
 *  @param tieba_id 贴吧id
 *  @param block    回调的block
 */
+(void)getNeighbourCommentListWithPage:(int)page tieba_id:(NSString *)tieba_id block:(NeighbourBlock)block;
@end

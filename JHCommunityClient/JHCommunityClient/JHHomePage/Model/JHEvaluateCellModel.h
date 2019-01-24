//
//  JHEvaluateCellModel.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHEvaluateCellModel : NSObject
@property(nonatomic,copy) NSString *comment_id;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *dateline;
@property(nonatomic,copy) NSString *face;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *reply;
@property(nonatomic,copy) NSString *reply_time;
@property(nonatomic,copy) NSString *score;
@property(nonatomic,copy) NSString *score_fuwu;
@property(nonatomic,copy) NSString *score_kouwei;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSArray  *comment_photos;
@property(nonatomic,copy) NSArray *photos;
@end

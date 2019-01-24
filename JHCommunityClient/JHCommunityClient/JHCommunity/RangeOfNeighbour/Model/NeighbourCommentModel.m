//
//  NeighbourCommentModel.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "NeighbourCommentModel.h"
 

@implementation NeighbourCommentModel

+(void)replyCommentWithInfoDic:(NSDictionary *)infoDic block:(ReplyBlock)block{
    
    [HttpTool postWithAPI:@"client/xiaoqu/tieba/reply" withParams:infoDic success:^(id json) {
        NSLog(@"回复评论  %@",json);
        if ([json[@"error"] intValue]==0) {
            block(@"回复成功");
        }else block(json[@"message"]);
    } failure:^(NSError *error) {
        block(@"服务器繁忙,请稍后再试!");
    }];
    
}

@end

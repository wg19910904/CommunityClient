//
//  HoseKeepingCommentFrameModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/24.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MaintainCommentFrameModel.h"
#import "NSObject+CGSize.h"
@implementation MaintainCommentFrameModel
- (void)setCommentModel:(MaintainCommentModel *)commentModel
{
    _commentModel = commentModel;
    CGSize size = [self currentSizeWithString:commentModel.content font:FONT(14) withWidth:40];
    self.commentRect = FRAME(10, 10, size.width,size.height);
    self.starRect = FRAME(10, 20 + self.commentRect.size.height, 80, 10);
    self.rowHeight = 80 + size.height;
}
@end

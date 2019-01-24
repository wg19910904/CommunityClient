//
//  HoseKeepingCommentFrameModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/24.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HoseKeepingCommentModel.h"
@interface HoseKeepingCommentFrameModel : NSObject
@property (nonatomic,assign)CGRect commentRect;
@property (nonatomic,assign)CGRect starRect;
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,strong)HoseKeepingCommentModel *commentModel;
@end

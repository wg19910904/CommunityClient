//
//  HoseKeepingCommentFrameModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/24.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaintainCommentModel.h"
@interface MaintainCommentFrameModel : NSObject
@property (nonatomic,assign)CGRect commentRect;
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,assign)CGRect starRect;
@property (nonatomic,strong)MaintainCommentModel *commentModel;
@end

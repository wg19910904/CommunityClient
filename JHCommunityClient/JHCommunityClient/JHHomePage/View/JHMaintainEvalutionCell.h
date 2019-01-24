//
//  JHHouseKeepingEvalutionCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅中评论列表的单元格

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "MaintainCommentFrameModel.h"
@interface JHMaintainEvalutionCell : UITableViewCell
@property (nonatomic,strong)UILabel *evalutionLabel;
@property (nonatomic,strong)UIView *starView;
@property (nonatomic,strong)UILabel *fromLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIView  *backView;
@property (nonatomic,strong)MaintainCommentFrameModel *frameModel;
@end

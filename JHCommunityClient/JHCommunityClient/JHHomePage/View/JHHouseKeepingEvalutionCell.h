//
//  JHHouseKeepingEvalutionCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//阿姨详情中评论列表的单元格

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "HoseKeepingCommentFrameModel.h"
@interface JHHouseKeepingEvalutionCell : UITableViewCell
@property (nonatomic,strong)UILabel *evalutionLabel;
@property (nonatomic,strong)UIView*starView;
@property (nonatomic,strong)UILabel *fromLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIView  *backView;
@property (nonatomic,strong)HoseKeepingCommentFrameModel *frameModel;
@end

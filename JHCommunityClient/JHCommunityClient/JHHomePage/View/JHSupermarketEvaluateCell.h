//
//  JHSupermarketEvaluateCell.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHEvaluateCellModel.h"

@interface JHSupermarketEvaluateCell : UITableViewCell
@property(nonatomic,strong)JHEvaluateCellModel *dataModel;
@property(nonatomic, strong)UIImageView *protraitIV;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *evaluateTimeLabel;
@property(nonatomic, strong)UIView *starView;
@property(nonatomic, strong)UILabel *evalucateContentLabel;
//评论图片
@property(nonatomic, strong)UIImageView *imageView_image1;
@property(nonatomic, strong)UIImageView *imageView_image2;
@property(nonatomic, strong)UIImageView *imageView_image3;
@property(nonatomic, strong)UIImageView *imageView_image4;
@property(nonatomic, strong)UILabel *replyLabel;
@property(nonatomic, strong)UILabel *replyTimeLabel;
@property(nonatomic, strong)UIView *imageBackView;
@property(nonatomic, strong)UIView *replyBackView;
@property(nonatomic, strong)UIImageView *arrowIV;
@end

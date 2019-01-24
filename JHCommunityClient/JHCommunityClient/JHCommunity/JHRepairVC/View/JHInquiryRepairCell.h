//
//  JHInquiryRepairCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHInquiryRepairModel.h"
@interface JHInquiryRepairCell : UITableViewCell
@property (nonatomic,strong)UILabel *infoLabel;//姓名+时间
@property (nonatomic,strong)UILabel *statusLabel;//状态
@property (nonatomic,strong)UILabel *contentLabel;//内容
@property (nonatomic,strong)UIButton *alertBnt;//提醒
@property (nonatomic,strong)UIButton *cancelBnt;//撤销
@property (nonatomic,strong)UIButton *deleteBnt;//删除
@property (nonatomic,strong)UIView *imgBackView;//照片背景视图
@property (nonatomic,assign)CGSize contentSize;
@property (nonatomic,strong)NSArray *imgArray;
@property (nonatomic,strong)JHInquiryRepairModel *inquiryModel;
- (CGFloat)getCellHeight;
@end

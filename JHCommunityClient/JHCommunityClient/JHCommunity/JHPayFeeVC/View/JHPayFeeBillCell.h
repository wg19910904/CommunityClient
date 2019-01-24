//
//  JHPayFeeBillCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPayFeeBillListModel.h"
@interface JHPayFeeBillCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;//图标
@property (nonatomic,strong)UILabel *infoLabel;//姓名 + 地址
@property (nonatomic,strong)UILabel *feeLabel;//费用
@property (nonatomic,strong)UILabel *timeLabel;//时间
@property (nonatomic,strong)UILabel *status;//状态
@property (nonatomic,strong)JHPayFeeBillListModel *payFeeBillListModel;
@end

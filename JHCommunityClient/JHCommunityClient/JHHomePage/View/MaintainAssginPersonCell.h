//
//  HouseKeepingAssginPersonCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/19.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅下单指定阿姨单元格

#import <UIKit/UIKit.h>
#import "MaintainListModel.h"
@interface MaintainAssginPersonCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *length;
@property (nonatomic,strong)UIView *startView;
@property (nonatomic,strong)UILabel *experience;
@property (nonatomic,strong)UILabel *service;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)MaintainListModel *assignModel;
@end

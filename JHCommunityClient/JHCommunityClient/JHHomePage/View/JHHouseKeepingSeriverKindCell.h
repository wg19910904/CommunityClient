//
//  JHHouseKeepingSeriverKindCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//家政阿姨详情中服务种类cell

#import <UIKit/UIKit.h>
#import "HouseKeepingSeriverKindModel.h"
@interface JHHouseKeepingSeriverKindCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *priceLbael;
@property (nonatomic,strong)UILabel *areaLabel;
@property (nonatomic,strong)HouseKeepingSeriverKindModel *seriverModel;
@end

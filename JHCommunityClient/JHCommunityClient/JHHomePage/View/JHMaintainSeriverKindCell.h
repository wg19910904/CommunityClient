//
//  JHHouseKeepingSeriverKindCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅详情中服务种类cell

#import <UIKit/UIKit.h>
#import "MaintainSeriverKindModel.h"
@interface JHMaintainSeriverKindCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *priceLbael;
@property (nonatomic,strong)UILabel *areaLabel;
@property (nonatomic,strong)MaintainSeriverKindModel *seriverModel;
@end

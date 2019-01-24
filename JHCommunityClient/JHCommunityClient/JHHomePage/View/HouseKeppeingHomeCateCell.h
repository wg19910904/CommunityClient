//
//  HouseKeppeingHomeCateCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//家政首页

#import <UIKit/UIKit.h>
#import "HouseKeepingHomeCateProductModel.h"
@interface HouseKeppeingHomeCateCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *pictureImg;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)HouseKeepingHomeCateProductModel *productModel;
@end

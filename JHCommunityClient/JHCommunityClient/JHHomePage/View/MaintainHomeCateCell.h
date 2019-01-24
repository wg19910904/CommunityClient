//
//  HouseKeppeingHomeCateCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅首页

#import <UIKit/UIKit.h>
#import "MaintainHomeCateProductModel.h"
@interface MaintainHomeCateCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *pictureImg;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)MaintainHomeCateProductModel *productModel;
@end

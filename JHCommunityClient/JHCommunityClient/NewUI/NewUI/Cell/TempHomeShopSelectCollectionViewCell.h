//
//  TempHomeShopSelectCollectionViewCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/13.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTempAdvModel.h"

@interface TempHomeShopSelectCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *topImageV;
@property (strong, nonatomic) UILabel *titlelabel;
@property(nonatomic,strong)JHTempAdvModel  *model;


@end

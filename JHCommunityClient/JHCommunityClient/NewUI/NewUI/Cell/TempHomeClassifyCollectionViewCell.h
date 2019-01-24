//
//  TempHomeClassifyCollectionViewCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/14.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTempAdvModel.h"

@interface TempHomeClassifyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *topImage;

@property (strong, nonatomic) UILabel *titlelabel;
@property(nonatomic,strong)JHTempAdvModel *model;

@end

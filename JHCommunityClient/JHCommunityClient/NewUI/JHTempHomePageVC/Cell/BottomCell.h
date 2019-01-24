//
//  BottomCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/24.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTempClientNewsModel.h"
@interface BottomCell : UITableViewCell
@property(nonatomic,retain)UICollectionView *myCollectionView;
@property(nonatomic,strong)JHTempClientNewsModel *model;
@end

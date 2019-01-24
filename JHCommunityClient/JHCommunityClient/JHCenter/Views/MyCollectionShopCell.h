//
//  MyCollectionShopCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "MyCollectionShopModel.h"
@interface MyCollectionShopCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *startView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *distanLabel;
@property (nonatomic,strong)UIImageView *distantImg;
@property (nonatomic,strong)MyCollectionShopModel *myCollectionShopModel;
@end

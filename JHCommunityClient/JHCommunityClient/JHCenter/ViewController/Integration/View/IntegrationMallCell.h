//
//  iIntegrationMallCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegrationMallModel.h"
@interface IntegrationMallCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *codeLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *addBnt;
@property (nonatomic,strong)IntegrationMallModel *integrationMallModel;
@end

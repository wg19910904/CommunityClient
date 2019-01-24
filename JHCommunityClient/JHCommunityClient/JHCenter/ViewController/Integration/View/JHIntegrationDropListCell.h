//
//  JHIntegrationDropListCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegrationMallCateBntModel.h"
@interface JHIntegrationDropListCell : UITableViewCell
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)IntegrationMallCateBntModel *model;
@end

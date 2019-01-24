//
//  JHIntegrationOrderListCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHIntegrationOrderProductModel.h"
@interface JHIntegrationOrderListCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *price;
@property (nonatomic,strong)UILabel *num;
@property (nonatomic,strong)JHIntegrationOrderProductModel *integrationProductModel;
@end

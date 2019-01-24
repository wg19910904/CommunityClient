//
//  IntegrationCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegrationModel.h"
@interface IntegrationCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *jifenLabel;
@property (nonatomic,strong)IntegrationModel *integrationModel;
@end

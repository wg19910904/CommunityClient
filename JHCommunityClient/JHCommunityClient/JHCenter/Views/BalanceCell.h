//
//  BalanceCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceModel.h"
@interface BalanceCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)BalanceModel *balanceModel;
@end

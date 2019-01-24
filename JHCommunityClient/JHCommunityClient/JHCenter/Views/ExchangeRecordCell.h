//
//  ExchangeRecordCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeRecordModel.h"
@interface ExchangeRecordCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *codeLabel;
@property (nonatomic,strong)UILabel *exchangeStatus;
@property (nonatomic,strong)ExchangeRecordModel *exchangeRecordModel;
@end

//
//  SendTableViewCellFive.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPaoTuiHongBaoModel.h"
@interface SendTableViewCellFive : UITableViewCell
@property(nonatomic,retain)UISlider * mySlider;
@property(nonatomic,retain)UIImageView * titleImage;
@property(nonatomic,retain)UILabel * moneyLabel;
@property(nonatomic,retain)UILabel * label1;
@property(nonatomic,retain)UILabel * label2;
@property(nonatomic,retain)UILabel * label3;
@property(nonatomic,retain)UILabel * label_currentMoney;
@property(nonatomic,strong)UILabel *hongbaoL;//展示红包的金额
@property(nonatomic,strong)JHPaoTuiHongBaoModel *model;
@property(nonatomic,copy)NSString *hongbao_id;//红包id
@property(nonatomic,copy)void(^myBlock)(NSString *money);
@end

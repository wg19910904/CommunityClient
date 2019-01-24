//
//  TakeawayOrderDetailCellTwo.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTakeawayDetailModel.h"
@interface TakeawayOrderDetailCellTwo : UITableViewCell
@property(nonatomic,retain)UIButton * btn_more;//显示再来一份
@property(nonatomic,retain)UILabel * label_totalMoney;//显示总价的
@property(nonatomic,retain)JHTakeawayDetailModel * model;
@end

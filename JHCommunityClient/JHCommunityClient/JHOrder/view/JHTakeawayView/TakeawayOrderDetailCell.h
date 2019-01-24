//
//  TakeawayOrderDetailCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTakeawayDetailModel.h"
@interface TakeawayOrderDetailCell : UITableViewCell
@property(nonatomic,retain)JHTakeawayDetailModel * model;
@property(nonatomic,retain)UIButton * btn_backOrder;//申请退单
@end

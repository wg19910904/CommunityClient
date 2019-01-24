//
//  TakeawayTableViewCellOne.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTakeyawayModel.h"
#import "JHOrderBtn.h"
@interface TakeawayTableViewCellOne : UITableViewCell
@property(nonatomic,retain)JHTakeyawayModel * model;
@property(nonatomic,retain)JHOrderBtn * btn;
@property(nonatomic,retain)UIButton * cancelBtn;
@end

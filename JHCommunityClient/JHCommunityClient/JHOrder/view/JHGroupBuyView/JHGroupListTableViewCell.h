//
//  JHGroupListTableViewCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGroupModel.h"
@interface JHGroupListTableViewCell : UITableViewCell
@property(nonatomic,retain)JHGroupModel * model;
@property(nonatomic,retain)UIButton * btn;
@property(nonatomic,retain)UIButton * cancelBtn;
@end

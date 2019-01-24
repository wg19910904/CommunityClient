//
//  JHPrivilegeListCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPrivilegeListModel.h"
@interface JHPrivilegeListCell : UITableViewCell
@property(nonatomic,retain)JHPrivilegeListModel * model;
@property(nonatomic,retain)UIButton * btn_cancel;//取消
@property(nonatomic,retain)UIButton * btn_evalute;//评价/待支付
@end

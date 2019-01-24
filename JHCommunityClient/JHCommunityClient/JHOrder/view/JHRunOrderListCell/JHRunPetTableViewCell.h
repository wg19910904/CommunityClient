//
//  JHRunPetTableViewCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRunModel.h"
#import "JHOrderBtn.h"
@interface JHRunPetTableViewCell : UITableViewCell
@property(nonatomic,retain)JHRunModel * model;
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,retain)JHOrderBtn * btn_pay;//支付按钮
@property(nonatomic,retain) JHOrderBtn * btn_cancel;//取消订单
@end

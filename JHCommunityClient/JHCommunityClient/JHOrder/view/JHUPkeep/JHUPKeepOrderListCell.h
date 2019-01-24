//
//  JHUPKeepOrderListCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface JHUPKeepOrderListCell : UITableViewCell
@property(nonatomic,retain)OrderModel * model;
@property(nonatomic,retain)UIButton * btn_cancel;//取消
@property(nonatomic,retain)UIButton * btn_pay;//去结算还是去支付

@end

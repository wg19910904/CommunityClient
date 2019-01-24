//
//  JHConvenientServiceCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHConvenientServiceModel.h"
@interface JHConvenientServiceCell : UITableViewCell
@property (nonatomic,strong)UIButton *mobileBtn;//电话按钮
@property (nonatomic,strong)JHConvenientServiceModel *convenientServiceModel;
@end

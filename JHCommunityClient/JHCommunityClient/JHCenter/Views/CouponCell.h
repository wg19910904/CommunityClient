//
//  CouponCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface CouponCell : UITableViewCell
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *money;
@property (nonatomic,strong)UILabel *password;
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,strong)UIImageView *codeImg;
@property (nonatomic,strong)UIImageView *backImg;
//@property (nonatomic,strong)UIImageView *middleImg;
//@property (nonatomic,strong)UIImageView *titleImg;
@property (nonatomic,strong)CouponModel *couponModel;
@end

//
//  JHPayBillDetailCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPayFeeBillDetailFrameModel.h"
@interface JHPayBillDetailCell : UITableViewCell
@property (nonatomic,strong)UILabel *houseName;//户名
@property (nonatomic,strong)UILabel *houseHold;//户号
@property (nonatomic,strong)UILabel *unitName;//缴费单位
@property (nonatomic,strong)UILabel *tenementFee;//物业费
@property (nonatomic,strong)UILabel *waterFee;//水费
@property (nonatomic,strong)UILabel *electricCharge;//电费
@property (nonatomic,strong)UILabel *gasFee;//燃气费
@property (nonatomic,strong)UIView *totalView;
@property (nonatomic,strong)UILabel *totalFee;//总费用
@property (nonatomic,strong)UILabel *money;//¥
@property (nonatomic,strong)UILabel *cheWeiFee;//车位费
@property (nonatomic,strong)UILabel *houseName1;//户名
@property (nonatomic,strong)UILabel *houseHold1;//户号
@property (nonatomic,strong)UILabel *unitName1;//缴费单位
@property (nonatomic,strong)UILabel *tenementFee1;//物业费
@property (nonatomic,strong)UILabel *waterFee1;//水费
@property (nonatomic,strong)UILabel *electricCharge1;//电费
@property (nonatomic,strong)UILabel *gasFee1;//燃气费
@property (nonatomic,strong)UILabel *cheWeiFee1;//车位费
@property (nonatomic,strong)JHPayFeeBillDetailFrameModel *payFeeBillDetailFrameModel;
@end

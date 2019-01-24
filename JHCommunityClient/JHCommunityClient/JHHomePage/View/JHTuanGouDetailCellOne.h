//
//  JHTuanGouDetailCellOne.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTuanGouDetialCellOneModel.h"
@interface JHTuanGouDetailCellOne : UITableViewCell<UIScrollViewDelegate>
@property(nonatomic, strong)JHTuanGouDetialCellOneModel *dataModel;
@property(nonatomic, strong)UIButton *orderBtn;
@property(nonatomic, strong)UIButton *phoneBtn;
@end

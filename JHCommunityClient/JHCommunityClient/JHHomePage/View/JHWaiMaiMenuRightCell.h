//
//  JHWaiMaiMenuCell.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiMenuRightModel.h"
@interface JHWaiMaiMenuRightCell : UITableViewCell
@property(nonatomic,strong)JHWaimaiMenuRightModel *dataModel;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UIButton *subtractBtn;
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)UILabel *buy_numLabel;
@property(nonatomic,strong)UILabel *specLabel;
@property(nonatomic,strong)UILabel *label_no;
/**
 *  显示减号按钮及数量标签
 */
- (void)showSubtractBtn;
/**
 *  隐藏减号及数量标签
 */
- (void)hideSubtractBtn;
@end

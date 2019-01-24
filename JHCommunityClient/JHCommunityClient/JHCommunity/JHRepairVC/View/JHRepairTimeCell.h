//
//  JHRepairTimeCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHRepairTimeCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UITextField *timeLabel;
@property (nonatomic,strong)UIImageView *dirImg;
@end

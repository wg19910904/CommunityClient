//
//  TempHomeClassifyCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/14.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempHomeClassifyCell : UITableViewCell
@property(nonatomic,copy)void(^clickBlock)(NSInteger tag);
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)UIButton *moreBtn;//右边更多按钮
@end

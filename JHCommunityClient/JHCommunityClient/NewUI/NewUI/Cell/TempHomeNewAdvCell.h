//
//  TempHomeNewAdvCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/12.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempHomeNewAdvCell : UITableViewCell
@property(nonatomic,copy)void(^clickAdvBlock)(NSInteger tag);
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)UIButton *moreBtn;//右边更多按钮

@end

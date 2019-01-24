//
//  TempHomeTopCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempHomeTopCell : UITableViewCell
@property(nonatomic,copy)void(^clickBlock)(NSInteger tag);
@property(nonatomic,retain)NSMutableArray *array;//数据
@end

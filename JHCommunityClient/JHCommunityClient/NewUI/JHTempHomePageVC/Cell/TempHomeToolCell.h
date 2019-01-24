//
//  TempHomeToolCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempHomeToolCell : UITableViewCell
@property(nonatomic,copy)void(^clickToolBlock)(NSInteger tag);
@property(nonatomic,retain)NSMutableArray *array;//数据
@end

//
//  TempHomeHeadlinesCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/12.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempHomeHeadlinesCell : UITableViewCell
@property(nonatomic,copy)void(^clickBlock)(NSInteger tag);
@property(nonatomic,strong)NSArray *arr;

@end

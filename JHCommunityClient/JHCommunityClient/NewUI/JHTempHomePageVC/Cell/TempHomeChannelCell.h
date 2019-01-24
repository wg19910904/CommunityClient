//
//  TempHomeChannelCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempHomeChannelCell : UITableViewCell
@property(nonatomic,copy)void(^myBlock)(NSInteger tag);
@property(nonatomic,strong)NSArray *array;
@end

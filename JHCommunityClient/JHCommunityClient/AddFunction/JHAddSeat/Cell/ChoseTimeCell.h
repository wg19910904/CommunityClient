//
//  ChoseTimeCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAddSeatModel.h"
@interface ChoseTimeCell : UITableViewCell
@property(nonatomic,retain)JHAddSeatModel *model;
@property(nonatomic,copy)void(^myBlock)(NSInteger _index);
@end

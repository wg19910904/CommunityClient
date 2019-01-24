//
//  JHNewMyCenterTwoCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/15.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHBaseTableViewCell.h"

@interface JHNewMyCenterTwoCell : JHBaseTableViewCell
@property(nonatomic,copy)void(^myBlock)(NSInteger tag);
@property(nonatomic,strong)NSArray *array;
@end

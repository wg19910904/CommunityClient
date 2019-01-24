//
//  JHNewRechargeCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHBaseTableViewCell.h"

typedef void(^clickBlock)(NSInteger tag);

@interface JHNewRechargeCell : JHBaseTableViewCell
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,copy)clickBlock clickBlock;

@end

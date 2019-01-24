//
//  JHNewMyCenterOneCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/15.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHBaseTableViewCell.h"
#import "MemberInfoModel.h"

typedef void(^clickBlock)(NSInteger tag);
@interface JHNewMyCenterOneCell : JHBaseTableViewCell
@property(nonatomic,copy)clickBlock clickBlock;
@property(nonatomic,strong)MemberInfoModel *model;
@end

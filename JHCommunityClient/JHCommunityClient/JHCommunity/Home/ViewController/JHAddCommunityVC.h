//
//  JHAddCommunityVC.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
#import "MineCommunityModel.h"

typedef void(^SuccessAdd)();

@interface JHAddCommunityVC : JHBaseVC
@property(nonatomic,strong)MineCommunityModel *model;
@property(nonatomic,assign)BOOL is_change;//是不是修改小区
@property(nonatomic,copy)SuccessAdd successAdd;
@end

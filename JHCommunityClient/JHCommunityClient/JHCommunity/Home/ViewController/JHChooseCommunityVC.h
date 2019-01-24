//
//  JHChooseCommunityVC.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
#import "MineCommunityModel.h"

typedef void(^ChooseCommunity)(MineCommunityModel *addrModel);

@interface JHChooseCommunityVC : JHBaseVC
@property(nonatomic,copy)ChooseCommunity chooseCommunity;
@property(nonatomic,copy)void(^myBlock)();
@end

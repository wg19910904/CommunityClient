//
//  JHChooseCityCommunityVC.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^ChooseCityCommunity)(NSString *name,NSString *xiaoqu_id);

@interface JHChooseCityCommunityVC : JHBaseVC
@property(nonatomic,copy)ChooseCityCommunity chooseCityCommunity;
@end

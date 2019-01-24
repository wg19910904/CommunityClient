//
//  JHNeighbourDetailVC.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^Success)();

@interface JHNeighbourDetailVC : JHBaseVC
@property(nonatomic,copy)NSString *tieba_id;
@property(nonatomic,copy)Success success;
@end

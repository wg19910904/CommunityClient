//
//  JHPubilshNeighbourVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^Success)();

@interface JHPubilshNeighbourVC : JHBaseVC
@property(nonatomic,copy)Success success;
@end

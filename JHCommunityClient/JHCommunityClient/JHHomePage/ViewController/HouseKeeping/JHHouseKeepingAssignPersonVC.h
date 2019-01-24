//
//  JHHouseKeepingAssignPersonVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/19.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHHouseKeepingAssignPersonVC : JHBaseVC
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)void(^myBlock)(NSString *staff_id,NSString *name);

@end

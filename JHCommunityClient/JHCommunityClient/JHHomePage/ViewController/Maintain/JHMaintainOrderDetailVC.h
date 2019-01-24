//
//  JHHouseKeepingOrderDetailVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/19.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅订单详情

#import "JHBaseVC.h"

@interface JHMaintainOrderDetailVC : JHBaseVC
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *start;
@end

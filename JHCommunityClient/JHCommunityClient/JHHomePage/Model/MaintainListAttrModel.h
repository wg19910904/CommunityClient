//
//  HouseKeepingListAttrModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅列表中的属性标签

#import <Foundation/Foundation.h>

@interface MaintainListAttrModel : NSObject
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *cate_title;
@property (nonatomic,copy)NSString *staff_id;
@end

//
//  HouseKeepingMapPersonModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseKeepingMapPersonModel : NSObject
@property (nonatomic,assign)float lat;
@property (nonatomic,assign)float lng;
@property (nonatomic,copy)NSString *staff_id;
@end

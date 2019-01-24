//
//  JHAddressListVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHAddressListVC : JHBaseVC
@property(nonatomic,assign)BOOL isCenter;
@property (nonatomic,assign) int index;
@property (nonatomic,copy)NSString *addr_id;
@property (nonatomic,copy) void(^myBlock)(UIImage *img,NSString *name,NSString *phone,NSString *addr,NSString *addr_id,NSString *house);
@property (nonatomic,copy) void(^myBlock2)(NSString *name,NSString *lat,NSString *lng,NSString *phone,NSString *addr,NSString *house);
@end

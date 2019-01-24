//
//  AddrModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddrListModel : NSObject
@property (nonatomic,copy)NSString *addr_id;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *contact;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *addr;
@property (nonatomic,copy)NSString *house;
@property (nonatomic,copy)NSString *is_default;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *lng;
@property (nonatomic,copy)NSString *type;
@end

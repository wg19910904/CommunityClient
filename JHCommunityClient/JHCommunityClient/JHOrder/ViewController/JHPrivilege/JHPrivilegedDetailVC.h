//
//  JHPrivilegedDetailVC.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void (^myBlock)(void);
@interface JHPrivilegedDetailVC : JHBaseVC
@property(nonatomic,copy)NSString * order_id;//订单号
@property(nonatomic,copy)myBlock block;
@end

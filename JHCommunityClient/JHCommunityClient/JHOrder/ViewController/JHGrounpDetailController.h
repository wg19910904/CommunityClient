//
//  JHGrounpDetailController.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^block)(void);
@interface JHGrounpDetailController : JHBaseVC
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,assign)BOOL isPayCome;//是否从支付界面跳转过来
@property(nonatomic,copy)block myBlock;
@end

//
//  JHOtherOrderDetailVC.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHOtherOrderDetailVC : JHBaseVC
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)void(^myBlock)(void);
@property(nonatomic,assign)BOOL isPayCome;//是否从支付界面跳转过来
@end

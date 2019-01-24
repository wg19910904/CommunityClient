//
//  JHPayOrderVC.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/31.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHPayOrderVC : JHBaseVC
@property(nonatomic,copy)NSString *order_id;//订单号
@property(nonatomic,copy)NSString *amount;//支付金额
@property(nonatomic,assign)BOOL isDetailVC;//是否是从详情进入的
@property(nonatomic,copy)NSString *jumpVcStr;//支付成功后需要跳转的控制器
@property(nonatomic,copy)MsgBlock paySuccessBlock;// 支付成功的回调
@end

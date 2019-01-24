//
//  JHWaiMaiOrderDetailVC.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHWaiMaiOrderDetailVC : JHBaseVC
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,assign)BOOL isPayCome;// 是否从支付界面跳转来的
@end

//
//  JHIntegrationOrderDetailVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHIntegrationOrderDetailVC : JHBaseVC
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,assign)BOOL isPayCome;
@property (nonatomic,copy)void(^cancelBlock)();
@property (nonatomic,copy)void(^confirmBlock)();
@end

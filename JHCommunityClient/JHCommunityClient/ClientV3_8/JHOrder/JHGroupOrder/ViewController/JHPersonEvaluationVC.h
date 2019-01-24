//
//  JHPersonEvaluationVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^PersonEvaluationSuccess)();
@interface JHPersonEvaluationVC : JHBaseVC
@property (nonatomic,assign)BOOL isTuan;//团购评价是or否
@property (nonatomic,copy)NSString *number;//积分
@property (nonatomic,copy)NSString *order_id;//订单号
@property (nonatomic,copy)PersonEvaluationSuccess personEvaluationSuccess;

@end

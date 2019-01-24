//
//  JHDetailOfSeatAndNumberVC.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHDetailOfSeatAndNumberVC : JHBaseVC
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,assign)BOOL is_seat;//是否是订座
@end

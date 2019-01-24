//
//  RedPacketModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPacketModel : NSObject
@property (nonatomic,copy)NSString *hongbao_id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *min_amount;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *stime;
@property (nonatomic,copy)NSString *ltime;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *used_time;
@property (nonatomic,copy)NSString *nowtime;
@property (nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *use_lable;
@property(nonatomic,copy)NSString *from_lable;
@end

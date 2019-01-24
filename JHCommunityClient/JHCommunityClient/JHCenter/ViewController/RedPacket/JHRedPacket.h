//
//  JHRedPacket.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"


typedef void(^RedPacket)(NSString *hongbao_id,NSString *money);
@interface JHRedPacket : JHBaseVC
//@property (nonatomic,assign)int index;
@property (nonatomic,copy)NSString *hongbao_id;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)RedPacket redPacket;
@property (nonatomic,assign)BOOL selectRedPacket;
@end

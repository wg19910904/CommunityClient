//
//  JHInquiryRepaiModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHInquiryRepairModel : NSObject
@property (nonatomic,copy)NSString *baoxiu_id;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *xiaoqu_id;
@property (nonatomic,copy)NSString *contact;
@property (nonatomic,copy)NSString *yezhu_id;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *reply;
@property (nonatomic,copy)NSString *reply_time;
@property (nonatomic,copy)NSString *tx_time;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,strong)NSArray *photos;
@end

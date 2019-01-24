//
//  PropertyNotifyModel.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NotifyBlock)(NSArray *arr,NSString *msg);

@interface PropertyNotifyModel : NSObject

@property(nonatomic,copy)NSString *news_id;
@property(nonatomic,copy)NSString *xiaoqu_id;
@property(nonatomic,copy)NSString *from;//类型 news:小区资讯,notice:通知
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *intro;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,assign)int views;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,assign)NSInteger dateline;
@property(nonatomic,copy)NSString *dateline_label;

/**
 *  获取物业通知列表
 *
 *  @param page  分页
 *  @param block 回调的block
 */
+(void)getNotifyListWithPage:(int)page block:(NotifyBlock)block;
@end

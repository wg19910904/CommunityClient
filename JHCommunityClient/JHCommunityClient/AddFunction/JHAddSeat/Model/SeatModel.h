//
//  SeatModel.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeatModel;
typedef void(^CreatBlock)(NSString *order_id,NSString *msg);
typedef void(^SeatModelBlock)(NSArray *arr,NSString *msg);
typedef void(^SeatModelDetail)(SeatModel *model,NSString *msg);

@interface SeatModel : NSObject
@property(nonatomic,copy)NSString *dingzuo_id;
@property(nonatomic,copy)NSString *city_id;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,assign)int order_status;//0:待处理, 1:已经完成，-1:已取消
@property(nonatomic,copy)NSString *order_status_label;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,assign)NSInteger yuyue_time;//预约时间
@property(nonatomic,copy)NSString *yuyue_number;//就餐人数
@property(nonatomic,assign)BOOL is_baoxiang;//是否包厢 0:不定，1：包厢
@property(nonatomic,assign)NSInteger dateline;//下单时间
@property(nonatomic,strong)NSDictionary *shop_detail;//商户信息
@property(nonatomic,strong)NSDictionary *zhuohao_detail;//桌号信息
@property(nonatomic,copy)NSString *zhuo_wait_nums;


/**
 *  检测是否已有订单
 *
 *  @param shop_id  商家id
 *  @param block 回调的block
 */
+(void)checkOutHaveOrder:(NSString *)shop_id block:(CreatBlock)block;

/**
 *  获取列表信息
 *
 *  @param page  分页
 *  @param block 回调的block
 */
+(void)getSeatListWithPage:(int)page block:(SeatModelBlock)block;

/**
 *  催单
 *
 *  @param dingzuo_id  订座id
 *  @param block     回调的block
 */
+(void)cuiDingZuoWithId:(NSString *)dingzuo_id block:(SeatModelBlock)block;

/**
 *  获取详情
 *
 *  @param dingzuo_id 订座id
 *  @param block     回到的block
 */
+(void)getSeatModelDetail:(NSString *)dingzuo_id block:(SeatModelDetail)block;

/**
 *  取消排队
 *
 *  @param dingzuo_id 订座id
 *  @param reasonStr 取消理由
 *  @param block     回调的block
 */
+(void)cancelDingZuoWithId:(NSString *)dingzuo_id reasonStr:(NSString *)reasonStr block:(SeatModelBlock)block;

/**
 *  删除订座
 *
 *  @param dingzuo_id  订座id
 *  @param block     回调的block
 */
+(void)deleteDingZuoWithId:(NSString *)dingzuo_id block:(SeatModelBlock)block;
@end

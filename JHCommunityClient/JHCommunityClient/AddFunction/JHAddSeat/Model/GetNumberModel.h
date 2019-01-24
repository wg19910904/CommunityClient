//
//  GetNumberModel.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GetNumberModel;
typedef void(^CreatBlock)(NSString *order_id,NSString *msg);
typedef void(^GetNumberBlock)(NSArray *arr,NSString *msg,int count);
typedef void(^GetNumberDetail)(GetNumberModel *model,NSString *msg);

@interface GetNumberModel : NSObject
@property(nonatomic,copy)NSString *paidui_id;
@property(nonatomic,copy)NSString *city_id;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,assign)int order_status;//0:待处理, 1:排队中，-1:已取消 2已完成
@property(nonatomic,copy)NSString *order_status_label;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *wait_time;//预计时间
@property(nonatomic,copy)NSString *paidui_number;//就餐人数
@property(nonatomic,assign)NSInteger dateline;//下单时间
@property(nonatomic,strong)NSDictionary *shop_detail;//商户信息
@property(nonatomic,strong)NSDictionary *zhuohao_detail;//桌号信息
@property(nonatomic,copy)NSString *zhuo_wait_nums;
//@property(nonatomic,copy)NSString *zhuohao_cate_title;//桌号分类
//@property(nonatomic,copy)NSString *title;//桌号标题

/**
 *  检测是否已有订单
 *
 *  @param shop_id  商家id
 *  @param block 回调的block
 */
+(void)checkOutHaveOrder:(NSString *)shop_id block:(CreatBlock)block;

/**
 *  创建排队订单
 *
 *  @param infoDic  排队的信息
 *  @param block 回调的block
 */
+(void)getNumberWithInfo:(NSDictionary *)infoDic block:(CreatBlock)block;

/**
 *  获取列表信息
 *
 *  @param page  分页
 *  @param block 回调的block
 */
+(void)getNumberListWithPage:(int)page block:(GetNumberBlock)block;

/**
 *  获取详情
 *
 *  @param paidui_id 排队id
 *  @param block     回到的block
 */
+(void)getNumberDetail:(NSString *)paidui_id block:(GetNumberDetail)block;

/**
 *  取消排队
 *
 *  @param paidui_id 排队id
 *  @param reasonStr 取消理由
 *  @param block     回调的block
 */
+(void)cancelPaiDuiWithId:(NSString *)paidui_id reasonStr:(NSString *)reasonStr block:(GetNumberBlock)block;

/**
 *  删除排号
 *
 *  @param paidui_id 排队id
 *  @param block     回调的block
 */
+(void)deletePaiDuiWithId:(NSString *)paidui_id block:(GetNumberBlock)block;

@end

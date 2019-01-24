//
//  MineCommnityModel.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CommunityBlock)(NSArray *arr,NSString *msg);

@interface MineCommunityModel : NSObject
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *xiaoqu_title;
@property(nonatomic,copy)NSString *house_huhao;//户号
@property(nonatomic,copy)NSString *house_louhao;//楼号
@property(nonatomic,copy)NSString *house_danyuan;//单元
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *mobile;//业主手机号码
@property(nonatomic,copy)NSString *phone;//物业号码
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@property(nonatomic,assign)int audit;//0:待审, 1:已审核
@property(nonatomic,copy)NSString *yezhu_id;//商户ID
@property(nonatomic,copy)NSString *xiaoqu_id;//小区ID
@property(nonatomic,copy)NSString *city_name;
@property(nonatomic,copy)NSString *city_id;
//所在小区需要用到的字段
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *title;

/**
 *  获取已入住小区的列表
 *
 *  @param block 回调的block
 */
+(void)getHadCommunityListWithBlock:(CommunityBlock)block;

/**
 *  猜你住在的小区列表
 *  @param city_id 城市id
 *  @param block 回调的block
 */
+(void)getCommunityListWithCity_id:(NSString *)city_id block:(CommunityBlock)block;

/**
 *  搜索的小区列表
 *
 *  @param key   搜索的文字
 *  @param city_id 城市id
 *  @param block 回调的block
 */
+(void)getCommunitySearchListWithKeyword:(NSString *)key city_id:(NSString *)city_id block:(CommunityBlock)block;


/**
 *  申请入住小区
 *
 *  @param infoDic 入驻的信息
 *  @param block 回调的block
 */
+(void)addCommunityWithDic:(NSDictionary *)infoDic block:(CommunityBlock)block;

/**
 *  开通小区
 *  @param infoDic 参数字典
 *  @param block 回调的block
 */
+(void)kaiTongCommunityWithDic:(NSDictionary *)infoDic block:(CommunityBlock)block;

/**
 *  修改入住小区
 *  @param infoDic 修改的信息
 *  @param block 回调的block
 */
+(void)changeCommunityWithDic:(NSDictionary *)infoDic block:(CommunityBlock)block;


/**
 *  删除入住的小区
 *  @param yezhu_id 业主id(一个小区对应一个业主id)
 *  @param block 回调的block
 */
+(void)deleteCommunity:(NSString *)yezhu_id block:(CommunityBlock)block;

@end

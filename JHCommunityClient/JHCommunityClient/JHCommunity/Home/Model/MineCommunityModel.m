//
//  MineCommnityModel.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MineCommunityModel.h"
#import <MJExtension.h>
#import "CommunityHttpTool.h"
#import "JHShareModel.h"

@implementation MineCommunityModel

/**
 *  获取已入住小区的列表
 *
 *  @param block 回调的block
 */
+(void)getHadCommunityListWithBlock:(CommunityBlock)block{
 
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/yezhu/items" withParams:@{} success:^(id json) {
        NSLog(@"已入住的小区  %@",json);
        
        if ([json[@"error"] intValue]==0) {
            NSArray *arr=[MineCommunityModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}

/**
 *  猜你住在的小区列表
 *  @param city_id 城市id
 *  @param block 回调的block
 */
+(void)getCommunityListWithCity_id:(NSString *)city_id block:(CommunityBlock)block{
    city_id= city_id == nil ? @"" : city_id;
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/items" withParams:@{@"city_id":city_id} success:^(id json) {
        NSLog(@"猜你住在的小区列表  %@",json);
        if ([json[@"error"] intValue]==0){
            NSArray *arr=[MineCommunityModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }
        else block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}

/**
 *  搜索的小区列表
 *
 *  @param key   搜索的文字
 *  @param block 回调的block
 */
+(void)getCommunitySearchListWithKeyword:(NSString *)key city_id:(NSString *)city_id block:(CommunityBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/items" withParams:@{@"key":key,@"city_id":city_id} success:^(id json) {
        NSLog(@"搜索的小区列表  %@",json);
        if ([json[@"error"] intValue]==0) {
            NSArray *arr=[MineCommunityModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }
        else block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}


/**
 *  申请入住小区
 *
 *  @param block 回调的block
 */
+(void)addCommunityWithDic:(NSDictionary *)infoDic block:(CommunityBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/yezhu/create" withParams:infoDic success:^(id json) {
        NSLog(@"申请入住小区  %@",json);
        if ([json[@"error"] intValue]==0)  block(@[],NSLocalizedString(@"入驻成功", nil));
        else block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}

/**
 *  开通小区
 *  @param infoDic 参数字典
 *  @param block 回调的block
 */
+(void)kaiTongCommunityWithDic:(NSDictionary *)infoDic block:(CommunityBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/apply" withParams:infoDic success:^(id json) {
        NSLog(@"开通小区  %@",json);
        if ([json[@"error"] intValue]==0)  block(@[],NSLocalizedString(@"开通成功,等待审核!", nil));
        else block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}

/**
 *  修改入住小区
 *
 *  @param block 回调的block
 */
+(void)changeCommunityWithDic:(NSDictionary *)infoDic block:(CommunityBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/yezhu/edit" withParams:infoDic success:^(id json) {
        NSLog(@"修改入住小区  %@",json);
        if ([json[@"error"] intValue]==0)  block(@[],NSLocalizedString(@"修改成功", nil));
        else block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}

/**
 *  删除入住的小区
 *
 *  @param block 回调的block
 */
+(void)deleteCommunity:(NSString *)yezhu_id block:(CommunityBlock)block{
    yezhu_id = yezhu_id == nil ? @"" : yezhu_id;
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/yezhu/delete" withParams:@{@"yezhu_id":yezhu_id} success:^(id json) {
        NSLog(@"删除入住的小区  %@",json);
        if ([json[@"error"] intValue]==0)  block(@[],NSLocalizedString(@"删除成功", nil));
        else block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}

@end

//
//  CommunityHttpTool.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityHttpTool : NSObject

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithAPI:(NSString *)api withParams:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formData  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithAPI:(NSString *)api  params:(NSDictionary *)params fromDataDic:(NSDictionary *)dataDic
            success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;
/**
 *  发送一个POST请求(上传文件数据,多张图片和录音)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formData  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithAPI:(NSString *)api
             params:(NSDictionary *)params
    fromMoreDataDic:(NSDictionary *)dataDic
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure;
//跑腿http协议上传文件(图片,音频等)
+ (void)postRunWithAPI:(NSString *)api
                params:(NSDictionary *)params
           fromDataDic:(NSDictionary *)dataDic
               success:(void (^)(id json))success
               failure:(void (^)(NSError *error))failure;@end

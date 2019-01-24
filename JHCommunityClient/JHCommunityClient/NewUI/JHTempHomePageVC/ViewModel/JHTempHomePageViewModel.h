//
//  JHTempHomePageViewModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/5.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHTempHomePageModel.h"
#import "JHTempNewsTypeModel.h"
@interface JHTempHomePageViewModel : NSObject

/**
 请求首页数据的接口

 @param dic 需要传入的参数
 @param resultBlock 请求的回调结果
 */
+(void)postToGetHomePageDataWithDic:(NSDictionary *)dic isShopList:(BOOL)isSHopList block:(void(^)(NSString *error,JHTempHomePageModel *model))resultBlock;

/**
 请求社区头条分类的接口

 @param resultBlock 请求的回调结果
 */
+(void)postToGetNewsType:(void(^)(NSString *error,NSArray *modelArr))resultBlock;

/**
 请求社区头条列表的接口
 
 @param resultBlock 请求的回调结果
 */
+(void)postToGetNewsListWithDic:(NSDictionary *)dic block:(void(^)(NSString *error,NSArray *modelArr))resultBlock;

/**
 判断是否需要升级的接口

 @param dic 参数
 @param resultBlock 请求的回调结果
 */
+(void)postToSureThatIsNeedUpgradeVersion;
@end

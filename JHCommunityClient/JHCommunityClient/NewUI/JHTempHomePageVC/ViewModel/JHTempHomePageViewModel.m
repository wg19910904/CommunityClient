//
//  JHTempHomePageViewModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/5.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTempHomePageViewModel.h"
 
#import "JHTempClientListMainModel.h"
#import "JHShareModel.h"
#import "JHShowAlert.h"
@implementation JHTempHomePageViewModel
/**
 请求首页数据的接口
 
 @param dic 需要传入的参数
 @param resultBlock 请求的回调结果
 */
+(void)postToGetHomePageDataWithDic:(NSDictionary *)dic isShopList:(BOOL)isSHopList block:(void(^)(NSString *error,JHTempHomePageModel *model))resultBlock{
    NSString *api = @"client/v2/shop/index";
    if (isSHopList) {
        api = @"client/shop/items";
    }
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSString *err;
        JHTempHomePageModel *model;
        NSLog(@"首页获取的数据----%@----",json);
        if ([json[@"error"] integerValue] == 0) {//请求成功
           model = [JHTempHomePageModel mj_objectWithKeyValues:json[@"data"]];
        }else{//请求失败
            err = json[@"message"];
        }
        if (resultBlock) {
            resultBlock(err,model);
        }
    } failure:^(NSError *error) {
        if (resultBlock) {
            resultBlock(@"服务器连接失败,请稍后重试!",nil);
        }
    }];
}
/**
 请求社区头条分类的接口
 
 @param resultBlock 请求的回调结果
 */
+(void)postToGetNewsType:(void(^)(NSString *error,NSArray *modelArr))resultBlock{
    [HttpTool postWithAPI:@"client/v2/article/cate" withParams:@{} success:^(id json) {
        NSString *err;
        NSArray *modelArray;
        NSLog(@"请求新闻分类的数据----%@-----",json);
        if ([json[@"error"] integerValue] == 0) {//请求成功
            JHTempNewsTypeModel *tempModel = [JHTempNewsTypeModel mj_objectWithKeyValues:json[@"data"]];
            modelArray =tempModel.items;
        }else{//请求失败
            err = json[@"message"];
        }
        if (resultBlock) {
            resultBlock(err,modelArray);
        }
    } failure:^(NSError *error) {
        if (resultBlock) {
            resultBlock(@"服务器连接失败,请稍后重试!",nil);
        }
    }];
}
/**
 请求社区头条列表的接口
 
 @param resultBlock 请求的回调结果
 */
+(void)postToGetNewsListWithDic:(NSDictionary *)dic block:(void(^)(NSString *error,NSArray *modelArr))resultBlock{
    NSString *url = @"client/v2/article/index";
    if ([dic.allKeys containsObject:@"type"]) {
        url = @"client/member/collect/items";
    }
    [HttpTool postWithAPI:url withParams:dic success:^(id json) {
        NSString *err;
        NSArray *modelArray;
        NSLog(@"请求社区头条列表的数据----%@-----",json);
        if ([json[@"error"] integerValue] == 0) {//请求成功
            JHTempClientListMainModel *model = [JHTempClientListMainModel mj_objectWithKeyValues:json[@"data"]];
            modelArray = model.items;
        }else{//请求失败
            err = json[@"message"];
        }
        if (resultBlock) {
            resultBlock(err,modelArray);
        }
    } failure:^(NSError *error) {
        if (resultBlock) {
            resultBlock(NSLocalizedString(@"服务器连接失败,请稍后重试!", nil),nil);
        }
    }];

}
/**
 判断是否需要升级的接口
 
 @param dic 参数
 @param resultBlock 请求的回调结果
 */
+(void)postToSureThatIsNeedUpgradeVersion{
    [HttpTool postWithAPI:@"client/v2/data/appver" withParams:@{} success:^(id json) {
        NSLog(@"更新版本的信息%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([json[@"data"][@"ios_client_version"] compare:[JHShareModel shareModel].version] != NSOrderedDescending) {
                return;
            }
            if ([[json[@"data"][@"ios_client_force_update"] description] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:json[@"data"][@"ios_client_intro"] withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withCancelBlock:^{
                    [JHShareModel shareModel].isNotUpdate =YES;
                }withSureBlock:^{
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:json[@"data"][@"ios_client_download"]]];
                }];
            }else{
                [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:json[@"data"][@"ios_client_intro"] withBtn_cancel:nil withBtn_sure:NSLocalizedString(@"确定", nil) withCancelBlock:nil withSureBlock:^{
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:json[@"data"][@"ios_client_download"]]];
                }];
 
            }
        }
        
    } failure:^(NSError *error) {
    }];
}
@end

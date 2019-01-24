//
//  CommunityHttpTool.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "CommunityHttpTool.h"
#import "JHShareModel.h"
#define UserAgent @"JHCommunityClient/1.2.20160808 (iPhone; iOS 9.2.1; Scale/3.00) com.jhcms.ios.sq"
@class JHShareModel;
@implementation CommunityHttpTool
//将字典转换为json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (void)postWithAPI:(NSString *)api withParams:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    
    //获取token
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *token = [userDefaults objectForKey:@"token"];
    token = token == nil ? @"" : token;
    
    //将业务数据转换为json串
    NSString *jsonString = [self dictionaryToJson:params];
    NSString *lat = nil;
    NSString *lng = nil;
    if([JHShareModel shareModel].communityModel.lat <= 0){
        lat = [NSString stringWithFormat:@"%f",[JHShareModel shareModel].lat];
        lng = [NSString stringWithFormat:@"%f",[JHShareModel shareModel].lng];
    }else{
        lat = [NSString stringWithFormat:@"%f",[JHShareModel shareModel].communityModel.lat];
        lng = [NSString stringWithFormat:@"%f",[JHShareModel shareModel].communityModel.lng];
    }
    //定义系统级参数字典
    NSDictionary *systemDic = @{@"API":api,
                                @"CLIENT_API":@"CUSTOM",
                                @"CLIENT_OS":@"IOS",
                                @"CLIENT_VER":@"1.0.0",
                                @"CITY_ID":@"0",
                                @"TOKEN":token,
                                @"data":jsonString,
                                @"city_code":[JHShareModel shareModel].cityCode,
                                @"LAT":lat,
                                @"LNG":lng};
    
    //发起请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *dic = mgr.requestSerializer.HTTPRequestHeaders;
    [mgr.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
    NSLog(@"%@",systemDic);
    [mgr POST:IPADDRESS parameters:systemDic progress:^(NSProgress * _Nonnull uploadProgress) {}
     
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
          NSError *error;
          NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers error:&error];
          //----打印完整网址------
          NSMutableString *urlS = @"".mutableCopy;
          for (NSString *key in systemDic) {
              NSString *temS = [NSString stringWithFormat:@"&%@=%@",key,systemDic[key]];
              [urlS appendString:temS];
          }
          [urlS replaceCharactersInRange:NSMakeRange(0, 1) withString:@"?"];
          NSLog(@"\n\n请求的网址为:\n\n%@%@\n\n",task.originalRequest.URL,urlS);
          //----打印完成-------
          if (error) {
              NSLog(@"%@-----%@",error.localizedDescription,string);
              error = nil;
              string = nil;
          }
          string = nil;
          if (success) {
              success(JSON);
              NSLog(@" message ===== %@",JSON[@"message"]);
          }
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          if (failure) {
              failure(error);
          }
      }];
}

//http协议上传文件(图片,音频等)
+ (void)postWithAPI:(NSString *)api
             params:(NSDictionary *)params
        fromDataDic:(NSDictionary *)dataDic
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure
{
    //获取token
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    token = token == nil ? @"" : token;
    
    //将业务数据转换为json串
    NSString * jsonString = [self dictionaryToJson:params];
    //定义系统级参数字典
    NSDictionary *systemDic = @{@"API":api,
                                @"CLIENT_API":@"CUSTOM",
                                @"CLIENT_OS":@"IOS",
                                @"CLIENT_VER":@"1.0.0",
                                @"CITY_ID":@"0",
                                @"TOKEN":token,
                                @"data":jsonString,
                                @"city_code":[JHShareModel shareModel].cityCode,
                                @"LAT":[NSString stringWithFormat:@"%f",[JHShareModel shareModel].communityModel.lat],
                                @"LNG":[NSString stringWithFormat:@"%f",[JHShareModel shareModel].communityModel.lng]
                                };

    NSLog(@"%@",jsonString);
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
//    NSDictionary *dic = mgr.requestSerializer.HTTPRequestHeaders;
    [mgr.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
    [mgr POST:IPADDRESS parameters:systemDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (dataDic.count == 0) {
            // do nothing
        }else{
            for (NSString *key in dataDic) {
                //上传的参数名
                NSData *data = dataDic[key];
                //上传的fileName
                if ([key isEqualToString:@"face"]) {
                    
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".png"] //文件名
                                            mimeType:@"image/png"];
                    
                }
                else{
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".mp3"] //文件名
                                            mimeType:@"audio/mpeg"];
                }
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) { }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if (success) {
              success(responseObject);
              NSLog(@" message ===== %@",responseObject[@"message"]);
          }
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failure) {
              failure(error);
          }
      }];
}
//http协议上传文件(图片,音频等)
+ (void)postWithAPI:(NSString *)api
             params:(NSDictionary *)params
    fromMoreDataDic:(NSDictionary *)dataDic
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure
{
    //获取token
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    token = token == nil ? @"" : token;
    
    //将业务数据转换为json串
    NSString * jsonString = [self dictionaryToJson:params];
    //定义系统级参数字典
    NSDictionary *systemDic = @{@"API":api,
                                @"CLIENT_API":@"CUSTOM",
                                @"CLIENT_OS":@"IOS",
                                @"CLIENT_VER":@"1.0.0",
                                @"CITY_ID":@"0",
                                @"TOKEN":token,
                                @"data":jsonString,
                                @"city_code":[JHShareModel shareModel].cityCode,
                                @"LAT":[NSString stringWithFormat:@"%f",[JHShareModel shareModel].communityModel.lat],
                                @"LNG":[NSString stringWithFormat:@"%f",[JHShareModel shareModel].communityModel.lng]
                                };
    
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
//    NSDictionary *dic = mgr.requestSerializer.HTTPRequestHeaders;
    [mgr.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
    [mgr POST:IPADDRESS parameters:systemDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (dataDic.count == 0) {
            // do nothing
        }else{
            for (NSString *key in dataDic) {
                //上传的参数名
                NSData *data = dataDic[key];
                //上传的fileName
                if ([key isEqualToString:@"photo1"]) {
                    
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".png"] //文件名
                                            mimeType:@"image/png"];
                    
                }
                else if ([key isEqualToString:@"photo2"]) {
                    
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".png"] //文件名
                                            mimeType:@"image/png"];
                    
                }
                else if ([key isEqualToString:@"photo3"]) {
                    
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".png"] //文件名
                                            mimeType:@"image/png"];
                    
                }
                else if ([key isEqualToString:@"photo4"]) {
                    
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".png"] //文件名
                                            mimeType:@"image/png"];
                    
                }
                else{
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".mp3"] //文件名
                                            mimeType:@"audio/mpeg"];
                }
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) { }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if (success) {
              success(responseObject);
              NSLog(@" message ===== %@",responseObject[@"message"]);
          }
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failure) {
              failure(error);
          }
      }];
}
//跑腿http协议上传文件(图片,音频等)
+ (void)postRunWithAPI:(NSString *)api
                params:(NSDictionary *)params
           fromDataDic:(NSDictionary *)dataDic
               success:(void (^)(id json))success
               failure:(void (^)(NSError *error))failure
{
    //获取token
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    token = token == nil ? @"" : token;
    
    //将业务数据转换为json串
    NSString * jsonString = [self dictionaryToJson:params];
    //定义系统级参数字典
    NSDictionary *systemDic = @{@"API":api,
                                @"CLIENT_API":@"CUSTOM",
                                @"CLIENT_OS":@"IOS",
                                @"CLIENT_VER":@"1.0.0",
                                @"CITY_ID":@"0",
                                @"TOKEN":token,
                                @"data":jsonString,
                                @"city_code":[JHShareModel shareModel].cityCode,
                                @"LAT":[NSString stringWithFormat:@"%f",[JHShareModel shareModel].communityModel.lat],
                                @"LNG":[NSString stringWithFormat:@"%f",[JHShareModel shareModel].communityModel.lng]
                                };

    //    NSLog(@"%@",systemDic);
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
//    NSDictionary *dic = mgr.requestSerializer.HTTPRequestHeaders;
    [mgr.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
    [mgr POST:IPADDRESS parameters:systemDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (dataDic.count == 0) {
            // do nothing
        }else{
            for (NSString *key in dataDic) {
                //上传的参数名
                NSData *data = dataDic[key];
                //上传的fileName
                if ([key isEqualToString:@"photo"]) {
                    
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".png"] //文件名
                                            mimeType:@"image/png"];
                    
                }else{
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".mp3"] //文件名
                                            mimeType:@"audio/mpeg"];
                }
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) { }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if (success) {
              success(responseObject);
              NSLog(@" message ===== %@",responseObject[@"message"]);
          }
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failure) {
              failure(error);
          }
      }];
}
@end

//
//  CommunityHomeModel.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "CommunityHomeModel.h"
#import "CommunityHttpTool.h"
#import <MJExtension.h>
#import "JHShareModel.h"

@implementation CommunityHomeModel
+(NSDictionary *)mj_objectClassInArray{
    return  @{@"items":[NearShopModel class]};
}

+(void)getHomeDataWithYezhu_id:(NSString *)yezhu_id block:(GetHomeData)block{
    
    yezhu_id = yezhu_id == nil ? @"" : yezhu_id;
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/index" withParams: @{@"yezhu_id":yezhu_id} success:^(id json) {
        NSLog(@"小区首页  %@",json);
        if ([json[@"error"] intValue]==0) {
            CommunityHomeModel *model=[CommunityHomeModel mj_objectWithKeyValues:json[@"data"]];
            block(model,nil);
            [JHShareModel shareModel].communityModel.phone=json[@"data"][@"xiaoqu"][@"phone"];
            [JHShareModel shareModel].communityModel.mobile=json[@"data"][@"yezhu"][@"mobile"];
        }else{
            block(nil,json[@"message"]);
        }
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}


-(NSArray *)adv_list{
    if (_adv_list) {
        NSMutableArray *arr=[NSMutableArray array];
        for (NSDictionary *dic in _adv_list) {
            NSMutableDictionary *adDic=[NSMutableDictionary dictionary];
            adDic[@"photo"]=dic[@"thumb"];
            adDic[@"link"]=dic[@"link"];
            adDic[@"title"]=dic[@"title"];
            [arr addObject:adDic];
        }
        return [arr copy];
    }
    return @[];
}


-(NSArray *)banner_list{
    if (_banner_list) {
        NSMutableArray *arr=[NSMutableArray array];
        for (NSDictionary *dic in _banner_list) {
            NSMutableDictionary *adDic=[NSMutableDictionary dictionary];
            adDic[@"photo"]=dic[@"photo"];
            adDic[@"link"]=dic[@"link"];
            adDic[@"title"]=dic[@"title"];
            [arr addObject:adDic];
        }
        return [arr copy];
    }
    return @[];
}


-(NSArray *)news_list{
    if (_news_list) {
        NSMutableArray *arr=[NSMutableArray array];
        for (NSDictionary *dic in _news_list) {
            NSMutableDictionary *adDic=[NSMutableDictionary dictionary];
            adDic[@"link"]=dic[@"link"];
            adDic[@"title"]=dic[@"title"];
            [arr addObject:adDic];
        }
        return [arr copy];
    }
    return @[];
}

@end

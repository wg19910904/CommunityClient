//
//  WaiMaiHomeModel.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/5.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "WaiMaiHomeModel.h"
 
#import <MJExtension.h>
#import "JHShareModel.h"
#import "GaoDe_Convert_BaiDu.h"
@implementation WaiMaiHomeModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"items":@"WaiMaiShopperModel"};
}


+(void)getHomeListWith:(int)page block:(ModelBlock)block{
    double bd_lat;
    double bd_lon;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:[JHShareModel shareModel].lat
                                                 WithGD_lon:[JHShareModel shareModel].lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    
    [HttpTool postWithAPI:@"client/v2/waimai/shop/index" withParams:@{@"page":@(page),@"lng":@(bd_lon),@"lat":@(bd_lat)} success:^(id json) {
        
        NSLog(@"外卖首页=======  %@",json);
        
        if ([json[@"error"] isEqualToString:@"0"]) {
            WaiMaiHomeModel *model = [WaiMaiHomeModel mj_objectWithKeyValues:json[@"data"]];
            block(model,nil);
        }else{
            block(nil,json[@"message"]);
        }
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}

@end

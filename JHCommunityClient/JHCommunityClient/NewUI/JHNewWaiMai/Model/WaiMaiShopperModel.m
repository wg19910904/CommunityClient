//
//  WaiMaiShopperModel.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "WaiMaiShopperModel.h"
#import <MJExtension.h>
 
#import "JHShareModel.h"
#import "GaoDe_Convert_BaiDu.h"
@implementation WaiMaiShopperModel

+(void)getShopFilterListWith:(int)page cate_id:(NSString *)cate_id title:(NSString *)title area_id:(NSString *)area_id paixu_id:(NSString *)paixu_id buiness:(NSString *)buiness_id block:(DataBlock)block{
    double bd_lat;
    double bd_lon;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:[JHShareModel shareModel].lat
                                                 WithGD_lon:[JHShareModel shareModel].lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    
    NSDictionary *dic = @{@"page":@(page),@"title":title,@"lng":@(bd_lon),@"lat":@(bd_lat),@"order":paixu_id,@"filter":area_id,@"cate_id":cate_id?cate_id:@""};
    NSString *str;
    if ([JHShareModel shareModel].isShop) {
        str = @"client/v2/shop/discover";
    }else{
        str = @"client/v2/waimai/shop/items";
    }
    [HttpTool postWithAPI:str withParams:dic success:^(id json) {
        
        NSLog(@"外卖商家筛选列表=======  %@",json);
        
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSArray *arr;
            if ([JHShareModel shareModel].isShop) {
               arr = [WaiMaiShopperModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"shop_items"]];
            }else{
               arr = [WaiMaiShopperModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            }
           
            block(arr,nil);
        }else{
            block(nil,json[@"message"]);
        }
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}


@end

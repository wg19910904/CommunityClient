//
//  JHTempHomePageModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/5.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTempHomePageModel.h"

@implementation JHTempHomePageModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"shop_items":@"WaiMaiShopperModel",
             @"advs":@"JHTempAdvModel",
             @"banners":@"JHTempAdvModel",
             @"tools":@"JHTempAdvModel",
             @"toutiao":@"JHTempClientNewsModel",
             @"index_cate":@"JHTempAdvModel",
             @"lifes":@"JHTempAdvModel",
             @"merchants":@"JHTempAdvModel",
             @"nearby":@"JHTempAdvModel",
//             @"tender":@"JHTempAdvModel",
             @"top_line":@"JHTempAdvModel",
             @"items":@"WaiMaiShopperModel",
             @"fileds":@"JHTempAdvModel"
             
             };
}
@end

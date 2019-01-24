//
//  JHBtnRouterModel.h
//  JHCommunityClient
//
//  Created by xixixi on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBtnRouterModel : NSObject
+ (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav;

@end

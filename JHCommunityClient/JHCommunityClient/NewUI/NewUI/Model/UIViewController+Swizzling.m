//
//  UIViewController+Swizzling.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/27.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>


@implementation UIViewController (Swizzling)

+(void)load{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method fromMethod = class_getInstanceMethod([self class], @selector(viewWillAppear:));
        Method toMethod = class_getInstanceMethod([self class], @selector(YN_viewWillAppear:));
        method_exchangeImplementations(fromMethod, toMethod);
    });
}
-(void)YN_viewWillAppear:(BOOL)animated{
//    [self YN_viewWillAppear:animated];
//    NSArray *arr = @[@"JHHeadLinesVC",@"JHRecommendedView"];
//    if ([arr containsObject:[NSString stringWithFormat:@"%@",self.class]] ) {
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:HEX(@"333333", 1)}];
//        [[UIApplication sharedApplication] setStatusBarStyle:0];
//    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:HEX(@"333333", 1)}];
        [[UIApplication sharedApplication] setStatusBarStyle:0];
//    }
}
@end

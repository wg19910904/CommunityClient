//
//  UINavigationController+TabbarHidden.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/18.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "UINavigationController+TabbarHidden.h"
#import <objc/message.h>

@implementation UINavigationController (TabbarHidden)
+(void)load{

    Method oldMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"pushViewController:animated:"));
    Method newMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"yf_pushViewController:animated:"));
    method_exchangeImplementations(oldMethod, newMethod);
    
}

-(void)yf_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self yf_pushViewController:viewController animated:animated];
}
@end

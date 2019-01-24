//
//  JHBtnRouterModel.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBtnRouterModel.h"
#import <objc/runtime.h>

@implementation JHBtnRouterModel

+ (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav {
    //类名(对象名)
    NSString *class = vcName;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象(写到这里已经可以进行随机页面跳转了)
    id instance = [[newClass alloc] init];
    
    //下面是传值－－－－－－－－－－－－－－
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            //kvc给属性赋值
            
            [instance setValue:obj forKey:key];
        }else {
            NSLog(@"不包含key=%@的属性",key);
        }
    }];
    [nav pushViewController:instance animated:YES];
    
}
/**
 *  检测对象是否存在该属性
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}

@end

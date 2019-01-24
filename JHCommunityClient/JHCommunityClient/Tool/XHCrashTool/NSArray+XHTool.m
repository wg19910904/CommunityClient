//
//  NSArray+XHTool.m
//  crash
//
//  Created by xixixi on 16/12/16.
//  Copyright © 2016年 xixixi. All rights reserved.
//

#import "NSArray+XHTool.h"
#import <objc/runtime.h>
@implementation NSArray (XHTool)

+(void)load{
    [super load];
    //防止数组越界
    Method oldGetObjc = class_getInstanceMethod(self, @selector(objectAtIndexedSubscript:));
    Method newGetObjc = class_getInstanceMethod(self, @selector(XHObjectAtIndexedSubscript:));
    
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */
    if (!class_addMethod([self class], @selector(objectAtIndexedSubscript:), method_getImplementation(newGetObjc), method_getTypeEncoding(newGetObjc))) {
        method_exchangeImplementations(oldGetObjc, newGetObjc);
    }
}

- (id)XHObjectAtIndexedSubscript:(NSUInteger)idx{
    //判断是否越界
    if (idx >= self.count ) return @"";
    else return  [self XHObjectAtIndexedSubscript:idx];
}

@end

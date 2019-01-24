//
//  UINavigationBar+Awesome.m
//  YFtab
//
//  Created by ios_yangfei on 16/12/1.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Awesome)

//添加属性
static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//设置NavigationBar的背景颜色
- (void)yf_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + STATUS_HEIGHT)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

//设置NavigationBar的偏移量
- (void)yf_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

//改变NavigationBar所有控件的透明度
- (void)yf_setElementsAlpha:(CGFloat)alpha
{
    //    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
    //        view.alpha = alpha;
    //    }];
    //
    //    NSLog(@"%@",[self valueForKey:@"_leftViews"]);
    //
    //    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
    //        view.alpha = alpha;
    //    }];
    //    NSLog(@"%@",[self valueForKey:@"_rightViews"]);
    
    //    UIView *titleView = [self valueForKey:@"_titleView"];
    //    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    //    NSLog(@"%@",[self subviews]);
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
            obj.alpha = 0;
        }else{
            obj.alpha = alpha;
        }
        //        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
        //            obj.alpha = alpha;
        //            *stop = YES;
        //        }
    }];
}
//移除之前对NavigationBar的操作
- (void)yf_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}
@end

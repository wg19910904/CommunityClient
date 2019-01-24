//
//  UINavigationBar+Awesome.h
//  YFtab
//
//  Created by ios_yangfei on 16/12/1.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Awesome)

//设置NavigationBar的背景颜色
- (void)yf_setBackgroundColor:(UIColor *)backgroundColor;
//改变NavigationBar所有控件的透明度
- (void)yf_setElementsAlpha:(CGFloat)alpha;
//设置NavigationBar的偏移量
- (void)yf_setTranslationY:(CGFloat)translationY;
//移除之前对NavigationBar的操作
- (void)yf_reset;

@end

//
//  YFProgressHUD.h
//  LoadingViewAnimation
//
//  Created by ios_yangfei on 2017/11/13.
//  Copyright © 2017年 tracy wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFProgressHUD : UIView

#pragma mark ====== 添加在window上 =======

/**
 显示UIActivityIndicatorView 和 title

 @param titleString 加载时展示的文字(可选)
 */
+(YFProgressHUD *) showProgressHUDWithTitle:(NSString *)titleString;

/**
 带有下落动画HUD

 @param titleString 加载时展示的文字(可选)
 @param arr         动画的图片
 */
+(YFProgressHUD *) showProgressHUDWithTitle:(NSString *)titleString imagesArr:(NSArray *)arr;


/**
 gif动画HUD

 @param titleString 加载时展示的文字(可选)
 @param gifName     gif动画的图片
 */
+(YFProgressHUD *) showProgressHUDWithTitle:(NSString *)titleString gifImg:(NSString *)gifName;

/**
 移除HUD
 */
+(void) hiddenProgressHUD;

#pragma mark ====== 添加在view上 =======
/**
 显示UIActivityIndicatorView 和 title
 
 @param titleString 加载时展示的文字(可选)
 */
+(YFProgressHUD *) showProgressHUDinView:(UIView *)view title:(NSString *)titleString;

/**
 带有下落动画HUD

 @param view        需要展示HUD的view
 @param titleString 加载时展示的文字(可选)
 @param arr         动画的图片
 */
+(YFProgressHUD *) showProgressHUDinView:(UIView *)view title:(NSString *)titleString imagesArr:(NSArray *)arr;

/**
 gif动画HUD
 @param view        需要展示HUD的view
 @param titleString 加载时展示的文字(可选)
 @param gifName     gif动画的图片
 */
+(YFProgressHUD *) showProgressHUDinView:(UIView *)view  withTitle:(NSString *)titleString gifImg:(NSString *)gifName;
/**
 移除HUD
 */
+(void) hiddenProgressHUDforView:(UIView *)view;

@end

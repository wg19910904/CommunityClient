
//
//  ShopCarAnimationVC.h
//
//  Created by xixixi
//  Copyright © 2016年 xixixi. All rights reserved.
//  

#import "JHBaseVC.h"

/**
 *  接收动画结束通知的name
 */
#define kShopCartAnimationEnd @"shopCartAnimationEnd"

@interface ShopCartAnimationVC : JHBaseVC

/**
 *  购物车动画，商品图片掉入购物车
 *
 *  @param imageView   掉入购物车的商品图片
 *  @param dropToPoint 掉入位置
 *  @param isNeedNotification 是否有动画结束的通知（用于购物车上的计数加一）
 */
- (void)addProductsAnimation:(UIView *)out_view dropToPoint:(CGPoint)dropToPoint isNeedNotification:(BOOL)isNeedNotification;

@end

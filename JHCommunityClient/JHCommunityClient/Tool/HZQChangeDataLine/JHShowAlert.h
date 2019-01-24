//
//  JHShowAlert.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHShowAlert : NSObject
/**
 *  JHShowAlert
 *
 *  @param title       提示标题
 *  @param msg         提示信息
 *  @param cancel      左边按钮名称
 *  @param sure        右边按钮名称
 *  @param cancelBlock 左边按钮点击方法回调
 *  @param sureBlock   右边的按钮点击方法回调
 */
+(void)showAlertWithTitle:(NSString *)title
              withMessage:(NSString *)msg
           withBtn_cancel:(NSString *)cancel
             withBtn_sure:(NSString *)sure
                withCancelBlock:(void(^)(void))cancelBlock
            withSureBlock:(void(^)(void))sureBlock;

/**
 点击弹出底部的警告框
 
 @param arr 标题的数组
 @param btnBlock 点击按钮的回调
 */
+(void)showSheetAlertWithTextArr:(NSArray *)arr
                  withController:(UIViewController *)vc
                  withClickBlock:(void(^)(NSInteger tag))btnBlock;
/**
 *  显示简单信息
 *
 *  @param msg 要显示的信息
 */
+(void)showAlertWithMsg:(NSString *)msg;
/**
 *  显示一个按钮,并且按钮有回调Block
 *
 *  @param msg      显示的信息
 *  @param title    按钮的文字
 *  @param btnBlock 按钮的回调
 */
+(void)showAlertWithMsg:(NSString *)msg withBtnTitle:(NSString *)title withBtnBlock:(void(^)())btnBlock;
/**
 *  打电话
 *
 *  @param phone 电话号码
 */
+ (void)showCallWithMsg:(NSString *)phone;
@end

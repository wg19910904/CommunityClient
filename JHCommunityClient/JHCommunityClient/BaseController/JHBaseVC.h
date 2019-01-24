//
//  JHBaseVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/2/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Awesome.h"
#import <YFBasePageVC.h>

@interface JHBaseVC : YFBasePageVC
/**
 *  返回时箭头
 */
@property (nonatomic, strong)UIButton *backBtn;
/**
 *  外部函数
 */
- (void)clickBackBtn;
- (void)touch_BackView;
/**
 *  创建右边的图片按钮
 *
 *  @param imageStr     imageName
 *  @param action       action
 *  @param edgeInsets   图片的调整
 */
- (void)creatRightBtnWith:(NSString *)imageStr sel:(SEL)action edgeInsets:(UIEdgeInsets )edgeInsets;

/**
 *  创建右边的文字按钮
 *
 *  @param titleStr     titlestr
 *  @param action       action
 *  @param edgeInsets   文字的调整
 */
- (void)creatRightTitleBtn:(NSString *)titleStr titleColor:(UIColor *)titleColor sel:(SEL)action edgeInsets:(UIEdgeInsets )edgeInsets;

// 没有数据时展示
- (void)showHaveNoMoreData;

// 用于提醒断网或者服务器正忙
- (void)showNoNetOrBusy:(BOOL)isNoNet;

// 消息提示
- (void)showMsg:(NSString *)msg;
-(void)showToastAlertMessageWithTitle:(NSString *)msg;

/**
 *打电话提示框
 */
- (void)showMobile:(NSString *)title;
/**
 push到一个新的控制器
 
 @param vcName 新的控制器的名称
 */
-(void)pushToNextVcWithVcName:(NSString *)vcName;

/**
 push到一个新的控制器
 
 @param vcName 新的控制器的名称
 @param dic 需要的参数
 */
-(void)pushToNextVcWithVcName:(NSString *)vcName params:(NSDictionary *)dic;

#pragma mark ======显示和隐藏没有数据的view=======
-(void)showEmptyViewWithImgName:(NSString *)imgName desStr:(NSString *)desStr btnTitle:(NSString *)btnTitle inView:(UIView *)view;
//-(void)showEmptyViewWithImgName:(NSString *)imgName desStr:(NSString *)desStr inView:(UIView *)view;
-(void)hiddenEmptyView;
// 状态按钮
-(void)clickStatusBtnAction;
@end

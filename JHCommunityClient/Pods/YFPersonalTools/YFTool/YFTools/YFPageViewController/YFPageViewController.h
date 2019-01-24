//
//  YFPageViewController.h
//  YFPageViewControllerVC
//
//  Created by ios_yangfei on 2017/12/20.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFBasePageVC.h"

typedef NS_ENUM(NSUInteger, VCTransformType) {
    VCTransformType_Scroll,     // 滚动
    VCTransformType_Overlay     // 叠加
};

@class YFPageViewController;
@protocol YFPageViewControllerDelegate <NSObject>
@optional

/**
 下一个将要显示的控制器和index

 @param pageViewController  page控制器
 @param subVC               将要显示的控制器
 @param index               将要显示的控制器的index
 */
-(void)pageViewController:(YFPageViewController *)pageViewController
   showNextViewController:(YFBasePageVC *)subVC
               showNextVC:(NSUInteger)index;
@end

@interface YFPageViewController : UIViewController

/**
 初始化PageVC

 @param vcArr       控制器数组
 @return            返回PageVC控制器
 */
-(instancetype)initWithTransformType:(VCTransformType)vcTransformType vcArr:(NSArray <YFBasePageVC *>*)vcArr;

@property(nonatomic,weak)UIViewController *superVC;

@property(nonatomic,weak)id<YFPageViewControllerDelegate> delegate;
// 控制器数组
@property(nonatomic,strong)NSArray <YFBasePageVC *>* subVCArr ;
// 默认VCHierarchy_Scroll,控制器是以滚动的方式切换的
@property(nonatomic,assign)VCTransformType vcTransformType;
// 当前的index
@property(nonatomic,assign)NSUInteger current_index;
@end

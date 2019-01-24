//
//  NewUpwardLunV.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/13.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tapActionBlock)(NSInteger index);
@interface NewUpwardLunV : UIView<UIScrollViewDelegate>




@property(nonatomic,assign)NSTimeInterval animationDuration;//时间
/* 默认图片，下载未完成时显示 */
/* 注意：赋值必须写在Start方法之前，否则仍然为nil */
@property(nonatomic,strong)UIImage *placeHoldImage;
/* 数据源 **/
@property(nonatomic,copy)NSArray *imageGroup;

/**
 *  初始化广告播放滚动View
 *
 *  @param rect       尺寸位置
 *  @param imageGroup 图片数据源
 */
+ (instancetype)adsPlayViewWithFrame:(CGRect)rect imageGroup:(NSArray *)imageGroup;

/**
 *  开始播放，默认五秒钟,点击响应block回调
 *
 *  @param block 回调，返回当前图片index，不需要回调则设置为nil
 */
- (void)startWithTapActionBlock:(tapActionBlock)block;

/**
 *  停止播放
 */
- (void)stop;

@property(nonatomic,strong)NSArray * array;
@end



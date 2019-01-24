//
//  DisplayImageInView.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/28.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayImageInView : UIView<UIScrollViewDelegate>
@property(nonatomic,copy)void(^block)(void);
//直接传图片数组(@[@"1.png",@"2.png"])
-(void)showInViewWithImageArray:(NSArray *)imageArray withIndex:(NSInteger )index withBlock:(void(^)(void))click;
/**
 *  传入stringl类型的数组
 *
 *  @param imageArray string 数组
 *  @param index      指定的展示index
 *  @param click      回调
 */
-(void)showInViewWithImageUrlArray:(NSArray *)imageArray
                         withIndex:(NSInteger )index
                         withBlock:(void(^)(void))click;
@end

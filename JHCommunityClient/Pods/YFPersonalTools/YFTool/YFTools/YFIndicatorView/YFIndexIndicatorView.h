//  YFIndexIndicatorView.h
//
//
//  Created by YangFei on 2018/4/10.
//  Copyright © 2018年 YangFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFIndexIndicatorView;

@protocol YFIndexIndicatorViewDelegate<NSObject>
@optional
- (void)indexIndicatorView :(YFIndexIndicatorView *)indexIndicatorView didSelectItemAtIndex:(NSInteger)index;
@end


@interface YFIndexIndicatorView : UIView
@property(nonatomic,weak)id<YFIndexIndicatorViewDelegate> delegate;
/*
 @{
 @"title":@"title",
 @"badge":@"1"
 }
 */
@property(nonatomic,strong)NSArray<NSDictionary*> *index_arr;

// 获取当前的index
@property(nonatomic,assign,getter=current_index)NSInteger scrollToIndex;
// 是否可以滑动
@property(nonatomic,assign)BOOL scrollEnabled;
// 选中item的时候是否有缩放的效果
@property(nonatomic,assign)BOOL showAnmation;

// 是否显示indicatorLine
@property(nonatomic,assign)BOOL showIndicatorLineView;
// indicatorLine的宽度
@property(nonatomic,assign)CGFloat indicatorLineWidth;
// indicatorLine的宽度根据item的宽度而定
@property(nonatomic,assign)CGFloat indicatorLineAutoWidth;
// indicatorLine的颜色
@property(nonatomic,strong)UIColor *indicatorLineColor;

@end

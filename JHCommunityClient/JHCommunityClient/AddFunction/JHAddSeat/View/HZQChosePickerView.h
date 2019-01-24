//
//  ChosePeopleNumView.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HZQChosePickerViewDelegate<NSObject>
-(void)choseWithText:(NSString*)text withIndex:(NSInteger)num;
@end
@interface HZQChosePickerView : UIControl<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIView *center_view;
@property(nonatomic,strong)UILabel *label_title;
@property(nonatomic,strong)UIPickerView *pickerView;
/**
 *  代理回调(自选一种回调方式)
 */
@property(nonatomic,assign)id<HZQChosePickerViewDelegate>delegate;
/**
 *  block回调(自选一种回调方式)
 */
@property(nonatomic,copy)void(^myBlock)(NSString *text,NSInteger num);

/**
 *  选择人数的view
 *
 *  @param infoArray 将人数数组传入
 *  @param index     上次选中的索引号
 *
 *  @return 返回一个对象
 */
+(HZQChosePickerView *)showChosePeopleNumViewWithArray:(NSArray *)infoArray
                                             withIndex:(NSInteger)index;
@end

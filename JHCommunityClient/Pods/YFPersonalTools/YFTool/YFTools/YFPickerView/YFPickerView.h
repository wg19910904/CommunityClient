//
//  YFPickerView.h
//  YFTool
//
//  Created by ios_yangfei on 2018/4/23.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFPickerViewDefine.h"

@class YFPickerView;
@protocol YFPickerViewDelegate<NSObject>
@optional

/**
 点击确定按钮的回调

 @param pickerView      YFPickerView对象
 @param row_1           第一个UIPickerView选择的row
 @param row_2           第二个UIPickerView选择的row
 @param row_3           第三个UIPickerView选择的row
 */
-(void)pickerView:(YFPickerView *)pickerView clickSureActionRow1:(NSInteger)row_1 row2:(NSInteger)row_2 row3:(NSInteger)row_3;

/**
 选择某一个UIPickerView的回调

 @param pickerView      YFPickerView对象
 @param indexPath       UIPickerView选择的row
 */
-(void)pickerView:(YFPickerView *)pickerView didSelectIndexPath:(NSIndexPath *)indexPath;

/**
 UIPickerView的文字显示处理

 @param pickerView       YFPickerView对象
 @param indexPath        UIPickerView当前的row
 @param textLab          UIPickerView当前的row对应显示的view
 */
-(void)pickerView:(YFPickerView *)pickerView viewForIndexPath:(NSIndexPath *)indexPath view:(UILabel *)textLab;

@end

@interface YFPickerView : UIView

@property(nonatomic,weak)id<YFPickerViewDelegate> delegate;

@property(nonatomic,copy)NSString *titleStr;// title
@property(nonatomic,strong)NSArray *firstArr;
@property(nonatomic,strong)NSArray *secondArr;
@property(nonatomic,strong)NSArray *thirdArr;

@property(nonatomic,assign)YFPickerViewShowType showType;// pickview展示出来时的动画位置
@property(nonatomic,assign)YFPickerViewSubViewLocationType sureBtnType;
@property(nonatomic,assign)YFPickerViewSubViewLocationType titleLabType;


/**
 初始化

 @param type    YFPickerViewType初始化几个UIPickerView
 @return        YFPickerView对象
 */
-(instancetype)initWithType:(YFPickerViewType)type;
// 展示
-(void)showPickerView;
// 消失
-(void)hiddenPickerView;
// 刷新数据
-(void)reloadData;

@end


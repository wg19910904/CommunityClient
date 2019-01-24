//
//  YFTextField.h
//  baocmsAPP
//
//  Created by jianghu3 on 15/12/31.
//  Copyright © 2015年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFTextField : UITextField
@property(nonatomic,assign)CGFloat margin;
@property(nonatomic,assign)CGFloat placeholdeFont;
@property(nonatomic,strong)UIColor *placeholdeColor;
/**
 *  设置左边视图margin距离
 */
-(id)initWithFrame:(CGRect)frame leftView:(UIView *)leftView;

-(id)initWithFrame:(CGRect)frame leftView:(UIView *)leftView rightView:(UIView *)rightView;
@end

//
//  UIView+Extension.h
//  baocmsAPP
//
//  Created by Apple on 16/1/3.
//  Copyright © 2016年 jianghu3. All rights reserved.
//
//
#import "UIView+Extension.h"

@implementation UIView (Extension)

CGFloat _mas_top;
CGFloat _mas_left;
CGFloat _mas_bottom;
CGFloat _mas_right;
CGFloat _mas_width;
CGFloat _mas_height;
CGFloat _mas_centerX;
CGFloat _mas_centerY;

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.width;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.height;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


#pragma mark ====== 约束设置 =======
-(void)addLayoutConstraint:(UIEdgeInsets)edgeInset{
    
    NSAssert(self.superview, @"添加约束的时候没有设置父视图");
    // 给需要设置约束的视图禁用autoresizing，禁用父视图autoresizing对子控件无效
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *layout_top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInset.top];
   
    NSLayoutConstraint *layout_left = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:edgeInset.left];
   
    NSLayoutConstraint *layout_bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInset.bottom];
    
    NSLayoutConstraint *layout_right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1 constant:edgeInset.right];
    
    [self.superview addConstraints:@[layout_left,layout_top,layout_right,layout_bottom]];
}

-(void)mas_constraint:(ConstraintMake)constraintMake{
    
    NSAssert(self.superview, @"添加约束的时候没有设置父视图");
    // 给需要设置约束的视图禁用autoresizing，禁用父视图autoresizing对子控件无效
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintMake(self);
}

-(void)setYf_mas_top:(CGFloat)yf_mas_top{
    _mas_top = yf_mas_top;
    NSLayoutConstraint *layout_top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:yf_mas_top];
    [self.superview addConstraint:layout_top];
}

-(void)setYf_mas_left:(CGFloat)yf_mas_left{
    _mas_left = yf_mas_left;
    NSLayoutConstraint *layout_left = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:yf_mas_left];
    [self.superview addConstraint:layout_left];
}

-(void)setYf_mas_bottom:(CGFloat)yf_mas_bottom{
    _mas_bottom = yf_mas_bottom;
    NSLayoutConstraint *layout_bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:yf_mas_bottom];
    [self.superview addConstraint:layout_bottom];
}

-(void)setYf_mas_right:(CGFloat)yf_mas_right
{
    _mas_right = yf_mas_right;
    NSLayoutConstraint *layout_right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1 constant:yf_mas_right];
    [self.superview addConstraint:layout_right];
}

-(void)setYf_mas_width:(CGFloat)yf_mas_width{
    _mas_width = yf_mas_width;
    NSLayoutConstraint *layout_width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:yf_mas_width];
    [self.superview addConstraint:layout_width];
}

-(void)setYf_mas_height:(CGFloat)yf_mas_height
{
    _mas_height = yf_mas_height;
    NSLayoutConstraint *layout_height = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:yf_mas_height];
    [self.superview addConstraint:layout_height];
}

-(void)setYf_mas_centerX:(CGFloat)yf_mas_centerX{
    _mas_centerX = yf_mas_centerX;
    NSLayoutConstraint *layout_centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:yf_mas_centerX];
    [self.superview addConstraint:layout_centerX];
}
-(void)setYf_mas_centerY:(CGFloat)yf_mas_centerY{
    _mas_centerY = yf_mas_centerY;
    NSLayoutConstraint *layout_centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:yf_mas_centerY];
    [self.superview addConstraint:layout_centerY];
}

-(CGFloat)yf_mas_top{
    return _mas_top;
}

-(CGFloat)yf_mas_left{
   return _mas_left;
}

-(CGFloat)yf_mas_bottom{
    return _mas_bottom;
}

-(CGFloat)yf_mas_right{
    return _mas_right;
}

-(CGFloat)yf_mas_height{
    return _mas_height;
}

-(CGFloat)yf_mas_width{
    return _mas_width;
}

-(CGFloat)yf_mas_centerX{
    return _mas_centerX;
}

-(CGFloat)yf_mas_centerY{
    return _mas_centerY;
}

@end

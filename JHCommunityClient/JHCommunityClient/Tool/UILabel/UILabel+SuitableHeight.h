//
//  UILabel+SuitableHeight.h
//  testLabel
//
//  Created by xixixi on 15/11/16.
//  Copyright © 2015年 xihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SuitableHeight)
- (CGFloat)getLabelFitHeight:(UILabel *)label  withFont:(UIFont *)font;

@end
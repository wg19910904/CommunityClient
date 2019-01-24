//
//  UILabel+SuitableHeight.m
//  testLabel
//
//  Created by xixixi on 15/11/16.
//  Copyright © 2015年 xihao. All rights reserved.
//

#import "UILabel+SuitableHeight.h"

@implementation UILabel (SuitableHeight)

/*
 *return  label height
 *
 */
- (CGFloat)getLabelFitHeight:(UILabel *)label  withFont:(UIFont *)font
{
    CGFloat width = label.frame.size.width;     //width : UILable的宽度
    CGSize size = CGSizeMake(width, MAXFLOAT);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    //自动换行
    label.numberOfLines = 0;
    CGSize textRealSize;
    textRealSize = [label.text boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil].size;
    label.frame = FRAME(label.frame.origin.x, label.frame.origin.x, textRealSize.width, textRealSize.height);
    //返回适应后的高
    return textRealSize.height;
}

@end

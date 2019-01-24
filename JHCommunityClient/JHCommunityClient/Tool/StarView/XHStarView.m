//
//  XHStarView.m
//  JHCommunityClient
//
//  Created by xixixi on 16/6/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "XHStarView.h"
const NSInteger KStarNum = 5;
@interface XHStarView()
@end
@implementation XHStarView

+(XHStarView *)addEvaluateViewWithStarNO:(float)starNum
                   withFrame:(CGRect )frame
{
    XHStarView *starView = [[XHStarView alloc] init];
    starView.grayStarImage = [UIImage imageNamed:@"xing2"];
    starView.colorStarImage = [UIImage imageNamed:@"xing1"];
    starView.backgroundColor = [UIColor clearColor];
    starView.frame = CGRectMake(frame.origin.x, frame.origin.y,
                                KStarNum * starView.grayStarImage.size.width,
                                starView.grayStarImage.size.height);
    
    starView.backView = [[UIView alloc] initWithFrame:CGRectZero];
    starView.backView.backgroundColor = [UIColor clearColor];
    starView.backView.backgroundColor = [UIColor colorWithPatternImage:starView.grayStarImage];
    starView.backView.frame = starView.bounds;
    [starView addSubview:starView.backView];
    if (isnan(starNum) || isinf(starNum)) {
        
        [starView.topView removeFromSuperview];
        
    }else{
        starNum = MIN(starNum, KStarNum);
        starView.topView = [[UIView alloc] initWithFrame:CGRectZero];
        starView.topView.backgroundColor = [UIColor clearColor];
        starView.topView.backgroundColor = [UIColor colorWithPatternImage:starView.colorStarImage];
        starView.topView.frame = starView.bounds;
        [starView addSubview:starView.topView];
        
        CGRect frame1 = starView.topView.frame;
        starView.topView.frame = CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width * starNum / KStarNum, frame1.size.height);
    }
    
    CGFloat time = CGRectGetHeight(frame) / starView.grayStarImage.size.height;
    starView.transform = CGAffineTransformMakeScale(time, time);
    starView.frame = CGRectMake(frame.origin.x, frame.origin.y, starView.frame.size.width, starView.frame.size.height);
    return starView;
}

-(void)setStartNum:(float)startNum{
    _startNum=startNum;
//    self.colorStarImage = [UIImage imageNamed:self.notBadImage];
//    if (startNum<=1) self.colorStarImage = [UIImage imageNamed:self.badImage];
//    else if(startNum == 5) self.colorStarImage = [UIImage imageNamed:self.fillImage];
    
    [self.topView removeFromSuperview];
    
    startNum = (int)MIN(startNum, KStarNum);
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = [UIColor clearColor];
    self.topView.backgroundColor = [UIColor colorWithPatternImage:self.colorStarImage];
    self.topView.frame = self.bounds;
    [self addSubview:self.topView];
    
    CGRect frame1 = self.topView.frame;
    self.topView.frame = CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width * startNum / KStarNum, frame1.size.height);
}

@end

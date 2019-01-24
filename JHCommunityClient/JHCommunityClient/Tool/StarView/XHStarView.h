//
//  XHStarView.h
//  JHCommunityClient
//
//  Created by xixixi on 16/6/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHStarView : UIView
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIImage *grayStarImage;
@property(nonatomic,strong)UIImage *colorStarImage;
@property(nonatomic,assign)float startNum;
+(XHStarView *)addEvaluateViewWithStarNO:(float)starNum
                   withFrame:(CGRect )frame;
@end

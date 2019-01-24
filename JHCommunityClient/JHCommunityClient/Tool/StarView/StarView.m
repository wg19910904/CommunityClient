//
//  StarView.m
//  Lunch
//
//  Created by ijianghu on 15/12/9.
//  Copyright © 2015年 jianghu. All rights reserved.
//

#import "StarView.h"

@interface StarView ()

@end

@implementation StarView
#pragma mark - 添加评价星级视图
+(UIView *)addEvaluateViewWithStarNO:(float)starNO
                         withStarSize:(CGFloat)size
                    withBackViewFrame:(CGRect )frame
{
    if (isnan(starNO) || isinf(starNO))  {
        UIView *starBackView = [[UIView alloc] initWithFrame:frame];
        for (int i = 0; i < 5; i++) {
            UIImageView *starIV = [[UIImageView alloc] initWithFrame:CGRectMake(size * 4 / 3 * i, 10 - size / 2 , size, size)];
            starIV.image = [UIImage imageNamed:@"xing2"];
            [starBackView addSubview:starIV];
        }
        return starBackView;
    }
    if (starNO > 5.0) starNO = 5.0;
    //获取最后所需重绘的星星index
    NSInteger lastNO = starNO;
    UIView *starBackView = [[UIView alloc] initWithFrame:frame];
    for (int i = 0; i < 5; i++) {
        UIImageView *starIV = [[UIImageView alloc] initWithFrame:CGRectMake(size * 4 / 3 * i, 10 - size / 2 , size, size)];
        starIV.image = [UIImage imageNamed:@"xing2"];
        [starBackView addSubview:starIV];
    }
    if (lastNO > 0) {
        for (int i = 0; i <= starNO - 1; i++) {
            UIImageView *starIV = [[UIImageView alloc] initWithFrame:CGRectMake(size * 4 / 3 * i, 10 - size / 2, size, size)];
            starIV.image = [UIImage imageNamed:@"xing1"];
            [starBackView addSubview:starIV];
        }
    }
    if (starNO == 5) {
        //
    }else{
        //添加最后的星星(不完整星星)
        //创建一个和和所使用星星图片尺寸同样大小的view
        UIView *specialBackView = [[UIView alloc] initWithFrame:CGRectMake(size * 4 / 3 * lastNO, 10 - size / 2, size, size)];
        //获取需要显示的小数数值
        float extraNO = starNO - (int)starNO;
        //根据小数在背景view上添加颜色
        //添加橘色背景
        UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size * extraNO, size)];
        orangeView.backgroundColor = HEX(@"fd6469", 1.0f);
        //添加灰色背景
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(size * extraNO, 0, size - size * extraNO, size)];
        //创建最上层的星星imageView
        UIImageView *topIV = [[UIImageView alloc] initWithFrame:specialBackView.bounds];
        topIV.image = [UIImage imageNamed:@"starB1_touming"];
        //添加到specialBackView
        [specialBackView addSubview:orangeView];
        [specialBackView addSubview:grayView];
        [specialBackView addSubview:topIV];
        [starBackView addSubview:specialBackView];
    }
    return starBackView;
}
@end

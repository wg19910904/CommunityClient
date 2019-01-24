//
//  Rating.m
//  JHHouseKeeping
//
//  Created by jianghu2 on 15/12/29.
//  Copyright © 2015年 jianghu. All rights reserved.
//

#import "Rating.h"

@implementation Rating
{
    UIImageView *_img1;
    UIImageView *_img2;
    UIImageView *_img3;
    UIImageView *_img4;
    UIImageView *_img5;
    UIImageView *_img6;
    UIImageView *_img7;
    UIImageView *_img8;
    UIImageView *_img9;
    UIImageView *_img10;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _img10 = [[UIImageView alloc] init];
        _img1 = [[UIImageView alloc] init];
        _img2 = [[UIImageView alloc] init];
        _img3 = [[UIImageView alloc] init];
        _img4 = [[UIImageView alloc] init];
        _img5 = [[UIImageView alloc] init];
        _img6 = [[UIImageView alloc] init];
        _img7 = [[UIImageView alloc] init];
        _img8 = [[UIImageView alloc] init];
        _img9 = [[UIImageView alloc] init];
        NSArray *array = @[_img1,_img2,_img3,_img4,_img4,_img5];
        for (int i = 0; i < 5; i++) {
            UIImageView *img = array[i];
            if(img == nil)
            {
                img = [[UIImageView alloc] init];
            }
            img.frame = FRAME(i * 12, 0, 10, 10);
            img.image = [UIImage imageNamed:@"xing2"];
            [self addSubview:img];
        }
        
    }
    return self;
}
- (void)setRate:(NSInteger)rate
{
    _rate = rate;
    NSArray *array = @[_img6,_img7,_img8,_img9,_img10];
    for(int i = 0; i < rate;i++)
    {
        UIImageView *img = array[i];
        if(img == nil)
        {
            img = [[UIImageView alloc] init];
        }
        img.frame = FRAME(i * 12, 0, 10, 10);
        img.image = [UIImage imageNamed:@"xing1"];
        [self addSubview:img];
    }

}
@end

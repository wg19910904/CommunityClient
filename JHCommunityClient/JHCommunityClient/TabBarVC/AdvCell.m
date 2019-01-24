//
//  AdvCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2017/5/2.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "AdvCell.h"
#import <UIImageView+WebCache.h>
@interface AdvCell()
@property(nonatomic,strong)UIImageView *imageV;//展示广告的图片
@end
@implementation AdvCell
-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageStr]];
}
//展示广告图片的
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.frame = FRAME(0, 0, WIDTH, HEIGHT);
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageV];
    }
    return _imageV;
}
@end

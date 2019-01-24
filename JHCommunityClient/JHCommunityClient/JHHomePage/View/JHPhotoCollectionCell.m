//
//  JHPhotoCollectionCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPhotoCollectionCell.h"
#import <UIImageView+WebCache.h>
@implementation JHPhotoCollectionCell
{
    //cell的宽 高
    CGFloat width;
    CGFloat height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        width = CGRectGetWidth(frame);
        height = CGRectGetHeight(frame);
        //添加子视图
        [self addSubviews];
    }
    return self;
}
#pragma mark - 添加子视图
- (void)addSubviews
{
    self.iv = [UIImageView new];
    self.iv.frame = FRAME(0, 0, width, height);
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = HEX(@"000000", 0.35);
    self.titleLabel.frame = FRAME(0, height - 30, width, 30);
    self.titleLabel.font = FONT(13);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_iv];
    [self addSubview:_titleLabel];
}
#pragma mark - 传入参数时
- (void)setDataDic:(NSDictionary *)dataDic
{
    NSString *photo_name = dataDic[@"photo"];
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:photo_name]];
    _iv.contentMode = 2;
    _iv.clipsToBounds =YES;
    [_iv sd_setImageWithURL:url placeholderImage:IMAGE(@"5")];
}
@end

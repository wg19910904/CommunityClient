//
//  TempHomeClassifyCollectionViewCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/14.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "TempHomeClassifyCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation TempHomeClassifyCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatUI];
    }
    
    return self;
}
-(void)creatUI{

    
    _topImage  = [[UIImageView alloc] init];
    [self addSubview:_topImage];
    [_topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset =5;
        make.left.offset =(WIDTH/6 - 40)/2;
        make.right.offset = -(WIDTH/6 - 40)/2;
        make.height.offset = 40;
    }];
    
    
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    _titlelabel.textColor = TEXT_COLOR;
    _titlelabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset =-5;
        make.left.right.offset =0;
        make.height.offset = 15;
    }];
    _titlelabel.textColor =HEX(@"333333", 1);
    
    
}
- (void)setModel:(JHTempAdvModel *)model{
    _model = model;
    [_topImage sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:PHAIMAGE];
    _titlelabel.text = model.title;
    
}
@end

//
//  TempHomeShopSelectCollectionViewCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/13.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "TempHomeShopSelectCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation TempHomeShopSelectCollectionViewCell

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
    CGFloat f =( WIDTH - 3*109*WIDTH/375)/4;
    UIView *bgview = [[UIView alloc]init];
//                      WithFrame:CGRectMake(f*2/3, 5, 109*WIDTH/375, 130*WIDTH/375)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 5;
        make.left.offset = f*2/3;
        make.bottom.offset = -10*WIDTH/375;
        make.right.offset = -f*2/3;
    }];
    bgview.layer.cornerRadius =4;
    bgview.layer.shadowColor = [UIColor blackColor].CGColor;
    bgview.layer.shadowOpacity = 0.2f;
    bgview.layer.shadowOffset = CGSizeMake(0, 0);
    
    _topImageV  = [[UIImageView alloc] init];
    [bgview addSubview:_topImageV];
    [_topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset =9;
        make.left.offset =(109*WIDTH/375 - 75*WIDTH/375)/2;
//        make.right.offset = -15;
        make.height.width.offset = 75*WIDTH/375;
    }];
    
    
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    _titlelabel.textColor = TEXT_COLOR;
    _titlelabel.font = [UIFont systemFontOfSize:15];
    [bgview addSubview:_titlelabel];
    
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset =-10;
        make.left.right.offset =0;
        make.height.offset = 20;
    }];
    
    
    
}
-(void)setModel:(JHTempAdvModel *)model{
    _model = model;
    [_topImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:PHAIMAGE];
    _titlelabel.text = model.title;
    
}


@end

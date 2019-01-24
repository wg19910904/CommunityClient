//
//  SearchCollectionViewCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@interface SearchCollectionViewCell ()
@property(nonatomic,weak)UILabel *titleLab;
@end

@implementation SearchCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
    titleLab.layer.borderColor=LINE_COLOR.CGColor;
    titleLab.layer.borderWidth=1.0;
    titleLab.layer.cornerRadius=10;
    titleLab.clipsToBounds=YES;
}

-(void)reloadCellWith:(NSString *)title{
    self.titleLab.text = title;
}


@end

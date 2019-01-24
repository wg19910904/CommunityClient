//
//  ActivityImgCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/28.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "ActivityImgCell.h"

@interface ActivityImgCell()
@property(nonatomic,weak)UILabel *titleLab;
@end

@implementation ActivityImgCell
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
        make.centerY.offset = 0;
        make.centerX.offset = 0;
        make.width.offset = 15;
        make.height.offset = 15;
    }];
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
    titleLab.font = FONT(12);
    titleLab.layer.borderColor=HEX(@"ffffff", 1.0).CGColor;
    titleLab.layer.borderWidth=1.0;
    titleLab.layer.cornerRadius=7.5;
    titleLab.clipsToBounds=YES;
}

-(void)reloadCellWith:(NSDictionary *)dic{
    
    self.titleLab.textColor = HEX(dic[@"color"], 1.0);
    self.titleLab.text = dic[@"title"];
    self.titleLab.layer.borderColor = HEX(dic[@"color"], 1.0).CGColor;
    
}

@end

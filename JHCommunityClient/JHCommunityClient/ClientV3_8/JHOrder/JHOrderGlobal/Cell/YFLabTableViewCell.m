//
//  YFLabTableViewCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "YFLabTableViewCell.h"

@interface YFLabTableViewCell ()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *centerLab;
@property(nonatomic,weak)UILabel *rightLab;
@end

@implementation YFLabTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(20);
        make.height.offset(20);
        make.bottom.offset(-10);
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"666666", 1.0);
    self.titleLab = titleLab;
    
    UILabel *centerLab = [UILabel new];
    [self.contentView addSubview:centerLab];
    [centerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
    centerLab.font = FONT(14);
    centerLab.textColor = HEX(@"666666", 1.0);
    self.centerLab = centerLab;
    
    UILabel *rightLab = [UILabel new];
    [self.contentView addSubview:rightLab];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
    rightLab.font = FONT(14);
    rightLab.textColor = HEX(@"666666", 1.0);
    self.rightLab = rightLab;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=-0.5;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.hidden = YES;
    lineView.backgroundColor=LINE_COLOR;
    self.lineView = lineView;
    
}

-(void)reloadCellWithTitle:(NSString *)titleStr center:(NSString *)centerStr right:(NSString *)rightStr{
    self.titleLab.text = titleStr;
    self.centerLab.text = centerStr;
    self.rightLab.text = rightStr;
}

#pragma mark ====== Setter =======
-(void)setCenterLab_masRight:(CGFloat)centerLab_masRight{
    [self.centerLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(centerLab_masRight);
        make.centerY.offset(10);
        make.height.offset(20);
    }];
}

-(void)setTitle_masLeft:(CGFloat)title_masLeft{
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(title_masLeft);
        make.height.offset(20);
        make.bottom.offset(-10);
    }];
}

-(void)setRightLab_masRight:(CGFloat)rightLab_masRight{
    [self.rightLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(rightLab_masRight);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
}

-(void)setTitleLabColor:(UIColor *)titleLabColor{
    self.titleLab.textColor = titleLabColor;
}

-(void)setCenterLabColor:(UIColor *)centerLabColor{
    self.centerLab.textColor = centerLabColor;
}

-(void)setRightLabColor:(UIColor *)rightLabColor{
    self.rightLab.textColor = rightLabColor;
}

@end

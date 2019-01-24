//
//  JHNewMyCenterThreeCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/15.
//  Copyright © 2018年 JiangHu. All rights reserved.
///var/folders/1z/708nhjmn6k557rdv1nvc1pxh0000gn/T/AppIconMaker/appicon.png

#import "JHNewMyCenterThreeCell.h"
#import <UIImageView+WebCache.h>
@interface JHNewMyCenterThreeCell()
{
    UIImageView *leftImg;
    UILabel *titleL;
    UIImageView *midImg;
    UILabel *rightL;
    UIImageView *rightImg;
    UIView *lineV;
    
    
}
@end

@implementation JHNewMyCenterThreeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    leftImg = [[UIImageView alloc]init];
    [self addSubview:leftImg];
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 13;
        make.left.offset = 11;
        make.width.height.offset = 18;
    }];
    leftImg.contentMode = UIViewContentModeScaleAspectFill;
 
    
    titleL = [[UILabel alloc]init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 11;
        make.left.equalTo(leftImg.mas_right).offset = 6;
        make.width.offset = 80;
        make.bottom.offset =-8;
    }];
    titleL.textColor = HEX(@"333333", 1);
    titleL.font = FONT(14);
    titleL.textAlignment = NSTextAlignmentLeft;
    
//    rightImg = [[UIImageView alloc]init];
//    [self addSubview:rightImg];
//    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset = 5;
//        make.right.offset = -1;
//        make.width.height.offset = 29;
//    }];
//    rightImg.image = IMAGE(@"jiantou_1");
    
    midImg = [[UIImageView alloc]init];
    [self addSubview:midImg];
    [midImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 13;
        make.right.offset = -40;
        make.height.offset = 18;
        make.width.offset = 75;
    }];
    midImg.contentMode = UIViewContentModeScaleAspectFill;
    midImg.hidden = YES;
    
    rightL = [[UILabel alloc]init];
    [self addSubview:rightL];
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 13;
         make.right.offset = -40;
        make.height.offset = 18;
        make.width.offset = 90;
    }];
    rightL.hidden = YES;
    rightL.textAlignment = NSTextAlignmentRight;
    rightL.textColor = HEX(@"666666", 1);
    rightL.font = FONT(12);
    
    lineV = [[UIView alloc]init];
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.bottom.offset = -0.5;
        make.height.offset = 0.5;
    }];
    lineV.backgroundColor = HEX(@"e5e5e5", 1);
    
    
}
//title    string    标题
//icon    string    图标
//url    string    链接
//info    string    简介
//mark    string    标签（hot、new）

- (void)setDic:(NSDictionary *)dic{
    
    [leftImg sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]] placeholderImage:[UIImage imageNamed:@"loginheader"]];
    
    titleL.text = dic[@"title"];
    
    if (dic[@"mark"]) {
        [midImg sd_setImageWithURL:[NSURL URLWithString:dic[@"mark"]] placeholderImage:[UIImage imageNamed:@"loginheader"]];
        midImg.hidden= NO;
        
    }
    
    if (dic[@"info"]) {
        rightL.text = dic[@"info"];
        rightL.hidden = NO;
        midImg.hidden = YES;
    }
    
    
}
+(NSString *)getIdentifier{
    return @"JHNewMyCenterThreeCell";
}

+(CGFloat)getHeight:(id)model{
    return 40;
}
@end

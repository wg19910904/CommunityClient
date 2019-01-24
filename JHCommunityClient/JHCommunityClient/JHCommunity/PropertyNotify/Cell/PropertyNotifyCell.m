//
//  PropertyNotifyCell.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "PropertyNotifyCell.h"
#import <UIImageView+WebCache.h>

@interface PropertyNotifyCell ()
@property(nonatomic,weak)UIImageView *typeImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIImageView *contentImgView;
@property(nonatomic,weak)UILabel *contentLab;

@end

@implementation PropertyNotifyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *backView=[UIView new];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=0;
        make.width.offset=WIDTH-20;
        make.bottom.equalTo(self.contentView.mas_bottom).offset=0;
    }];
    backView.backgroundColor=[UIColor whiteColor];
    backView.layer.cornerRadius=4;
    backView.clipsToBounds=YES;
    
    UIImageView *typeImgView=[[UIImageView alloc] initWithFrame:FRAME(5, 5, 30, 30)];
    [backView addSubview:typeImgView];
//    [typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset=5;
//        make.top.offset=5;
//        make.width.offset=30;
//        make.height.offset=30;
//    }];
    self.typeImgView=typeImgView;
    
    UILabel *titleLab=[UILabel new];
    [backView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeImgView.mas_right).offset=20;
        make.top.offset=10;
        make.right.equalTo(backView.mas_right).offset=-10;
        make.height.offset=20;
    }];
    titleLab.textColor=HEX(@"666666", 1.0);
    titleLab.font=FONT(16);
    self.titleLab=titleLab;
    
    UIView *vLineView=[UIView new];
    vLineView.backgroundColor=LINE_COLOR;
    [backView addSubview:vLineView];
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeImgView.mas_right).offset=10;
        make.top.offset=0;
        make.width.offset=1;
        make.height.offset=40;
    }];
    
    UIView *lineViewOne=[UIView new];
    lineViewOne.backgroundColor=LINE_COLOR;
    [backView addSubview:lineViewOne];
    [lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=40;
        make.width.offset=WIDTH;
        make.height.offset=1;
    }];
    
    UIImageView *contentImgView=[[UIImageView alloc] initWithFrame:FRAME(10, 60, WIDTH-40, 115)];
    [backView addSubview:contentImgView];
//    [contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset=10;
//        make.top.equalTo(typeImgView.mas_bottom).offset=20;
//        make.right.equalTo(backView.mas_right).offset=-10;
//        make.height.offset=115;
//    }];
    self.contentImgView=contentImgView;
    
    UILabel *contentLab=[UILabel new];
    [backView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(contentImgView.mas_bottom).offset=10;
        make.right.equalTo(backView.mas_right).offset=-10;
        make.bottom.offset=-50;
    }];
    contentLab.numberOfLines=0;
    contentLab.lineBreakMode=NSLineBreakByCharWrapping;
    contentLab.textColor=HEX(@"666666", 1.0);
    contentLab.font=FONT(15);
    self.contentLab=contentLab;
    
    UIView *lineViewTwo=[UIView new];
    lineViewTwo.backgroundColor=LINE_COLOR;
    [backView addSubview:lineViewTwo];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(contentLab.mas_bottom).offset=10;
        make.width.offset=WIDTH;
        make.height.offset=1;
    }];
    
    UILabel *lab=[UILabel new];
    [backView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(contentLab.mas_bottom).offset=20;
        make.width.offset=100;
        make.height.offset=20;
    }];
    lab.text=@"阅读全文";
    lab.textColor=HEX(@"666666", 1.0);
    lab.font=FONT(16);
    
    UIImageView *imgView=[UIImageView new];
    [backView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(lab.mas_centerY).offset=0;
        make.width.offset=5;
        make.height.offset=10;
    }];
    imgView.image=IMAGE(@"address_next");
}

-(void)reloadCellWithModel:(PropertyNotifyModel *)model{
    
    NSString *imgStr;
    if ([model.from isEqualToString:@"notice"])   imgStr=@"notify_1";
    else imgStr=@"notify_2";
    self.typeImgView.image=IMAGE(imgStr);
    
    self.titleLab.text=model.title;

    if (model.photo.length>0) {
        
        self.contentImgView.height=115;
        NSString *url=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.photo];
        [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"jfproduct640x400") ];
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset=175;
        }];
        
    }else {

        self.contentImgView.height=0;
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset=50;
        }];
        
    }
    
    self.contentLab.text=model.intro;

}

@end

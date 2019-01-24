//
//  GetNumberCell.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "GetNumberCell.h"
#import "NSString+Tool.h"

@interface GetNumberCell ()
@property(nonatomic,weak)UILabel *getNumTimeLab;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *statusLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *numberLab;
@property(nonatomic,weak)UILabel *typeLab;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UILabel *tableTypeLab;
@property(nonatomic,weak)UILabel *numOfTableLab;
@property(nonatomic,weak)UIImageView *arrowImgView;
@property(nonatomic,weak)UIButton *shopBtn;
@end

@implementation GetNumberCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab=[UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.height.offset=20;
    }];
    titleLab.textColor=HEX(@"333333", 1.0);
    titleLab.font=FONT(14);
    self.titleLab=titleLab;
    
    UILabel *statusLab=[UILabel new];
    [self.contentView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(titleLab.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    statusLab.textColor=THEME_COLOR;
    statusLab.font=FONT(14);
    self.statusLab=statusLab;
    
    UIButton *shopBtn=[UIButton new];
    [self.contentView addSubview:shopBtn];
    [shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=40;
    }];
    [shopBtn addTarget:self action:@selector(onClickGoShop) forControlEvents:UIControlEventTouchUpInside];
    self.shopBtn=shopBtn;
    
    UILabel *getNumTimeLab=[UILabel new];
    [self.contentView addSubview:getNumTimeLab];
    [getNumTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(titleLab.mas_bottom).offset=20;
        make.height.offset=20;
    }];
    getNumTimeLab.textColor=HEX(@"999999", 1.0);
    getNumTimeLab.font=FONT(12);
    self.getNumTimeLab=getNumTimeLab;
    
    UILabel *timeLab=[UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(getNumTimeLab.mas_bottom).offset=10;
        make.height.offset=20;
    }];
    timeLab.textColor=HEX(@"999999", 1.0);
    timeLab.font=FONT(12);
    self.timeLab=timeLab;
    
    UILabel *numberLab=[UILabel new];
    [self.contentView addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(timeLab.mas_bottom).offset=10;
        make.height.offset=20;
    }];
    numberLab.textColor=HEX(@"999999", 1.0);
    numberLab.font=FONT(12);
    self.numberLab=numberLab;
    
    UILabel *tableTypeLab=[UILabel new];
    [self.contentView addSubview:tableTypeLab];
    [tableTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(numberLab.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    tableTypeLab.textColor=HEX(@"666666", 1.0);
    tableTypeLab.font=FONT(12);
    self.tableTypeLab=tableTypeLab;
    
    UILabel *numOfTableLab=[UILabel new];
    [self.contentView addSubview:numOfTableLab];
    [numOfTableLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.bottom.equalTo(tableTypeLab.mas_top).offset=-5;
        make.height.offset=30;
    }];
    numOfTableLab.textColor=THEME_COLOR;
    numOfTableLab.font=FONT(18);
    self.numOfTableLab=numOfTableLab;
    
    UIView *lineView2=[UIView new];
    [self.contentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(numberLab.mas_bottom).offset=10;
        make.right.offset=-10;
        make.height.offset=0.5;
    }];
    lineView2.backgroundColor=LINE_COLOR;
    
    UILabel *typeLab=[UILabel new];
    [self.contentView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lineView2.mas_bottom).offset=10;
        make.width.offset=30;
        make.height.offset=15;
    }];
    typeLab.layer.cornerRadius=2;
    typeLab.clipsToBounds=YES;
    typeLab.textColor=[UIColor whiteColor];
    typeLab.textAlignment=NSTextAlignmentCenter;
    typeLab.backgroundColor=HEX(@"ff6600", 1.0);
    typeLab.font=FONT(12);
    self.typeLab=typeLab;
    
    UILabel *desLab=[UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLab.mas_right).offset=5;
        make.centerY.equalTo(typeLab.mas_centerY).offset=0;
        make.height.offset=15;
    }];
    desLab.textColor=HEX(@"999999", 1.0);
    desLab.font=FONT(13);
    self.desLab=desLab;
    
    UIImageView *imgView=[UIImageView new];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(titleLab.mas_centerY).offset=0;
        make.width.offset=20;
        make.height.offset=20;
    }];
    imgView.contentMode=UIViewContentModeCenter;
    imgView.image=IMAGE(@"arrow-r copy");
    self.arrowImgView=imgView;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=40;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
}

-(void)reloadCellWithModel:(GetNumberModel *)model is_detail:(BOOL)is_detail show_goShop:(BOOL)is_show{
    NSString *title = [NSString stringWithFormat:@"%@ (号单: %@)",model.shop_detail[@"title"],model.paidui_id];
    self.titleLab.text=title;
    if (is_detail) {
        self.statusLab.hidden=YES;
        self.arrowImgView.hidden=!is_show;
        self.shopBtn.userInteractionEnabled=YES;
        self.getNumTimeLab.text=[NSString stringWithFormat:@"%@ 已取号",[NSString formateDateYear:model.dateline]];
    }else{
        self.statusLab.hidden=NO;
        self.arrowImgView.hidden=YES;
//        NSString *statusStr=@"";
//        switch (model.order_status) {
//            case 0:
//                statusStr=@"已取号";
//                break;
//            case 1:
//                statusStr=@"已取号";
//                break;
//            case -1:
//                statusStr=@"已取消";
//                break;
//                
//            default:
//                break;
//        }
        self.statusLab.text=model.order_status_label;
        self.shopBtn.userInteractionEnabled=NO;
        [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset=50;
        }];
    }
    
    self.timeLab.attributedText=[self getAttStr:[NSString stringWithFormat:NSLocalizedString(@"预计等待  %@", nil),model.wait_time] preStr:NSLocalizedString(@"预计等待", nil)];
    self.numberLab.attributedText=[self getAttStr:[NSString stringWithFormat:NSLocalizedString(@"还需等待  %@桌", nil),model.zhuo_wait_nums] preStr:NSLocalizedString(@"还需等待", nil)];
    self.typeLab.text=@"排队";
    self.desLab.text=@"过号不作废，在现场叫号基础上顺延3桌安排";
    self.tableTypeLab.text=model.zhuohao_detail[@"title"];//@"小桌(午市)";
    self.numOfTableLab.text=model.zhuohao_detail[@"zhuohao_cate_title"];//@"A20";
}

#pragma mark ======商家详情=======
-(void)onClickGoShop{
    if (self.clickGoShopDetail)  self.clickGoShopDetail();
}

-(NSMutableAttributedString *)getAttStr:(NSString *)allStr preStr:(NSString *)preStr{
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:allStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEX(@"333333", 1.0) range:NSMakeRange(preStr.length, allStr.length-preStr.length)];
    return attStr;
}

@end

//
//  SeatCell.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SeatCell.h"
#import "NSString+Tool.h"

@interface SeatCell ()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *statusLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *numberLab;
@property(nonatomic,weak)UILabel *typeLab;
@property(nonatomic,weak)UIImageView *arrowImgView;
@property(nonatomic,weak)UIButton *shopBtn;
@property(nonatomic,weak)UILabel *infoLab;
@end


@implementation SeatCell

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
        make.top.offset=10;
        make.height.offset=20;
    }];
    statusLab.textColor=THEME_COLOR;
    statusLab.font=FONT(14);
    self.statusLab=statusLab;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(self.statusLab.mas_bottom).offset=10;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UILabel *timeLab=[UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lineView.mas_bottom).offset=10;
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
    
    UILabel *infoLab=[UILabel new];
    [self.contentView addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(numberLab.mas_bottom).offset=10;
        make.height.offset=20;
    }];
    infoLab.textColor=HEX(@"333333", 1.0);
    infoLab.font=FONT(12);
    self.infoLab=infoLab;
    
    UIView *lineView2=[UIView new];
    [self.contentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.bottom.offset=-35;
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
    typeLab.backgroundColor=HEX(@"7ed321", 1.0);
    typeLab.font=FONT(12);
    self.typeLab=typeLab;
    
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
 
}

-(void)reloadCellWithModel:(SeatModel *)model is_detail:(BOOL)is_detail show_goShop:(BOOL)is_show{
    NSString *title = [NSString stringWithFormat:@"%@ (订座: %@)",model.shop_detail[@"title"],model.dingzuo_id];
    self.titleLab.text=title;
    if (is_detail) {
        self.statusLab.hidden=YES;
        self.arrowImgView.hidden=!is_show;
        self.shopBtn.userInteractionEnabled=YES;
        self.infoLab.text=[NSString stringWithFormat:@"%@  %@",model.contact,model.mobile];
    }else{
        self.statusLab.hidden=NO;
        self.arrowImgView.hidden=YES;
//        NSString *statusStr=@"";
//        switch (model.order_status) {
//            case 0:
//                statusStr=@"待处理";
//                break;
//            case 1:
//                statusStr=@"订座成功";
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
    }
    
    self.timeLab.attributedText=[self getAttStr:[NSString stringWithFormat:NSLocalizedString(@"到店时间  %@", nil),[NSString formateDateToWeek:model.yuyue_time]] preStr:NSLocalizedString(@"到店时间", nil)];
   
    self.numberLab.attributedText=[self getAttStr:[NSString stringWithFormat:NSLocalizedString(@"就餐人数  %@人 %@", nil),model.yuyue_number,model.zhuohao_detail[@"title"]] preStr:NSLocalizedString(@"就餐人数", nil)];
    self.typeLab.text=@"订座";
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

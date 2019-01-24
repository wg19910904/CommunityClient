//
//  JHNeighbourCell.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHNeighbourCell.h"
#import "YFButton.h"
#import "ShowImgsView.h"
#import <UIButton+WebCache.h>
#import "NSString+Tool.h"

#define Img_Margin 15

@interface JHNeighbourCell ()
@property(nonatomic,weak)UIButton *iconBtn;
@property(nonatomic,weak)UILabel *nameLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *typeLab;
@property(nonatomic,weak)UILabel *contentLab;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UIView *desLineView;
@property(nonatomic,weak)YFButton *locationBtn;
@property(nonatomic,weak)YFButton *viewBtn;
@property(nonatomic,weak)YFButton *supportBtn;
@property(nonatomic,weak)YFButton *commentBtn;
@property(nonatomic,strong)ShowImgsView *showImgsView;
@property(nonatomic,weak)UILabel *moneyLab;
@end

@implementation JHNeighbourCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
 
    UIButton *iconBtn=[UIButton new];
    [self.contentView addSubview:iconBtn];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=15;
        make.top.offset=15;
        make.width.offset=40;
        make.height.offset=40;
    }];
    self.iconBtn=iconBtn;
    
    UILabel *moneyLab=[UILabel new];
    [self.contentView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-15;
        make.centerY.equalTo(iconBtn.mas_centerY).offset=0;
        make.width.offset=WIDTH-20;
        make.height.offset=20;
    }];
    moneyLab.textAlignment=NSTextAlignmentRight;
    moneyLab.textColor=HEX(@"ff3300", 1.0);
    moneyLab.font=FONT(15);
    self.moneyLab=moneyLab;
    
    UILabel *nameLab=[UILabel new];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconBtn.mas_right).offset=15;
        make.top.offset=12;
        make.right.equalTo(self.contentView.mas_right).offset=10;
        make.height.offset=20;
    }];
    nameLab.textColor=HEX(@"333333", 1.0);
    nameLab.font=FONT(15);
    self.nameLab=nameLab;
    
    UILabel *timeLab=[UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconBtn.mas_right).offset=15;
        make.top.equalTo(nameLab.mas_bottom).offset=5;
        make.right.equalTo(self.contentView.mas_right).offset=10;
        make.height.offset=20;
    }];
    timeLab.textColor=HEX(@"999999", 1.0);
    timeLab.font=FONT(13);
    self.timeLab=timeLab;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor=LINE_COLOR;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(timeLab.mas_bottom).offset=15;
        make.width.offset=WIDTH-20;
        make.height.offset=1;
    }];
    
    UILabel *contentLab=[UILabel new];
    [self.contentView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=15;
        make.top.equalTo(lineView.mas_bottom).offset=14;
        make.width.offset=WIDTH-20;
    }];
    contentLab.numberOfLines=0;
    contentLab.textColor=HEX(@"666666", 1.0);
    contentLab.font=FONT(14);
    self.contentLab=contentLab;
    
    UILabel *typeLab=[UILabel new];
    [self.contentView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=15;
        make.top.equalTo(lineView.mas_bottom).offset=10;
        make.width.offset=45;
        make.height.offset=20;
    }];
    typeLab.layer.cornerRadius=4;
    typeLab.clipsToBounds=YES;
    typeLab.textColor=[UIColor whiteColor];
    typeLab.font=FONT(12);
    typeLab.textAlignment=NSTextAlignmentCenter;
    self.typeLab=typeLab;
    
    ShowImgsView *showImgView=[[ShowImgsView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 0)];
    [self.contentView addSubview:showImgView];
    self.showImgsView=showImgView;
    CGFloat imgH=0;
    
    int count=2;//(int)model.photos.count/4+1;
    imgH= (WIDTH-Img_Margin*4)/3.0 * count+Img_Margin*(count+1);
    
    [showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(contentLab.mas_bottom).offset=0;
        make.width.offset=WIDTH;
         make.height.offset=imgH;
    }];
    
    
    UILabel *desLab=[UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=15;
        make.bottom.offset=0;
        make.width.offset=WIDTH-20;
    }];
    desLab.textColor=HEX(@"999999", 1.0);
    desLab.font=FONT(13);
    desLab.numberOfLines=0;
    desLab.lineBreakMode=NSLineBreakByCharWrapping;
    self.desLab=desLab;
    
    UIView *desLine=[UIView new];
    [desLab addSubview:desLine];
    desLine.backgroundColor=LINE_COLOR;
    [desLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=-5;
        make.right.offset=-5;
        make.height.offset=0.5;
    }];
    self.desLineView=desLine;
    
    YFButton *locationBtn=[YFButton new];
    [self.contentView addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=15;
        make.bottom.equalTo(desLab.mas_top).offset=-10;
        make.width.offset=140;
        make.height.offset=25;
    }];
    locationBtn.imgName=@"address";//neighbourhood_address
    locationBtn.titleColor=HEX(@"92b9e1", 1.0);
    locationBtn.titleFont=FONT(12);
    self.locationBtn=locationBtn;
    locationBtn.userInteractionEnabled=NO;
    
    YFButton *commentBtn=[YFButton new];
    [self.contentView addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset=-15;
        make.bottom.equalTo(desLab.mas_top).offset=-10;
        make.width.offset=50;
        make.height.offset=25;
    }];
    commentBtn.titleFont=FONT(12);
    commentBtn.imgName=@"neighbourhood_comment";
    commentBtn.titleColor=HEX(@"999999", 1.0);
    commentBtn.adjustImgMargin=4;
    self.commentBtn=commentBtn;
    [commentBtn addTarget:self action:@selector(clickCommentBtn) forControlEvents:UIControlEventTouchUpInside];
    
    YFButton *supportBtn=[YFButton new];
    [self.contentView addSubview:supportBtn];
    [supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(commentBtn.mas_left).offset=-5;
        make.bottom.equalTo(desLab.mas_top).offset=-10;
        make.width.offset=50;
        make.height.offset=25;
    }];
    supportBtn.titleFont=FONT(12);
    supportBtn.imgName=@"neighbourhood_support";
    supportBtn.titleColor=HEX(@"999999", 1.0);
    self.supportBtn=supportBtn;
    [supportBtn addTarget:self action:@selector(clickSupportBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    YFButton *viewBtn=[YFButton new];
    [self.contentView addSubview:viewBtn];
    [viewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(supportBtn.mas_left).offset=-5;
        make.bottom.equalTo(desLab.mas_top).offset=-10;
        make.width.offset=50;
        make.height.offset=25;
    }];
    viewBtn.titleFont=FONT(12);
    viewBtn.imgName=@"neighbourhood_see";
    viewBtn.titleColor=HEX(@"999999", 1.0);
    self.viewBtn=viewBtn;
    viewBtn.userInteractionEnabled=NO;
    
}

#pragma mark ======点赞=======
-(void)clickSupportBtn{
    if (self.clickSupport)   self.clickSupport();
}

#pragma mark ======点击评论=======
-(void)clickCommentBtn{
    if (self.clickComment)   self.clickComment();
}

-(void)reloadCellWithModel:(NeighbourModel *)model is_showDes:(BOOL)is_show{
    
    NSString *url=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.member[@"face"]];
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:IMAGE(@"evaluationheader")];
    
    self.nameLab.text=model.member[@"nickname"];
    //self.timeLab.text= [NSString distanceTimeFormNow:model.dateline];
    self.timeLab.text = model.dateline_label;
    NSString *type=@"邻里圈";
    NSString *color=@"ff6600";
    self.moneyLab.hidden=YES;
    BOOL is_ershou=NO;
    if ([model.from isEqualToString:@"trade"]) {
        type=@"二手";
        color=@"ffb54c";
        is_ershou=YES;
        self.moneyLab.hidden=NO;
        self.moneyLab.text=[NSString stringWithFormat:@"¥ %@",model.price];
        
    }
    self.typeLab.text=type;
    self.typeLab.backgroundColor=HEX(color, 1.0);
    //详情隐藏
    self.typeLab.hidden=is_show;
    
    NSString *contentStr;
    if (is_show) {
        if (is_ershou)  contentStr= [NSString stringWithFormat:@"%@",model.title];
        else  contentStr= [NSString stringWithFormat:@"%@",model.content];
    }else contentStr= [NSString stringWithFormat:@"             %@",model.content];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:5.0];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    self.contentLab.attributedText = attributedString;
    [self.contentLab sizeToFit];

    self.showImgsView.imgsArr=model.photos;
    if (model.photos.count>0) {
        self.showImgsView.hidden=NO;
//        CGFloat imgH=0;
//        
//        int count=2;//(int)model.photos.count/4+1;
//        imgH= (WIDTH-Img_Margin*4)/3.0 * count+Img_Margin*(count+1);
//        
//        [self.showImgsView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.offset=imgH;
//        }];
    }else{
//        [self.showImgsView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.offset=0;
//        }];
        self.showImgsView.hidden=YES;
    }

    self.desLineView.hidden=YES;
    self.desLab.hidden=YES;
    
     if(is_ershou && is_show){
        self.desLineView.hidden=NO;
        self.desLab.hidden=NO;
        self.desLab.attributedText=[self getDesStr:model.content];
        [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset=-10;
        }];
     }else if (!is_show) {
         [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
             make.bottom.offset=0;
         }];
     }
    
    
    self.locationBtn.titleStr=model.xiaoqu_title;
    self.viewBtn.titleStr=model.views;
    self.supportBtn.titleStr=model.likes;
    self.commentBtn.titleStr=model.replys;;
    
}

-(NSMutableAttributedString *)getDesStr:(NSString *)str{
    NSString *desStr=[NSString stringWithFormat:NSLocalizedString(@"宝贝简介: %@", nil),str];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:desStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEX(@"333333", 1.0) range:NSMakeRange(0, 5)];
    return attStr;
}



@end

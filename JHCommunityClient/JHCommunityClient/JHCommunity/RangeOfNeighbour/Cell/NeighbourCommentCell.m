//
//  NeighbourCommentCell.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "NeighbourCommentCell.h"
#import <UIButton+WebCache.h>
#import "NSString+Tool.h"

@interface NeighbourCommentCell ()
@property(nonatomic,weak)UIButton *iconBtn;
@property(nonatomic,weak)UILabel *nameLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *contentLab;

@end

@implementation NeighbourCommentCell
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
    [iconBtn addTarget:self action:@selector(clickIconBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *nameLab=[UILabel new];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconBtn.mas_right).offset=15;
        make.top.offset=15;
        make.right.equalTo(self.contentView.mas_right).offset=-15;
        make.height.offset=20;
    }];
    nameLab.textColor=HEX(@"999999", 1.0);
    nameLab.font=FONT(15);
    self.nameLab=nameLab;
    
    UILabel *timeLab=[UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-15;
        make.top.offset=15;
        make.left.offset=70;
        make.height.offset=20;
    }];
    timeLab.textAlignment=NSTextAlignmentRight;
    timeLab.font=FONT(13);
    timeLab.textColor=HEX(@"cccccc", 1.0);
    self.timeLab=timeLab;
    
    UILabel *contentLab=[UILabel new];
    [self.contentView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconBtn.mas_right).offset=15;
        make.top.equalTo(nameLab.mas_bottom).offset=10;
        make.right.offset=-15;
        make.bottom.equalTo(self.contentView.mas_bottom).offset=-10;
    }];
    contentLab.numberOfLines=0;
    contentLab.lineBreakMode=NSLineBreakByCharWrapping;
    contentLab.textColor=HEX(@"333333", 1.0);
    contentLab.font=FONT(12);
    self.contentLab=contentLab;
    
}

#pragma mark ======点击头像=======
-(void)clickIconBtn{
    if (self.clickIcon) self.clickIcon();
}

-(void)reloadCellWith:(NeighbourCommentModel *)model{
   
    NSString *url=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.member[@"face"]];
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:IMAGE(@"evaluationheader")];

    if ([model.at_member[@"uid"] intValue]==0) {
        self.nameLab.text=model.member[@"nickname"];
    }else {
        NSString *from=model.member[@"nickname"];
        NSString *to=model.at_member[@"nickname"];
        if (from.length>5)  from=[from substringToIndex:5];
        if (to.length>5)  to=[to substringToIndex:5];
        self.nameLab.text=[NSString stringWithFormat:@"%@ 回复 %@",from,to];
    }
    
    self.timeLab.text=[NSString formateDateMouth:model.dateline];
    self.contentLab.text=model.content;
    
}


@end

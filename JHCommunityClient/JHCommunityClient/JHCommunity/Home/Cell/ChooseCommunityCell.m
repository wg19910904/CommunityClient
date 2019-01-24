//
//  ChooseCommunityCell.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ChooseCommunityCell.h"
#import "JHShareModel.h"
#import "AppDelegate.h"
@interface ChooseCommunityCell()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *houseLab;
@property(nonatomic,weak)UILabel *statusLab;
@property(nonatomic,weak)UIButton *chooseBtn;
@property(nonatomic,weak)UIView *bottomView;
@end

@implementation ChooseCommunityCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
 
    UIButton *chooseBtn=[UIButton new];
    [self.contentView addSubview:chooseBtn];
    [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=15;
        make.width.offset=30;
        make.height.offset=30;
    }];
    self.chooseBtn=chooseBtn;
    [chooseBtn setImage:IMAGE(@"address_choose") forState:UIControlStateSelected];
    [chooseBtn setImage:IMAGE(@"address_2") forState:UIControlStateNormal];
    chooseBtn.userInteractionEnabled=NO;
    
    UILabel *titleLab=[UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chooseBtn.mas_right).offset=10;
        make.top.offset=10;
        make.height.offset=20;
    }];
    titleLab.textColor=HEX(@"333333", 1.0);
    titleLab.font=FONT(15);
    self.titleLab=titleLab;
    
    UILabel *statusLab=[UILabel new];
    [self.contentView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset=10;
        make.top.offset=10;
        make.width.offset=50;
        make.height.offset=16;
    }];
    statusLab.layer.cornerRadius=2;
    statusLab.clipsToBounds=YES;
    statusLab.textAlignment=NSTextAlignmentCenter;
    statusLab.textColor=[UIColor whiteColor];
    statusLab.font=FONT(12);
    self.statusLab=statusLab;
    
    UILabel *houseLab=[UILabel new];
    [self.contentView addSubview:houseLab];
    [houseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chooseBtn.mas_right).offset=10;
        make.top.equalTo(titleLab.mas_bottom).offset=10;
        make.right.equalTo(self.contentView.mas_right).offset=0;
        make.height.offset=20;
    }];
    houseLab.textColor= THEME_COLOR;
    houseLab.font=FONT(12);
    self.houseLab=houseLab;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(houseLab.mas_bottom).offset=10;
        make.width.offset=WIDTH;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UIButton *deleBtn=[UIButton new];
    deleBtn.titleLabel.font=FONT(14);
    [self.contentView addSubview:deleBtn];
    [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(lineView.mas_bottom).offset=0;
        make.width.offset=WIDTH/2.0;
        make.height.offset=30;
    }];
    [deleBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [deleBtn setImage:IMAGE(@"address_delete") forState:UIControlStateNormal];
    [deleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [deleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [deleBtn setTitleColor:HEX(@"999999", 1.0) forState:UIControlStateNormal];
    [deleBtn addTarget:self action:@selector(deleteCommunity) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeBtn=[UIButton new];
    changeBtn.titleLabel.font=FONT(14);
    [self.contentView addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=WIDTH/2.0;
        make.top.equalTo(lineView.mas_bottom).offset=0;
        make.width.offset=WIDTH/2.0;
        make.height.offset=30;
    }];
    [changeBtn setTitle:NSLocalizedString(@"修改", nil) forState:UIControlStateNormal];
    [changeBtn setImage:IMAGE(@"address_alter") forState:UIControlStateNormal];
    [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [changeBtn setTitleColor:HEX(@"999999", 1.0) forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeCommunity) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)reloadCellWithModel:(MineCommunityModel *)model withVC:(JHBaseVC *)vc{
    _vc = vc;
    _model = model;
    self.titleLab.text=[NSString stringWithFormat:@"%@•%@",model.city_name,model.xiaoqu_title];
    if (model.audit==1) {
        self.statusLab.text=@"已认证";
        self.statusLab.backgroundColor=HEX(@"ffb54c", 1.0);    //92b9e1
    }else{
        self.statusLab.text=@"认证中";
        self.statusLab.backgroundColor=HEX(@"92b9e1", 1.0);    //92b9e1
    }
    
    self.houseLab.text = [self getHouseStr:model.house_louhao unit:model.house_danyuan house:model.house_huhao];
    self.layer.masksToBounds=YES;
    
}

-(NSString *)getHouseStr:(NSString *)dong unit:(NSString *)unit house:(NSString *)house{
    
    if (unit.length==0){
        NSString *str=[NSString stringWithFormat:@"%@ %@",dong,house];
//        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:str];
//        [attStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:NSMakeRange(0, dong.length)];
//        [attStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:NSMakeRange(dong.length+2,house.length)];
        return str;
    }else{
        NSString *str=[NSString stringWithFormat:@"%@ %@ %@",dong,unit,house];
//        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:str];
//        [attStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:NSMakeRange(0, dong.length)];
//        [attStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:NSMakeRange(dong.length+2,unit.length)];
//        [attStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:NSMakeRange(str.length-1-house.length,house.length)];
        return str;
    }
}

#pragma mark ======点击事件=======
//删除小区
-(void)deleteCommunity{
    if([[JHShareModel shareModel].communityModel.xiaoqu_id isEqualToString:_model.xiaoqu_id]){
        [self showMsg:NSLocalizedString(@"抱歉,无法删除该小区", nil)];
    }else{
         if (self.deleteAddr)  self.deleteAddr();
    }
   
}

//修改小区
-(void)changeCommunity{
    if([[JHShareModel shareModel].communityModel.xiaoqu_id isEqualToString:_model.xiaoqu_id]){
        [self showMsg:NSLocalizedString(@"抱歉,无法修改该小区", nil)];
    }else {
          if (self.changeAddr)  self.changeAddr();
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.chooseBtn.selected=selected;
}
#pragma mark - 消息提示
- (void)showMsg:(NSString *)msg
{
    UIAlertController * alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [alertViewController addAction:certainAction];
    [_vc presentViewController:alertViewController animated:YES completion:nil];
}
@end

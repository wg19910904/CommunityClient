//
//  JHGetNumberVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGetNumberVC.h"
#import "YFTextField.h"
#import "TitleBtnLeft.h"
#import "JHDetailOfSeatAndNumberVC.h"
#import "HZQChosePickerView.h"
#import "GetNumberModel.h"

@interface JHGetNumberVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HZQChosePickerViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)BOOL is_stop;//暂停取号
@property(nonatomic,assign)BOOL is_setTX;//设置取号提醒
@property(nonatomic,assign)BOOL is_man;
@property(nonatomic,weak)YFTextField *nameField;
@property(nonatomic,weak)YFTextField *phoneField;
@property(nonatomic,weak)TitleBtnLeft *manBtn;
@property(nonatomic,weak)TitleBtnLeft *womenBtn;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,copy)NSString *number;
@property(nonatomic,assign)NSInteger numIndex;
@end

@implementation JHGetNumberVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.navigationItem.title=@"排队取号";
    [self setUpView];
    self.is_man=YES;
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=HEX(@"fafafa", 1.0);
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.is_stop ? 1 : 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.is_stop) return 1;
    return section == 1 ? 2 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[UITableViewCell new];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (self.is_stop) {//暂停取号
        
        if(!self.is_setTX){
            UILabel *lab=[UILabel new];
            [cell.contentView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=10;
                make.top.offset=5;
                make.width.offset=WIDTH-20;
                make.height.offset=20;
            }];
            lab.textAlignment=NSTextAlignmentCenter;
            lab.font=FONT(14);
            lab.textColor=HEX(@"333333", 1.0);
            lab.text=@"该商家当前暂停取号";
        }
        
        CGFloat topMargin=35;
        if (self.is_setTX) topMargin=5;
    
        UIButton *btn=[UIButton new];
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.top.offset=topMargin;
            make.right.offset=-10;
            make.height.offset=40;
        }];
        btn.layer.cornerRadius=4;
        btn.clipsToBounds=YES;
        btn.titleLabel.font=FONT(18);
        btn.selected=self.is_setTX;
        btn.userInteractionEnabled=!self.is_setTX;
        
        [btn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [btn setBackgroundColor:HEX(@"cccccc", 1.0) forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"取号时提醒我", nil) forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"已设置取号提醒", nil) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(onClickSetTX) forControlEvents:UIControlEventTouchUpInside];
        
        TitleBtnLeft *titleBtn=[TitleBtnLeft new];
        [cell.contentView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.top.equalTo(btn.mas_bottom).offset=0;
            make.width.offset=WIDTH-20;
            make.height.offset=20;
        }];
        titleBtn.imgName=@"icon-tips";
        titleBtn.titleStr=@"过号请重新取号,谢谢配合";
        titleBtn.titleFont=FONT(12);
        titleBtn.titleColor=HEX(@"999999", 1.0);
        
    }else{//可以取号
        if (indexPath.section==1 && indexPath.row==1) {
            UIView *lineView=[UIView new];
            [cell.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=0;
                make.top.offset=0;
                make.right.offset=0;
                make.height.offset=0.5;
            }];
            lineView.backgroundColor=LINE_COLOR;
        }
        
        if (indexPath.section==0) {
            TitleBtnLeft *titleBtn=[TitleBtnLeft new];
            [cell.contentView addSubview:titleBtn];
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=10;
                make.top.offset=0;
                make.width.offset=100;
                make.bottom.offset=0;
            }];
            titleBtn.imgName=@"icon-people";
            titleBtn.titleStr=@"人数";
            titleBtn.titleFont=FONT(14);
            titleBtn.titleColor=HEX(@"333333", 1.0);
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *countLab=[UILabel new];
            [cell.contentView addSubview:countLab];
            [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset=0;
                make.right.offset=0;
                make.height.offset=20;
            }];
            countLab.textAlignment=NSTextAlignmentRight;
            countLab.font=FONT(14);
            countLab.textColor=HEX(@"333333", 1.0);
            self.countLab=countLab;
            
        }
        
        if (indexPath.section==1) {
            switch (indexPath.row) {
                case 0:
                {
                    TitleBtnLeft *manBtn=[TitleBtnLeft new];
                    [cell.contentView addSubview:manBtn];
                    [manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.offset=-10;
                        make.top.offset=0;
                        make.width.offset=60;
                        make.bottom.offset=0;
                    }];
                    
                    manBtn.imgName= !self.is_man ? @"icon-select-click" : @"icon-select-default";
                    manBtn.titleStr=@"  女士";
                    manBtn.titleFont=FONT(14);
                    manBtn.titleColor=HEX(@"333333", 1.0);
                    manBtn.tag=100;
                    [manBtn addTarget:self action:@selector(onClickChooseMan:) forControlEvents:UIControlEventTouchUpInside];
                    self.manBtn=manBtn;
                    
                    TitleBtnLeft *womenBtn=[TitleBtnLeft new];
                    [cell.contentView addSubview:womenBtn];
                    [womenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(manBtn.mas_left).offset=-10;
                        make.top.offset=0;
                        make.width.offset=60;
                        make.bottom.offset=0;
                    }];
                    womenBtn.imgName= self.is_man ? @"icon-select-click" : @"icon-select-default";
                    womenBtn.titleStr=@"  先生";
                    womenBtn.titleFont=FONT(14);
                    womenBtn.titleColor=HEX(@"333333", 1.0);
                    womenBtn.tag=101;
                    [womenBtn addTarget:self action:@selector(onClickChooseMan:) forControlEvents:UIControlEventTouchUpInside];
                    self.womenBtn=womenBtn;
                    
                    YFTextField *nameField=[[YFTextField alloc] initWithFrame:FRAME(10, 0, WIDTH-150, 40)];
                    [cell.contentView addSubview:nameField];
                    nameField.placeholdeColor=HEX(@"cccccc", 1.0);
                    nameField.placeholdeFont=14;
                    nameField.font=FONT(14);
                    nameField.delegate=self;
                    nameField.placeholder=@"尊称: 请填写您的姓名";
                    self.nameField=nameField;
                }
                    break;
                    
                default:
                {
                    NSString *str=@"联系电话:";
                    CGFloat w=getSize(str, 20, 14).width;
                    UILabel *lab=[[UILabel alloc] initWithFrame:FRAME(0, 0, w, 20)];
                    lab.font=FONT(14);
                    lab.textColor=HEX(@"333333", 1.0);
                    lab.text=str;
                    
                    YFTextField *phoneField=[[YFTextField alloc] initWithFrame:FRAME(0, 0, WIDTH-20, 40) leftView:lab];
                    [cell.contentView addSubview:phoneField];
                    phoneField.placeholdeColor=HEX(@"cccccc", 1.0);
                    phoneField.placeholdeFont=14;
                    phoneField.font=FONT(14);
                    phoneField.delegate=self;
                    phoneField.placeholder=@" 请填写您的手机号";
                    phoneField.keyboardType=UIKeyboardTypeNumberPad;
                    self.phoneField=phoneField;
                    
                }
                    break;
            }
        }
        
        if (indexPath.section==2) {
            UIButton *btn=[UIButton new];
            [cell.contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=10;
                make.top.offset=5;
                make.right.offset=-10;
                make.height.offset=40;
            }];
            btn.layer.cornerRadius=4;
            btn.clipsToBounds=YES;
            btn.titleLabel.font=FONT(18);
            btn.selected=self.is_setTX;
            btn.userInteractionEnabled=!self.is_setTX;
            [btn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:NSLocalizedString(@"立即取号", nil) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClickGetNumber) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
    
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UILabel *lab=[[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH, 40)];
        lab.textColor=HEX(@"333333", 1.0);
        lab.font=FONT(12);
        lab.text=@"  顾客信息";
        return lab;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==1)  return 40;
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.is_setTX) return 70;
    if (self.is_stop) return 100;
    
    if (indexPath.section==2) return 50;
    return 40;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {//选择人数
        [self.view endEditing:YES];
        [self resignFirstResponder];
        [HZQChosePickerView showChosePeopleNumViewWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40"] withIndex:self.numIndex].delegate=self;
    }
}

#pragma mark ======HZQChosePickerViewDelegate=======
-(void)choseWithText:(NSString*)text withIndex:(NSInteger)num{
    self.number=text;
    self.countLab.text=[NSString stringWithFormat:@"%@ 人",self.number];
    self.numIndex=num;
}

#pragma mark ======按钮点击事件=======
-(void)onClickSetTX{//设置提醒
    if (!self.is_setTX) {
        self.is_setTX=YES;
        [self.tableView reloadData];
    }
}

-(void)onClickChooseMan:(TitleBtnLeft *)btn{//选择男女
    if(btn.tag-100==0){//点击先生
        self.is_man=YES;
        btn.imgName=  @"icon-select-click";
        self.womenBtn.imgName=@"icon-select-default";
        
    }else{//点击女士
        self.is_man=NO;
        btn.imgName=  @"icon-select-click";
        self.manBtn.imgName=@"icon-select-default";
    }
}

-(void)onClickGetNumber{//取号
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
    
    if (self.number.length==0) {
        [self showMsg:NSLocalizedString(@"您还没选择就餐人数", nil)];
        return;
    }
    if ( self.nameField.text.length==0 ) {
        [self showMsg:NSLocalizedString(@"请填写姓名", nil)];
        return;
    }
    if ( self.phoneField.text.length==0 ) {
        [self showMsg:NSLocalizedString(@"您填写联系方式", nil)];
        return;
    }
    
    NSString *name=self.nameField.text;
    if(self.is_man) name=[NSString stringWithFormat:@"%@先生",self.nameField.text];
    else name=[NSString stringWithFormat:@"%@女士",self.nameField.text];
    NSDictionary *infoDic=@{@"shop_id":self.shop_id,@"contact":self.nameField.text,@"mobile":self.phoneField.text,@"paidui_number":self.number};

    HIDE_HUD
    SHOW_HUD
    [GetNumberModel getNumberWithInfo:infoDic block:^(NSString *order_id, NSString *msg) {
        HIDE_HUD
        if (!msg) {
            [self showMsg:NSLocalizedString(@"取号成功!", nil)];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                JHDetailOfSeatAndNumberVC *detail=[[JHDetailOfSeatAndNumberVC alloc] init];
                detail.order_id=order_id;
                [self.navigationController pushViewController:detail animated:YES];
            });
            
        }else  [self showMsg:msg];
        
    }];
    
    
}


#pragma mark - 收起键盘
-(void)touch_BackView{
    [self.view endEditing:YES];
    [self resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
    return  YES;
}

@end

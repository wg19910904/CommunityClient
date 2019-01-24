//
//  JHNewChangePassWordVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/18.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewChangePassWordVC.h"
 
#import "JHNewForgetPasswordVC.h"

@interface JHNewChangePassWordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *_tableView;
    NSArray *titleArr;
    NSArray *textFphArr;
    NSMutableArray *textFieldArr;
    BOOL isshow;
    UIButton *sureB;
}

@end

@implementation JHNewChangePassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title= @"修改密码";
    [self initData];
    [self creatUI];
}
-(void)initData{
    isshow = NO;
    textFieldArr = @[].mutableCopy;
    titleArr = @[@"当前密码",@"新密码",@"确认密码"];
    textFphArr = @[@"请输入当前密码",@"请输入新密码",@"再次输入新密码"];
}
-(void)creatUI{
    
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0,NAVI_HEIGHT, WIDTH, 150) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACK_COLOR;
        _tableView.scrollEnabled = NO;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [_tableView addSubview:thread];
        [self.view addSubview:_tableView];
    }
  
    UILabel *desL = [[UILabel alloc]init];
    [self.view addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset = 10;
        make.left.offset = 20;
        make.width.offset = 200;
        make.height.offset = 20;
    }];
    desL.text = @"密码需为6-18位数字和英文的组合";
    desL.textColor = HEX(@"999999", 1);
    desL.font = FONT(12);
    
    UIButton *forgetB = [[UIButton alloc]init];
    [self.view addSubview:forgetB];
    [forgetB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset = 10;
        make.right.offset = -20;
        make.width.offset = 50;
        make.height.offset = 20;
    }];
    [forgetB setTitle:@"忘记密码" forState:0];
    forgetB.titleLabel.font = FONT(12);
    [forgetB addTarget:self action:@selector(forgrtBClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetB setTitleColor:HEX(@"999999", 1) forState:0];
    
    
    sureB = [[UIButton alloc]init];
    [self.view addSubview:sureB];
    
    [sureB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetB.mas_bottom).offset = 30;
        make.right.offset = -12;
        make.left.offset = 12;
        make.height.offset = 44;
    }];
    sureB.layer.cornerRadius = 2;
    [sureB setTitle:@"完成" forState:0];
    sureB.enabled = NO;
    [sureB setBackgroundColor:HEX(@"cccccc", 1) forState:0];
    [sureB addTarget:self action:@selector(sureBclick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark - 忘记密码
-(void)forgrtBClick{
    JHNewForgetPasswordVC *vc = [[JHNewForgetPasswordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];  
}
#pragma mark - 确定提交按钮
-(void)sureBclick{
    UITextField *f0 = textFieldArr[0];
    UITextField *f1 = textFieldArr[1];
    UITextField *f2 = textFieldArr[2];
    
    if (![f1.text isEqualToString:f2.text]) {
        [self showMsg:@"新密码不一致"];
        return;
    }
    
    [HttpTool postWithAPI:@"client/v3/member/member/updatepasswd" withParams:@{@"old_passwd" : f0.text,@"new_passwd" : f1.text,@"new_passwd2" : f2.text} success:^(id json) {
        if ([json[@"error"] isEqualToString:@"0"]) {
            
            [self showMsg:json[@"message"]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:f2.text forKey:@"password"];
            self.tabBarController.selectedIndex = 4;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            [self showMsg:json[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        [self showNoNetOrBusy:YES];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(20, 15, 80, 25)];
    label.font = FONT(16);
    label.text = titleArr[indexPath.row];
    label.textColor = HEX(@"666666", 1.0f);
    [cell.contentView addSubview:label];
    UITextField * textF = [[UITextField alloc] initWithFrame:FRAME(110, 0, WIDTH-110, 49)];
    textF.textColor = HEX(@"999999", 1.0f);
    textF.placeholder = textFphArr[indexPath.row];
    textF.delegate = self;
    textF.font = FONT(14);
    textF.secureTextEntry = YES;
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.contentView addSubview:textF];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
    thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [cell.contentView addSubview:thread];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [textFieldArr addObject:textF];
    return cell;
}
-(void)textDidChange:(UITextField*)textField{
    
    for (UITextField *field in textFieldArr) {
        isshow = YES;
        if (field.text.length<6) {
            isshow = NO;
            break;
        }
    }
    
    if (isshow) {
        
        [sureB setBackgroundColor:THEME_COLOR forState:0];
        sureB.enabled= YES;
    }else{
        [sureB setBackgroundColor:HEX(@"cccccc", 1) forState:0];
        sureB.enabled= NO;
    }
    
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0){
        return YES;
    }
    if (textField.text.length>=18) {
        return NO;
    }
    return YES;
    
}
@end

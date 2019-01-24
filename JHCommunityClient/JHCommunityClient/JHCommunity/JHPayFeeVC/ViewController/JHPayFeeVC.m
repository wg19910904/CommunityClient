//
//  JHPayFeeVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPayFeeVC.h"
#import "JHPayFeeCell.h"
#import "YFPayTool.h"
#import "CommunityHttpTool.h"
#import "JHForgetPasswordVC.h"
#import "JHPayFeeBillDetailVC.h"
@interface JHPayFeeVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_payTableView;
    UIButton *_payBnt;//立即支付
    NSInteger _indexRow;
    JHPayFeeCell *_lastCell;
    NSString *_strType;//保存选中的支付方法的
    UIControl * control;//创建选择余额支付时的蒙版
    UITextField * textFiled_money;//用来输入余额支付时的密码的
    NSString *_trade_no;//流水号
}
@end

@implementation JHPayFeeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"缴费", nil);
 
    _strType = NSLocalizedString(@"支付宝", nil);
    [self createPayTableView];
}

#pragma mark--===创建支付表视图
- (void)createPayTableView{
    _payBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBnt.frame = FRAME(15, 0, WIDTH - 30, 40);
    [_payBnt setTitle:NSLocalizedString(@"立即缴费", nil) forState:0];
    [_payBnt setTitleColor:[UIColor whiteColor] forState:0];
    _payBnt.titleLabel.font = FONT(16);
    _payBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_payBnt setBackgroundColor:THEME_COLOR forState:0];
    [_payBnt setBackgroundColor:HEX(@"59C181",0.3f) forState:UIControlStateHighlighted];
    [_payBnt setBackgroundColor:HEX(@"59C181",0.3f) forState:UIControlStateSelected];
    [_payBnt addTarget:self action:@selector(clicPayButton) forControlEvents:UIControlEventTouchUpInside];
    _payBnt.layer.cornerRadius = 4.0f;
    _payBnt.clipsToBounds = YES;
    
    _payTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    _payTableView.delegate = self;
    _payTableView.dataSource = self;
    _payTableView.showsVerticalScrollIndicator = NO;
    _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    _payTableView.backgroundView = view;
    [self.view addSubview:_payTableView];
}
#pragma mark--==UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 3;
    else
        return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return NAVI_HEIGHT;
    else
        return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 70;
    else
        return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *identifier = @"payCell";
        JHPayFeeCell *cell = [_payTableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[JHPayFeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.indexPath = indexPath;
        if(indexPath.row == _indexRow){
            cell.selectImg.image = IMAGE(@"pay_select");
            _lastCell = cell;
            
        }else{
             cell.selectImg.image = IMAGE(@"Check_no");
        }
      
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:_payBnt];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        JHPayFeeCell *cell = [_payTableView cellForRowAtIndexPath:indexPath];
        if(_lastCell != nil){
            _lastCell.selectImg.image = IMAGE(@"Check_no");
        }
        cell.selectImg.image = IMAGE(@"pay_select");
        _lastCell = cell;
        _indexRow = indexPath.row;
        switch (_indexRow) {
            case 0:
            {
                _strType = NSLocalizedString(@"支付宝", nil);
            }
                break;
            case 1:
            {
                _strType = NSLocalizedString(@"微信", nil);
            }
                break;
            case 2:
            {
                _strType = NSLocalizedString(@"余额", nil);
            }
                break;
            default:
                break;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [UIView new];
        UILabel *title = [UILabel new];
        title.font = FONT(14);
        title.textColor = HEX(@"191a19", 1.0f);
        title.text = NSLocalizedString(@"需支付", nil);
        [view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.offset = 0;
            make.height.offset = 70;
            make.width.offset = 80;
            
        }];
        UILabel *feeLabel = [UILabel new];
        feeLabel.font = FONT(14);
        feeLabel.textColor = HEX(@"ff3300", 1.0f);
        feeLabel.text = [NSString stringWithFormat:@"¥%@",self.totalMoney];
        feeLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:feeLabel];
        [feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.top.offset = 0;
            make.height.offset = 70;
            make.width.offset = 150;
        }];
        UIView *line = [UIView new];
        line.backgroundColor = LINE_COLOR;
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.size.mas_equalTo(CGSizeMake(WIDTH, 0.5));
            make.bottom.offset = 0;
        }];
        return view;
    }
    return nil;
}

#pragma mark--==立即支付按钮点击事件
- (void)clicPayButton{
    if([_strType isEqualToString:NSLocalizedString(@"支付宝", nil)]){
        NSDictionary * dic = @{@"amount":self.totalMoney,@"code":@"alipay",@"order_id":self.order_id};
        [YFPayTool AlipayApi:@"client/payment/yzbill" params:dic block:^(BOOL success, NSString *errStr) {
            if (success) {
                JHPayFeeBillDetailVC *detail = [[JHPayFeeBillDetailVC alloc] init];
                detail.bill_id = self.order_id;
                [self.navigationController pushViewController:detail animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBillList" object:nil];
            }else{
                [self creatUIAlertControlWithMessage:errStr];
            }
        }];

    }else if([_strType isEqualToString:NSLocalizedString(@"微信", nil)]){
        //微信支付
        NSLog(@"您将要用微信支付");
        NSDictionary * dic = @{@"amount":self.totalMoney,@"code":@"wxpay",@"order_id":self.order_id};
        [YFPayTool WXPayApi:@"client/payment/yzbill" params:dic block:^(BOOL success, NSString *errStr) {
            if (success) {
                JHPayFeeBillDetailVC *detail = [[JHPayFeeBillDetailVC alloc] init];
                detail.bill_id = self.order_id;
                [self.navigationController pushViewController:detail animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBillList" object:nil];
            }else{
                [self creatUIAlertControlWithMessage:errStr];
            }
        }];

    }else{
        //余额支付
        NSLog(@"您将要用余额支付");
//        if (<#condition#>) {
//            <#statements#>
//        }
        
        //获取流水号
        NSDictionary *dic = @{@"order_id":self.order_id,@"code":@"money"};
        //获取trade_no
        [HttpTool postWithAPI:@"client/payment/yzbill" withParams:dic success:^(id json) {
            NSLog(@"json%@",json[@"message"]);
            if([json[@"error"] isEqualToString:@"0"]){
                _trade_no = json[@"data"][@"trade_no"];
                [self creatUIControl];
            }else{
                
                [self showMsg:json[@"message"]];
                
            }
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
            [self creatUIAlertControlWithMessage:error.localizedDescription];
        }];
        //创建蒙版
        
    }
}
#pragma mark - 这是创建蒙版的方法
-(void)creatUIControl{
    if (control == nil) {
        control = [[UIControl alloc]init];
        control.frame = FRAME(0, 0, WIDTH, HEIGHT);
        control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        [self.view addSubview:control];
        [control addTarget:self action:@selector(removeMengban) forControlEvents:UIControlEventTouchUpInside];
        //创建蒙版上的view
        UIView * view = [[UIView alloc]init];
        if(HEIGHT == 480.000000){
            view.frame = FRAME(25, 80, WIDTH - 50, 240);
        }else if (HEIGHT == 568.000000){
            view.frame = FRAME(25, 110, WIDTH - 50, 240);
        }else{
            view.frame = FRAME(25, 150, WIDTH - 50, 240);
        }
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 2;
        view.layer.masksToBounds = YES;
        [control addSubview:view];
        //显示头部提示的
        UILabel * label_title = [[UILabel alloc]init];
        label_title.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        NSString * string = NSLocalizedString(@"请输入支付密码(即登录密码)", nil);
        NSRange range = [string rangeOfString:NSLocalizedString(@"登录密码", nil)];
        NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
        [attribute addAttributes:@{NSForegroundColorAttributeName :[UIColor orangeColor]} range:range];
        label_title.text = string;
        label_title.textAlignment = NSTextAlignmentCenter;
        label_title.font = [UIFont systemFontOfSize:14];
        label_title.attributedText = attribute;
        label_title.frame = FRAME(0, 0,WIDTH - 50, 40);
        [view addSubview:label_title];
        //显示订单编号的
        UILabel * label_code = [[UILabel alloc]init];
        label_code.text = [NSString stringWithFormat:NSLocalizedString(@"订单编号:%@", nil),self.order_id];
        label_code.font = [UIFont systemFontOfSize:12];
        label_code.frame = FRAME(15,50, WIDTH - 80, 20);
        label_code.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [view addSubview:label_code];
        //显示应付金额的
        UILabel * label_money = [[UILabel alloc]init];
        label_money.frame = FRAME(15, 80, WIDTH - 80, 20);
        [view addSubview:label_money];
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"支付金额:%@", nil),self.totalMoney];
        NSRange newRange = [str  rangeOfString:NSLocalizedString(@"支付金额:", nil)];
        NSMutableAttributedString * newAttributed = [[NSMutableAttributedString alloc]initWithString:str];
        [newAttributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:newRange];
        label_money.text = str;
        label_money.textColor = [UIColor redColor];
        label_money.font = [UIFont systemFontOfSize:12];
        label_money.attributedText = newAttributed;
        //输入密码框
        textFiled_money = [[UITextField alloc]init];
        textFiled_money.frame = FRAME(15, 110,  WIDTH - 80, 40);
        textFiled_money.delegate = self;
        textFiled_money.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        textFiled_money.placeholder = NSLocalizedString(@"请输入支付密码", nil);
        textFiled_money.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
        textFiled_money.leftView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0f];
        textFiled_money.leftViewMode = UITextFieldViewModeAlways;
        textFiled_money.font = [UIFont systemFontOfSize:13];
        textFiled_money.layer.cornerRadius = 2;
        textFiled_money.layer.masksToBounds = YES;
        textFiled_money.secureTextEntry = YES;
        [view addSubview:textFiled_money];
        //创建显示忘记密码的按钮
        UIButton * btn_forgt = [[UIButton alloc]init];
        [btn_forgt setTitle:NSLocalizedString(@"忘记密码?", nil) forState:UIControlStateNormal];
        [btn_forgt setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [view addSubview:btn_forgt];
        btn_forgt.titleLabel.font = [UIFont systemFontOfSize:13];
        btn_forgt.frame = FRAME(15, 150, 80, 30);
        [btn_forgt addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchUpInside];
        //创建取消和确定的按钮
        float a = (WIDTH - 95)/2;
        for (int i = 0; i<2; i++){
            UIButton * button = [[UIButton alloc]init];
            button.frame = FRAME(15+(a + 15)*i, 190, a, 40);
            button.layer.cornerRadius = 2;
            button.layer.masksToBounds = YES;
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            if (i == 0) {
                [button setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            }else{
                [button setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = THEME_COLOR;
            }
        }
    }
}
-(void)removeMengban{
    if (textFiled_money.isFirstResponder){
        [textFiled_money resignFirstResponder];
    }else{
        [control removeFromSuperview];
        control = nil;
    }
}
#pragma mark - 这是输入框的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 这是余额支付点击忘记密码调用的方法
-(void)forgetPassWord{
    NSLog(@"这是忘记密码的方法");
    JHForgetPasswordVC * vc = [[JHForgetPasswordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是余额支付点击取消或者确定的方法
-(void)buttonClick:(UIButton *)sender{
    [textFiled_money resignFirstResponder];
    if (sender.tag == 0) {
        [control removeFromSuperview];
        control = nil;
    }else{
        NSLog(@"确定");
        if (textFiled_money.text.length == 0) {
            [self creatUIAlertControlWithMessage:NSLocalizedString(@"请填写支付密码", nil)];
            return;
        }
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:control animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        hud.mode = MBProgressHUDModeIndeterminate;
        NSDictionary * dicc = @{@"amount":self.totalMoney,@"trade_no":_trade_no,@"passwd":textFiled_money.text};
        [CommunityHttpTool postWithAPI:@"client/payment/paymoney" withParams:dicc success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                [MBProgressHUD hideHUDForView:control animated:YES];
                [control removeFromSuperview];
                control = nil;
                JHPayFeeBillDetailVC *detail = [[JHPayFeeBillDetailVC alloc] init];
                detail.bill_id = self.order_id;
                [self.navigationController pushViewController:detail animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBillList" object:nil];
            }else{
                [MBProgressHUD hideHUDForView:control animated:YES];
                [control removeFromSuperview];
                control = nil;
                [self creatUIAlertControlWithMessage:[NSString stringWithFormat:NSLocalizedString(@"支付失败 原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:control animated:YES];
            [control removeFromSuperview];
            control = nil;
            NSLog(@"error%@",error.localizedDescription);
            [self creatUIAlertControlWithMessage:error.localizedDescription];
        }];
    }
}

#pragma mark - 这是警告框的方法
-(void)creatUIAlertControlWithMessage:(NSString *)info{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:info preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

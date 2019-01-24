//
//  JHNewRechargeVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewRechargeVC.h"
#import "JHNewRechargeCell.h"
#import "OnlineCell.h"
 
//#import "AppDelegate.h"
//#import "PayWithAliAndWechat.h"
#import "JHShareModel.h"
#import "YFPayTool.h"

@interface JHNewRechargeVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *moneyArr;
    OnlineCell *_lastCell1;
    OnlineCell *_lastCell2;
    NSArray *dataArr;
    NSString *_str1;//记录充值选项
    NSString *_str2;//记录充值类型,微信或支付宝
    NSInteger _row1;
    NSInteger _row2;
//    PayWithAliAndWechat *payVC;
    NSInteger selectTag;
    
}

@end

@implementation JHNewRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    selectTag =100;
    self.navigationController.navigationBar.hidden =NO;
    self.title = NSLocalizedString(@"在线充值", nil);
    moneyArr = @[].mutableCopy;
    self.view.backgroundColor = BACK_COLOR;

    [self createTableView];
    //获取充值金额数组
    [self getMoney];
}

#pragma mark========创建表视图============
- (void)createTableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [_tableView addSubview:thread];
        
    }
    else
    {
        [_tableView reloadData];
    }
    
}
#pragma mark - 获取金额数组
- (void)getMoney
{
    [HttpTool postWithAPI:@"client/payment/package"
               withParams:@{}
                  success:^(id json) {
                      NSLog(@"client/payment/package--%@",json);
                      dataArr = json[@"data"][@"items"];
                      for (NSDictionary *dic in json[@"data"][@"items"]) {

                          [moneyArr addObject:dic];
                      }
//                      [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                                withRowAnimation:UITableViewRowAnimationNone];
                       [self createTableView];
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                  }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 3;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        NSInteger num = 0;
        if ([[JHShareModel shareModel].payment containsObject:@"alipay"]) {
            num++;
        }
        if ([[JHShareModel shareModel].payment containsObject:@"wxpay"]) {
            num++;
        }
        return num;
    }else{
        return 1;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
    NSString *str = [JHNewRechargeCell getIdentifier];
    JHNewRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[JHNewRechargeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.arr = dataArr;
        cell.clickBlock = ^(NSInteger tag) {
            NSLog(@"%ld",tag);
            selectTag = tag;
             NSLog(@"%ld",selectTag);
        };
    return cell;
    }else if (indexPath.section == 1){
        
        static NSString *identifier = @"cell1";
        OnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[OnlineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.iconImg.frame = FRAME(10, 10, 30, 30);
        cell.titleLabel.frame = FRAME(50, 10, 80, 30);
        cell.img.frame = FRAME(WIDTH - 35, 15, 20, 20);
        cell.titleLabel.font = FONT(14);
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.detailLabel.font = FONT(12);
        cell.detailLabel.textColor = HEX(@"999999", 1.0f);
        switch (indexPath.row) {
            case 0:
            {
                if ([[JHShareModel shareModel].payment containsObject:@"alipay"]) {
                    cell.iconImg.image = IMAGE(@"payWay02");
                    cell.titleLabel.text = NSLocalizedString(@"支付宝", nil);
                    
                }
                
                if ([[JHShareModel shareModel].payment containsObject:@"wxpay"]) {
                    cell.iconImg.image = IMAGE(@"weixin");
                    cell.titleLabel.text = NSLocalizedString(@"微信", nil);
                    
                }
                
            
            }
                break;
            case 1:
            {
//                cell.iconImg.image = IMAGE(@"weixin");
//                cell.titleLabel.text = NSLocalizedString(@"微信", nil);
                cell.iconImg.image = IMAGE(@"payWay02");
                cell.titleLabel.text = NSLocalizedString(@"支付宝", nil);
               
            }
                break;
            default:
            {
                cell.iconImg.image = IMAGE(@"paypal");
                cell.titleLabel.text = NSLocalizedString(@"paypal", nil);
                cell.detailLabel.text = NSLocalizedString(@"", nil);
            }
                break;
        }
        if(_row2 == indexPath.row)
        {
            
            cell.img.image = IMAGE(@"selectCurrent");
            _lastCell2 = cell;
            if([cell.titleLabel.text isEqualToString:NSLocalizedString(@"支付宝", nil)]){
                
                _str2 = @"alipay";
            }else if([cell.titleLabel.text isEqualToString:NSLocalizedString(@"微信", nil)]){
                _str2 = @"wxpay";
            }else{
                _str2 = @"paypal";
            }
        }
        else
        {
            cell.img.image = IMAGE(@"selectDefault");
        }
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [cell addSubview:thread];
        if (indexPath.row == 1){
            thread.hidden = YES;
        }
            
        return cell;
    }else{
        
        UITableViewCell  *cell = [[UITableViewCell alloc] init];
        UIButton *rechargeBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        rechargeBnt.frame = FRAME(10, 0, WIDTH - 20, 40);
        [rechargeBnt setTitle:NSLocalizedString(@"确认充值", nil) forState:UIControlStateNormal];
        [rechargeBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rechargeBnt.layer.cornerRadius = 4.0f;
        rechargeBnt.clipsToBounds = YES;
        rechargeBnt.titleLabel.font = FONT(14);
        [rechargeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [rechargeBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
        [rechargeBnt addTarget:self action:@selector(rechargeBnt) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:rechargeBnt];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACK_COLOR;
        return cell;
    
    }  
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:FRAME(10, 10, 100, 21)];
        detailLabel.font = FONT(15);
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.text = NSLocalizedString(@"    选择充值方式", nil);
        detailLabel.textColor = [UIColor blackColor];

        return detailLabel;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [JHNewRechargeCell getHeight:dataArr];
    }else if(indexPath.section == 1)
    return 50;
    else
        return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 10;
    }
    else if(section == 1)
    {
        return 20;
    }
    else
        return 0.1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
        return 40;
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        if(indexPath.section == 1){
        if(_lastCell2 != nil)
        {
            _lastCell2.img.image = IMAGE(@"selectDefault");
        }
        OnlineCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:1]];
        cell.img.image = IMAGE(@"selectCurrent");
        _lastCell2 = cell;
        if([cell.titleLabel.text isEqualToString:NSLocalizedString(@"支付宝", nil)]){
            _str2 = @"alipay";
        }else if([cell.titleLabel.text isEqualToString:NSLocalizedString(@"微信", nil)]){
            _str2 = @"wxpay";
        }else{
            _str2 = @"paypal";
        }
        _row2 = indexPath.row;
            NSLog(@"%@",_str2);
    }
}
#pragma mark=======确定充值按钮点击事件===========
- (void)rechargeBnt
{
    SHOW_HUD
    
    NSLog(@"确定充值了");
    NSLog(@"str1%@=====str2%@",_str1,_str2);
    NSString *amout_ = dataArr[selectTag -100][@"chong"];
    if([_str2 isEqualToString:@"alipay"])//这是支付宝支付
    {
        NSLog(@"支付宝");
        NSDictionary *dic = @{@"amount":amout_,@"code":_str2};
        [YFPayTool AlipayApi:@"client/payment/money" params:dic block:^(BOOL success, NSString *errStr) {
            HIDE_HUD
            if (success) {
                [self showAlertView:NSLocalizedString(@"恭喜您,充值成功!", nil)];
            }else{
                [self showAlertView:errStr];
            }
        }];
    }
    else if ([_str2 isEqualToString:@"wxpay"])//这是微信支付
    {
        NSLog(@"微信支付");
        
        NSDictionary *dic = @{@"amount":amout_,@"code":_str2};
        [YFPayTool WXPayApi:@"client/payment/money" params:dic block:^(BOOL success, NSString *errStr) {
            HIDE_HUD
            if (success) {
                [self showAlertView:NSLocalizedString(@"恭喜您,充值成功!", nil)];
            }else{
                [self showAlertView:errStr];
            }
        }];
    }else if ([_str2 isEqualToString:@"paypal"]){  //paypal支付
        //paypal
        NSLog(@"您将要用paypal支付");
        NSDictionary *dic = @{@"amount":amout_,@"code":_str2};
        [YFPayTool PayPalPayApi:@"client/payment/money" params:dic presentVC:self block:^(BOOL success, NSString *errStr) {
            HIDE_HUD
            if (success) {
                [self showAlertView:NSLocalizedString(@"恭喜您,充值成功!", nil)];
            }else{
                [self showAlertView:errStr];
            }
        }];
        
    }
    
    
}

#pragma mark=======提示框==========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

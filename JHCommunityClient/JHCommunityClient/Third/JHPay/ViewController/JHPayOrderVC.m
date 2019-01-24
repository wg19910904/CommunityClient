//
//  JHPayOrderVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/31.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHPayOrderVC.h"
#import "JHWaimaiOrderPayHeaderCell.h"
#import "JHWaimaiOrderPayTypeCell.h"
#import "JHWaimaiOrderPayBtnCell.h"
#import "YFPayTool.h"
@interface JHPayOrderVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *imgArr;
    NSArray *titleArr;
    NSInteger selIndex;//选中的索引
}
@property(nonatomic,strong)UITableView *myTableView;//表视图
@property(nonatomic,copy)NSString *pay_code;
@end

@implementation JHPayOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //创建表视图
    [self myTableView];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    _pay_code = @"alipay";
    self.navigationItem.title = NSLocalizedString(@"支付页面", nil);
    imgArr = @[@"payWay01",@"payWay02",@"payWay03"];
    titleArr = @[NSLocalizedString(@"支付宝支付", nil),
                 NSLocalizedString(@"微信支付", nil),
                  NSLocalizedString(@"余额支付", nil),];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
            table.rowHeight = UITableViewAutomaticDimension;
            table.estimatedRowHeight= 100;
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = BACK_COLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            table;
            
        });
    }
    return _myTableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 1;
    }
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *str = @"JHWaimaiOrderPayHeaderCell";
        JHWaimaiOrderPayHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderPayHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.amount = _amount;
        cell.order_id = _order_id;
        return cell;

    }else if (indexPath.section == 2){
        static NSString *str = @"JHWaimaiOrderPayBtnCell";
        JHWaimaiOrderPayBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderPayBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof (self)weakSelf = self;
        [cell setMyBlock:^{
            [weakSelf clickPay];
        }];
        return cell;
    }
    else{
        static NSString *str = @"JHWaimaiOrderPayTypeCell";
        JHWaimaiOrderPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderPayTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeImg = imgArr[indexPath.row];
        cell.title = titleArr[indexPath.row];
        if (indexPath.row == selIndex) {
            cell.rightImg = @"index_selector_enable";
        }else{
            cell.rightImg = @"index_selector_disable";
        }
        if (indexPath.row == imgArr.count - 1) {
            cell.isHid = YES;
        }else{
            cell.isHid = NO;
        }
        return cell;
 
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        selIndex = indexPath.row;
        NSArray *arr = @[@"alipay",@"wxpay",@"money"];
        _pay_code = arr[indexPath.row];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

    }
}
#pragma mark - 这是点击支付的方法
-(void)clickPay{
    
   // SHOW_HUD_INVIEW([UIApplication sharedApplication].keyWindow);
    
    NSDictionary *dic = @{@"order_id":self.order_id,@"code":self.pay_code};
    if ([self.pay_code isEqualToString:@"alipay"]) {
        [YFPayTool AlipayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else if ([self.pay_code isEqualToString:@"wxpay"]){
        [YFPayTool WXPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else{
        [YFPayTool moneyPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }
    
}
// 处理支付结果
-(void)dealWithPayResult:(BOOL)success msg:(NSString *)msg{
    
    //HIDE_HUD_FOR_VIEW([UIApplication sharedApplication].keyWindow);
    [self showToastAlertMessageWithTitle:msg];
    if (success) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YF_SAFE_BLOCK(self.paySuccessBlock,success,nil);
            if (_isDetailVC) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self pushToNextVcWithVcName:_jumpVcStr params:@{@"FromPayVC":@(YES),@"order_id":self.order_id}];
            }
        });
    }
}
@end

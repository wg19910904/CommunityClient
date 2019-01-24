//
//  JHWMPayOrderVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMPayOrderVC.h"
#import "JHWaimaiOrderPayHeaderCell.h"
#import "JHWaimaiOrderPayTypeCell.h"
#import "JHWaimaiOrderPayBtnCell.h"
#import "JHWMPayOrderMoneyCell.h"
#import "YFPayTool.h"
#import "MemberInfoModel.h"
//#import "MineBankModel.h"
#import "JHWaimaiMineViewModel.h"
#import "JHWaiMaiOrderDetailVC.h"//外卖订单详情
#import "JHBuyOrderDetailViewController.h"//买
#import "JHSendOrderDetailVC.h"//送
#import "JHOtherOrderDetailVC.h"//其他
#import "JHPetOrderDetailVC.h"//宠物
#import "JHQueueOrderDetailVC.h"//排队
#import "JHSeatOrderDetailVC.h"//占座
#import "JHHouseOrderDeatailVC.h"//家政
#import "JHUpKeepOrderDetailVC.h"//维修
#import "JHIntegrationOrderDetailVC.h"//积分详情

#import "JHShopHomepageVC.h"
#import "JHTuanGouProductDetailVC.h"
#import "JHGroupOrderDetailVC.h"
#import "JHPrivilegedDetailVC.h"
#import "JHShareModel.h"
#import "JHShowAlert.h"
#import "JHMaidanOrderDetail.h"
@interface JHWMPayOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)NSInteger selIndex;
@property(nonatomic,strong)UITableView *tableView;//表视图
@property(nonatomic,copy)NSString *pay_code;// money 只用余额支付
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)BOOL is_use_money;//使用余额（包含余额不足不包含0）
@property(nonatomic,assign)BOOL is_can_user_other;// 使用其他方式支付（除余额外的方式）
//@property(nonatomic,strong)MineBankModel *bankModel;
@end

@implementation JHWMPayOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.is_contain_money = YES;
    [self tableView];
    [self initData];
    [self getData];
    
}
#pragma mark=====重写导航栏返回按钮=======
- (void)clickBackBtn
{
    //如果clickBackBlock为真,执行
    if (self.clickBackBlock) {
        _clickBackBlock();
    }
    // 是否从我的界面进来的
    BOOL is_comefrom_me = self.tabBarController.selectedIndex == 4;
    
    if(_isBuy){
        JHBuyOrderDetailViewController *buy = [[JHBuyOrderDetailViewController alloc] init];
        buy.order_id = self.order_id;
        
        [self.navigationController pushViewController:buy animated:YES];
    }else if(_isSong){
        JHSendOrderDetailVC *send = [[JHSendOrderDetailVC alloc] init];
        send.order_id = self.order_id;
        
        [self.navigationController pushViewController:send animated:YES];
    }else if (_isSeat){
        JHSeatOrderDetailVC *seat = [[JHSeatOrderDetailVC alloc] init];
        seat.order_id = self.order_id;
        seat.isPayCome = YES;
        [self.navigationController pushViewController:seat animated:YES];
    }else if(_isPaiDui){
        JHQueueOrderDetailVC *queue = [[JHQueueOrderDetailVC alloc] init];
        queue.order_id = self.order_id;
        queue.isPayCome = YES;
        [self.navigationController pushViewController:queue animated:YES];
    }else if (_isPet){
        JHPetOrderDetailVC *pet = [[JHPetOrderDetailVC alloc] init];
        pet.order_id = self.order_id;
        pet.isPayCome = YES;
        [self.navigationController pushViewController:pet animated:YES];
    }else if(_isOther){
        JHOtherOrderDetailVC *other = [[JHOtherOrderDetailVC alloc] init];
        other.order_id = self.order_id;
        other.isPayCome = YES;
        [self.navigationController pushViewController:other animated:YES];
    }else if(_isTuan && !is_comefrom_me && !_isDetailVC){
        JHGroupOrderDetailVC *tuanDeytail = [[JHGroupOrderDetailVC alloc] init];
        tuanDeytail.order_id = self.order_id;
        tuanDeytail.isPayCome = YES;
        [self.navigationController pushViewController:tuanDeytail animated:YES];
    }else if(_isWM && !is_comefrom_me && !_isDetailVC){
        JHWaiMaiOrderDetailVC *waimai = [[JHWaiMaiOrderDetailVC alloc] init];
        waimai.order_id = self.order_id;
        waimai.isPayCome = YES;
        [self.navigationController pushViewController:waimai animated:YES];
    }else if (_isHui){
        NSArray <JHBaseVC *>*vcArray = self.navigationController.viewControllers;
        [vcArray enumerateObjectsUsingBlock:^(JHBaseVC * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[JHShopHomepageVC class]]){
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
    }else if(_isWeiXiu){
        JHUpKeepOrderDetailVC *upKeep = [[JHUpKeepOrderDetailVC alloc] init];
        upKeep.order_id = self.order_id;
        upKeep.isPayCome = YES;
        [self.navigationController pushViewController:upKeep animated:YES];
    }else if(_isHouse){
        JHHouseOrderDeatailVC *house = [[JHHouseOrderDeatailVC alloc] init];
        house.order_id = self.order_id;
        house.isPayCome = YES;
        [self.navigationController pushViewController:house animated:YES];
    }else if(_isIntegration){
        JHIntegrationOrderDetailVC *integration = [[JHIntegrationOrderDetailVC alloc] init];
        integration.isPayCome = YES;
        integration.order_id = self.order_id;
        [self.navigationController pushViewController:integration animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"支付页面", nil);
//    if (IsHaveBankCardPay) {
//        self.dataSource = @[
//                            @{@"title":NSLocalizedString(@"余额支付", nil),@"img":@"payWay03",@"code":@"money"},
//                            @{@"title":NSLocalizedString(@"支付宝支付", nil),@"img":@"payWay01",@"code":@"alipay"},
//                            @{@"title":NSLocalizedString(@"微信支付", nil),@"img":@"payWay02",@"code":@"wxpay"},
//                            @{@"title":NSLocalizedString(@"信用卡支付", nil),@"img":@"payWay04",@"code":@"stripe"}
//                            ];
//    }else{
    self.dataSource = [@[@{@"title":NSLocalizedString(@"余额支付", nil),@"img":@"payWay003",@"code":@"money"}] mutableCopy];
    NSArray *paymentArr = [JHShareModel shareModel].payment;
    //包含支付宝添加支付宝
    if ([paymentArr containsObject:@"alipay"]) {
        [self.dataSource addObject:@{@"title":NSLocalizedString(@"支付宝支付", nil),@"img":@"payWay001",@"code":@"alipay"}];
    }
    //包含微信则添加微信支付
    if ([paymentArr containsObject:@"wxpay"]) {
        [self.dataSource addObject:@{@"title":NSLocalizedString(@"微信支付", nil),@"img":@"payWay002",@"code":@"wxpay"}];
    }
    if (self.dataSource.count > 1) {
        NSDictionary *payment = self.dataSource[1];
        _pay_code = [payment valueForKey:@"code"];
        self.selIndex = 1;
    }
//    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 1;
    }
    return self.dataSource.count;
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
        if (indexPath.row == 0 && self.is_contain_money) {
            static NSString *str = @"JHWMPayOrderMoneyCell";
            JHWMPayOrderMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWMPayOrderMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            [cell relaodCellWith:self.amount];
             __weak typeof(self) weakSelf=self;
            cell.changeStatus =^(BOOL is_money){
                weakSelf.is_use_money = is_money;
                [weakSelf dealWithMoneyPayOrder];
            };
            return cell;
        }else{
            static NSString *str = @"JHWaimaiOrderPayTypeCell";
            JHWaimaiOrderPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaimaiOrderPayTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.isHid = indexPath.row == self.dataSource.count - 1;
            
            NSDictionary *dic = self.dataSource[indexPath.row];
            cell.typeImg = dic[@"img"];
            cell.title   = dic[@"title"];
            if (indexPath.row == _selIndex) {
                cell.rightImg = (self.is_can_user_other || !self.is_contain_money) ? @"index_selector_enable" : @"index_selector_disable";
            }else{
                cell.rightImg = @"index_selector_disable";
            }

            if ([dic[@"code"] isEqualToString:@"stripe"]) {
//                cell.bankCardName = self.bankModel ? self.bankModel.card_name :  NSLocalizedString(@"请选择信用卡", NSStringFromClass([self class]));
            }else{
                cell.bankCardName = @"";
            }
            return cell;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.is_contain_money) {
            if (indexPath.row > 0 && self.is_can_user_other) {
                [self dealPayCodeSelected:indexPath];
            }
        }else{
            [self dealPayCodeSelected:indexPath];
        }
    }
}

-(void)dealPayCodeSelected:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];
//    if ([dic[@"code"] isEqualToString:@"stripe"]) {// 选择信用卡支付
//        __weak typeof(self) weakSelf=self;
//        void(^chooseBank)(MineBankModel *,NSString *) = ^(MineBankModel *model,NSString *msg){
//            if (model) {
//                weakSelf.bankModel = model;
//                weakSelf.selIndex = indexPath.row;
//                weakSelf.pay_code = dic[@"code"];
//                [weakSelf.tableView reloadData];
//            }
//        };
//        [self pushToNextVcWithVcName:@"JHWMBankCardListVC" params:@{@"is_choose":@(YES),@"chooseBank":chooseBank,@"card_id":self.bankModel.card_id}];
//    }else{
        self.selIndex = indexPath.row;
        _pay_code = dic[@"code"];
        [self.tableView reloadData];
//    }
}

#pragma mark ====== Functions =======
// 获取用户信息(主要余额)
-(void)getData{
    dispatch_async(dispatch_get_main_queue(), ^{
        SHOW_HUD
    });
    //获取余额支付后的下一个支付方式
    NSString *paytype = @"";
    if (self.dataSource.count > 1) {
        NSDictionary *payment = self.dataSource[1];
        paytype = [payment valueForKey:@"code"];
    }
    
    [JHWaimaiMineViewModel postToGetUserInfoWithBlock:^(NSString *error) {
        HIDE_HUD
        if (self.is_contain_money) {
            self.is_use_money = [[MemberInfoModel shareModel].money floatValue] > 0;
            _pay_code = ([[MemberInfoModel shareModel].money floatValue] >= [self.amount floatValue]) ? @"money" : paytype;
//            self.selIndex =[[JHUserModel shareJHUserModel].money floatValue] >= [self.amount floatValue] ? 0 :  1;
            self.is_can_user_other = !([_pay_code isEqualToString:@"money"] && self.is_use_money);
        }else{
            self.is_use_money = NO;
            _pay_code = paytype;
            self.selIndex = 1;
        }
        [self.tableView reloadData];
    }];
}

// 使用余额支付的处理
-(void)dealWithMoneyPayOrder{
    if (self.is_use_money) {
        _pay_code = ([[MemberInfoModel shareModel].money floatValue] >= [self.amount floatValue]) ? @"money" : _pay_code;
    }else{
        if (self.dataSource.count>1) {
            _pay_code = self.dataSource[self.selIndex][@"code"];
        }else{
            _pay_code = @"";
        }
    }
    self.is_can_user_other = !([_pay_code isEqualToString:@"money"] && self.is_use_money);
    [self.tableView reloadData];
}

// 这是点击支付的方法
-(void)clickPay{
    if (_pay_code.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择支付方式", nil)];
        return;
    }
//    SHOW_HUD_INVIEW([UIApplication sharedApplication].keyWindow);
    SHOW_HUD
    NSDictionary *dic = @{@"order_id":self.order_id,@"code":self.pay_code,@"use_money":@(@(self.is_use_money).integerValue)};
    
    if ([self.pay_code isEqualToString:@"alipay"]) {
        [YFPayTool AlipayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else if ([self.pay_code isEqualToString:@"wxpay"]){
        [YFPayTool WXPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else if ([self.pay_code isEqualToString:@"money"]){
        [YFPayTool moneyPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }
//    else  if ([self.pay_code isEqualToString:@"stripe"]){
//        dic = @{@"order_id":self.order_id,@"code":self.pay_code,@"use_money":@(self.is_use_money).stringValue,@"card_id":self.bankModel.card_id};
//        [YFPayTool stripePayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
//            [self dealWithPayResult:success msg:errStr];
//        }];
//    }
}

// 处理支付结果
-(void)dealWithPayResult:(BOOL)success msg:(NSString *)msg{
    HIDE_HUD
//    HIDE_HUD_FOR_VIEW([UIApplication sharedApplication].keyWindow);
    [self showToastAlertMessageWithTitle:msg];
    if (success) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YF_SAFE_BLOCK(self.paySuccessBlock,success,nil);
            if (_isDetailVC) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if(_isTuan){
                    JHGroupOrderDetailVC *tuanDeytail = [[JHGroupOrderDetailVC alloc] init];
                    tuanDeytail.order_id = self.order_id;
                    tuanDeytail.isPayCome = YES;
                    [self.navigationController pushViewController:tuanDeytail animated:YES];
                }else if(_isWeiXiu){
                    JHUpKeepOrderDetailVC *upKeep = [[JHUpKeepOrderDetailVC alloc] init];
                    upKeep.order_id = self.order_id;
                    upKeep.isPayCome = YES;
                    [self.navigationController pushViewController:upKeep animated:YES];
                }else if(_isHouse){
                    JHHouseOrderDeatailVC *house = [[JHHouseOrderDeatailVC alloc] init];
                    house.order_id = self.order_id;
                    house.isPayCome = YES;
                    [self.navigationController pushViewController:house animated:YES];
                }else if(_isOrder){
                    [self.navigationController popViewControllerAnimated:YES];
                }else if(_isBuy){
                    JHBuyOrderDetailViewController *buy = [[JHBuyOrderDetailViewController alloc] init];
                    buy.order_id = self.order_id;
                    buy.isPayCome = YES;
                    [self.navigationController pushViewController:buy animated:YES];
                }else if(_isSong){
                    JHSendOrderDetailVC *send = [[JHSendOrderDetailVC alloc] init];
                    send.order_id = self.order_id;
                    send.isPayCome = YES;
                    [self.navigationController pushViewController:send animated:YES];
                }else if (_isSeat){
                    JHSeatOrderDetailVC *seat = [[JHSeatOrderDetailVC alloc] init];
                    seat.order_id = self.order_id;
                    seat.isPayCome = YES;
                    [self.navigationController pushViewController:seat animated:YES];
                }else if(_isPaiDui){
                    JHQueueOrderDetailVC *queue = [[JHQueueOrderDetailVC alloc] init];
                    queue.order_id = self.order_id;
                    queue.isPayCome = YES;
                    [self.navigationController pushViewController:queue animated:YES];
                }else if (_isPet){
                    JHPetOrderDetailVC *pet = [[JHPetOrderDetailVC alloc] init];
                    pet.order_id = self.order_id;
                    pet.isPayCome = YES;
                    [self.navigationController pushViewController:pet animated:YES];
                }else if(_isOther){
                    JHOtherOrderDetailVC *other = [[JHOtherOrderDetailVC alloc] init];
                    other.order_id = self.order_id;
                    other.isPayCome = YES;
                    [self.navigationController pushViewController:other animated:YES];
                }else if(_isWM){
                    JHWaiMaiOrderDetailVC *wm = [[JHWaiMaiOrderDetailVC alloc] init];
                    wm.order_id = self.order_id;
                    wm.isPayCome = YES;
                    [self.navigationController pushViewController:wm animated:YES];
                }else if(_isHui){
//                    JHPrivilegedDetailVC *youhui = [[JHPrivilegedDetailVC alloc] init];
                    JHMaidanOrderDetail *youhui = [[JHMaidanOrderDetail alloc]init];
                    youhui.order_id = self.order_id;
                    [self.navigationController pushViewController:youhui animated:YES];
                }else if (_isIntegration){
                    JHIntegrationOrderDetailVC *integration = [[JHIntegrationOrderDetailVC alloc] init];
                    integration.isPayCome = YES;
                    integration.order_id = self.order_id;
                    [self.navigationController pushViewController:integration animated:YES];
                }
            }
        });
    }
}

#pragma mark ====== 懒加载 =======
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
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
    return _tableView;
}
@end


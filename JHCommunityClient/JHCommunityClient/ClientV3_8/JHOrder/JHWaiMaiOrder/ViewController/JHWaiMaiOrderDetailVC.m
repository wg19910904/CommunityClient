//
//  JHWaiMaiOrderDetailVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWaiMaiOrderDetailVC.h"
#import <MJRefresh.h>
#import "JHAllOrderDetailBottomView.h"
#import "JHWMOrderListHeaderView.h"
#import "NSString+Tool.h"

#import "JHWMOrderDetailStatusCell.h"
#import "JHAllOrderDetailMapCell.h"
#import "JHAllOrderDetailStaffCell.h"
#import "JHWMOrderDetailProductCell.h"
#import "YFLabTableViewCell.h"
#import "JHWMOrderDetailPeiSongInfoCell.h"
#import "JHWMOrderDetailOrderInfoCell.h"

#import "JHOrderInfoModel.h"
#import "JHShowAlert.h"

@interface JHWaiMaiOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,JHOrderStatusActionProtocol>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)JHWaiMaiModel *orderDetailModel;
@property(nonatomic,strong)JHAllOrderDetailBottomView *orderBottomView;
@property(nonatomic,weak)UIButton *tousuBtn;
@end

@implementation JHWaiMaiOrderDetailVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    self.navigationItem.title =  NSLocalizedString(@"订单详情", NSStringFromClass([self class]));
    [self reloadMap];
    [self getOrderDetail];
    
}

-(void)clickBackBtn{
    if(self.tabBarController.selectedIndex == 4){
        JHBaseVC * vc = self.navigationController.viewControllers[1];
        if (self.isPayCome) {
            [self.navigationController popToViewController:vc animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getOrderDetail];
    }];
    
    UIButton *callBtn = [UIButton new];
    [self.view addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.bottom.offset(-150);
        make.width.offset(40);
        make.height.offset(40);
    }];
    [callBtn setImage:IMAGE(@"wm_orderDetail_call") forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(clickCallBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tousuBtn = [UIButton new];
    [self.view addSubview:tousuBtn];
    [tousuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.bottom.offset(-90);
        make.width.offset(40);
        make.height.offset(40);
    }];
    [tousuBtn setImage:IMAGE(@"wm_orderDetail_tousu") forState:UIControlStateNormal];
    [tousuBtn addTarget:self action:@selector(clickTouSuBtn) forControlEvents:UIControlEventTouchUpInside];
    self.tousuBtn = tousuBtn;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.orderDetailModel) return 0;
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if ([self.orderDetailModel.staff[@"staff_id"] isEqualToString:@"0"]) {
                return 1;
            }else if (self.orderDetailModel.show_map){
                return 3;
            }
            return 2;
            break;
        case 1:
            return self.orderDetailModel.products.count + self.orderDetailModel.packageAndSendMoney_arr.count;
            break;
        case 2:
            return self.orderDetailModel.youhui_arr.count;
            break;
        case 3:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     __weak typeof(self) weakSelf=self;
    UITableViewCell *returnCell;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            JHWMOrderDetailStatusCell *cell=  [JHWMOrderDetailStatusCell initWithTableView:tableView reuseIdentifier:@"JHWMOrderDetailStatusCell"];
            cell.statusStr = self.orderDetailModel.order_status_warning;
            cell.pay_left_time = [self.orderDetailModel.limit_time integerValue];
            cell.cancelOrderBlock = ^(BOOL success, NSString *msg) {
                [weakSelf cancleOrderWithOrder_id:weakSelf.orderDetailModel.order_id];
            };
            returnCell = cell;
        }else if (indexPath.row ==1){
            if (self.orderDetailModel.show_map){
                JHAllOrderDetailMapCell *cell=  [JHAllOrderDetailMapCell initWithTableView:tableView reuseIdentifier:@"JHAllOrderDetailMapCell"];
                [cell reloadCellWithModel:self.orderDetailModel];
                returnCell = cell;
            }else{
                JHAllOrderDetailStaffCell *cell = [JHAllOrderDetailStaffCell initWithTableView:tableView reuseIdentifier:@"JHAllOrderDetailStaffCell"];
                [cell reloadCellWithModel:self.orderDetailModel];
                cell.clickCallBlock = ^(BOOL success, NSString *msg) {// 拨打配送员电话
                    [weakSelf showMobile:self.orderDetailModel.staff[@"mobile"]];
                };
                returnCell = cell;
            }
        }else{
            JHAllOrderDetailStaffCell *cell = [JHAllOrderDetailStaffCell initWithTableView:tableView reuseIdentifier:@"JHAllOrderDetailStaffCell"];
            [cell reloadCellWithModel:self.orderDetailModel];
            cell.clickCallBlock = ^(BOOL success, NSString *msg) {// 拨打配送员电话
                [weakSelf showMobile:self.orderDetailModel.staff[@"mobile"]];
            };
            returnCell = cell;
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row < self.orderDetailModel.products.count) {
            JHWMOrderDetailProductCell *cell = [JHWMOrderDetailProductCell initWithTableView:tableView reuseIdentifier:@"JHWMOrderDetailProductCell"];
            NSDictionary *dic = self.orderDetailModel.products[indexPath.row];
            [cell reloadCellWithModel:dic];
            returnCell = cell;
        }else{
            YFLabTableViewCell *cell = [YFLabTableViewCell initWithTableView:tableView reuseIdentifier:@"YFLabTableViewCell"];
            cell.titleLabColor = HEX(@"666666", 1.0);
            cell.rightLabColor = HEX(@"333333", 1.0);
            cell.title_masLeft = 10;
            cell.rightLab_masRight = -10;
            
            NSInteger index = indexPath.row - self.orderDetailModel.products.count;
            NSDictionary *dic = self.orderDetailModel.packageAndSendMoney_arr[index];
            [cell reloadCellWithTitle:dic[@"title"] center:dic[@"center"] right:dic[@"right"]];
            returnCell = cell;
        }
        
    }else if (indexPath.section == 2){
        
        YFLabTableViewCell *cell = [YFLabTableViewCell initWithTableView:tableView reuseIdentifier:@"YFLabTableViewCell"];
        cell.titleLabColor = HEX(@"666666", 1.0);
        cell.rightLabColor = HEX(@"ff0000", 1.0);
        cell.title_masLeft = 10;
        cell.rightLab_masRight = -10;
        
        UIView *lineView = [cell viewWithTag:100];
        if (!lineView) {
            lineView=[UIView new];
            [cell addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=0;
                make.top.offset=0;
                make.right.offset=0;
                make.height.offset=0.5;
            }];
            lineView.tag = 100;
            lineView.backgroundColor=LINE_COLOR;
        }
        lineView.hidden = indexPath.row != 0;
        
        NSDictionary *dic = self.orderDetailModel.youhui_arr[indexPath.row];
        [cell reloadCellWithTitle:dic[@"title"] center:dic[@"center"] right:dic[@"right"]];
        returnCell = cell;
        
    }else if (indexPath.section == 3){
        JHWMOrderDetailPeiSongInfoCell *cell = [JHWMOrderDetailPeiSongInfoCell initWithTableView:tableView reuseIdentifier:@"JHWMOrderDetailPeiSongInfoCell"];
        [cell reloadCellWithInfo:self.orderDetailModel];
        returnCell = cell;
    }else{
        JHWMOrderDetailOrderInfoCell *cell = [JHWMOrderDetailOrderInfoCell initWithTableView:tableView reuseIdentifier:@"JHWMOrderDetailOrderInfoCell"];
        [cell reloadCellWithInfo:self.orderDetailModel];
        returnCell = cell;
    }

    return  returnCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self pushToNextVcWithVcName:@"JHTempWebViewVC" params:@{@"url":self.orderDetailModel.progress_url}];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
         __weak typeof(self) weakSelf=self;
        static NSString *ID=@"JHWMOrderListHeaderView";
        JHWMOrderListHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
        if (!headerView) {
            headerView = [[JHWMOrderListHeaderView alloc] initWithReuseIdentifier:ID];
            headerView.is_detail = YES;
            // 前往商家详情
            headerView.clickShopBlock = ^(BOOL success, NSString *shop_id) {
                [weakSelf pushToNextVcWithVcName:@"JHWaiMaiMainVC" params:@{@"shop_id":weakSelf.orderDetailModel.shop_id}];
            };
            // 展示自提地址
            headerView.clickLocationBlock = ^(BOOL success, NSString *msg) {
                [weakSelf pushToNextVcWithVcName:@"JHPathMapVC"
                                          params:@{@"shopName":weakSelf.orderDetailModel.shop_title,
                                                   @"lat":@(weakSelf.orderDetailModel.o_lat),
                                                   @"lng":@(weakSelf.orderDetailModel.o_lng),
                                                   @"is_hiddenPath":@(YES)}];
            };
        }
        [headerView reloadViewWithModel:self.orderDetailModel];
        return headerView;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=0;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
        
        if (![self.orderDetailModel.pei_type isEqualToString:@"4"]) { // 4 堂食
            UIButton *btn = [UIButton new];
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.offset(10);
                make.width.offset(88);
                make.height.offset(35);
            }];
            btn.layer.cornerRadius=4;
            btn.clipsToBounds=YES;
            btn.layer.borderColor=Orange_COLOR.CGColor;
            btn.layer.borderWidth=1.0;
            btn.titleLabel.font = FONT(13);
            [btn setTitleColor:Orange_COLOR forState:UIControlStateNormal];
            [btn setTitle: NSLocalizedString(@"再来一单", NSStringFromClass([self class])) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickGetOrderAgain) forControlEvents:UIControlEventTouchUpInside];
        }

        UILabel *priceLab = [UILabel new];
        [view addSubview:priceLab];
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.offset(0);
            make.height.offset(20);
        }];
        priceLab.textColor = HEX(@"ff0000", 1.0);
        priceLab.font = FONT(14);
        
        NSString *str = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),self.orderDetailModel.real_pay];
        priceLab.attributedText = [NSString getAttributeString:str dealStr: NSLocalizedString(@"¥", nil) strAttributeDic:@{NSFontAttributeName : FONT(12)}];
        
        UILabel *lab = [UILabel new];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(priceLab.mas_left).offset(-10);
            make.centerY.offset(0);
            make.height.offset(20);
        }];
        lab.textColor = HEX(@"ff0000", 1.0);
        lab.font = FONT(14);
        lab.text =  self.orderDetailModel.pay_status == 0 ? NSLocalizedString(@"需付:", NSStringFromClass([self class])): NSLocalizedString(@"实付:", NSStringFromClass([self class]));
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 ) {
        return 50;
    }
    return (section == 0 || section == 2) ? CGFLOAT_MIN : 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 2 ? 55 : CGFLOAT_MIN;
}

#pragma mark ====== JHOrderStatusActionProtocol =======
// 钱款去向
-(void)moneyDirectionWithOrder_id:(NSString *)order_id tuikuan_url:(NSString *)url{
    [self pushToNextVcWithVcName:@"JHTempWebViewVC" params:@{@"url":url}];
}
// 取消订单
-(void)cancleOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHWaiMaiModel cancelOrderWith:order_id block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            [self getOrderDetail];
        }
        [self showToastAlertMessageWithTitle:msg];
    }];
}
// 去支付
-(void)payOrderWithOrder_id:(NSString *)order_id amount:(NSString *)amount{
    __weak typeof(self) weakSelf=self;
    MsgBlock block = ^(BOOL success, NSString *msg){
        if (success) {
            [weakSelf getOrderDetail];
        }
    };
    [self pushToNextVcWithVcName:@"JHWMPayOrderVC"
                          params:@{@"order_id":order_id,
                                   @"amount":amount,
                                   @"isDetailVC":@(YES),
                                   @"isWM":@(YES),
                                   @"paySuccessBlock":block}];
}
// 退款
-(void)refundOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHWaiMaiModel refundOrderWith:order_id block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            [self getOrderDetail];
        }
        [self showToastAlertMessageWithTitle:msg];
    }];
}
// 查看券码
-(void)viewCodeWithOrder_id:(NSString *)order_id ticket_url:(NSString *)url{
    [self pushToNextVcWithVcName:@"JHTempWebViewVC" params:@{@"url":url}];
}
// 去评价
-(void)commentOrderWithOrder_id:(NSString *)order_id{
    __weak typeof(self) weakSelf=self;
    void (^evaluateSuccess)(void) = ^(){
        [weakSelf getOrderDetail];
    };
    [self pushToNextVcWithVcName:@"JHShopEvaluationVC"
                          params:@{@"order_id":order_id,
                                   @"shopEvaluationSuccess":evaluateSuccess
                                   }];
}
// 再来一单
-(void)againOrderWithOrder:(JHWaiMaiModel *)order{
    
    JHOrderInfoModel * order_model = [JHOrderInfoModel shareModel];
    [order_model addShopProductsWith:order.products
                         withShop_id:order.shop_id];
    
    [self pushToNextVcWithVcName:@"JHPlaceWaimaiOrderVC"
                          params:@{@"shop_id":order.shop_id,
                                   @"isFromAgain":@(YES),
                                   @"amount":@([order.total_price floatValue])}];
}
// 催单
-(void)cuiOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHWaiMaiModel cuiOrderWith:order_id block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            [self getOrderDetail];
        }
        [self showToastAlertMessageWithTitle:msg];
    }];
}
// 确认送达
-(void)confirmOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHWaiMaiModel sureSendedOrderWith:order_id block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            [self getOrderDetail];
        }
        [self showToastAlertMessageWithTitle:msg];
    }];
}
// 查看评价
-(void)viewCommentWithOrder_id:(NSString *)order_id pei_type:(NSString *)pei_type{
    BOOL isZiti = [pei_type isEqualToString:@"3"];
    [self pushToNextVcWithVcName:@"JHSEvalauteVC"
                          params:@{@"order_id":order_id,
                                   @"isZiti":@(isZiti)}];

}

#pragma mark ====== Functions =======
// 获取订单详情
-(void)getOrderDetail{
    
    if (!self.orderDetailModel) {
        [self showEmptyViewWithImgName:@"noMessage" desStr:nil btnTitle:nil inView:self.view];
    }
    SHOW_HUD
    [JHWaiMaiModel getWMOrderDetail:self.order_id block:^(JHWaiMaiModel * model, NSString *msg) {
        HIDE_HUD
        [self.tableView.mj_header endRefreshing];
        if (model) {

            self.orderDetailModel = model;
            [self.tableView reloadData];
            self.orderBottomView.hidden = model.order_button.count == 0;
            self.tableView.height = model.order_button.count == 0 ? (HEIGHT-NAVI_HEIGHT): (HEIGHT-NAVI_HEIGHT - 60);
            [self.orderBottomView reloadViewWith:model];
            
            self.tousuBtn.hidden = self.orderDetailModel.complaint.count == 0;
            [self hiddenEmptyView];
            
        }else [self showToastAlertMessageWithTitle:msg];
    }];
}

// 再来一单
-(void)clickGetOrderAgain{
    [self againOrderWithOrder:self.orderDetailModel];
}

// 打电话
-(void)clickCallBtn{
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *phoneArr = [NSMutableArray array];
    for (NSDictionary *dic in self.orderDetailModel.phones) {
        [titleArr addObject:dic[@"title"]];
        [phoneArr addObject:dic[@"phone"]];
    }
    [JHShowAlert showSheetAlertWithTextArr:titleArr withController:self withClickBlock:^(NSInteger tag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneArr[tag]]]];
    }];
}

// 投诉
-(void)clickTouSuBtn{
    
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *linkArr = [NSMutableArray array];
    for (NSDictionary *dic in self.orderDetailModel.complaint) {
        [titleArr addObject:dic[@"title"]];
        [linkArr addObject:dic[@"link"]];
    }
     __weak typeof(self) weakSelf=self;
    [JHShowAlert showSheetAlertWithTextArr:titleArr withController:self withClickBlock:^(NSInteger tag) {
        [weakSelf pushToNextVcWithVcName:@"JHTempWebViewVC" params:@{@"url":linkArr[tag]}];
    }];
    
}

// 刷新mapView
-(void)reloadMap{
    
    if (self.orderDetailModel.show_map) {
        [self getOrderDetail];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadMap];
    });
}

#pragma mark ====== Lazy Load =======
-(JHAllOrderDetailBottomView *)orderBottomView{
    if (_orderBottomView==nil) {
        _orderBottomView=[[JHAllOrderDetailBottomView alloc] initWithFrame:CGRectZero btnMasRect:JHAllOrderFooterBtnMasRectMake(15, 15, 15, 85, 15)];
        [self.view addSubview:_orderBottomView];
        [_orderBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.offset(-SYSTEM_GESTURE_HEIGHT);
            make.height.offset(60);
        }];
        _orderBottomView.delegate = self;
    }
    return _orderBottomView;
}

@end

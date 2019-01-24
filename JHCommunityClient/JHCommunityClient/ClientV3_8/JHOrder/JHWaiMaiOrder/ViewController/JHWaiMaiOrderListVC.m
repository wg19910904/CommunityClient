//
//  JHWaiMaiOrderListVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWaiMaiOrderListVC.h"
#import "JHWMOrderListCell.h"
#import "JHWMOrderListHeaderView.h"
#import "JHAllOrderTableFooterView.h"
#import <MJRefresh.h>
#import "JHOrderInfoModel.h"

@interface JHWaiMaiOrderListVC ()<UITableViewDelegate,UITableViewDataSource,JHOrderStatusActionProtocol>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@end

@implementation JHWaiMaiOrderListVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setUpView];
    self.page = 1;
    
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - NAVI_HEIGHT - 44) style:UITableViewStyleGrouped];
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=1;
        [weakSelf getData];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getData];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    self.tableView.mj_footer=footer;
    self.tableView.mj_footer.automaticallyHidden=YES;
    
}

#pragma mark ====== UITableViewDelegate,UITableViewDataSource =======
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.dataSource.count;
    if (count == 0) {
        [self showEmptyViewWithImgName:@"noMessage" desStr:nil btnTitle:nil inView:self.view];
    }else{
        [self hiddenEmptyView];
    }
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHWMOrderListCell *cell=[JHWMOrderListCell initWithTableView:tableView reuseIdentifier:@"JHWMOrderListCell"];
    
    JHWaiMaiModel *model = self.dataSource[indexPath.section];
    [cell reloadCellWithModel:model];
    
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JHWaiMaiModel *model = self.dataSource[section];
    static NSString *ID=@"JHWMOrderListHeaderView";
    JHWMOrderListHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerView) {
        headerView = [[JHWMOrderListHeaderView alloc] initWithReuseIdentifier:ID];
         __weak typeof(self) weakSelf=self;
        // 前往商家详情
        headerView.clickShopBlock = ^(BOOL success, NSString *shop_id) {
            [weakSelf pushToNextVcWithVcName:@"JHWaiMaiMainVC" params:@{@"shop_id":shop_id}];
        };
    }
    [headerView reloadViewWithModel:model];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    JHWaiMaiModel *model = self.dataSource[section];
    if (model.order_button.count == 0) return nil;
    
    static NSString *ID=@"JHAllOrderDetailFooterView";
    JHAllOrderTableFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!footerView) {
        footerView = [[JHAllOrderTableFooterView alloc] initWithReuseIdentifier:ID btnMasRect:JHAllOrderFooterBtnMasRectMake(10, 10, 10, 64, 15)];
        footerView.delegate = self;
    }
    [footerView reloadViewWith:model];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    JHWaiMaiModel *model = self.dataSource[section];
    return model.order_button.count == 0 ? CGFLOAT_MIN : 44;
}

// 点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHWaiMaiModel *model = self.dataSource[indexPath.section];
    [self pushToNextVcWithVcName:@"JHWaiMaiOrderDetailVC" params:@{@"order_id":model.order_id}];
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
            [self getData];
        }
        [self showToastAlertMessageWithTitle:msg];
    }];
}
// 去支付
-(void)payOrderWithOrder_id:(NSString *)order_id amount:(NSString *)amount{

    [self pushToNextVcWithVcName:@"JHWMPayOrderVC"
                          params:@{@"order_id":order_id,
                                   @"amount":amount,
                                   @"isWM":@(YES)
                                   }];
}
// 退款
-(void)refundOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHWaiMaiModel refundOrderWith:order_id block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            [self getData];
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

    [self pushToNextVcWithVcName:@"JHShopEvaluationVC"
                          params:@{@"order_id":order_id}];
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
            [self getData];
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
            [self getData];
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
// 界面切换的时候
-(void)viewAppearToDoThing{
    self.page = 1;
    [self getData];
}

// 获取数据
-(void)getData{
    SHOW_HUD_INVIEW(self.view)
    [JHWaiMaiModel getWMOrderList:self.yf_base_index page:self.page block:^(NSArray *arr, NSString *msg) {
        
        HIDE_HUD_FOR_VIEW(self.view)
        [self.tableView.mj_header endRefreshing];
        if (arr) {
            if (self.page == 1) {
                [self.tableView.mj_footer resetNoMoreData];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
            }else{
                if (arr.count == 0) {
                    [self showHaveNoMoreData];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.tableView.mj_footer endRefreshing];
                    [self.dataSource addObjectsFromArray:arr];
                }
            }
            [self.tableView reloadData];
        }else [self showToastAlertMessageWithTitle:msg];
        
    }];
}

#pragma mark ====== Lazy =======
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end


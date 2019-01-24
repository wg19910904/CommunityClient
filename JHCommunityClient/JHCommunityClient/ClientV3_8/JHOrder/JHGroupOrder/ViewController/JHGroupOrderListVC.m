
//
//  JHGroupOrderListVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHGroupOrderListVC.h"
#import "JHGroupOrderListCell.h"
#import "JHAllOrderTableFooterView.h"
#import <MJRefresh.h>

@interface JHGroupOrderListVC ()<UITableViewDelegate,UITableViewDataSource,JHOrderStatusActionProtocol>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@end

@implementation JHGroupOrderListVC

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
    
    static NSString *ID=@"JHGroupOrderListCell";
    JHGroupOrderListCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[JHGroupOrderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    JHGroupOrderModel *order = self.dataSource[indexPath.section];
    [cell reloadCellWithModel:order];
    
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    JHGroupOrderModel *order = self.dataSource[section];
    if (order.order_button.count == 0) return nil;

    static NSString *ID=@"JHAllOrderTableFooterView";
    JHAllOrderTableFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!footerView) {
        footerView = [[JHAllOrderTableFooterView alloc] initWithReuseIdentifier:ID btnMasRect:JHAllOrderFooterBtnMasRectMake(10, 10, 10, 64, 15)];
        footerView.delegate = self;
        
        UIView *lineView=[UIView new];
        [footerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=0;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
    }
    
    [footerView reloadViewWith:order];
    return footerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    JHGroupOrderModel *order = self.dataSource[section];
    return order.order_button.count == 0 ? CGFLOAT_MIN : 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

// 点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHGroupOrderModel *model = self.dataSource[indexPath.section];
    [self pushToNextVcWithVcName:@"JHGroupOrderDetailVC" params:@{@"order_id":model.order_id}];
}

#pragma mark ====== JHOrderStatusActionProtocol =======
// 钱款去向
-(void)moneyDirectionWithOrder_id:(NSString *)order_id tuikuan_url:(NSString *)url{
    [self pushToNextVcWithVcName:@"JHTempWebViewVC" params:@{@"url":url}];
}
// 取消订单
-(void)cancleOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHGroupOrderModel cancelOrderWith:order_id block:^(BOOL success, NSString *msg) {
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
                                   @"isTuan":@(YES)}];
    
}

// 退款
-(void)refundOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHGroupOrderModel refundOrderWith:order_id block:^(BOOL success, NSString *msg) {
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
    
    [self pushToNextVcWithVcName:@"JHPersonEvaluationVC"
                          params:@{@"order_id":order_id,
                                   @"isTuan":@(YES)}];
    
}

// 查看评价
-(void)viewCommentWithOrder_id:(NSString *)order_id pei_type:(NSString *)pei_type{
    [self pushToNextVcWithVcName:@"JHPEvaluateVC" params:@{@"order_id":order_id,@"isTuan":@(YES)}];
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
    [JHGroupOrderModel getGroupOrderList:self.yf_base_index page:self.page block:^(NSArray *arr, NSString *msg) {
        
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

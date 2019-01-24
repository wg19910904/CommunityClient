//
//  JHIntegrationOrderVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//积分商城订单

#import "JHIntegrationOrderListVC.h"
#import "MJRefresh.h"
 
#import "JHIntegrationOrderListCell.h"
#import "JHIntegrationOrderDetailVC.h"
#import "JHIntegrationCancelMengBan.h"
#import "JHWMPayOrderVC.h"
#import "JHIntegrationOrderListModel.h"
#import "TransformTime.h"
#import "JHShowAlert.h"
@interface JHIntegrationOrderListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_integrationOrderListTableView;
    MJRefreshNormalHeader *_header;
    MJRefreshAutoNormalFooter *_footer;
    NSInteger _page;
    NSMutableArray *_dataArray;
    UIImageView *_backImg;
    
}
@end

@implementation JHIntegrationOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"商城订单", nil);
    _dataArray = @[].mutableCopy;
    [self loadNewData];
}
#pragma mark-===创建订单列表的表视图
- (void)createIntegrationOrderListTableView{
    if(_integrationOrderListTableView == nil){
        _integrationOrderListTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _integrationOrderListTableView.delegate = self;
        _integrationOrderListTableView.dataSource = self;
        _integrationOrderListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [UIView new];
        view.backgroundColor = BACK_COLOR;
        _backImg = [UIImageView new];
        [view addSubview:_backImg];
        _backImg.frame = FRAME(100, NAVI_HEIGHT, WIDTH - 200, (WIDTH - 200) / 1.4);
        _integrationOrderListTableView.backgroundView = view;
        _integrationOrderListTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_integrationOrderListTableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _integrationOrderListTableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _integrationOrderListTableView.mj_footer = _footer;
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
    }else{
        [_integrationOrderListTableView reloadData];
    }
}
#pragma mark-=====请求第一页数据
- (void)loadNewData{
    SHOW_HUD
    _page = 1;
    [HttpTool postWithAPI:@"client/mall/order/items" withParams:@{@"page":@(_page)} success:^(id json) {
        NSLog(@"json%@",json);
        HIDE_HUD
        if([json[@"error"] isEqualToString:@"0"]){
            [_dataArray removeAllObjects];
            NSArray *items =  json[@"data"][@"items"];
            for(NSDictionary *dic in items){
                JHIntegrationOrderListModel *listModel = [[JHIntegrationOrderListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:dic];
                for(NSDictionary *dicc in listModel.product_list){
                    JHIntegrationOrderProductModel *productModel = [[JHIntegrationOrderProductModel alloc] init];
                    [productModel setValuesForKeysWithDictionary:dicc];
                    [listModel.productArray addObject:productModel];
                }
                [_dataArray addObject:listModel];
            }
            [self createIntegrationOrderListTableView];
            if(items.count == 0){
                _backImg.hidden = NO;
                _backImg.image = IMAGE(@"404");
            }else{
                _backImg.hidden = YES;
            }
            _integrationOrderListTableView.mj_footer.userInteractionEnabled = YES;
        }else{
            [_dataArray removeAllObjects];
           [self createIntegrationOrderListTableView];
            _backImg.image = IMAGE(@"none_networkService");
            _integrationOrderListTableView.mj_footer.userInteractionEnabled = NO;
        }
        [_integrationOrderListTableView.mj_header endRefreshing];
        [_integrationOrderListTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_dataArray removeAllObjects];
        [self createIntegrationOrderListTableView];
        _backImg.image = IMAGE(@"none_networkService");
        NSLog(@"%@",error.localizedDescription);
        [_integrationOrderListTableView.mj_header endRefreshing];
        [_integrationOrderListTableView.mj_footer endRefreshing];
        _integrationOrderListTableView.mj_footer.userInteractionEnabled = NO;
    }];
}
#pragma mark-====加载更多数据
- (void)loadMoreData{
    SHOW_HUD
    _page ++;
    [HttpTool postWithAPI:@"client/mall/order/items" withParams:@{@"page":@(_page)} success:^(id json) {
        NSLog(@"json%@",json);
        HIDE_HUD
        if([json[@"error"] isEqualToString:@"0"]){
            NSArray *items = json[@"data"][@"items"];
            if(items.count == 0){
                HIDE_HUD
                [self showHaveNoMoreData];
                [_integrationOrderListTableView.mj_header endRefreshing];
                [_integrationOrderListTableView.mj_footer endRefreshing];
                return ;
            }
            for(NSDictionary *dic in items){
                JHIntegrationOrderListModel *listModel = [[JHIntegrationOrderListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:dic];
                for(NSDictionary *dicc in listModel.product_list){
                    JHIntegrationOrderProductModel *productModel = [[JHIntegrationOrderProductModel alloc] init];
                    [productModel setValuesForKeysWithDictionary:dicc];
                    [listModel.productArray addObject:productModel];
                }
                [_dataArray addObject:listModel];
            }
            [self createIntegrationOrderListTableView];
            
        }else{
           
            [self showNoNetOrBusy:NO];
        }
        [_integrationOrderListTableView.mj_header endRefreshing];
        [_integrationOrderListTableView.mj_footer endRefreshing];
   } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
       [self showNoNetOrBusy:YES];
       [_integrationOrderListTableView.mj_header endRefreshing];
       [_integrationOrderListTableView.mj_footer endRefreshing];
    }];
}
#pragma mark--=====UITableDelegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] productArray].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"integrationListCell";
    JHIntegrationOrderListCell *cell = [_integrationOrderListTableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[JHIntegrationOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    JHIntegrationOrderListModel *listModel = _dataArray[indexPath.section];
    JHIntegrationOrderProductModel *productModel = listModel.productArray[indexPath.row];
    [cell setIntegrationProductModel:productModel];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JHIntegrationOrderListModel *listModel = _dataArray[section];
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:FRAME(0, 10, WIDTH, 40)];
    [view addSubview:statusLabel];
    statusLabel.backgroundColor = [UIColor whiteColor];
    statusLabel.font = FONT(14);
    statusLabel.textColor = HEX(@"333333", 1.0f);
    statusLabel.text = [NSString stringWithFormat:@"  %@-%@",listModel.order_status_label,[TransformTime transfromWithString:listModel.dateline withFormat:@"yyyy-MM-dd HH:mm"]];
    NSMutableAttributedString *statusAttributed = [[NSMutableAttributedString alloc] initWithString:statusLabel.text];
    NSRange range = [statusLabel.text rangeOfString:[NSString stringWithFormat:@"-%@",[TransformTime transfromWithString:listModel.dateline withFormat:@"yyyy-MM-dd HH:mm"]]];
    [statusAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:range];
    [statusAttributed addAttributes:@{NSFontAttributeName:FONT(12)} range:range];
    statusLabel.attributedText = statusAttributed;
    UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
    line.backgroundColor = LINE_COLOR;
    [view addSubview:line];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     JHIntegrationOrderListModel *listModel = _dataArray[section];
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [view addSubview:backView];
    UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
    line.backgroundColor = LINE_COLOR;
    [backView addSubview:line];
    UIButton *payBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:payBnt];
    payBnt.layer.cornerRadius = 4.0f;
    payBnt.clipsToBounds = YES;
    payBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    payBnt.layer.borderColor = HEX(@"ff6600", 1.0f).CGColor;
    payBnt.layer.borderWidth = 0.5f;
    payBnt.titleLabel.font = FONT(14);
    [payBnt setTitle:NSLocalizedString(@"支付订单", nil) forState:UIControlStateNormal];
    [payBnt setTitleColor:HEX(@"ff6600", 1.0f) forState:UIControlStateNormal];
    [payBnt setTitleColor:HEX(@"ff6600", 1.0f) forState:UIControlStateHighlighted];
    [payBnt setTitleColor:HEX(@"ff6600", 1.0f) forState:UIControlStateSelected];
    [payBnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [payBnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [payBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.top.offset = 5;
        make.bottom.offset = -5;
        make.width.offset = 80;
    }];
    payBnt.tag = section + 1;
    [payBnt addTarget:self action:@selector(clickPayButton:) forControlEvents:UIControlEventTouchUpInside];
    if([listModel.pay_status integerValue] == 0){
        //未支付
        payBnt.hidden = NO;
    }
    if([listModel.pay_status integerValue] == 1 || [listModel.order_status integerValue] == -1){
        //已支付
        payBnt.hidden = YES;
    }
    
    UIButton *optionBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:optionBnt];
    optionBnt.layer.cornerRadius = 4.0f;
    optionBnt.clipsToBounds = YES;
    optionBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    optionBnt.layer.borderWidth = 0.5f;
    optionBnt.titleLabel.font = FONT(14);
    [optionBnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [optionBnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [optionBnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    optionBnt.tag = section + 1;
    if(payBnt.hidden){
        //支付按钮隐藏了
        [optionBnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.top.offset = 5;
            make.bottom.offset = -5;
            make.width.offset = 80;
        }];
    }else{
         //支付按钮未隐藏了
        [optionBnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -100;
            make.top.offset = 5;
            make.bottom.offset = -5;
            make.width.offset = 80;
        }];
    }
    optionBnt.enabled = YES;
    optionBnt.backgroundColor = [UIColor whiteColor];
    if ([listModel.order_status integerValue] == -1) {
        [optionBnt setTitle:NSLocalizedString(@"订单已取消", nil) forState:UIControlStateNormal];
        optionBnt.titleLabel.font = FONT(12);
        optionBnt.layer.borderColor = LINE_COLOR.CGColor;
        [optionBnt setTitleColor:HEX(@"545454", 1.0f) forState:UIControlStateNormal];
        [optionBnt setTitleColor:HEX(@"545454", 1.0f) forState:UIControlStateHighlighted];
        [optionBnt setTitleColor:HEX(@"545454", 1.0f) forState:UIControlStateSelected];
        optionBnt.enabled = NO;
        optionBnt.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    }
    if([listModel.order_status integerValue] == 0){
        [optionBnt setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
         optionBnt.layer.borderColor = LINE_COLOR.CGColor;
        [optionBnt setTitleColor:HEX(@"545454", 1.0f) forState:UIControlStateNormal];
        [optionBnt setTitleColor:HEX(@"545454", 1.0f) forState:UIControlStateHighlighted];
        [optionBnt setTitleColor:HEX(@"545454", 1.0f) forState:UIControlStateSelected];
        [optionBnt addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    if([listModel.order_status integerValue] >= 3){
        [optionBnt setTitle:NSLocalizedString(@"确认收货", nil) forState:UIControlStateNormal];
        optionBnt.layer.borderColor = THEME_COLOR.CGColor;
        [optionBnt setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [optionBnt setTitleColor:THEME_COLOR forState:UIControlStateHighlighted];
        [optionBnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [optionBnt addTarget:self action:@selector(clickCertainButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    if([listModel.order_status integerValue] == 8){
        [optionBnt setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateNormal];
        optionBnt.layer.borderColor = LINE_COLOR.CGColor;
        optionBnt.userInteractionEnabled = NO;
        [optionBnt setTitleColor:HEX(@"999999", 1.0f) forState:UIControlStateNormal];
        [optionBnt setTitleColor:HEX(@"999999", 1.0f) forState:UIControlStateHighlighted];
        [optionBnt setTitleColor:HEX(@"999999", 1.0f) forState:UIControlStateSelected];
    }
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHIntegrationOrderDetailVC *detailVC = [[JHIntegrationOrderDetailVC alloc] init];\
    [detailVC setCancelBlock:^{
        [self loadNewData];
    }];
    [detailVC setConfirmBlock:^{
        [_integrationOrderListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    JHIntegrationOrderListModel *listModel = _dataArray[indexPath.section];
    detailVC.order_id = listModel.order_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark--===支付按钮点击事件
- (void)clickPayButton:(UIButton*)sender{
    JHIntegrationOrderListModel *listModel = _dataArray[sender.tag - 1];
    JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
    vc.order_id = listModel.order_id;
    vc.amount = listModel.amount;
    vc.isIntegration = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark-====取消按钮点击事件
- (void)clickCancelButton:(UIButton*)sender{
    JHIntegrationOrderListModel *listModel = _dataArray[sender.tag - 1];
    [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"您确定要取消该订单吗?", nil) withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withCancelBlock:nil withSureBlock:^{
        [self cancleOrder:listModel.order_id];
    }];
   
}
#pragma mark -取消订单调用的接口
-(void)cancleOrder:(NSString *)order_id{
    SHOW_HUD
    NSDictionary *dic = @{@"order_id":order_id,@"reason":@""};
    NSString *api = @"client/mall/order/cancel";
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        HIDE_HUD
        if([json[@"error"] isEqualToString:@"0"]){
            [self loadNewData];
        }else{
           [self showMsg:json[@"error"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showMsg:NSLocalizedString(@"连接网络错误,请稍后再试!", nil)];
        
    }];

}
#pragma mark--====订单确认收货按钮点击事件
- (void)clickCertainButton:(UIButton*)sender{
    SHOW_HUD
    JHIntegrationOrderListModel *listModel = _dataArray[sender.tag - 1];
     __unsafe_unretained typeof(self)weakSelf = self;
    [HttpTool postWithAPI:@"client/mall/order/confirm" withParams:@{@"order_id":listModel.order_id} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
           [weakSelf loadNewData];
        
        }else{
            HIDE_HUD
            [self showNoNetOrBusy:NO];
        }
      
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"erorr%@",error.localizedDescription);
        [self showNoNetOrBusy:YES];
    }];
}
- (void)clickBackBtn{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass(vc.class) isEqualToString:@"JHIntegralMallVC"]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    } 
}
@end

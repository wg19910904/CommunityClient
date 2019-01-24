//
//  JHPayFeeVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//缴费账单

#import "JHPayFeeBillListVC.h"
#import "JHPayFeeBillCell.h"
#import "JHPayFeeBillDetailVC.h"
#import "CommunityHttpTool.h"
#import "MJRefresh.h"
#import "JHShareModel.h"
#import "JHPayFeeBillListModel.h"
@interface JHPayFeeBillListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_payFeeBillTableView;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    UIImageView *_backImg;
    JHShareModel *_shareModel;
    NSInteger _page;//分页
    NSMutableArray *_dataSource;
}
@end

@implementation JHPayFeeBillListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"缴费账单", nil);
    _dataSource = @[].mutableCopy;
    _shareModel = [JHShareModel shareModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"UpdateBillList" object:nil];
    [self loadNewData];
}
#pragma marek--====创建缴费列表表视图==
- (void)createPayFeeTableView{
    if(_payFeeBillTableView == nil){
        _payFeeBillTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _payFeeBillTableView.delegate = self;
        _payFeeBillTableView.dataSource = self;
        _payFeeBillTableView.showsVerticalScrollIndicator = NO;
        _payFeeBillTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BACK_COLOR;
        _payFeeBillTableView.backgroundView = view;
        _backImg = [UIImageView new];
        [view addSubview:_backImg];
        [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(120, 100));
            make.top.offset = 100;
        }];
        [self.view addSubview:_payFeeBillTableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _payFeeBillTableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _payFeeBillTableView.mj_footer = _footer;
    }else{
        [_payFeeBillTableView reloadData];
    }
}
#pragma mark--===请求第一页数据
- (void)loadNewData{
    SHOW_HUD
    _page = 1;
    NSDictionary *dic = @{@"yezhu_id":_shareModel.communityModel.yezhu_id,@"page":@(_page)};
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/bill/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            [_dataSource removeAllObjects];
            NSArray *items = json[@"data"][@"items"];
            for(NSDictionary *dic in items){
                JHPayFeeBillListModel *model = [[JHPayFeeBillListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataSource addObject:model];
            }
            [self createPayFeeTableView];
            if(items.count == 0){
                _backImg.hidden = NO;
                _backImg.image = IMAGE(@"404");
            }else{
                _backImg.hidden = YES;
            }
            _payFeeBillTableView.mj_footer.userInteractionEnabled = YES;
        }else{
            [_dataSource removeAllObjects];
            [self createPayFeeTableView];
            _backImg.hidden = NO;
            _backImg.image = IMAGE(@"none_networkService");
            _payFeeBillTableView.mj_footer.userInteractionEnabled = NO;
        }
        [_payFeeBillTableView.mj_header endRefreshing];
        [_payFeeBillTableView.mj_footer endRefreshing];
         HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [_dataSource removeAllObjects];
        [self createPayFeeTableView];
        _backImg.hidden = NO;
        _backImg.image = IMAGE(@"none_networkService");
        [_payFeeBillTableView.mj_header endRefreshing];
        [_payFeeBillTableView.mj_footer endRefreshing];
    }];
}
#pragma mark-===加载更多数据
- (void)loadMoreData{
    SHOW_HUD
    _page ++;
    NSDictionary *dic = @{@"yezhu_id":_shareModel.communityModel.yezhu_id,@"page":@(_page)};
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/bill/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            NSArray *items = json[@"data"][@"items"];
            if(items.count == 0){
                [self showHaveNoMoreData];
                [_payFeeBillTableView.mj_header endRefreshing];
                [_payFeeBillTableView.mj_footer endRefreshing];
                HIDE_HUD
                return ;
            }
            for(NSDictionary *dic in items){
                JHPayFeeBillListModel *model = [[JHPayFeeBillListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataSource addObject:model];
            }
            [self createPayFeeTableView];
        }else{
            [self showNoNetOrBusy:NO];
        }
        [_payFeeBillTableView.mj_header endRefreshing];
        [_payFeeBillTableView.mj_footer endRefreshing];
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showNoNetOrBusy:YES];
        [_payFeeBillTableView.mj_header endRefreshing];
        [_payFeeBillTableView.mj_footer endRefreshing];
    }];
}
#pragma mark-=====UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"feeCell";
    JHPayFeeBillCell *cell = [_payFeeBillTableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[JHPayFeeBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.payFeeBillListModel = _dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHPayFeeBillDetailVC *detail = [[JHPayFeeBillDetailVC alloc] init];
    detail.bill_id = [_dataSource[indexPath.row] bill_id];
    [self.navigationController pushViewController:detail animated:YES];
}
@end

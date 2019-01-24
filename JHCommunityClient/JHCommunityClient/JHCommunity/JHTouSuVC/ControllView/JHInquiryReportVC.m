//
//  JHInquiryVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//投诉建议查询

#import "JHInquiryReportVC.h"
#import "JHInquiryReportCell.h"
 
#import "MJRefresh.h"
#import "CommunityHttpTool.h"
#import "JHShareModel.h"
#import "JHInquiryReportModel.h"
@interface JHInquiryReportVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_inquiryTableView;
    NSMutableArray *_dataSource;//数据源
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    NSString *_api;//接口
    NSString *_alertApi;
    NSString *_deleteApi;
    NSString *_cancelApi;
    NSInteger _page;
    JHShareModel *_shareModel;
    UIImageView *_noNetImg;
    
}
@end

@implementation JHInquiryReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"查询", nil);
    [self configSubData];
    [self loadNewData];
}
#pragma mark--==初始化相关参数
- (void)configSubData{
    _dataSource = [@[] mutableCopy];
    _shareModel = [JHShareModel shareModel];
    _api = @"client/xiaoqu/report/items";
    _alertApi = @"client/xiaoqu/report/tixing";
    _deleteApi = @"client/xiaoqu/report/delete";
    _cancelApi = @"client/xiaoqu/report/cancel";
}
#pragma mark--===创建查询表视图
- (void)createInquiryTableView{
    if(_inquiryTableView == nil){
        _inquiryTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT , WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _inquiryTableView.showsVerticalScrollIndicator = NO;
        _inquiryTableView.delegate = self;
        _inquiryTableView.dataSource = self;
        _inquiryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BACK_COLOR;
        _inquiryTableView.backgroundView = view;
        _noNetImg = [UIImageView new];
        [view addSubview:_noNetImg];
        [_noNetImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 100));
            make.top.offset = 100;
            make.centerX.equalTo(view);
        }];
        [self.view addSubview:_inquiryTableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _inquiryTableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _inquiryTableView.mj_footer = _footer;
        
    }else{
        [_inquiryTableView reloadData];
    }

}
#pragma mark--===请求第一页数据
- (void)loadNewData{
    SHOW_HUD
    _page = 1;
    NSDictionary *dic= @{@"yezhu_id":_shareModel.communityModel.yezhu_id,@"page":@(_page)};
    [CommunityHttpTool postWithAPI:_api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            [_dataSource removeAllObjects];
            NSArray *items = json[@"data"][@"items"];
            for(NSDictionary *dic in items){
                JHInquiryReportModel *model = [[JHInquiryReportModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataSource addObject:model];
            }
            [self createInquiryTableView];
            if(items.count == 0){
                _noNetImg.hidden = NO;
                _noNetImg.image = IMAGE(@"404");
            }else{
                _noNetImg.hidden = YES;
            }
            _inquiryTableView.mj_footer.userInteractionEnabled = YES;
            HIDE_HUD
        }else{
            HIDE_HUD
            [_dataSource removeAllObjects];
            [self createInquiryTableView];
            _noNetImg.hidden = NO;
            _noNetImg.image = IMAGE(@"none_networkService");
            _inquiryTableView.mj_footer.userInteractionEnabled = NO;
            
        }
        [_inquiryTableView.mj_header endRefreshing];
        [_inquiryTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_dataSource removeAllObjects];
        [self createInquiryTableView];
        _noNetImg.hidden = NO;
        _noNetImg.image = IMAGE(@"none_networkService");
        _inquiryTableView.mj_footer.userInteractionEnabled = NO;
        [_inquiryTableView.mj_header endRefreshing];
        [_inquiryTableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark-===加载更多数据
- (void)loadMoreData{
    SHOW_HUD
    _page ++;
    NSDictionary *dic= @{@"yezhu_id":_shareModel.communityModel.yezhu_id,@"page":@(_page)};
    [CommunityHttpTool postWithAPI:_api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            NSArray *items = json[@"data"][@"items"];
            if(items.count == 0){
                HIDE_HUD
                [self showHaveNoMoreData];
                [_inquiryTableView.mj_header endRefreshing];
                [_inquiryTableView.mj_footer endRefreshing];
                return ;
            }
            for(NSDictionary *dic in items){
                JHInquiryReportModel *model = [[JHInquiryReportModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataSource addObject:model];
            }
            [self createInquiryTableView];
            HIDE_HUD
        }else{
            HIDE_HUD
            [self showNoNetOrBusy:NO];
        }
        [_inquiryTableView.mj_header endRefreshing];
        [_inquiryTableView.mj_footer endRefreshing];
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showNoNetOrBusy:YES];
        [_inquiryTableView.mj_header endRefreshing];
        [_inquiryTableView.mj_footer endRefreshing];
    }];
   
}

#pragma mark--===UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHInquiryReportCell *cell = [[JHInquiryReportCell alloc] init];
    JHInquiryReportModel *model = _dataSource[indexPath.section];
    [cell setInquiryModel:model];
    return [cell getCellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"inquiryReportCell";
    JHInquiryReportCell *cell = [_inquiryTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JHInquiryReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.alertBnt.tag = indexPath.section + 1;
    cell.cancelBnt.tag = indexPath.section + 2;
    cell.deleteBnt.tag = indexPath.section + 3;
    [cell.alertBnt addTarget:self action:@selector(clickAlertButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cancelBnt addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBnt addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell setInquiryModel:_dataSource[indexPath.section]];
    return cell;
}
#pragma mark-=======提醒按钮点击事件
- (void)clickAlertButton:(UIButton *)sender{
    NSLog(@"提醒");
    SHOW_HUD
    NSDictionary *dic = @{@"report_id":[_dataSource[sender.tag - 1] report_id]};
    [CommunityHttpTool postWithAPI:_alertApi withParams:dic success:^(id json) {
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            [self showMsg:NSLocalizedString(@"提醒成功", nil)];
        }else{
          HIDE_HUD
            [self showNoNetOrBusy:NO];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showNoNetOrBusy:YES];
    }];
}
#pragma mark--======撤销按钮点击事件
- (void)clickCancelButton:(UIButton *)sender{
    NSLog(@"撤销");
    SHOW_HUD
    NSDictionary *dic = @{@"report_id":[_dataSource[sender.tag - 2] report_id]};
    [CommunityHttpTool postWithAPI:_cancelApi withParams:dic success:^(id json) {
        if([json[@"error"] isEqualToString:@"0"]){
            [self showMsg:NSLocalizedString(@"撤销成功", nil)];
            HIDE_HUD
            [self loadNewData];
        }else{
            HIDE_HUD
            [self showNoNetOrBusy:NO];
        }

    } failure:^(NSError *error) {
        HIDE_HUD
        [self showNoNetOrBusy:YES];
    }];

}
#pragma mark--========删除按钮点击事件
- (void)clickDeleteButton:(UIButton *)sender{
    NSLog(@"删除");
    SHOW_HUD
    NSDictionary *dic = @{@"report_id":[_dataSource[sender.tag - 3] report_id]};
    [CommunityHttpTool postWithAPI:_deleteApi withParams:dic success:^(id json) {
        if([json[@"error"] isEqualToString:@"0"]){
            [self showMsg:NSLocalizedString(@"删除成功", nil)];
             HIDE_HUD
            [self loadNewData];
        }else{
            HIDE_HUD
            [self showNoNetOrBusy:NO];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showNoNetOrBusy:YES];
    }];

}
@end

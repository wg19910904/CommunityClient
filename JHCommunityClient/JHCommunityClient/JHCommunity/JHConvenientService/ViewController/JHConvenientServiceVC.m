//
//  JHConvenientServiceVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHConvenientServiceVC.h"
#import "JHConvenientServiceCell.h"
#import "JHConvenientServiceModel.h"
#import "JHConvenientServiceDetailVC.h"
#import "CommunityHttpTool.h"
#import "MJRefresh.h"
#import "JHShareModel.h"
#import "JHConvenientServiceModel.h"
#import "JHShareModel.h"
@interface JHConvenientServiceVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSource;
    UITableView *_convenientServiceTableView;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    JHShareModel *_shareModel;
    UIImageView *_noNetImg;
    NSInteger _page;
}
@end

@implementation JHConvenientServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"便民服务", nil);
    _dataSource = [@[] mutableCopy];
    [self loadNewData];
}
#pragma mark--==创建便民服务表视图
- (void)creteConvenientServiceTableView{
    if(_convenientServiceTableView == nil){
        _convenientServiceTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
        _convenientServiceTableView.delegate = self;
        _convenientServiceTableView.dataSource = self;
        _convenientServiceTableView.showsVerticalScrollIndicator = NO;
        _convenientServiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BACK_COLOR;
        _convenientServiceTableView.backgroundView = view;
        _noNetImg = [UIImageView new];
        [view addSubview:_noNetImg];
        [_noNetImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 100;
            make.size.mas_equalTo(CGSizeMake(120, 100));
            make.centerX.equalTo(view);
            
        }];
        [self.view addSubview:_convenientServiceTableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _convenientServiceTableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _convenientServiceTableView.mj_footer = _footer;
    }else{
        [_convenientServiceTableView reloadData];
    }
}
#pragma mark--===请求第一页数据
- (void)loadNewData{
    SHOW_HUD
    _page = 1;
    NSDictionary *dic = @{@"xiaoqu_id":[JHShareModel shareModel].communityModel.xiaoqu_id,@"page":@(_page)};
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/bianmin/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            [_dataSource removeAllObjects];
            NSArray *itemsArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemsArray){
                JHConvenientServiceModel *model = [[JHConvenientServiceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataSource addObject:model];
            }
            [self creteConvenientServiceTableView];
            _convenientServiceTableView.mj_footer.userInteractionEnabled = YES;
            if(itemsArray.count <= 0){
                _noNetImg.hidden = NO;
                _noNetImg.image = IMAGE(@"404");
            }else{
                _noNetImg.hidden = YES;
            }
            HIDE_HUD
        }else{
            HIDE_HUD
            [_dataSource removeAllObjects];
            [self creteConvenientServiceTableView];
            _noNetImg.hidden = NO;
            _noNetImg.image = IMAGE(@"none_networkService");
             _convenientServiceTableView.mj_footer.userInteractionEnabled = NO;
        }
        [_convenientServiceTableView.mj_header endRefreshing];
        [_convenientServiceTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_dataSource removeAllObjects];
        [self creteConvenientServiceTableView];
        _noNetImg.hidden = NO;
        _noNetImg.image = IMAGE(@"none_networkService");
        [_convenientServiceTableView.mj_header endRefreshing];
        [_convenientServiceTableView.mj_footer endRefreshing];
         _convenientServiceTableView.mj_footer.userInteractionEnabled = YES;
    }];
   
}
#pragma mark-===加载更多数据
- (void)loadMoreData{
    SHOW_HUD
    _page ++;
    NSDictionary *dic = @{@"xiaoqu_id":[JHShareModel shareModel].communityModel.xiaoqu_id,@"page":@(_page)};
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/bianmin/items" withParams:dic success:^(id json) {
        if([json[@"error"] isEqualToString:@"0"]){
            NSArray *items = json[@"data"][@"items"];
            if(items.count == 0){
                HIDE_HUD
                [_convenientServiceTableView.mj_header endRefreshing];
                [_convenientServiceTableView.mj_footer endRefreshing];
                [self showHaveNoMoreData];
                return ;
            }
            for(NSDictionary *dic in items){
                JHConvenientServiceModel *model = [[JHConvenientServiceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataSource addObject:model];
            }
            [self creteConvenientServiceTableView];
            HIDE_HUD
        }else{
            HIDE_HUD
            [self showNoNetOrBusy:NO];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showNoNetOrBusy:YES];
        [_convenientServiceTableView.mj_header endRefreshing];
        [_convenientServiceTableView.mj_footer endRefreshing];
  
    }];
}
#pragma mark--===UITableViewDelegate  dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"convenientServiceCell";
    JHConvenientServiceCell *cell = [_convenientServiceTableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[JHConvenientServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setConvenientServiceModel:_dataSource[indexPath.row]];
    [cell.mobileBtn addTarget:self action:@selector(clickMobileButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.mobileBtn.tag = indexPath.row + 1;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHConvenientServiceDetailVC *detailVC = [[JHConvenientServiceDetailVC alloc] init];
    JHConvenientServiceModel *model = _dataSource[indexPath.row];
    detailVC.dataModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
   
}
#pragma mark--==拨打电话
- (void)clickMobileButton:(UIButton *)sender{
    [self showMobile:[_dataSource[sender.tag - 1] phone]];
}
@end

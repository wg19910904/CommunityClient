//
//  JHTuanGouListVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouProductListVC.h"
#import <MJRefresh.h>
#import "JHTuanGouProductDetailVC.h"
 
#import "JHShareModel.h"
#import "JHTuanGouProductListCell.h"
#import "JHTuanGouProductListCellModel.h"
@interface JHTuanGouProductListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHTuanGouProductListVC
{
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    //参数字典
    NSMutableDictionary *paramsDic;
    //数据请求页面
    NSInteger page;
    //保存数据
    NSMutableArray *tuanGouListModeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleString;
    self.view.backgroundColor = BACK_COLOR;
    //创建表视图
    [self createMainTableview];
    //处理第一次请求
    [self handleFirstLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - 处理第一次请求数据
- (void)handleFirstLoad
{
    page = 1;
    paramsDic = [@{@"page":@(page),
                   @"lat":@([JHShareModel shareModel].lat),
                   @"lng":@([JHShareModel shareModel].lng),
                   @"shop_id":_shop_id} mutableCopy];
    [self loadNewData];
    
}
#pragma mark - 创建主表视图
- (void)createMainTableview
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.backgroundColor = BACK_COLOR;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //-----------------刷新和加载更多添加--------------------
        //创建刷新表头
        _headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _headerRefresh.lastUpdatedTimeLabel.hidden = YES;
        [_headerRefresh setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_headerRefresh setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _headerRefresh.stateLabel.textColor = [UIColor colorWithRed:129/255.0
                                                              green:129/255.0
                                                               blue:129/255.0
                                                              alpha:1.0];
        _mainTableView.mj_header = _headerRefresh;
        //创建加载表尾
        _footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadMoreData)];
        [_footerRefresh setTitle:@"" forState:MJRefreshStateIdle];//普通闲置状态
        _mainTableView.mj_footer = _footerRefresh;
        //----------------------------------------------------
        [self.view addSubview:_mainTableView];

    }else{
        [_mainTableView reloadData];
    }
    
}
#pragma mark - 请求新数据
- (void)loadNewData
{
    SHOW_HUD
    //处理参数列表
    page = 1;
    [paramsDic addEntriesFromDictionary:@{@"page":@(page)}];
    [HttpTool postWithAPI:@"client/tuan/goods"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/tuan/goods---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          NSArray *dataArray = json[@"data"][@"items"];
                          if (dataArray.count == 0) {
                              __weak typeof(self)weakSelf = self;
                              [_mainTableView configBlankPageWithType:XHBlankPageHaveNoData withBlock:^{
                                  [weakSelf loadNewData];
                                  
                              }];
                              _mainTableView.mj_footer.userInteractionEnabled = NO;
                          }else{
                          
                              [_mainTableView configBlankPageWithType:XHBlankpageHaveData withBlock:nil];
                              tuanGouListModeArray = [@[] mutableCopy];
                              NSArray *dataArray = json[@"data"][@"items"];
                              for (NSDictionary *dic in dataArray) {
                                  JHTuanGouProductListCellModel *model = [[JHTuanGouProductListCellModel alloc] init];
                                  [model setValuesForKeysWithDictionary:dic];
                                  [tuanGouListModeArray addObject:model];
                              }
                              [_mainTableView reloadData];
                              _mainTableView.mj_footer.userInteractionEnabled = YES;
                              [_headerRefresh endRefreshing];
                          }
                          
                      }else{
                          __weak typeof(self)weakSelf = self;
                          [_mainTableView configBlankPageWithType:XHBlankPageNetError withBlock:^{
                              [weakSelf loadNewData];
                              
                          }];
                          _mainTableView.mj_footer.userInteractionEnabled = NO;
                      }
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      [_headerRefresh endRefreshing];
                      HIDE_HUD
                      __weak typeof(self)weakSelf = self;
                      [_mainTableView configBlankPageWithType:XHBlankPageNetError withBlock:^{
                          [weakSelf loadNewData];
                          
                      }];
                  }];
    [_headerRefresh endRefreshing];
}

#pragma mark - 加载更多数据
- (void)loadMoreData
{
    SHOW_HUD
    //处理参数字典页数
    page++;
    [paramsDic addEntriesFromDictionary:@{@"page":@(page)}];
    //请求
    [HttpTool postWithAPI:@"client/tuan/goods"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/tuan/goods---%@",json);
                      NSArray *dataArray = json[@"data"][@"items"];
                      for (NSDictionary *dic in dataArray) {
                          JHTuanGouProductListCellModel *model = [[JHTuanGouProductListCellModel alloc] init];
                          [model setValuesForKeysWithDictionary:dic];
                          [tuanGouListModeArray addObject:model];
                      }
                      [self createMainTableview];
                      [_footerRefresh endRefreshing];
                      HIDE_HUD
                  } failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      [_footerRefresh endRefreshing];
                      HIDE_HUD
                  }];
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tuanGouListModeArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BACK_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec = indexPath.section;
    static NSString *JHTuanGouProductListCellID = @"JHTuanGouProductListCellID";
    JHTuanGouProductListCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:JHTuanGouProductListCellID];
    if (!cell) {
        cell = [[JHTuanGouProductListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:JHTuanGouProductListCellID];
    }
    cell.dataModel = tuanGouListModeArray[sec];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到团购详情
    JHTuanGouProductDetailVC *vc = [[JHTuanGouProductDetailVC alloc] init];
    JHTuanGouProductListCellModel *model = (JHTuanGouProductListCellModel *)tuanGouListModeArray[indexPath.section];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tuan_id = model.tuan_id;
    vc.shop_id = self.shop_id;
    vc.titleString = _titleString;
    [self.navigationController pushViewController:vc animated:YES];
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

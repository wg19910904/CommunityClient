//
//  JHWaiMaiListVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiListVC.h"
#import "JHWaiMaiSubNavClassifyVC.h"
#import "JHWaiMaiSubNavSortVC.h"
#import "JHWaiMaiSubNavFilterVC.h"
#import "SubNavView.h"
#import <MJRefresh.h>
#import "JHWaiMaiListCell.h"
#import "JHWaiMaiMainVC.h"
 
#import "JHShareModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHWaimaiShopItemModel.h"
#import "JHSupermarketMainVC.h"
@interface JHWaiMaiListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong)JHWaiMaiSubNavClassifyVC *classifyVC;
@property(nonatomic, strong)JHWaiMaiSubNavSortVC *sortVC;
@property(nonatomic, strong)JHWaiMaiSubNavFilterVC *filterVC;
@property(nonatomic, strong)UIButton *classifyBtn;
@property(nonatomic, strong)UIButton *filterBtn;
@property(nonatomic, strong)UIButton *sortBtn;

@end

@implementation JHWaiMaiListVC
{
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    //用来存储转换生成的百度坐标
    double bd_lat;
    double bd_lon;
    //存储当前的页数
    NSInteger page;
    //保存模型数组
    NSMutableArray *waimaiShopModelArray;
    //数据请求参数字典
    NSMutableDictionary *paramsDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"外卖", nil);
    //创建顶部子导航分类条
    [self createSubNav];
    self.view.backgroundColor = BACK_COLOR;
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteNavVC) name:@"JHDeleteNavVCNotificationName" object: nil];
    [self createMainTableView];
    //第一次请求数据
    [self handleFirstLoadData];
}

#pragma mark - 处理第一次请求
- (void)handleFirstLoadData
{
    page = 1;
    paramsDic = [@{@"page":@(1)} mutableCopy];
    [self loadNewData];
}
#pragma mark - 初始化主表视图
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT -(NAVI_HEIGHT+40)) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = BACK_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //-----------------刷新和加载更多添加--------------------
        //创建刷新表头
        _headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _headerRefresh.lastUpdatedTimeLabel.hidden = YES;
        [_headerRefresh setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_headerRefresh setTitle:NSLocalizedString(@"正在为您刷新中", nil) forState:MJRefreshStateRefreshing];
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
    }
}
#pragma mark - 请求新数据
- (void)loadNewData
{
    SHOW_HUD
    NSLog(@"请求新数据");
    page = 1;
    //将本机高德地图转换为百度地图坐标
    [self gaode_to_baidu];
    [paramsDic addEntriesFromDictionary:@{@"page":@(page)}];
    [HttpTool postWithAPI:@"client/waimai/shop/items"
               withParams:paramsDic
                  success:^(id json) {
                      waimaiShopModelArray = [@[] mutableCopy];
                      NSLog(@"client/waimai/shop/items---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          for (NSDictionary *dic in json[@"data"][@"items"]) {
                              JHWaimaiShopItemModel *model = [[JHWaimaiShopItemModel alloc]init];
                              [model setValuesForKeysWithDictionary:dic];
                              [waimaiShopModelArray addObject:model];
                          }
                          _mainTableView.mj_footer.userInteractionEnabled = YES;
                          [_mainTableView reloadData];
                          if ([json[@"data"][@"items"] count] > 0) {
                              [_mainTableView configBlankPageWithType:XHBlankpageHaveData
                                                            withBlock:nil];
                          }else{
                              [_mainTableView configBlankPageWithType:XHBlankPageHaveNoData
                                                            withBlock:^{
                                                                [self loadNewData];
                                                            }];
                          }
                      }else{
                          
                          [_mainTableView configBlankPageWithType:XHBlankPageHaveNoData
                                                        withBlock:^{
                                                            [self loadNewData];
                                                        }];
                          _mainTableView.mj_footer.userInteractionEnabled = NO;
                      }
                      [_headerRefresh endRefreshing];
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      [_headerRefresh endRefreshing];
                      waimaiShopModelArray = [@[] mutableCopy];
                      [_mainTableView reloadData];
                      [_mainTableView configBlankPageWithType:XHBlankPageNetError
                                                    withBlock:^{
                                                        [self loadNewData];
                                                    }];
                      _mainTableView.mj_footer.userInteractionEnabled = NO;
                      HIDE_HUD
                  }];
}
#pragma mark - 加载更多数据
- (void)loadMoreData
{
    SHOW_HUD
    NSLog(@"请求更多数据");
    page++;
    //将本机高德地图转换为百度地图坐标
    [self gaode_to_baidu];
    [paramsDic addEntriesFromDictionary:@{@"page":@(page)}];
    [HttpTool postWithAPI:@"client/waimai/shop/items"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/waimai/shop/items---%@",json);
                      for (NSDictionary *dic in json[@"data"][@"items"]) {
                          JHWaimaiShopItemModel *model = [[JHWaimaiShopItemModel alloc]init];
                          [model setValuesForKeysWithDictionary:dic];
                          [waimaiShopModelArray addObject:model];
                      }
                      [_mainTableView reloadData];
                      [_footerRefresh endRefreshing];
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      [_footerRefresh endRefreshing];
                      waimaiShopModelArray = [@[] mutableCopy];
                      [_mainTableView reloadData];
                      [_mainTableView configBlankPageWithType:XHBlankPageNetError
                                                    withBlock:^{
                                                        [self loadNewData];
                                                    }];
                      _mainTableView.mj_footer.userInteractionEnabled = NO;
                      HIDE_HUD
                  }];
    
}
#pragma mark - 创建顶部子导航分类
- (void)createSubNav
{
    SubNavView *navView = [[SubNavView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH,40)];
    navView.titleArray = @[NSLocalizedString(@"全部分类", nil),NSLocalizedString(@"排序", nil),NSLocalizedString(@"筛选", nil)];
    _classifyBtn = navView.btn0;
    _sortBtn = navView.btn1;
    _filterBtn = navView.btn2;
    [_classifyBtn addTarget:self action:@selector(clickClassifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_sortBtn addTarget:self action:@selector(clickDistanceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_filterBtn addTarget:self action:@selector(clickSortBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
}
#pragma mark - 点击子导航分类按钮
- (void)clickClassifyBtn:(UIButton *)sender
{
    NSLog(@"点击分类按钮");
    if (sender.selected) { //当前为选中状态
        [_classifyVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_classifyVC) {
            _classifyVC = [[JHWaiMaiSubNavClassifyVC alloc] init];
            __weak typeof(self) weakSelf = self;
            _classifyVC.refreshBlock = ^(NSDictionary *paramDic){
                //处理参数
                [weakSelf handleParamsDicWithDic:paramDic];
                //将subNav视图移除
                [weakSelf deleteNavVC];
                //刷新商家列表
                [weakSelf loadNewData];
            };
            _classifyVC.refreshBtnTitleBlock = ^(NSString *btnTitle){
                [weakSelf updateClassifyBtnTitle:btnTitle];
            };
            [self addChildViewController:_classifyVC];
            
        }
        [self.view addSubview:_classifyVC.view];
    }
    sender.selected = !sender.selected;
    _sortBtn.selected = NO;
    _filterBtn.selected = NO;
    [_sortVC.view removeFromSuperview];
    [_filterVC.view removeFromSuperview];
}
#pragma mark - 点击子导航排序按钮
- (void)clickDistanceBtn:(UIButton *)sender
{
    NSLog(@"点击排序按钮");
    if (sender.selected) { //当前为选中状态
        [_sortVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_sortVC) {
            _sortVC = [[JHWaiMaiSubNavSortVC alloc] init];
            __weak typeof(self) weakSelf = self;
            _sortVC.refreshBlock = ^(NSDictionary *paramDic){
                //处理参数
                [weakSelf handleParamsDicWithDic:paramDic];
                //将subNav视图移除
                [weakSelf deleteNavVC];
                //刷新商家列表
                [weakSelf loadNewData];
            };
            _sortVC.refreshBtnTitleBlock = ^(NSString *btnTitle){
                [weakSelf updateSortBtnTitle:btnTitle];
            };
            [self addChildViewController:_sortVC];
        }
        [self.view addSubview:_sortVC.view];
    }
    sender.selected = !sender.selected;
    _classifyBtn.selected = NO;
    _filterBtn.selected = NO;
    [_classifyVC.view removeFromSuperview];
    [_filterVC.view removeFromSuperview];
}
#pragma mark - 点击子导航筛选按钮
- (void)clickSortBtn:(UIButton *)sender
{
    NSLog(@"点击筛选按钮");
    if (sender.selected) { //当前为选中状态
        [_filterVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_filterVC) {
            _filterVC = [[JHWaiMaiSubNavFilterVC alloc] init];
            __weak typeof(self) weakSelf = self;
            _filterVC.refreshBlock = ^(NSDictionary *paramDic){
                //处理参数
                [weakSelf handleParamsDicWithDic:paramDic];
                //将subNav视图移除
                [weakSelf deleteNavVC];
                //刷新商家列表
                [weakSelf loadNewData];
            };
            _filterVC.refreshBtnTitleBlock = ^(NSString *btnTitle){
                [weakSelf updateFilterBtnTitle:btnTitle];
            };
            [self addChildViewController:_filterVC];
        }
        [self.view addSubview:_filterVC.view];
    }
    sender.selected = !sender.selected;
    _classifyBtn.selected = NO;
    _sortBtn.selected = NO;
    [_classifyVC.view removeFromSuperview];
    [_sortVC.view removeFromSuperview];
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return waimaiShopModelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHWaiMaiListCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHWaiMaiListCellID"];
    if (!cell) {
        cell = [[JHWaiMaiListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHWaiMaiListCellID"];
    }
    cell.dataModel = waimaiShopModelArray[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取模型数据
    JHWaimaiShopItemModel *dataModel = (JHWaimaiShopItemModel *)waimaiShopModelArray[indexPath.row];
    NSString *type = dataModel.tmpl_type;
    if ([type isEqualToString:@"waimai"]) {
        //跳转
        JHWaiMaiMainVC *vc = [[JHWaiMaiMainVC alloc] init];
        vc.shop_id = dataModel.shop_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JHSupermarketMainVC *vc = [[JHSupermarketMainVC alloc] init];
        vc.shop_id = dataModel.shop_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}
#pragma mark - 通知移除NavVC的view的方法
- (void)deleteNavVC
{
    [_classifyVC.view removeFromSuperview];
    [_filterVC.view removeFromSuperview];
    [_sortVC.view removeFromSuperview];
    _classifyBtn.selected = NO;
    _filterBtn.selected = NO;
    _sortBtn.selected = NO;
}
#pragma mark - 高德坐标转换为百度坐标
- (void)gaode_to_baidu
{
    //获取当前位置
    JHShareModel *shareModel = [JHShareModel shareModel];
    //在请求前将高德坐标转换为百度坐标
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:shareModel.lat
                                                 WithGD_lon:shareModel.lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    paramsDic[@"lat"] = @(bd_lat);
    paramsDic[@"lng"] = @(bd_lon);
}
#pragma mark - 处理参数字典
- (void)handleParamsDicWithDic:(NSDictionary *)dic
{
    NSString *key = [[dic allKeys] firstObject];
    if ([[paramsDic allKeys] containsObject:key]) {
        [paramsDic removeObjectForKey:key];
    }
    [paramsDic addEntriesFromDictionary:dic];
}
#pragma mark - 更改分类按钮的title
- (void)updateClassifyBtnTitle:(NSString *)btnTitle
{
    [_classifyBtn setTitle:btnTitle forState:(UIControlStateNormal)];
}
#pragma mark - 更改排序按钮的title
- (void)updateSortBtnTitle:(NSString *)btnTitle
{
    [_sortBtn setTitle:btnTitle forState:(UIControlStateNormal)];
}
#pragma mark - 更改筛选按钮的title
- (void)updateFilterBtnTitle:(NSString *)btnTitle
{
    [_filterBtn setTitle:btnTitle forState:(UIControlStateNormal)];
}
#pragma mark -界面消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JHDeleteNavVCNotificationName" object: nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end

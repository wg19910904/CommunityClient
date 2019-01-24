//
//  JHTuanGouListVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouListVC.h"
#import <MJRefresh.h>
#import "JHTuanGouProductListVC.h"
#import "SubNavView.h"
#import "JHSubNavClassifyVC.h"
#import "JHTuanGouSubNavAddressVC.h"
#import "JHTuanGouSubNavSortVC.h"
 
#import "JHShareModel.h"
#import "JHHomePageCell.h"
#import "JHHomePageShopItemModel.h"
#import "GaoDe_Convert_BaiDu.h"
@interface JHTuanGouListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic, strong)UIButton *classifyBtn;
@property(nonatomic,strong)UIButton *distanceBtn;
@property(nonatomic,strong)UIButton *sortBtn;
@property(nonatomic, strong)JHSubNavClassifyVC *classifyVC;
@property(nonatomic, strong)JHTuanGouSubNavAddressVC *distanceVC;
@property(nonatomic, strong)JHTuanGouSubNavSortVC *sortVC;
@end

@implementation JHTuanGouListVC
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
    //记录表视图所需偏移
    CGFloat table_offset;
    
    //
    double bd_lat;
    double bd_lon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"团购", nil);
    self.view.backgroundColor = BACK_COLOR;
    //添加页面内导航栏
    _isFromShopDetailPage ? (table_offset = NAVI_HEIGHT) : ({ [self createSubNav];
                                                     table_offset = NAVI_HEIGHT+40;});
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteNavVC) name:@"JHDeleteNavVCNotificationName" object: nil];
    [self createMainTableview];
    //处理第一次请求
    [self handleFirstLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark--===重新返回按钮
- (void)clickBackBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 创建页面内导航栏
- (void)createSubNav
{

    SubNavView *navView = [[SubNavView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 40)];
    navView.titleArray = @[NSLocalizedString(@"全部", nil),NSLocalizedString(@"附近", nil),NSLocalizedString(@"智能排序", nil)];
    _classifyBtn = navView.btn0;
    _distanceBtn = navView.btn1;
    _sortBtn = navView.btn2;
    [_classifyBtn addTarget:self action:@selector(clickClassifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_distanceBtn addTarget:self action:@selector(clickDistanceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_sortBtn addTarget:self action:@selector(clickSortBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
}
#pragma mark - 处理第一次请求数据
- (void)handleFirstLoad
{
    JHShareModel *shareModel = [JHShareModel shareModel];
    //在请求前将高德坐标转换为百度坐标
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:shareModel.lat
                                                 WithGD_lon:shareModel.lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    page = 1;
    paramsDic = [@{@"page":@(page),
                   @"lat":@(bd_lat),
                   @"lng":@(bd_lon)} mutableCopy];
    [self loadNewData];
}
#pragma mark - 创建主表视图
- (void)createMainTableview
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, table_offset, WIDTH, HEIGHT - table_offset)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.backgroundColor = BACK_COLOR;
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
    JHShareModel *shareModel = [JHShareModel shareModel];
    //在请求前将高德坐标转换为百度坐标
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:shareModel.lat
                                                 WithGD_lon:shareModel.lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    page = 1;
    [paramsDic setObject:@(page) forKey:@"page"];
    [paramsDic setObject:@(bd_lat) forKey:@"lat"];
    [paramsDic setObject:@(bd_lon) forKey:@"lng"];
    SHOW_HUD
    [HttpTool postWithAPI:@"client/tuan/items"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/tuan/items---%@",json);
                      tuanGouListModeArray = [@[] mutableCopy];
                      if ([json[@"error"] isEqualToString:@"0"] ) {
                          NSArray *dataArray = json[@"data"][@"items"];
                          for (NSDictionary *dataDic in dataArray) {
                              JHHomePageShopItemModel *model = [JHHomePageShopItemModel new];
                              [model setValuesForKeysWithDictionary:dataDic];
                              [tuanGouListModeArray addObject:model];
                          }
                          _mainTableView.mj_footer.userInteractionEnabled = YES;
                          [_mainTableView reloadData];
                          if (dataArray.count > 0) {
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
                      tuanGouListModeArray = [@[] mutableCopy];
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

    //处理参数字典页数
    page++;
    [paramsDic addEntriesFromDictionary:@{@"page":@(page)}];
    //请求
    [HttpTool postWithAPI:@"client/tuan/items"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/tuan/items---%@",json);
                      NSArray *dataArray = json[@"data"][@"items"];
                      for (NSDictionary *dataDic in dataArray) {
                          JHHomePageShopItemModel *model = [JHHomePageShopItemModel new];
                          [model setValuesForKeysWithDictionary:dataDic];
                          [tuanGouListModeArray addObject:model];
                      }
                      [self createMainTableview];
                      [_footerRefresh endRefreshing];
       
                  } failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      [_footerRefresh endRefreshing];
                      tuanGouListModeArray = [@[] mutableCopy];
                      [_mainTableView reloadData];
                      [_mainTableView configBlankPageWithType:XHBlankPageNetError
                                                    withBlock:^{
                                                        [self loadNewData];
                                                    }];
                      _mainTableView.mj_footer.userInteractionEnabled = NO;
                
                  }];
    [_footerRefresh endRefreshing];
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
    NSInteger section = indexPath.section;
    static NSString *JHTuanGouListVCCellID = @"JHTuanGouListVCCellID";
    JHHomePageCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:JHTuanGouListVCCellID];
    if (!cell) {
        cell = [[JHHomePageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:JHTuanGouListVCCellID];
    }
    cell.dataModel = tuanGouListModeArray[section];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到团购详情
    JHTuanGouProductListVC *vc = [[JHTuanGouProductListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    //将店铺标题传入
    JHHomePageShopItemModel *model = tuanGouListModeArray[indexPath.section];
    vc.titleString = model.title;
    vc.shop_id = model.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 点击了分类按钮
- (void)clickClassifyBtn:(UIButton *)sender
{
    NSLog(@"点击分类按钮");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLeftIndex" object:nil];
    if (sender.selected) { //当前为选中状态
        [_classifyVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_classifyVC) {
            _classifyVC = [[JHSubNavClassifyVC alloc] init];
            [self addChildViewController:_classifyVC];
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
        }
        [self.view addSubview:_classifyVC.view];
    }
    _distanceBtn.selected = NO;
    _sortBtn.selected = NO;
    [_distanceVC.view removeFromSuperview];
    [_sortVC.view removeFromSuperview];
    sender.selected = !sender.selected;
}
#pragma mark - 点击距离按钮
- (void)clickDistanceBtn:(UIButton *)sender
{
    if (sender.selected) { //当前为选中状态
        [_distanceVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_distanceVC) {
            _distanceVC = [[JHTuanGouSubNavAddressVC alloc] init];
            [self addChildViewController:_distanceVC];
            __weak typeof(self) weakSelf = self;
            _distanceVC.refreshBlock = ^(NSDictionary *paramDic){
                //处理参数
                [weakSelf handleParamsDicWithDic:paramDic];
                //将subNav视图移除
                [weakSelf deleteNavVC];
                //刷新商家列表
                [weakSelf loadNewData];
            };
            _distanceVC.refreshBtnTitleBlock = ^(NSString *btnTitle){
                [weakSelf updateDistanceBtnTitle:btnTitle];
            };
        }
        [self.view addSubview:_distanceVC.view];
    }
    _classifyBtn.selected = NO;
    _sortBtn.selected = NO;
    [_classifyVC.view removeFromSuperview];
    [_sortVC.view removeFromSuperview];
    sender.selected = !sender.selected;
}
#pragma mark - 点击排序按钮
- (void)clickSortBtn:(UIButton *)sender
{
    NSLog(@"点击分类按钮");
    if (sender.selected) { //当前为选中状态
        [_sortVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_sortVC) {
            _sortVC = [[JHTuanGouSubNavSortVC alloc] init];
            [self addChildViewController:_sortVC];
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
        }
        [self.view addSubview:_sortVC.view];
    }
    _classifyBtn.selected = NO;
    _distanceBtn.selected = NO;
    [_classifyVC.view removeFromSuperview];
    [_distanceVC.view removeFromSuperview];
    sender.selected = !sender.selected;

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
#pragma mark - 移除subNav视图
- (void)deleteNavVC{
    [_classifyVC.view removeFromSuperview];
    [_distanceVC.view removeFromSuperview];
    [_sortVC.view removeFromSuperview];
    _classifyBtn.selected = NO;
    _distanceBtn.selected = NO;
    _sortBtn.selected = NO;
}
#pragma mark - 更改分类按钮的title
- (void)updateClassifyBtnTitle:(NSString *)btnTitle
{
    [_classifyBtn setTitle:btnTitle forState:(UIControlStateNormal)];
}

#pragma mark - 更改附近按钮的title
- (void)updateDistanceBtnTitle:(NSString *)btnTitle
{
    [_distanceBtn setTitle:btnTitle forState:(UIControlStateNormal)];
}
#pragma mark - 更改排序按钮的title
- (void)updateSortBtnTitle:(NSString *)btnTitle
{
    [_sortBtn setTitle:btnTitle forState:(UIControlStateNormal)];
}
@end

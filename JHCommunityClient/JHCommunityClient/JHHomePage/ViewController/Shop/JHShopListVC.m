 //
//  JHTuanGouVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHShopListVC.h"
#import "JHHomePageCell.h"
#import "SubNavView.h"
#import "JHSubNavClassifyVC.h"
#import "JHSubNavAddressVC.h"
#import "JHSubNavSortVC.h"
#import <MJRefresh.h>
#import "JHSupermarketMainVC.h"
#import "JHShopHomepageVC.h"
 
#import "JHShareModel.h"
#import "JHHomePageShopItemModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import "WaiMaiShopperCell.h"
#import "WaiMaiShopperModel.h"
#import "JHTempHomePageViewModel.h"
@interface JHShopListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong)JHSubNavClassifyVC *classifyVC;
@property(nonatomic, strong)JHSubNavAddressVC *distanceVC;
@property(nonatomic, strong)JHSubNavSortVC *sortVC;
@property(nonatomic, strong)UIButton *classifyBtn;
@property(nonatomic, strong)UIButton *distanceBtn;
@property(nonatomic, strong)UIButton *sortBtn;
@end

@implementation JHShopListVC
{
    //保存当前数据页数
    NSInteger page;
    //参数字典
    NSMutableDictionary *paramsDic;
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    //存储列表模型数组
    NSMutableArray *shopListModelArray;
    
    //
    double bd_lat;
    double bd_lon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"商家", nil);
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteNavVC) name:@"JHDeleteNavVCNotificationName" object: nil];
    //创建顶部子导航分类条
    [self createSubNav];
    //第一次请求数据
    [self handleFirstLoad];
    [self createMainTableView];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadNewData)
                                                 name:KGetLocation_Notification
                                               object:nil];
}
#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - 处理第一次请求数据
- (void)handleFirstLoad
{
    [self transform];
    page = 1;
    paramsDic = [@{@"page":@(page),@"cate_id": _cate_id?_cate_id : @""} mutableCopy];
    [self loadNewData];
    
}
- (void)transform
{
    JHShareModel *shareModel = [JHShareModel shareModel];
    //在请求前将高德坐标转换为百度坐标
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:shareModel.lat
                                                 WithGD_lon:shareModel.lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    
    paramsDic[@"lat"] = @(bd_lat);
    paramsDic[@"lng"] = @(bd_lon);
}
#pragma mark - 初始化主表视图
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT -(NAVI_HEIGHT+40)) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
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
    }
}
-(void)loadData{
    //获取当前位置
    //JHShareModel *shareModel = [JHShareModel shareModel];
    //在请求前将高德坐标转换为百度坐标
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:[XHMapKitManager shareManager].lat
                                                 WithGD_lon:[XHMapKitManager shareManager].lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    NSLog(@"%g----%g",bd_lat,bd_lon);
    
    //发送请求
    NSDictionary *dic = @{@"page":@(page),@"lng":@([JHShareModel shareModel].lng),@"lat":@([JHShareModel shareModel].lat)};
    [paramsDic addEntriesFromDictionary:dic];
    [JHTempHomePageViewModel postToGetHomePageDataWithDic:paramsDic isShopList:YES block:^(NSString *error, JHTempHomePageModel *model) {
        HIDE_HUD
        if (error) {//请求失败
            [self showMsg:error];
        }else{//请求成功
            if (page == 1) {
                shopListModelArray = model.shop_items.mutableCopy;
            }else{
                //商家推荐
                for (WaiMaiShopperModel *waimaiModel in model.shop_items) {
                    [shopListModelArray addObject:waimaiModel];
                }
                
            }
            
            [self.mainTableView reloadData];
        }
        [_headerRefresh endRefreshing];
        [_footerRefresh endRefreshing];
    }];
}
#pragma mark - 请求新数据
- (void)loadNewData
{
    SHOW_HUD
    //处理参数字典
    page = 1;
    [self loadData];
}
#pragma mark - 加载更多数据
- (void)loadMoreData
{
   
    //处理参数字典页数
    page++;
    [self loadData];
}
#pragma mark - 创建顶部子导航分类
- (void)createSubNav
{
    SubNavView *navView = [[SubNavView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 40)];
    navView.titleArray = @[_btnTitle?_btnTitle:NSLocalizedString(@"全部", nil),NSLocalizedString(@"附近", nil),NSLocalizedString(@"智能排序", nil)];
    _classifyBtn = navView.btn0;
    _distanceBtn = navView.btn1;
    _sortBtn = navView.btn2;
    [_classifyBtn addTarget:self action:@selector(clickClassifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_distanceBtn addTarget:self action:@selector(clickDistanceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_sortBtn addTarget:self action:@selector(clickSortBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
}
#pragma mark - 点击子导航分类按钮
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
#pragma mark - 点击子导航附近按钮
- (void)clickDistanceBtn:(UIButton *)sender
{
    NSLog(@"点击分类按钮");
    if (sender.selected) { //当前为选中状态
        [_distanceVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_distanceVC) {
            _distanceVC = [[JHSubNavAddressVC alloc] init];
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
        _distanceVC.isStartSelector = YES;
        _distanceVC.isRightStartSelector = YES;
        [self.view addSubview:_distanceVC.view];
    }
    _classifyBtn.selected = NO;
    _sortBtn.selected = NO;
    [_classifyVC.view removeFromSuperview];
    [_sortVC.view removeFromSuperview];
    sender.selected = !sender.selected;
}
#pragma mark - 点击子导航排序按钮
- (void)clickSortBtn:(UIButton *)sender
{
    NSLog(@"点击分类按钮");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLeftIndex" object:nil];
    if (sender.selected) { //当前为选中状态
        [_sortVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_sortVC) {
            _sortVC = [[JHSubNavSortVC alloc] init];
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
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shopListModelArray.count;
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
    WaiMaiShopperModel *model = shopListModelArray[indexPath.row];
    CGFloat height = 3 * 30;
    if (model.showYouHui || model.activity_list.count <= 3) {
        height = model.activity_list.count * 30 ;
    }
    return 100 + height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *JHShopListVCCellID = @"WaiMaiShopperCell";
    WaiMaiShopperCell *cell=[tableView dequeueReusableCellWithIdentifier:JHShopListVCCellID];
    if (!cell) {
        cell=[[WaiMaiShopperCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:JHShopListVCCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WaiMaiShopperModel *model = shopListModelArray[indexPath.row];
    cell.isHomePage = YES;
    cell.index = indexPath.row;
    [cell setMyBlock:^(NSInteger index){
        [self jumpToShopHomepageWith:index];
    }];
    [cell reloadCellWithModel:model isFliterList:YES];
    cell.reloadYouhuiCell = ^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    return cell;
    
}
-(void)jumpToShopHomepageWith:(NSInteger)index{
    WaiMaiShopperModel *model = shopListModelArray[index];
    JHShopHomepageVC *vc = [[JHShopHomepageVC alloc] init];
    vc.shop_id = model.shop_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self jumpToShopHomepageWith:indexPath.row];
    
}
#pragma mark - 通知移除二级视图的方法
- (void)deleteNavVC
{
    [_classifyVC.view removeFromSuperview];
    [_distanceVC.view removeFromSuperview];
    [_sortVC.view removeFromSuperview];
    _classifyBtn.selected = NO;
    _distanceBtn.selected = NO;
    _sortBtn.selected = NO;
}
#pragma mark - 处理参数字典
- (void)handleParamsDicWithDic:(NSDictionary *)dic
{
    if ([dic.allKeys containsObject:@"business_id"] || [dic.allKeys containsObject:@"range"]) {
        [paramsDic removeObjectForKey:@"business_id"];
        [paramsDic removeObjectForKey:@"range"];
    }
    [paramsDic addEntriesFromDictionary:dic];
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
#pragma mark -界面消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KGetLocation_Notification
                                                  object:nil];
}
@end

//
//  JHShopEvaluateVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHShopEvaluateVC.h"
#import "StarView.h"
#import <MJRefresh.h>
#import "JHSupermarketEvaluateCell.h"
 
#import "JHEvaluateCellModel.h"
@interface JHShopEvaluateVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *mainTableView;

@end

@implementation JHShopEvaluateVC
{
    //导航栏
    UIView *_customNav;
    UIButton *backBtn_custom;
    UILabel *title_;
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    //参数字典
    NSMutableDictionary *_params_Dic;
    //高度数组
    NSMutableArray *heightArray;
    //当前所在页数
    NSInteger page;
    //保存模型数组
    NSMutableArray *modelArray;
    
    //保存评论的分数
    CGFloat starNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"店铺评价", nil);
    //添加自定义导航栏
    [self createNav];
    //处理参数字典
    [self handleParamsDic];
    //请求第一次数据
    [self loadNewData];
}
#pragma mark - 创建自定义的导航栏
- (void)createNav
{
    _customNav = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, NAVI_HEIGHT)];
    [self.view addSubview:_customNav];
    _customNav.backgroundColor = THEME_COLOR;
    backBtn_custom = [[UIButton alloc] initWithFrame:CGRectMake(15,33,18,18)];
    [backBtn_custom addTarget:self action:@selector(clickBackBtn)
             forControlEvents:UIControlEventTouchUpInside];
    [backBtn_custom setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_customNav addSubview:backBtn_custom];
    title_ = [[UILabel alloc] initWithFrame:FRAME(0, 0, 100, 44)];
    title_.text = NSLocalizedString(@"全部评价", nil);
    title_.font = FONT(18);
    title_.textColor = [UIColor whiteColor];
    title_.textAlignment = NSTextAlignmentCenter;
    [_customNav addSubview:title_];
    title_.center = CGPointMake(_customNav.center.x, _customNav.center.y + 10);
}
#pragma mark - 处理参数字典
- (void)handleParamsDic
{
    _params_Dic = [@{} mutableCopy];
    [_params_Dic addEntriesFromDictionary:_paramsDic];
}
#pragma mark - 初始化主表视图,刷新表视图
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        heightArray = [@[] mutableCopy];
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT -NAVI_HEIGHT) style:(UITableViewStyleGrouped)];
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
    NSLog(@"请求新数据");
    page = 1;
    [_params_Dic addEntriesFromDictionary:@{@"page":@(page)}];
    [HttpTool postWithAPI:_API
               withParams:_params_Dic
                  success:^(id json) {
                      NSLog(@"%@---%@",_API,json);
                      if (![json[@"error"] isEqualToString:@"0"]) {
                          [self showAlertView:json[@"message"]];
                          return;
                      }
                      modelArray = [@[] mutableCopy];
                      for (NSDictionary *dic in json[@"data"][@"items"]) {
                          JHEvaluateCellModel *model = [[JHEvaluateCellModel alloc] init];
                          [model setValuesForKeysWithDictionary:dic];
                          [modelArray addObject:model];
                      }
                      NSDictionary *scoreDic = json[@"data"][@"shop"];
                      if ([scoreDic[@"score"] doubleValue] == 0) {
                          starNum = 0.0;
                      }else{
                          starNum = [scoreDic[@"score"] doubleValue]/[scoreDic[@"comments"] doubleValue];
                          if (isnan(starNum) || isinf(starNum)) {
                              starNum = 0.0;
                          }
                      }
                      [self createMainTableView];
                      [_headerRefresh endRefreshing];
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                       [_headerRefresh endRefreshing];
                  }];
}
#pragma mark - 加载更多数据
- (void)loadMoreData
{
    page++;
    [_params_Dic addEntriesFromDictionary:@{@"page":@(page)}];
    [HttpTool postWithAPI:_API
               withParams:_params_Dic
                  success:^(id json) {
                      NSLog(@"%@---%@",_API,json);
                      for (NSDictionary *dic in json[@"data"][@"items"]) {
                          JHEvaluateCellModel *model = [[JHEvaluateCellModel alloc] init];
                          [model setValuesForKeysWithDictionary:dic];
                          [modelArray addObject:model];
                      }
                      [self createMainTableView];
                      [_footerRefresh endRefreshing];
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      [_footerRefresh endRefreshing];
                  }];
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 30)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 65, 30)];
    titleLabel.text = NSLocalizedString(@"总体评价:", nil);
    titleLabel.font = FONT(13);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    
    UIView *starView = [StarView addEvaluateViewWithStarNO:starNum
                                              withStarSize:14
                                         withBackViewFrame:FRAME(75, 5, 100, 30)];
    [headerView addSubview:titleLabel];
    [headerView addSubview:starView];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:FRAME(170, 0, 50, 30)];
    scoreLabel.text = [NSString stringWithFormat:@"%3.1f分",starNum];
    scoreLabel.font = FONT(12);
    scoreLabel.textColor = HEX(@"999999", 1.0f);
    [headerView addSubview:scoreLabel];
    //添加上边分割线
    UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0, -0.5, WIDTH, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [headerView addSubview:lineView];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat height;
    if (indexPath.row + 1 <= heightArray.count) {
        height = [heightArray[row] floatValue];
    }else{
        UITableViewCell *cell = [self tableView:_mainTableView cellForRowAtIndexPath:indexPath];
        height = cell.frame.size.height;
        [heightArray addObject:@(height)]; //存储高度
        [cell removeFromSuperview];
        cell = nil;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    JHSupermarketEvaluateCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHSupermarketEvaluateCellID"];
    if (!cell) {
        cell = [[JHSupermarketEvaluateCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHSupermarketEvaluateCellID"];
    }
    cell.dataModel = modelArray[row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
#pragma mark - 点击导航栏左按钮
- (void)clickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark=======提示框==========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

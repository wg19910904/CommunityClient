//
//  JHShopEvaluateVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiEvaluateVC.h"
#import "StarView.h"
#import <MJRefresh.h>
#import "JHSupermarketEvaluateCell.h"
 
#import "JHEvaluateCellModel.h"
@interface JHWaiMaiEvaluateVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *mainTableView;

@end

@implementation JHWaiMaiEvaluateVC
{
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    
    //高度数组
    NSMutableArray *heightArray;
    //记录页数
    NSInteger page;
    //模型数组
    NSMutableArray *dataModelArray;
    //评论字典
    NSDictionary *scoreDic; //{count = , score = }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求评价列表
    [self loadNewData];
}
#pragma mark - 请求评价列表
- (void)loadNewData
{
    SHOW_HUD
    page = 1;
    NSDictionary *paramDic = @{@"shop_id":_shop_id,
                               @"page":@(page)};
    [HttpTool postWithAPI:@"client/waimai/comment/items"
               withParams:paramDic
                  success:^(id json) {
                      dataModelArray = [@[] mutableCopy];
                      NSLog(@"client/waimai/comment/items---%@",json);
                      //处理数据模型
                      scoreDic = json[@"data"][@"comment"];
                      [self handleDataModel:json[@"data"][@"items"]];
                      [self createMainTableView];
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark - 处理模型数组
- (void)handleDataModel:(NSArray *)dataArray
{
    for (NSDictionary *dic in dataArray) {
        JHEvaluateCellModel *dataModel = [[JHEvaluateCellModel alloc] init];
        [dataModel setValuesForKeysWithDictionary:dic];
        [dataModelArray addObject:dataModel];
    }
}
#pragma mark - 初始化主表视图,刷新表视图
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        heightArray = [@[] mutableCopy];
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT -99) style:(UITableViewStyleGrouped)];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //-----------------刷新和加载更多添加--------------------
        //创建加载表尾
        _footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadMoreData)];
        [_footerRefresh setTitle:@"" forState:MJRefreshStateIdle];//普通闲置状态
        _mainTableView.mj_footer = _footerRefresh;
        //----------------------------------------------------
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - 加载更多数据
- (void)loadMoreData
{
    page ++;
    NSDictionary *paramDic = @{@"shop_id":_shop_id,
                               @"page":@(page)};
    [HttpTool postWithAPI:@"client/waimai/comment/items"
               withParams:paramDic
                  success:^(id json) {
                      NSLog(@"client/waimai/comment/items---%@",json);
                      //处理数据模型
                      [self handleDataModel:json[@"data"][@"items"]];
                      [_mainTableView reloadData];
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
    if (dataModelArray.count == 0) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:@"" btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }

    return dataModelArray.count;
    
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
    [headerView addSubview:titleLabel];
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:FRAME(170, 0, 50, 30)];
    CGFloat scoreV ;
    if ([scoreDic[@"count"] doubleValue] == 0.0) {
        scoreLabel.text = @"0.0分";
        scoreV = 0.0;
    }else{
        scoreV = [scoreDic[@"score"] doubleValue] / [scoreDic[@"count"] doubleValue];
        scoreLabel.text = [NSString stringWithFormat:@"%3.2g分",scoreV];
    }
    scoreLabel.font = FONT(12);
    scoreLabel.textColor = HEX(@"999999", 1.0f);
    [headerView addSubview:scoreLabel];
    
    UIView *starView = [StarView addEvaluateViewWithStarNO:scoreV withStarSize:14 withBackViewFrame:FRAME(75, 5, 100, 30)];
    [headerView addSubview:starView];
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
    JHSupermarketEvaluateCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHSupermarketEvaluateCellID"];
    if (!cell) {
        cell = [[JHSupermarketEvaluateCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHSupermarketEvaluateCellID"];
    }
    cell.dataModel = (JHEvaluateCellModel *)dataModelArray[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end

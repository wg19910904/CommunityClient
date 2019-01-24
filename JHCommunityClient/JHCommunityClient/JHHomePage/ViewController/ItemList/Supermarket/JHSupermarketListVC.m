//
//  JHSuperMarketListVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSupermarketListVC.h"
#import <MJRefresh.h>
#import "JHSuperMarketListCell.h"
#import "JHSuperMarketMainVC.h"
#import "JHWaiMaiMainVC.h"
 
#import "GaoDe_Convert_BaiDu.h"
#import "JHShareModel.h"
#import "JHWaimaiShopItemModel.h"
@interface JHSupermarketListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *mainTableView;

@end

@implementation JHSupermarketListVC
{
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    //记录页数
    NSInteger page;
    //用来存储转换生成的百度坐标
    double bd_lat;
    double bd_lon;
    //存储请求的数据源
    NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"超市", nil);
    self.view.backgroundColor = BACK_COLOR;
    [self createMainTableView];
    //请求默认的商超数据
    [self loadNewData];
    
}
#pragma mark - 请求默认的商超数据
- (void)loadNewData
{
    SHOW_HUD
    page = 1;
    //获取当前位置
    JHShareModel *shareModel = [JHShareModel shareModel];
    //在请求前将高德坐标转换为百度坐标
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:shareModel.lat
                                                 WithGD_lon:shareModel.lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    NSDictionary *paramDic = @{@"lat":@(bd_lat),
                               @"lng":@(bd_lon),
                               @"page":@(1)};
    [HttpTool postWithAPI:@"client/waimai/shop/marketitems"
               withParams:paramDic
                  success:^(id json) {
                      NSLog(@"client/waimai/shop/marketitems---%@",json);
                      
                      dataArray = [@[] mutableCopy];
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          for (NSDictionary *dic in json[@"data"][@"items"]) {
                              JHWaimaiShopItemModel *model = [[JHWaimaiShopItemModel alloc]init];
                              [model setValuesForKeysWithDictionary:dic];
                              [dataArray addObject:model];
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
                      //停止刷新
                      [_headerRefresh endRefreshing];
                      HIDE_HUD
               }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                      [_headerRefresh endRefreshing];
                      dataArray = [@[] mutableCopy];
                      [_mainTableView reloadData];
                      [_mainTableView configBlankPageWithType:XHBlankPageNetError
                                                    withBlock:^{
                                                        [self loadNewData];
                                                    }];
                      _mainTableView.mj_footer.userInteractionEnabled = NO;
                  }];
    
    
}
#pragma mark - 创建主表视图
- (void)createMainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, 69, WIDTH, HEIGHT - 69)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.backgroundColor = BACK_COLOR;
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
    }else{
        
        [_mainTableView reloadData];
    }
}
#pragma mark - 加载更多数据
- (void)loadMoreData
{
    SHOW_HUD
    page ++ ;
    //获取当前位置
    JHShareModel *shareModel = [JHShareModel shareModel];
    //在请求前将高德坐标转换为百度坐标
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:shareModel.lat
                                                 WithGD_lon:shareModel.lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    NSDictionary *paramDic = @{@"lat":@(bd_lat),
                               @"lng":@(bd_lon),
                               @"page":@(page)};
    [HttpTool postWithAPI:@"client/waimai/shop/marketitems"
               withParams:paramDic
                  success:^(id json) {
                      NSLog(@"client/waimai/shop/marketitems---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          for (NSDictionary *dic in json[@"data"][@"items"]) {
                              JHWaimaiShopItemModel *model = [[JHWaimaiShopItemModel alloc]init];
                              [model setValuesForKeysWithDictionary:dic];
                              [dataArray addObject:model];
                          }
                          [_mainTableView reloadData];
                      }
                      //停止刷新
                      [_footerRefresh endRefreshing];
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                      [_footerRefresh endRefreshing];
                      dataArray = [@[] mutableCopy];
                      [_mainTableView reloadData];
                      [_mainTableView configBlankPageWithType:XHBlankPageNetError
                                                    withBlock:^{
                                                        [self loadNewData];
                                                    }];
                      _mainTableView.mj_footer.userInteractionEnabled = NO;
                  }];
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
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
    JHSuperMarketListCell *cell =[_mainTableView dequeueReusableCellWithIdentifier:@"JHSuperMarketListCellID"];
    if (!cell) {
        cell = [[JHSuperMarketListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHSuperMarketListCellID"];
    }
    cell.dataModel = (JHWaimaiShopItemModel *)dataArray[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHWaimaiShopItemModel *model = (JHWaimaiShopItemModel *)dataArray[indexPath.row];
    //判断类型
    NSString *type = model.tmpl_type;
    if ([type isEqualToString:@"market"]) {
        
        JHSupermarketMainVC *vc = [[JHSupermarketMainVC alloc] init];
        vc.shop_id = model.shop_id;
        vc.restStatus = model.yysj_status;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
    
        JHWaiMaiMainVC *vc = [[JHWaiMaiMainVC alloc] init];
        vc.shop_id = model.shop_id;
//        vc.restStatus = model.yysj_status;
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

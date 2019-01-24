//
//  JHHouseKeepingListVc.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//附近服务人员列表

#import "JHHouseKeepingListVc.h"
#import "HouseKeepingListCell.h"
#import "NSObject+CGSize.h"
#import "HouseKeepingListBnt.h"
#import "JHHouseKeepingSubCateVc.h"
//#import "JHHouseKeepingSubEvaluationVc.h"
#import "JHHouseKeepingSubSortVc.h"
#import "JHHouseKeepingMapVC.h"
#import "JHHouseKeepingDetailVC.h"
 
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "HoseKeepingListModel.h"
#import "DSToast.h"

@interface JHHouseKeepingListVc ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    HouseKeepingListBnt *_cateBnt;
    HouseKeepingListBnt *_distantBnt;
    BOOL _isCateSelected;
    BOOL _isDistantSelected;
    JHHouseKeepingSubCateVc *_subCateVc;
    JHHouseKeepingSubSortVc *_distantVc;
    NSInteger _page;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    NSMutableDictionary *_dic;
    DSToast *toast;
    UIImageView *_backImg;
}

@end

@implementation JHHouseKeepingListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"附近服务人员列表", nil) ;
    self.view.backgroundColor = BACK_COLOR;
    _page = 1;
    _dataArray = [NSMutableArray array];
    _dic = [NSMutableDictionary dictionary];
    [_dic setValue:self.cate_id forKey:@"cate_id"];
    _subCateVc = [[JHHouseKeepingSubCateVc alloc] init];
    _distantVc = [[JHHouseKeepingSubSortVc alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonStatus:) name:@"updateHouseKeepingList" object:nil];
    [self createRightItem];
    [self createTableView];
    [self createCateAndSortView];
}
#pragma mark--====创建分类排序视图
- (void)createCateAndSortView{
    UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    _cateBnt = [[HouseKeepingListBnt alloc] initWithFrame:FRAME(0.25*WIDTH-50, 2.5, 100, 40)];
    if(_cateTitle.length != 0){
        [_cateBnt setTitle:_cateTitle forState:UIControlStateNormal];
    }else{
        [_cateBnt setTitle:self.cateTitle forState:UIControlStateNormal];
    }
    [_cateBnt addTarget:self action:@selector(cateBnt:) forControlEvents:UIControlEventTouchUpInside];
    _isCateSelected = _cateBnt.selected;
    [backView addSubview:_cateBnt];
    _distantBnt = [[HouseKeepingListBnt alloc] initWithFrame:FRAME(WIDTH*0.75-50, 2.5, 100, 40)];
    if(self.sortTitle.length != 0){
        [_distantBnt setTitle:self.sortTitle forState:UIControlStateNormal];
    }else{
        [_distantBnt setTitle:NSLocalizedString(@"智能排序", nil) forState:UIControlStateNormal];
    }
    
    [_distantBnt addTarget:self action:@selector(distantBnt:) forControlEvents:UIControlEventTouchUpInside];
    _isDistantSelected = _distantBnt.selected;
    UIView *middleLabel = [UIView new];
    middleLabel.frame = FRAME((WIDTH - 0.5) / 2, 5, 0.5, 30);
    middleLabel.backgroundColor = LINE_COLOR;
    [backView addSubview:middleLabel];
    [backView addSubview:_cateBnt];
    [backView addSubview:_distantBnt];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [backView addSubview:thread];
    [self.view addSubview:backView];
}
#pragma mark=====右侧转换按钮===========
- (void)createRightItem
{
//    UIButton *switchBnt = [UIButton buttonWithType:UIButtonTypeCustom];
//    switchBnt.frame = FRAME(0, 0, 15, 15);
//    [switchBnt setBackgroundImage:IMAGE(@"switch-1") forState:UIControlStateNormal];
//    [switchBnt addTarget:self action:@selector(switchBnt) forControlEvents:UIControlEventTouchUpInside];
//    switchBnt.titleLabel.font = FONT(14);
//    [switchBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:switchBnt];
//    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)switchBnt
{
    //转换到地图模式
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark=======创建表视图========
- (void)createTableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+40 , WIDTH, HEIGHT - NAVI_HEIGHT - 40) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = LINE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
        __unsafe_unretained typeof (self)weakSelf = self;
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header beginRefreshing];
        _tableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = _footer;
        _backImg = [[UIImageView alloc] init];
        _backImg.frame = FRAME(100, 144, WIDTH - 200, (WIDTH - 200) / 1.4);
        _backImg.image = IMAGE(@"noMessage");
    }
    else
    {
        [_tableView reloadData];
    }
}
#pragma mark=====加载第一页数据========
- (void)loadNewData
{
    SHOW_HUD
    _page = 1;
    NSString *lat = [NSString stringWithFormat:@"%f",[XHMapKitManager shareManager].lat];
    NSString *lng = [NSString stringWithFormat:@"%f",[XHMapKitManager shareManager].lng];
    [_dic setValue:lat forKey:@"lat"];
    [_dic setValue:lng forKey:@"lng"];
    [_dic setValue:@(_page) forKey:@"page"];
    [HttpTool postWithAPI:@"client/house/items" withParams:_dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            [_dataArray removeAllObjects];
            NSArray *itemsArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemsArray)
            {
                HoseKeepingListModel *model = [[HoseKeepingListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            if(_dataArray.count == 0)
            {
                [_tableView addSubview:_backImg];
            }
            else
            {
                [_backImg removeFromSuperview];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self createTableView];
            HIDE_HUD
        }
        else
        {
            HIDE_HUD
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self showAlertView:NSLocalizedString(@"数据请求失败", nil)];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}
#pragma mark=======加载更多数据=========
- (void)loadMoreData
{
    SHOW_HUD
    _page ++;
    NSString *lat = nil;
    NSString *lng = nil;
    lat = [NSString stringWithFormat:@"%f",[XHMapKitManager shareManager].lat];
    lng = [NSString stringWithFormat:@"%f",[XHMapKitManager shareManager].lng];
    [_dic setValue:lat forKey:@"lat"];
    [_dic setValue:lng forKey:@"lng"];
    [_dic setValue:@(_page) forKey:@"page"];
    [HttpTool postWithAPI:@"client/house/items" withParams:_dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            NSArray *itemsArray = json[@"data"][@"items"];
            if (itemsArray.count == 0) {
                HIDE_HUD
                [self showHaveNoMoreData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                return ;
            }
            for(NSDictionary *dic in itemsArray)
            {
                HoseKeepingListModel *model = [[HoseKeepingListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            if(_dataArray.count == 0)
            {
                [_tableView addSubview:_backImg];
            }
            else
            {
                [_backImg removeFromSuperview];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self createTableView];
            HIDE_HUD
        }
        else
        {
            HIDE_HUD
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self showAlertView:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"数据加载失败,原因:", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    HouseKeepingListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[HouseKeepingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.listModel = _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHHouseKeepingDetailVC *detail = [[JHHouseKeepingDetailVC alloc] init];
    detail.staff_id = [_dataArray[indexPath.row] staff_id];
    detail.name = [_dataArray[indexPath.row] name];
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
#pragma mark=======更新按钮状态========
- (void)updateButtonStatus:(NSNotification *)noti
{
    _cateBnt.selected = NO;
    _isCateSelected = NO;
    _distantBnt.selected = NO;
    _isDistantSelected = NO;
    if(noti.userInfo.count == 0){
        
    }else{
        
        if([[noti.userInfo objectForKey:@"name"] isEqualToString:@"cate"]){
            if([[noti.userInfo objectForKey:@"title"] isEqualToString:NSLocalizedString(@"全部分类", nil)])
            {
                if([_dic objectForKey:@"cate_id"]){
                    [_dic removeObjectForKey:@"cate_id"];
                }
            }else{
                [_dic setObject:[noti.userInfo objectForKey:@"cate_id"] forKey:@"cate_id"];
            }
            [_cateBnt setTitle:[noti.userInfo objectForKey:@"title"] forState:UIControlStateNormal];
             self.cateTitle = [noti.userInfo objectForKey:@"title"];
        }else{
            NSString *title = [noti.userInfo objectForKey:@"title"];
            if([title isEqualToString:NSLocalizedString(@"智能排序", nil)]){
                [_dic setObject:@"" forKey:@"orderby"];
                _sortTitle = NSLocalizedString(@"智能排序", nil);
            }else if([title isEqualToString:NSLocalizedString(@"好评优先", nil)]){
                [_dic setObject:@"s" forKey:@"orderby"];
                _sortTitle = NSLocalizedString(@"好评优先", nil);
            }else if([[noti.userInfo objectForKey:@"title"] isEqualToString:NSLocalizedString(@"距离最近", nil)]){
                [_dic setObject:@"d" forKey:@"orderby"];
                _sortTitle = NSLocalizedString(@"距离最近", nil);
            }else{
                [_dic setObject:@"o" forKey:@"orderby"];
                _sortTitle = NSLocalizedString(@"销量最好", nil);
            }
             [_distantBnt setTitle:self.sortTitle forState:UIControlStateNormal];
        }
        
        [self loadNewData];
    }
}
#pragma mark=======分类,评价,距离按钮点击事件===========
- (void)cateBnt:(UIButton *)sender

{
    if(_isCateSelected == NO){
        sender.selected = YES;
        [self.view addSubview:_subCateVc.view];
        _isDistantSelected = NO;
        _distantBnt.selected = NO;
        [_distantVc removeFromParentViewController];
        [_distantVc.view removeFromSuperview];
    }else{
        sender.selected = NO;
        [_subCateVc removeFromParentViewController];
        [_subCateVc.view removeFromSuperview];
    }
    _isCateSelected = !_isCateSelected;
}

- (void)distantBnt:(UIButton *)sender
{
    if(_isDistantSelected == NO){
        sender.selected = YES;
        [self.view addSubview:_distantVc.view];
        _isCateSelected = NO;
        _cateBnt.selected = NO;
        [_subCateVc removeFromParentViewController];
        [_subCateVc.view removeFromSuperview];
       
    }else{
        sender.selected = NO;
        [_distantVc removeFromParentViewController];
        [_distantVc.view removeFromSuperview];
    }
    _isDistantSelected = !_isDistantSelected;
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark - 没有数据时展示
- (void)showHaveNoMoreData
{
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
        [toast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            toast = nil;
        }];
    }
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateHouseKeepingList" object:nil];
}
@end

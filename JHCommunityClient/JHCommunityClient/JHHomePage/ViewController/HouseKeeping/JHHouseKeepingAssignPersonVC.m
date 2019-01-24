//
//  JHHouseKeepingAssignPersonVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/19.
//  Copyright © 2016年 JiangHu. All rights reserved.
//家政阿姨选择指定人员

#import "JHHouseKeepingAssignPersonVC.h"
#import "HouseKeepingAssginPersonCell.h"
 
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "HoseKeepingListModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import "HoseKeepingListModel.h"
#import "DSToast.h"
@interface JHHouseKeepingAssignPersonVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //UIButton *_lastBnt;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    NSInteger _page;
    NSMutableArray *_dataArray;
    HouseKeepingAssginPersonCell *_lastCell;
    DSToast *toast;
    UIImageView *_backImg;
    NSString *_personTag;
}

@end

@implementation JHHouseKeepingAssignPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _dataArray = [NSMutableArray array];
    _lastCell = nil;
    self.title = NSLocalizedString(@"选择服务人员", nil);
    self.view.backgroundColor = BACK_COLOR;
    [self createTableView];
    UIButton * btn = [[UIButton alloc]initWithFrame:FRAME(10, HEIGHT - 55, WIDTH - 20, 45)];
    [btn setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.clipsToBounds = YES;
    [btn setTitle:NSLocalizedString(@"不指定服务人员", nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickToNo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark - 这是不指定的方法
-(void)clickToNo{
    //    MaintainAssginPersonCell * cell = (MaintainAssginPersonCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.staff_id integerValue] inSection:0]];
    if(self.myBlock)
    {
        self.myBlock(nil,NSLocalizedString(@"选择师傅,否则系统随机指定", nil));
    }
    _lastCell.selectImg.image = IMAGE(@"selectDefault");
    _personTag = self.staff_id ? self.staff_id : [[NSUserDefaults standardUserDefaults] objectForKey:@"personTag"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"personTag"];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark========创建表视图=======
- (void)createTableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT -55) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [_tableView addSubview:thread];
        __unsafe_unretained typeof (self)weakSelf = self;
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您刷新中", nil) forState:MJRefreshStateRefreshing];
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
    _page = 1;
    
    NSString *lat = nil;
    NSString *lng = nil;
    lat = [NSString stringWithFormat:@"%f",[XHMapKitManager shareManager].lat];
    lng = [NSString stringWithFormat:@"%f",[XHMapKitManager shareManager].lng];
    NSDictionary *dic = @{@"lat":lat,@"lng":lng,@"page":@(_page),@"cate_id":self.cate_id};
    [HttpTool postWithAPI:@"client/house/items" withParams:dic success:^(id json) {
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
            [self createTableView];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
        }
        else
        {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self showAlertView:NSLocalizedString(@"数据请求失败", nil)];
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}
#pragma mark=======加载更多数据=========
- (void)loadMoreData
{
    _page ++;
    NSString *lat = nil;
    NSString *lng = nil;
    lat = [NSString stringWithFormat:@"%f",[XHMapKitManager shareManager].lat];
    lng = [NSString stringWithFormat:@"%f",[XHMapKitManager shareManager].lng];
    NSDictionary *dic = @{@"lat":lat,@"lng":lng,@"page":@(_page),@"cate_id":self.cate_id};

    [HttpTool postWithAPI:@"client/house/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            NSArray *itemsArray = json[@"data"][@"items"];
            if (itemsArray.count == 0) {
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
            [self createTableView];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
        }
        else
        {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self showAlertView:NSLocalizedString(@"数据请求失败", nil)];
        }
    } failure:^(NSError *error) {
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
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    HouseKeepingAssginPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    HoseKeepingListModel *model = _dataArray[indexPath.row];
    if(cell == nil)
    {
        cell = [[HouseKeepingAssginPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    _personTag = self.staff_id ? self.staff_id : [[NSUserDefaults standardUserDefaults] objectForKey:@"personTag"];
    if([_personTag integerValue] == [model.staff_id integerValue])
    {
        cell.selectImg.image = IMAGE(@"selectCurrent");
        _lastCell = cell;
    }
    if(_dataArray.count == 0 || indexPath.row >= _dataArray.count){
    
    }else{
        cell.assignModel = model;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseKeepingAssginPersonCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    HoseKeepingListModel *model = _dataArray[indexPath.row];
    if(_lastCell != nil)
    {
        _lastCell.selectImg.image = IMAGE(@"selectDefault");
    }
    cell.selectImg.image = IMAGE(@"selectCurrent");
    _lastCell = cell;
    if(self.myBlock)
    {
        self.myBlock(model.staff_id,model.name);
    }
    [[NSUserDefaults standardUserDefaults] setObject:model.staff_id forKey:@"personTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

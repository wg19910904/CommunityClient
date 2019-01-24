//
//  JHAddressListVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//地址列表

#import "JHAddressListVC.h"
#import "AddressListCell.h"
#import "JHAddAddressVC.h"
#import "JHChangeAddressVC.h"
#import "AddrListModel.h"
 
#import "MJRefresh.h"
#import "NSObject+CGSize.h"
#import "DSToast.h"
@interface JHAddressListVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    MJRefreshAutoNormalFooter *_footer;
    NSInteger _page;
    UIButton *_lastBnt;
    NSString *_addrid;
    //用于展示没有数据
    DSToast *toast;
    UIImageView *_backImg;
    MJRefreshNormalHeader *_header;
    AddressListCell *_lastCell;
}
@end

@implementation JHAddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"地址列表", nil);
    _page = 1;
    _lastBnt = nil;
    self.view.backgroundColor = BACK_COLOR;
    UIButton *addAddressBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBnt.frame = FRAME(0, 0, 30, 15);
    [addAddressBnt setTitle:NSLocalizedString(@"添加", nil) forState:UIControlStateNormal];
    [addAddressBnt addTarget:self action:@selector(addAddressBnt) forControlEvents:UIControlEventTouchUpInside];
    addAddressBnt.titleLabel.font = FONT(14);
    [addAddressBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addAddressBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
    _dataArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"changeAddr" object:nil];
    [self createTableView];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)updateUI
{
    [self loadNewData];
}
#pragma mark===========添加按钮点击事件==========
- (void)addAddressBnt
{
    NSLog(@"添加地址");
    JHAddAddressVC *addAddressVc = [[JHAddAddressVC alloc] init];
    [self.navigationController pushViewController:addAddressVc animated:YES];
}
#pragma mark=====搭建UI界面========
- (void)createTableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0,(NAVI_HEIGHT+10), WIDTH, HEIGHT - (NAVI_HEIGHT+10)) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = LINE_COLOR;
        _tableView.backgroundColor = BACK_COLOR;
        _tableView.tableFooterView = [[UIView alloc] init];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [_tableView addSubview:thread];
        [self.view addSubview:_tableView];
        __unsafe_unretained typeof(self)weakSelf = self;
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        [_header beginRefreshing];
        _tableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = _footer;
        _backImg = [[UIImageView alloc] init];
        _backImg.frame = FRAME(100, 104, WIDTH - 200, (WIDTH - 200) / 1.4);
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
    NSDictionary *dic = @{@"page":@(_page)};
    SHOW_HUD
    [HttpTool postWithAPI:@"client/member/addr" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            
            [_dataArray removeAllObjects];
            NSArray *itemsArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemsArray)
            {
                AddrListModel *model = [[AddrListModel alloc] init];
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
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据请求失败,原因:%@", nil),json[@"message"]]];
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
    _page ++;
    NSDictionary *dic = @{@"page":@(_page)};
    SHOW_HUD
    [HttpTool postWithAPI:@"client/member/addr" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            NSArray *itemsArray = json[@"data"][@"items"];
            if (itemsArray.count == 0) {
                [self showHaveNoMoreData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                HIDE_HUD
                return ;
            }
            for(NSDictionary *dic in itemsArray)
            {
                AddrListModel *model = [[AddrListModel alloc] init];
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
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据请求失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
    
}
#pragma mark========UITableViewDelegate============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[AddressListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.isCenter = self.isCenter;
    cell.operateBnt.tag = indexPath.row + 1;
    [cell.operateBnt addTarget:self action:@selector(alterAddress:) forControlEvents:UIControlEventTouchUpInside];
    AddrListModel *model = _dataArray[indexPath.row];
    [cell setAddrListModel:model withIndex:self.index];
    _addrid = _addr_id ? _addr_id : [[NSUserDefaults standardUserDefaults] objectForKey:@"addr_id"];
    if(model.addr_id == _addrid)
    {
        cell.selectImg.highlighted = YES;
        _lastCell = cell;
        __unsafe_unretained typeof (self)weakSelf = self;
        if(_myBlock)
        {
            weakSelf.myBlock(cell.addressImg.image,cell.nameLabel.text,cell.phoneLabel.text,model.addr,model.addr_id,model.house);
        }
    }
    else
    {
        cell.selectImg.highlighted = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddrListModel *model = _dataArray[indexPath.row];
    if(self.index == 1)
    {
        CGSize size = [self currentSizeWithString:[NSString stringWithFormat:@"%@%@",model.addr,model.house] font:FONT(13) withWidth:70];
        return  50 + size.height;
    }
    else
    {
        CGSize size = [self currentSizeWithString:[NSString stringWithFormat:@"%@%@",model.addr,model.house] font:FONT(13) withWidth:105];
        return  50 + size.height;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCenter) {
        return;
    }
    if(self.index != 1)
    {
        AddressListCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if(_lastCell != nil)
        {
            _lastCell.selectImg.highlighted = NO;
        }
        cell.selectImg.highlighted = YES;
        _lastCell = cell;
        AddrListModel *model = _dataArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:model.addr_id forKey:@"addr_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        __unsafe_unretained typeof (self)weakSelf = self;
        if(_myBlock)
        {
            weakSelf.myBlock(cell.addressImg.image,cell.nameLabel.text,cell.phoneLabel.text,model.addr,model.addr_id,model.house);
        }
        
        if (_myBlock2) {
            weakSelf.myBlock2(model.contact,model.lat, model.lng, model.mobile, model.addr, model.house);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark=======单元格上修改按钮点击事件===========
- (void)alterAddress:(UIButton *)sender
{
    NSLog(@"修改地址");
    AddrListModel *listModel = _dataArray[sender.tag - 1];
    JHChangeAddressVC *changeAddressVc = [[JHChangeAddressVC alloc] init];
    changeAddressVc.nameText = listModel.contact;
    changeAddressVc.mobile = listModel.mobile;
    changeAddressVc.addr = listModel.addr;
    changeAddressVc.addrDetail = listModel.house;
    changeAddressVc.bntTag = listModel.type;
    changeAddressVc.addr_id = listModel.addr_id;
    changeAddressVc.lat = listModel.lat;
    changeAddressVc.lng = listModel.lng;
    [self.navigationController pushViewController:changeAddressVc animated:YES];
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeAddr" object:nil];
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

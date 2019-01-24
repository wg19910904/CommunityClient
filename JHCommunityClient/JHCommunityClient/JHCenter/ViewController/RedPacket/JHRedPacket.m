//
//  JHRedPacket.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRedPacket.h"
#import "JHExchangeRedPacketVC.h"
#import "RedPacketCell.h"
#import "JHRedPacketRuleVC.h"
#import "RedPacketModel.h"
#import "MJRefresh.h"
 
#import "DSToast.h"
@interface JHRedPacket ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView;
    RedPacketCell *_lastCell;
    UIButton *_cancelBnt;
    NSMutableArray *_dataArray;
    NSInteger _page;
    MJRefreshAutoNormalFooter *_footer;
    DSToast *toast;
    UIImageView *_backImg;
    MJRefreshNormalHeader *_header;
    //NSString *_hongbaoID;
}
@end

@implementation JHRedPacket

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"红包", nil);
    _dataArray = [NSMutableArray array];
    _page = 1;
    self.view.backgroundColor = BACK_COLOR;
    UIButton *exchangeBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBnt.frame = FRAME(0, 0, 30, 15);
    [exchangeBnt setTitle:NSLocalizedString(@"兑换", nil) forState:UIControlStateNormal];
    [exchangeBnt addTarget:self action:@selector(exchangeBnt) forControlEvents:UIControlEventTouchUpInside];
    exchangeBnt.titleLabel.font = FONT(14);
    [exchangeBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:exchangeBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self createTableView];
    _lastCell = nil;
    _cancelBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBnt.frame = FRAME(10, HEIGHT - 45, WIDTH - 20, 40);
    [_cancelBnt setTitle:NSLocalizedString(@"点击取消红包", nil) forState:UIControlStateNormal];
    [_cancelBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelBnt.layer.cornerRadius = 4.0f;
    _cancelBnt.clipsToBounds = YES;
    _cancelBnt.titleLabel.font = FONT(14);
    [_cancelBnt setBackgroundColor:[UIColor colorWithRed:250/255.0 green:180/255.0 blue:73/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [_cancelBnt setBackgroundColor:[UIColor colorWithRed:250/255.0 green:180/255.0 blue:73/255.0 alpha:0.6f] forState:UIControlStateHighlighted];
    [_cancelBnt addTarget:self action:@selector(cancelBnt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBnt];
    if(self.selectRedPacket)
    {
        
    }
    else
    {
        _cancelBnt.hidden = YES;
        _tableView.frame = FRAME(0, NAVI_HEIGHT, WIDTH , HEIGHT - NAVI_HEIGHT);
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // _hongbaoID = self.hongbao_id ? self.hongbao_id : [[NSUserDefaults standardUserDefaults] objectForKey:@"hongbao_id"];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self loadNewData];
}
#pragma mark======创建表视图======
- (void)createTableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0,NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 45) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACK_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        __unsafe_unretained typeof(self)weakSelf = self;
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
        _backImg.frame = FRAME(100, 104, WIDTH - 200, (WIDTH - 200) / 1.4);
        _backImg.image = IMAGE(@"noMessage");
    }
    else{
         [_tableView reloadData];
    }
}
#pragma mark=====加载第一页数据========
- (void)loadNewData
{
    _page = 1;
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"client/member/hongbao/index" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            
            [_dataArray removeAllObjects];
            NSArray *itemsArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemsArray)
            {
                RedPacketModel *model = [[RedPacketModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                if(self.selectRedPacket)
                   [self selectHongBaoWithModel:model];
                else
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
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"client/member/hongbao/index" withParams:dic success:^(id json) {
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
                RedPacketModel *model = [[RedPacketModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                if(self.selectRedPacket)
                    [self selectHongBaoWithModel:model];
                else
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

#pragma mark=========点击取消红包============
- (void)cancelBnt
{
    NSLog(@"点击取消红包");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark=====筛选可用红包数据源=======
- (void)selectHongBaoWithModel :(RedPacketModel *)redPacketModel
{
    if([redPacketModel.status isEqualToString:@"3"]){
            //已使用
        }
        else if([redPacketModel.status isEqualToString:@"2"]){
            //已过期)
        }
        else{
            if([self.amount floatValue] < [redPacketModel.min_amount floatValue]){
                //
            }
            else{
                 [_dataArray addObject:redPacketModel];
            }
        }
}
#pragma mark ============UITableViewDelegate=========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell1";
    RedPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[RedPacketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setRedPacketModel:_dataArray[indexPath.row] selectRedPacket:self.selectRedPacket];
    if(self.hongbao_id == [_dataArray[indexPath.row] hongbao_id])
    {
        cell.img.highlighted = YES;
        _lastCell = cell;
    }
    else
    {
        cell.img.highlighted = NO;
    }
    return  cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(self.selectRedPacket)
   {
       RedPacketCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
       NSString *hongbao_id = [_dataArray[indexPath.row] hongbao_id];
       NSString *money = [_dataArray[indexPath.row] amount];
       if(_lastCell != nil)
       {
           _lastCell.img.highlighted = NO;
       }
       [cell.img setHighlighted:YES];
       _lastCell = cell;
       if(self.redPacket)
       {
           self.redPacket(hongbao_id,money);
       }
//       [[NSUserDefaults standardUserDefaults] setObject:hongbao_id forKey:@"hongbao_id"];
//       [[NSUserDefaults standardUserDefaults] synchronize];
       [self.navigationController popViewControllerAnimated:YES];
   }
}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   if(self.selectRedPacket)
//   {
//       RedPacketCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
//       [cell.img setHighlighted:NO];
//   }
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
    view.backgroundColor = BACK_COLOR;
    UIButton *ruleBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBnt.frame = FRAME(WIDTH - 70, 10, 70, 10);
    [ruleBnt addTarget:self action:@selector(ruleBnt) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ruleBnt];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(0, 5, 15, 15)];
    iconImg.image = IMAGE(@"wen");
    [ruleBnt addSubview:iconImg];
    UILabel *describeLabel = [[UILabel alloc] initWithFrame:FRAME(15, 5, 55, 15)];
    describeLabel.font = FONT(12);
    describeLabel.text = NSLocalizedString(@"使用说明", nil);
    describeLabel.textColor = HEX(@"999999", 1.0f);
    [ruleBnt addSubview:describeLabel];
    return view;
}
#pragma mark==========兑换红包按钮==========
- (void)exchangeBnt
{
    NSLog(@"兑换红包了");
    JHExchangeRedPacketVC *exchange = [[JHExchangeRedPacketVC alloc] init];
    [self.navigationController pushViewController:exchange animated:YES];
}
#pragma mark=========红包使用规则按钮点击事件===========
- (void)ruleBnt
{
    NSLog(@"查看使用规则");
    JHRedPacketRuleVC *rule = [[JHRedPacketRuleVC alloc] init];
    [self.navigationController pushViewController:rule animated:YES];
    
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

@end

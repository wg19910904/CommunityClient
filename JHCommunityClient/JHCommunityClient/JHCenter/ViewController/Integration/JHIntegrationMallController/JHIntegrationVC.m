//
//  JHIntegrationVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//积分界面

#import "JHIntegrationVC.h"
#import "IntegrationCell.h"
#import "JHIntegralMallVC.h"
#import "JHIntegrationRuleVC.h"
#import "MJRefresh.h"
 
#import "IntegrationModel.h"
#import "DSToast.h"
#import "JHTempWebViewVC.h"
#import "MemberInfoModel.h"
@interface JHIntegrationVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_integralLabel;//当前积分
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    NSInteger _page;
    NSString *_integrationNumber;
    DSToast *toast;
    UIImageView *_backImg;
}
@end

@implementation JHIntegrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的积分", nil);
    UIButton *integrationBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    integrationBnt.frame = FRAME(0, 0, 60, 15);
    [integrationBnt setTitle:NSLocalizedString(@"积分规则", nil) forState:UIControlStateNormal];
    [integrationBnt addTarget:self action:@selector(integrationBnt) forControlEvents:UIControlEventTouchUpInside];
    integrationBnt.titleLabel.font = FONT(14);
    [integrationBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:integrationBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
    _integralLabel = [UILabel new];
    _dataArray = [NSMutableArray array];
    [self createTableView];
    
}

#pragma mark===========积分规则===========
- (void)integrationBnt
{
    NSLog(@"查看积分规则");
    JHIntegrationRuleVC *integrationVC = [[JHIntegrationRuleVC alloc] init];
    [self.navigationController pushViewController:integrationVC animated:YES];
}
#pragma mark========显示导航栏===============
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark=======创建表视图=========
- (void)createTableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACK_COLOR;
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        for(int i= 0; i < 3; i++)
        {
            UIView *thread = [[UIView alloc] init];
            thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
            if(i == 0)
            {
                thread.frame = FRAME(0, 0, WIDTH, 0.5);
            }
            else if(i == 1)
            {
                thread.frame = FRAME(0, 59.5, WIDTH, 0.5);
            }
            else
            {
                thread.frame = FRAME(0, 79.5, WIDTH, 0.5);
            }
            [_tableView addSubview:thread];
            
        }
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
        _backImg.frame = FRAME(100, 144, WIDTH - 200, (WIDTH - 200) / 1.4);
        _backImg.image = IMAGE(@"noMessage");

    }
    else
        [_tableView reloadData];
    
}
#pragma mark=====加载第一页数据========
- (void)loadNewData
{
    _page = 1;
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"client/member/jifen/log" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            _integrationNumber = json[@"data"][@"jifen"];
            [_dataArray removeAllObjects];
            NSArray *itemsArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemsArray)
            {
                IntegrationModel *model = [[IntegrationModel alloc] init];
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
        }else{
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
    [HttpTool postWithAPI:@"client/member/jifen" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        NSArray *itemsArray = json[@"data"][@"items"];
        if (itemsArray.count == 0) {
            [self showHaveNoMoreData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            return ;
        }
        for(NSDictionary *dic in itemsArray)
        {
            IntegrationModel *model = [[IntegrationModel alloc] init];
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
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
    
}

#pragma mark=========充值按钮==========
- (void)exchangeGoodBnt
{
    NSLog(@"兑换商品啦");
    JHTempWebViewVC *vc = [[JHTempWebViewVC alloc] init];
    vc.url = [MemberInfoModel shareModel].jifen_mall;
    [self.navigationController pushViewController:vc animated:YES];
   
}
#pragma mark========UITableViewDelegate===========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
        return _dataArray.count;
    else
        return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        UILabel *integrationLable = [[UILabel alloc] initWithFrame:FRAME(10, 80 + NAVI_HEIGHT, WIDTH, 10)];
        integrationLable.font = FONT(12);
        integrationLable.textColor = HEX(@"999999", 1.0f);
        integrationLable.textAlignment = NSTextAlignmentLeft;
        integrationLable.text = NSLocalizedString(@"   最近30天积分记录", nil);
        return integrationLable;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        static NSString *identifier = @"balanceCell";
        IntegrationCell *interCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(interCell == nil)
        {
            interCell = [[IntegrationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        interCell.integrationModel = _dataArray[indexPath.row];
        return interCell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        _integralLabel.frame = FRAME(0, 30, WIDTH/2, 20);
        _integralLabel.font = FONT(16);
        _integralLabel.textAlignment = NSTextAlignmentCenter;
        _integralLabel.textColor = HEX(@"f85357", 1.0f);
        [cell.contentView addSubview:_integralLabel];
        NSString *string = nil;
        if(_integrationNumber.length == 0)
        {
            string = NSLocalizedString(@"0.00分", nil);
        }
        else
        {
            string = [NSString stringWithFormat:NSLocalizedString(@"%@分", nil),_integrationNumber];
        }
        NSRange range = [string rangeOfString:NSLocalizedString(@"分", nil)];
        NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
        [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"999999" alpha:1.0]} range:range];
        [attribute addAttributes:@{NSFontAttributeName:FONT(12)} range:range];
        _integralLabel.text = string;
        _integralLabel.attributedText = attribute;
        UILabel *describeLabel = [[UILabel alloc] initWithFrame:FRAME(0, 10, WIDTH / 2, 10)];
        describeLabel.font = FONT(12);
        describeLabel.textColor = HEX(@"999999", 1.0f);
        describeLabel.text = NSLocalizedString(@"当前积分", nil);
        describeLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:describeLabel];
        UILabel *thread = [[UILabel alloc] initWithFrame:FRAME(WIDTH/2-1, 5, 1, 50)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [cell.contentView addSubview:thread];
        UIButton *exchangeGoodBnt  = [UIButton buttonWithType:UIButtonTypeCustom];
        exchangeGoodBnt.frame = FRAME(WIDTH/2 + 30, 10, WIDTH/2 - 60, 40);
        [exchangeGoodBnt setTitle:NSLocalizedString(@"兑换商品", nil) forState:UIControlStateNormal];
        [exchangeGoodBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        exchangeGoodBnt.layer.cornerRadius = 4.0f;
        exchangeGoodBnt.clipsToBounds = YES;
        exchangeGoodBnt.titleLabel.font = FONT(14);
        [exchangeGoodBnt setBackgroundColor:HEX(@"f85357", 1.0f) forState:UIControlStateNormal];
        [exchangeGoodBnt setBackgroundColor:HEX(@"f85357", 0.6f) forState:UIControlStateHighlighted];
        [exchangeGoodBnt addTarget:self action:@selector(exchangeGoodBnt) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:exchangeGoodBnt];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 60;
    }
    else
        return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 20;
    }
    else
        return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
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

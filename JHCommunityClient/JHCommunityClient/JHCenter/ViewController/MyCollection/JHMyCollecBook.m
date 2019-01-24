//
//  JHMyCollecBook.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/2/9.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMyCollecBook.h"
 
#import <MJRefresh.h>
#import "JHTempWebViewVC.h"
@interface JHMyCollecBook ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    NSMutableArray *_infoArray;
    MJRefreshNormalHeader *_header;
    MJRefreshAutoNormalFooter *_footer;
}
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation JHMyCollecBook

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    _infoArray = @[].mutableCopy;
    [self tableView];
    [self postHttp];
    
}
-(void)postHttp{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/member/collect/items" withParams:@{@"page":@(page).stringValue,@"type":@"5"} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page == 1) {
                [_infoArray removeAllObjects];
                _infoArray = json[@"data"][@"items"];
            }else{
                [_infoArray addObjectsFromArray:json[@"data"][@"items"]];
            }
            
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
        }
        [_header endRefreshing];
        [_footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [_header endRefreshing];
        [_footer endRefreshing];
        NSLog(@"error:%@",error);
    }];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - NAVI_HEIGHT - 50) style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = [UIColor whiteColor];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
            _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            _header.lastUpdatedTimeLabel.hidden = YES;
            [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            table.mj_header = _header;
            _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
            [_footer setTitle:@"" forState:MJRefreshStateIdle];
            [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
            table.mj_footer = _footer;

            table;
        });
    }
    return _tableView;
}
#pragma mark - 这是下拉刷新
-(void)downRefresh{
    page = 1;
    [self postHttp];
}
#pragma mark - 上拉加载
-(void)upLoadData{
    page ++;
    [self postHttp];
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _infoArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        UIView *view = [UIView new];
        [view setBackgroundColor:HEX(@"cccccc", 1)];
        [cell addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset = 0;
            make.height.offset = 0.5;
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _infoArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@  %@人浏览",nil),dic[@"dateline"],dic[@"views"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHTempWebViewVC *vc = [[JHTempWebViewVC alloc] init];
    vc.url = _infoArray[indexPath.row][@"link"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

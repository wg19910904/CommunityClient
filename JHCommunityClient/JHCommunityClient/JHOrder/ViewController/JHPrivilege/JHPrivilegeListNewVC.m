//
//  JHPrivilegeListNewVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegeListNewVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <MJRefresh.h>
#import "JHPrivilegeListCell.h"
#import "JHAllCell.h"
 
#import "DSToast.h"
#import "JHPrivilegeListModel.h"
#import "JHPrivilegedDetailVC.h"
#import "JHWMPayOrderVC.h"
#import "JHPersonEvaluationVC.h"
@interface JHPrivilegeListNewVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableview;
    MJRefreshNormalHeader * _header;
    MJRefreshAutoNormalFooter * _footer;
    NSInteger page;
    NSMutableArray * infoArray;
    DSToast * toast;
    BOOL isCancel;
    BOOL isFirst;
}
@end
@implementation JHPrivilegeListNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //创建表格的方法
    [self creatUITableView];
    //发送请求
    [self postHttpWithPage:[NSString stringWithFormat:@"%ld",page]];
    SHOW_HUD
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    infoArray = [NSMutableArray array];
    self.fd_interactivePopDisabled = YES;
    self.navigationItem.title = NSLocalizedString(@"订单", nil);
    page = 1;
}
#pragma mark - 这是创建UITableView的方法
-(void)creatUITableView{
    myTableview = [[UITableView alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
    myTableview.showsVerticalScrollIndicator = NO;
    myTableview.tableFooterView = [UIView new];
    myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableview.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [myTableview registerClass:[JHPrivilegeListCell class] forCellReuseIdentifier:@"cell"];
    [myTableview registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell1"];
    //添加刷新控件
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForCompletion)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    myTableview.mj_header = _header;
    //添加加载控件
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadForCompletion)];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    myTableview.mj_footer = _footer;
    myTableview.delegate = self;
    myTableview.dataSource = self;
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)pageNum{
    NSDictionary * dictionry = @{@"from":@"maidan",@"type":@"1", @"page":pageNum};
    [HttpTool postWithAPI:@"client/member/order/items" withParams:dictionry success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSMutableArray * tempArray = json[@"data"][@"items"];
            if (tempArray.count == 0 && [pageNum intValue] > 1) {
                [self creatWithMessage:NSLocalizedString(@"亲,没有更多数据了", nil)];
                [_footer endRefreshing];
                return ;
            }
            for (NSDictionary * dic in tempArray) {
                JHPrivilegeListModel * model = [JHPrivilegeListModel shareJHPrivilegeListModelWithDictionary:dic];
                [infoArray addObject:model];
            }
            if (!isFirst) {
                [self.view addSubview:myTableview];
                isFirst = YES;
            }
            [myTableview reloadData];
            HIDE_HUD
            [_header endRefreshing];
            [_footer endRefreshing];
        }else{
            if (!isFirst) {
                [self.view addSubview:myTableview];
                isFirst = YES;
            }
            [myTableview reloadData];
            HIDE_HUD
            [_header endRefreshing];
            [_footer endRefreshing];
            [self creatUIAalertControllerWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        HIDE_HUD
        [_header endRefreshing];
        [_footer endRefreshing];
    }];
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (infoArray.count == 0) {
        return 1;
    }else{
        return infoArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (infoArray.count == 0) {
            return HEIGHT - NAVI_HEIGHT;
        }else{
            return 170;
        }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (infoArray.count == 0) {
        JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        JHPrivilegeListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        JHPrivilegeListModel * model = infoArray[indexPath.row];
        cell.model = model;
        //去评价
        cell.btn_evalute.tag = indexPath.row;
        [cell.btn_evalute addTarget:self action:@selector(clickToEvaluate:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHPrivilegeListModel * model = infoArray[indexPath.row];
    JHPrivilegedDetailVC * vc = [[JHPrivilegedDetailVC alloc]init];
    vc.order_id = model.order_id;
    [vc setBlock:^(void){
        [self refreshForCompletion];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是去评价的方法
-(void)clickToEvaluate:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]) {
        JHPrivilegeListModel * model = infoArray[sender.tag];
        JHPersonEvaluationVC * vc = [JHPersonEvaluationVC new];
        vc.isTuan = YES;
        vc.number = model.jifen;
        vc.order_id = model.order_id;
        vc.personEvaluationSuccess = ^{
            [self refreshForCompletion];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 这是刷新已完成的方法
-(void)refreshForCompletion{
    if (!isCancel) {
        SHOW_HUD
    }
    page = 1;
    [infoArray removeAllObjects];
    [self postHttpWithPage:[NSString stringWithFormat:@"%ld",page]];
}
-(void)loadForCompletion{
    page ++;
   [self postHttpWithPage:[NSString stringWithFormat:@"%ld",page]];
}
#pragma mark - 展示错误信息的
-(void)creatUIAalertControllerWithMessage:(NSString *)msg{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 创建提示
-(void)creatWithMessage:(NSString *)msg{
    if (toast == nil) {
        toast = [[DSToast alloc]initWithText:msg];
        [toast showInView:self.view  showType:DSToastShowTypeCenter withBlock:^{
            toast = nil;
            isCancel = YES;
        }];
    }
}
@end

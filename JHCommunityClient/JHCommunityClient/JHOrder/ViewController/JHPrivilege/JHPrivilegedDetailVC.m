//
//  JHPrivilegedDetailVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegedDetailVC.h"
#import "JHPrivilegeDetailCellOne.h"
#import "JHPrivilegeDetailCellTwo.h"
#import "JHPrivilegeDetailCellThree.h"
#import "JHPrivilegeDetailModel.h"
#import "JHPersonEvaluationVC.h"
#import "JHShopHomepageVC.h"
 
#import <MJRefresh.h>
#import "JHPEvaluateVC.h"
#import "JHPrivilegeListNewVC.h"
@interface JHPrivilegedDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;//创建表格
    BOOL isFirst;//数据请求成功后加载表
    JHPrivilegeDetailModel * detailModel;
    MJRefreshNormalHeader * _header;
    UIButton * btn_evaluate;
    BOOL _youhui;
}
@end

@implementation JHPrivilegedDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化的一些数据
    [self initData];
    //创建表格
    [self creatUITableView];
    //创建查看评价的方法
    //[self creatSeeEvaluateBtn];
    SHOW_HUD
    //发送请求
    [self postHttp];
}
- (void)clickBackBtn{
    NSArray<JHBaseVC *>*vcArray = self.navigationController.viewControllers;
    for (JHBaseVC *obj in vcArray) {
        if([obj isKindOfClass:[JHShopHomepageVC class]]){
            _youhui = YES;
            [self.navigationController popToViewController:obj animated:YES];
           
        }else if ([obj isKindOfClass:[JHPrivilegeListNewVC class]]){
            _youhui = YES;
            [self.navigationController popToViewController:obj animated:YES];
        }

    }
    if(!_youhui){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - 这是评价后可以查看评价法的按钮
-(void)creatSeeEvaluateBtn{
    if (btn_evaluate == nil) {
        btn_evaluate = [[UIButton alloc]init];
        btn_evaluate.frame = FRAME(0, HEIGHT - 50, WIDTH, 50);
        [btn_evaluate setTitle:NSLocalizedString(@"查看评价", nil) forState:UIControlStateNormal];
        btn_evaluate.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_evaluate setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn_evaluate addTarget:self action:@selector(clickToSeeEvaluate) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_evaluate];
        
    }
    if ([detailModel.order_status integerValue] == 8 && [detailModel.comment_status integerValue] == 1) {
        btn_evaluate.hidden = NO;
        myTableView.frame = CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50);
    }else{
        btn_evaluate.hidden = YES;
         myTableView.frame = CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT);
    }
}
#pragma mark - 这是点击进入查看评价的方法
-(void)clickToSeeEvaluate{
    NSLog(@"查看评价");
    JHPEvaluateVC * vc  = [[JHPEvaluateVC alloc]init];
    vc.order_id = detailModel.order_id;
    vc.isTuan = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是初始化的一些数据
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"订单详情", nil);
}
#pragma mark - 这是发送订单详情的请求的方法
-(void)postHttp{
    NSDictionary * dic = @{@"order_id":self.order_id};
    [HttpTool postWithAPI:@"client/member/order/detail" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSDictionary * dic = json[@"data"][@"order"];
            detailModel = [JHPrivilegeDetailModel shareJHPrivilegeDetailModelWithDictionary:dic];
            if (!isFirst) {
                [self.view addSubview:myTableView];
                isFirst = YES;
            }
            if ([detailModel.comment_status integerValue] == 1) {
                [self creatSeeEvaluateBtn];
            }
            [myTableView reloadData];
            [_header endRefreshing];
        }else{
            HIDE_HUD
            [self creatUIAlertControlWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        NSLog(@"%@",error.localizedDescription);
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
    }];
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableFooterView = [UIView new];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[JHPrivilegeDetailCellOne class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[JHPrivilegeDetailCellTwo class] forCellReuseIdentifier:@"cell2"];
    [myTableView registerClass:[JHPrivilegeDetailCellThree class] forCellReuseIdentifier:@"cell3"];
    //添加下拉刷新的
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    [myTableView setMj_header:_header];
    myTableView.delegate = self;
    myTableView.dataSource = self;

}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    [self postHttp];
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    }else if (indexPath.row == 1 || indexPath.row == 3){
        return 10;
    }else if (indexPath.row ==  2){
        return 110;
    }else{
        return 180;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JHPrivilegeDetailCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.model = detailModel;
        [cell.btn addTarget:self action:@selector(clickToEvaluate) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.row == 1 || indexPath.row == 3){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        JHPrivilegeDetailCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.model = detailModel;
        [cell.btn_call addTarget:self action:@selector(clickToCall) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        JHPrivilegeDetailCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.model = detailModel;
        return cell;
    }
}
#pragma mark - 这是点击去评价的方法
-(void)clickToEvaluate{
    NSLog(@"点击去评价的方法");
    JHPersonEvaluationVC * vc = [[JHPersonEvaluationVC alloc]init];
    vc.order_id = detailModel.order_id;
    vc.isTuan = YES;
    vc.number = detailModel.jifen;
    vc.personEvaluationSuccess = ^{
        [self downRefresh];
        if (self.block) {
            self.block();
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是点击打电话的方法
-(void)clickToCall{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:detailModel.mobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击取消
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"呼叫", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击呼叫
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",detailModel.mobile]]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 创建提示框
-(void)creatUIAlertControlWithMessage:(NSString *)msg{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end

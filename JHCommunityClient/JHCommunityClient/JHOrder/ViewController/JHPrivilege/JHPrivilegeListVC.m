//
//  JHPrivilegeListVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegeListVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <MJRefresh.h>
#import "JHPrivilegeListCell.h"
#import "JHAllCell.h"
 
#import "DSToast.h"
#import "JHPrivilegeListModel.h"
#import "JHPrivilegedDetailVC.h"
#import "JHWMPayOrderVC.h"
#import "JHPersonEvaluationVC.h"
@interface JHPrivilegeListVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIScrollView * myScrollView;//创建滑动视图
    UITableView * tableView_make;//进行中的表
    UITableView * tableView_completon;//已完成的表
    UISegmentedControl * segmentControl;
    MJRefreshNormalHeader * _headerContinue;//刷新进行中的
    MJRefreshNormalHeader * _headerCompletion;//刷新已经完成的
    MJRefreshAutoNormalFooter * _footerContinue;//加载进行中的
    MJRefreshAutoNormalFooter * _footerCompletion;//加载已完成的
    BOOL isMove;
    DSToast * toast;
    BOOL  isFirst_continue;//判断是否是第一次加载页面
    BOOL  isFirst_completiion;//判断是否是第一次加载页面
    NSMutableArray * Continue_array;//存放正在进行中的数据的
    NSMutableArray * completion_array;//存放已经完成的数据的
    int page_continue;
    int page_completion;
    BOOL isCancel;


}
@end

@implementation JHPrivilegeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page_continue = 1;
    page_completion = 1;
    self.fd_interactivePopDisabled = YES;
    Continue_array = [NSMutableArray array];
    completion_array = [NSMutableArray array];
    self.navigationItem.title = NSLocalizedString(@"订单", nil);
    //创建UISegmentControl
    [self creatUISegmentControl];
    //创建滑动视图
    [self creatUIScrollView];
    SHOW_HUD
    [self postHttpWithType:@"0" withPage:[NSString stringWithFormat:@"%d",page_continue]];

}
-(void)postHttpWithType:(NSString *)type withPage:(NSString * )page{
    NSDictionary * dictionry = @{@"from":@"maidan",@"type":type, @"page":page};
    [HttpTool postWithAPI:@"client/member/order/items" withParams:dictionry success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"] ) {
            if ([type isEqualToString:@"0"]) {
                NSMutableArray * tempArray = json[@"data"][@"items"];
                if (tempArray.count == 0 && [page intValue] > 1) {
                    [self creatWithMessage:NSLocalizedString(@"亲,没有更多数据了", nil)];
                    [_footerContinue endRefreshing];
                    return ;
                }
                for(NSDictionary * dic in tempArray){
                    JHPrivilegeListModel * model = [JHPrivilegeListModel shareJHPrivilegeListModelWithDictionary:dic];
                    [Continue_array addObject:model];
                }
                if(!isFirst_continue){
                    [myScrollView addSubview:tableView_make];
                    isFirst_continue = YES;
                }
                [tableView_make reloadData];
                HIDE_HUD
                [_headerContinue endRefreshing];
                [_footerContinue endRefreshing];
                
            }else if ([type isEqualToString:@"1"]){
                NSMutableArray * tempArray = json[@"data"][@"items"];
                if (tempArray.count == 0 && [page intValue] > 1) {
                    if (toast == nil) {
                        toast = [[DSToast alloc]initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
                        [toast showInView:self.view  showType:DSToastShowTypeCenter withBlock:^{
                            toast = nil;
                        }];
                    }
                    [_footerCompletion endRefreshing];
                    return ;
                }
                for (NSDictionary * dic in tempArray) {
                    JHPrivilegeListModel * model = [JHPrivilegeListModel shareJHPrivilegeListModelWithDictionary:dic];
                    [completion_array addObject:model];
                }
                if (!isFirst_completiion) {
                    [myScrollView addSubview:tableView_completon];
                    isFirst_completiion = YES;
                }
                [tableView_completon reloadData];
                HIDE_HUD
                [_headerCompletion endRefreshing];
                [_footerCompletion endRefreshing];
            }
        }
        else{
            HIDE_HUD
            if([type isEqualToString:@"0"]){
                if(!isFirst_continue){
                    [myScrollView addSubview:tableView_make];
                    isFirst_continue = YES;
                }
                [tableView_make reloadData];
                [_headerContinue endRefreshing];
                [_footerContinue endRefreshing];
                
            }else{
                if (!isFirst_completiion) {
                    [myScrollView addSubview:tableView_completon];
                    isFirst_completiion = YES;
                }
                [tableView_completon reloadData];
                [_headerCompletion endRefreshing];
                [_footerCompletion endRefreshing];
            }
            [self creatUIAalertControllerWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
    } failure:^(NSError * error) {
        NSLog(@"%@",error.localizedDescription);
        [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        [_headerContinue endRefreshing];
        [_headerCompletion endRefreshing];
        [_footerCompletion endRefreshing];
        [_footerContinue endRefreshing];
        HIDE_HUD
    }];
}


#pragma mark - 这是创建UISegmengControl
-(void)creatUISegmentControl{
    segmentControl = [[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"进行中", nil),NSLocalizedString(@"已完成", nil)]];
    segmentControl.frame = CGRectMake(60, (NAVI_HEIGHT+10), WIDTH - 120, 35);
    segmentControl.tintColor = THEME_COLOR;
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(clickChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
}
#pragma mark - 这是点击segmentcontrol的方法
-(void)clickChange:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"你点击了进行中");
        
    }else{
        NSLog(@"你点击了已完成");
        if(!isFirst_completiion){
            SHOW_HUD
            //请求已经完成的数据
            [self postHttpWithType:@"1" withPage:[NSString stringWithFormat:@"%d",page_completion]];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [myScrollView setContentOffset:CGPointMake(WIDTH*sender.selectedSegmentIndex, 0) animated:YES];
    }];
}
#pragma mark - 创建滑动视图
-(void)creatUIScrollView{
    myScrollView = [[UIScrollView alloc]init];
    myScrollView.frame = FRAME(0, (NAVI_HEIGHT+55), WIDTH, HEIGHT - (NAVI_HEIGHT+55));
    myScrollView.delegate = self;
    myScrollView.pagingEnabled = YES;
    myScrollView.bounces = NO;
    //myScrollView.scrollEnabled = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(WIDTH*2, HEIGHT - (NAVI_HEIGHT+55));
    [self.view addSubview:myScrollView];
    for (int i = 0; i < 2; i++) {
        UITableView * myTableView = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT - (NAVI_HEIGHT+55)) style:UITableViewStylePlain];
        //[myScrollView addSubview:myTableView];
        if(i == 0){
            tableView_make = myTableView;
            //添加刷新控件
            _headerContinue = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForContinue)];
            _headerContinue.lastUpdatedTimeLabel.hidden = YES;
            [_headerContinue setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_headerContinue setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_headerContinue setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            _headerContinue.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            tableView_make.mj_header = _headerContinue;
            //添加加载控件
            _footerContinue = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadForContinue)];
            [_footerContinue setTitle:@"" forState:MJRefreshStateIdle];
            tableView_make.mj_footer = _footerContinue;
        }else{
            tableView_completon = myTableView;
            //添加刷新控件
            _headerCompletion = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForCompletion)];
            _headerCompletion.lastUpdatedTimeLabel.hidden = YES;
            [_headerCompletion setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_headerCompletion setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_headerCompletion setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            _headerCompletion.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            tableView_completon.mj_header = _headerCompletion;
            //添加加载控件
            _footerCompletion = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadForCompletion)];
            [_footerCompletion setTitle:@"" forState:MJRefreshStateIdle];
            tableView_completon.mj_footer = _footerCompletion;
        }
        [myTableView registerClass:[JHPrivilegeListCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell1"];
         myTableView.showsVerticalScrollIndicator = NO;
         myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
         myTableView.tableFooterView = [UIView new];
        myTableView.backgroundColor =[UIColor colorWithWhite:0.98 alpha:1];
        myTableView.delegate = self;
        myTableView.dataSource= self;
    }
}
#pragma mark - 这是刷新进行中的方法
-(void)refreshForContinue{
    SHOW_HUD
    page_continue = 1;
    [Continue_array removeAllObjects];
    [self postHttpWithType:@"0" withPage:[NSString stringWithFormat:@"%d",page_continue]];
}
#pragma mark - 这是刷新已完成的方法
-(void)refreshForCompletion{
    if (!isCancel) {
        SHOW_HUD
    }
    page_completion = 1;
    [completion_array removeAllObjects];
    [self postHttpWithType:@"1" withPage:[NSString stringWithFormat:@"%d",page_completion]];
}
#pragma mark - 这是加载进行中的方法
-(void)loadForContinue{
    page_continue ++;
    [self postHttpWithType:@"0" withPage:[NSString stringWithFormat:@"%d",page_continue]];
}
-(void)loadForCompletion{
    page_completion ++;
    [self postHttpWithType:@"1" withPage:[NSString stringWithFormat:@"%d",page_completion]];
}

#pragma mark - 这是表的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tableView_make) {
        if (Continue_array.count == 0) {
            return 1;
        }else{
            return Continue_array.count;
        }
    }else{
        if (completion_array.count == 0) {
            return 1;
        }else{
            return completion_array.count;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView_make) {
        if (Continue_array.count == 0) {
            return HEIGHT - (NAVI_HEIGHT+55);
        }else{
            return 150;
        }
    }else{
        if (completion_array.count == 0) {
            return HEIGHT - (NAVI_HEIGHT+55);
        }else{
            return 150;
        }
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView_make) {
        if (Continue_array.count == 0) {
            JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            JHPrivilegeListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            JHPrivilegeListModel * model = Continue_array[indexPath.row];
            cell.model = model;
            cell.btn_cancel.tag = indexPath.row;
            //点击取消订单
            [cell.btn_cancel addTarget:self action:@selector(clickToCancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            //去支付
            cell.btn_evalute.tag = indexPath.row;
            [cell.btn_evalute addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }else{
        if (completion_array.count == 0) {
            JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            JHPrivilegeListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            JHPrivilegeListModel * model = completion_array[indexPath.row];
            cell.model = model;
            //去评价
            cell.btn_evalute.tag = indexPath.row;
            [cell.btn_evalute addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tableView_make) {
        JHPrivilegeListModel * model = Continue_array[indexPath.row];
        JHPrivilegedDetailVC * vc = [[JHPrivilegedDetailVC alloc]init];
        vc.order_id = model.order_id;
       // vc.jifen = model.jifen;
       // vc.danbao_amount = model.danbao_amount;
        //vc.chajia = model.chajia;
//        [vc setMyBlock:^(void){
//            [self refreshForContinue];
//        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JHPrivilegeListModel * model = completion_array[indexPath.row];
        JHPrivilegedDetailVC * vc = [[JHPrivilegedDetailVC alloc]init];
        vc.order_id = model.order_id;
        //vc.jifen = model.jifen;
        //vc.danbao_amount = model.danbao_amount;
//        [vc setMyBlock:^(void){
//            [self refreshForCompletion];
//        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 这是点击取消订单的方法
-(void)clickToCancelOrder:(UIButton *)sender{
    NSLog(@"这是点击取消订单的方法");
    SHOW_HUD
    JHPrivilegeListModel * model = Continue_array[sender.tag];
    [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
}
#pragma mark - 这是发送取消订单的请求
-(void)cancelOrderWithOrder_id:(NSString *)order_id withRow:(NSInteger)row{
    isCancel = YES;
    [HttpTool postWithAPI:@"client/order/cancel" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            HIDE_HUD
            //刷新数据
            [self refreshWithIndex:row];
        }else{
            HIDE_HUD
            [self creatUIAalertControllerWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
    }];
}
#pragma mark - 这是处理取消订单后刷新数据的方法
-(void)refreshWithIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    [Continue_array removeObjectAtIndex:index];
    [tableView_make reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    //[tableView_make deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [self refreshForCompletion];
    [self creatWithMessage:NSLocalizedString(@"取消订单成功", nil)];
    
}

#pragma mark - 这是点击去支付的方法
-(void)clickToPay:(UIButton *)sender{
    NSLog(@"这是点击去支付的方法");
    JHPrivilegeListModel * model = nil;
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        NSLog(@"点击了去支付的按钮");
        model = Continue_array[sender.tag];
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.amount;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self refreshForContinue];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        NSLog(@"点击了去评价的按钮");
        model = completion_array[sender.tag];
        JHPersonEvaluationVC * vc = [JHPersonEvaluationVC new];
        vc.isTuan = YES;
        vc.number = model.jifen;
        vc.order_id = model.order_id;
        vc.personEvaluationSuccess = ^{
            [self refreshForCompletion];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        model = Continue_array[sender.tag];
        NSLog(@"点击了取消订单的按钮");
        SHOW_HUD;
        [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
    }
    else{
        NSLog(@"点击了已评价的按钮");
    }

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

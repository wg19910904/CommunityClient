//
//  JHTakeawayViewController.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/7.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTakeawayViewController.h"
#import "TakeawayTableViewCellOne.h"
#import "JHOrderDetailViewController.h"
#import "JHWMPayOrderVC.h"
#import "JHGrounpDetailController.h"
#import <MJRefresh.h>
#import "DSToast.h"
 
#import "JHTakeyawayModel.h"
#import "JHAllCell.h"
#import "JHShopEvaluationVC.h"
#import "JHOrderBtn.h"
@interface JHTakeawayViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * myScrollView;//滑动视图
    UISegmentedControl * segmentControl;//选择按钮
    UITableView * tableView_make;//进行中的表
    UITableView * tableView_completion;//已完成的表
    BOOL isMove;
    BOOL  isFirst_continue;//判断是否是第一次加载页面
    BOOL  isFirst_completiion;//判断是否是第一次加载页面
    MJRefreshNormalHeader * _headerContinue;//刷新进行中的
    MJRefreshNormalHeader * _headerCompletion;//刷新已完成的
    MJRefreshAutoNormalFooter * _footerContinue;//加载进行中的
    MJRefreshAutoNormalFooter * _footerCompletion;//加载已完成的
    DSToast * toast;
    NSMutableArray * Continue_array;//存放正在进行中的数据的
    NSMutableArray * completion_array;//存放已经完成的数据的
    int page_continue;
    int page_completion;
    BOOL isCancel;
}
@end

@implementation JHTakeawayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page_continue = 1;
    page_completion = 1;
    Continue_array = [NSMutableArray array];
    completion_array = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
    self.navigationItem.title = NSLocalizedString(@"订单", nil);
    //创建顶部的UISegmentControl
    [self creatUISegmentControl];
    //创建滑动视图
    [self creatUIScrollView];
    //请求进行中的接口
    SHOW_HUD
    [self postHttpWithType:@"0" withPage:[NSString stringWithFormat:@"%d",page_continue]];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithType:(NSString *)type withPage:(NSString * )page{
    NSDictionary * dictionry = @{@"from":@"waimai",@"type":type, @"page":page};
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
                NSLog(@"%@===%ld",tempArray,tempArray.count);
                for(NSDictionary * dic in tempArray){
                    JHTakeyawayModel * model = [JHTakeyawayModel creatJHTakeyawayWithDictionary:dic];
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
                    JHTakeyawayModel * model = [JHTakeyawayModel creatJHTakeyawayWithDictionary:dic];
                    [completion_array addObject:model];
                }
               
                if (!isFirst_completiion) {
                    [myScrollView addSubview:tableView_completion];
                    isFirst_completiion = YES;
                    }
                    [tableView_completion reloadData];
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
                    [myScrollView addSubview:tableView_completion];
                    isFirst_completiion = YES;
                }
                [tableView_completion reloadData];
                [_headerCompletion endRefreshing];
                [_footerCompletion endRefreshing];
            }
            [self creatUIAalertControllerWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
    } failure:^(NSError * error) {
        [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        NSLog(@"%@",error.localizedDescription);
        [_headerContinue endRefreshing];
        [_headerCompletion endRefreshing];
        [_footerCompletion endRefreshing];
        [_footerContinue endRefreshing];
        HIDE_HUD
    }];
}
#pragma mark - 创建顶部的UISegmentController
-(void)creatUISegmentControl{
    segmentControl = [[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"进行中", nil),NSLocalizedString(@"已完成", nil)]];
    segmentControl.frame = CGRectMake(60, NAVI_HEIGHT+10, WIDTH - 120, 35);
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
    segmentControl.tintColor = THEME_COLOR;
    [self.view addSubview:segmentControl];
}
//点击segmentcontroller时调用的方法
-(void)changeSegment:(UISegmentedControl *)segment{
    isMove =  NO;
    if (segment.selectedSegmentIndex == 0) {
        NSLog(@"我点击了进行中");
    }else{
        NSLog(@"我点击了已完成");
    if(!isFirst_completiion){
        SHOW_HUD
        //请求已经完成的数据
        [self postHttpWithType:@"1" withPage:[NSString stringWithFormat:@"%d",page_completion]];
        
        }
    }
     [UIView animateWithDuration:0.3 animations:^{
         myScrollView.contentOffset = CGPointMake(WIDTH*segment.selectedSegmentIndex, 0);
     }];
}
#pragma - mark 这是创建UIScrollView的方法
-(void)creatUIScrollView{
    myScrollView = [[UIScrollView alloc]init];
    myScrollView.frame = CGRectMake(0, (NAVI_HEIGHT+55), WIDTH, HEIGHT-(NAVI_HEIGHT+55));
    myScrollView.contentSize = CGSizeMake(WIDTH*2, HEIGHT-(NAVI_HEIGHT+55));
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.bounces = NO;
    myScrollView.delegate = self;
    //myScrollView.scrollEnabled = NO;
    for(int i = 0; i < 2;i++){
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT - (NAVI_HEIGHT+55)) style:UITableViewStylePlain];
        //[myScrollView addSubview:tableView];
        tableView.tableFooterView = [UIView new];
        tableView.showsVerticalScrollIndicator = NO;
        if (i==0) {
            tableView_make = tableView;
            //添加刷新控件
            _headerContinue = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForContinue)];
            _headerContinue.lastUpdatedTimeLabel.hidden = YES;
            [_headerContinue setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_headerContinue setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_headerContinue setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];            _headerContinue.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            tableView_make.mj_header = _headerContinue;
            //添加加载控件
            _footerContinue = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadForContinue)];
            [_footerContinue setTitle:@"" forState:MJRefreshStateIdle];
            [tableView_make setMj_footer:_footerContinue];
            
        }else{
            tableView_completion = tableView;
            //添加刷新控件的
            _headerCompletion = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForCompletion)];
            _headerCompletion.lastUpdatedTimeLabel.hidden = YES;
            [_headerCompletion setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_headerCompletion setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_headerCompletion setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            _headerCompletion.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            tableView_completion.mj_header = _headerCompletion;
            //添加加载控件
            _footerCompletion = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadForCompletion)];
            [_footerCompletion setTitle:@"" forState:MJRefreshStateIdle];
            tableView_completion.mj_footer = _footerCompletion;
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
        [tableView registerClass:[TakeawayTableViewCellOne class] forCellReuseIdentifier:@"cell"];
        [tableView registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell1"];
        tableView.delegate = self;
        tableView.dataSource = self;
    }
}
#pragma mark - 这是UIScrollViewde代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isMove = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isMove == YES) {
        if (scrollView == myScrollView) {
            if (scrollView.contentOffset.x == 0) {
                NSLog(@"这是进行中的界面");
                segmentControl.selectedSegmentIndex = 0;
            }else if (scrollView.contentOffset.x == WIDTH){
                NSLog(@"这是已完成的界面");
                segmentControl.selectedSegmentIndex = 1;
                if(!isFirst_completiion){
                    SHOW_HUD
                    //请求已经完成的数据
                   [self postHttpWithType:@"1" withPage:[NSString stringWithFormat:@"%d",page_completion]];
                }

            }
            
        }

    }
}
#pragma mark - 这是表格的代理和数据源方法
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
            return 175;
        }
    }else{
        if (completion_array.count == 0) {
            return HEIGHT - (NAVI_HEIGHT+55);
        }else{
            return 175;
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
        TakeawayTableViewCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        JHTakeyawayModel * model = Continue_array[indexPath.row];
        cell.model = model;
        cell.btn.tag = indexPath.row;
        cell.btn.myType = 0;
        [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.cancelBtn addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
            cell.cancelBtn.tag = indexPath.row;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }

    }else{
        if (completion_array.count == 0) {
            JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            TakeawayTableViewCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            JHTakeyawayModel * model = completion_array[indexPath.row];
            cell.model = model;
            cell.btn.tag = indexPath.row;
            cell.btn.myType = 1;
            [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView_make) {
        if (Continue_array.count > 0) {
            JHTakeyawayModel * model = Continue_array[indexPath.row];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSLog(@"进入查看订单详情的界面");
            JHOrderDetailViewController *  vc = [[JHOrderDetailViewController alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBloack:^(void){
                [self refreshForContinue];
                [self refreshForCompletion];
                HIDE_HUD
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if (completion_array.count > 0) {
            JHTakeyawayModel * model =  completion_array[indexPath.row];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSLog(@"进入查看订单详情的界面");
            JHOrderDetailViewController *  vc = [[JHOrderDetailViewController alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBloack:^(void){
                [self refreshForContinue];
                [self refreshForCompletion];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    }
#pragma mark - 这是点击去支付还是去评价的按钮点击方法
-(void)btnClick:(JHOrderBtn *)sender{
    NSLog(@"点击了按钮%ld",(long)sender.tag);
    JHTakeyawayModel * model = nil;
    if (sender.myType == 0) {
        NSLog(@"点击的是进行中的");
         model = Continue_array[sender.tag];
    }else{
        NSLog(@"点击的是已经完成的");
        model = completion_array[sender.tag];
    }
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        NSLog(@"点击了去支付的按钮");
       
        
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
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"确认完成", nil)]){
        [HttpTool postWithAPI:@"client/order/confirm" withParams:@{@"order_id":model.order_id} success:^(id json) {
            NSLog(@"%@==%@",json[@"message"],model.order_id);
            if ([json[@"error"] isEqualToString:@"0"]) {
                [self refreshForContinue];
                HIDE_HUD
                [self refreshForCompletion];
            }else{
                [self creatUIAalertControllerWithMessage:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
            NSLog(@"%@",error.localizedDescription);
        }];
    }
    else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        NSLog(@"点击了去评价的按钮");
        JHShopEvaluationVC * vc = [[JHShopEvaluationVC alloc]init];
//        vc.deliverTime = model.dateline;
//        vc.number = model.jifen;
        vc.order_id = model.order_id;
//        vc.isZiti = model.pei_type.integerValue == 3 ? YES : NO;
        vc.shopEvaluationSuccess = ^{
         [self refreshForCompletion];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击了取消订单的按钮");
        SHOW_HUD
        //TakeawayTableViewCellOne * cell = (TakeawayTableViewCellOne *)[sender superview];
        //NSIndexPath * indexPath = [tableView_make indexPathForCell:cell];
        [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
    }
    else{
        
    }
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
    [self creatWithMessage:NSLocalizedString(@"取消订单成功!", nil)];
}
#pragma mark - 这是在待支付状态下点击取消的按钮调用的方法
-(void)clickToCancel:(UIButton *)sender{
    NSLog(@"你点击了取消订单");
    JHTakeyawayModel * model = Continue_array[sender.tag];
    SHOW_HUD
    [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
}
#pragma mark - 这是进行中刷新的方法
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
#pragma mark - 这是上拉加载进行中 
-(void)loadForContinue{
    page_continue ++;
    [self postHttpWithType:@"0" withPage:[NSString stringWithFormat:@"%d",page_continue]];
}
#pragma mark - 这是上拉加载已完成的
-(void)loadForCompletion{
    page_completion ++;
    [self postHttpWithType:@"1" withPage:[NSString stringWithFormat:@"%d",page_completion]];
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
            isCancel = NO;
        }];
    }
}
@end

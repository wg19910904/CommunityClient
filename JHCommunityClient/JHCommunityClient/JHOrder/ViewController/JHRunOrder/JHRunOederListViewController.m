//
//  JHRunOederListViewController.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRunOederListViewController.h"
#import "JHOrderTableViewCell.h"
#import "JHRunTableViewCell.h"
#import "JHRunTableViewCellOther.h"
#import "JHRunPetTableViewCell.h"
#import "JHSeatTableViewCell.h"
#import "JHRunOtherTableViewCell.h"
#import "JHWMPayOrderVC.h"
#import "JHBuyOrderDetailViewController.h"
#import "JHSendOrderDetailVC.h"
#import "JHQueueOrderDetailVC.h"
#import "JHPetOrderDetailVC.h"
#import "JHSeatOrderDetailVC.h"
#import "JHOtherOrderDetailVC.h"
#import <MJRefresh.h>
#import "DSToast.h"
 
#import "JHRunModel.h"
#import "JHAllCell.h"
#import "JHOrderBtn.h"
#import "JHPersonEvaluationVC.h"
@interface JHRunOederListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIScrollView * myScrollView;//创建滑动视图
    UITableView * tableView_make;//进行中的表
    UITableView * tableView_completon;//已完成的表
    UISegmentedControl * segmentControl;
    BOOL isMove;
    BOOL  isFirst_continue;//判断是否是第一次加载页面
    BOOL  isFirst_completiion;//判断是否是第一次加载页面
    MJRefreshNormalHeader * _headerContinue;//刷新进行中的
    MJRefreshNormalHeader * _headerCompletion;//刷新已经完成的
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

@implementation JHRunOederListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page_continue = 1;
    page_completion = 1;
    Continue_array = [NSMutableArray array];
    completion_array = [NSMutableArray array];
    self.view.backgroundColor =[UIColor colorWithWhite:0.98 alpha:1];
     self.navigationItem.title = NSLocalizedString(@"订单", nil);
     //创建UISegmentControl
    [self creatUISegmentControl];
    //创建滑动视图
    [self creatUIScrollView];
    SHOW_HUD
    //请求跑腿进行中的数据
    [self postHttpWithType:@"0" withPage:[NSString stringWithFormat:@"%d",page_continue]];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithType:(NSString *)type withPage:(NSString * )page{
    NSDictionary * dictionry = @{@"from":@"paotui",@"type":type,@"page":page};
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
                    JHRunModel * model = [JHRunModel creatJHRunModelWithDictionry:dic];
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
                    JHRunModel * model = [JHRunModel creatJHRunModelWithDictionry:dic];
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

            [self creatUIAalertControllerWithMessage:json[@"message"]];
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
    isMove = NO;
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
            //添加刷新控件的
            _headerContinue = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForContinue)];
            _headerContinue.lastUpdatedTimeLabel.hidden = YES;
            [_headerContinue setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_headerContinue setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_headerContinue setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            _headerContinue.stateLabel.textColor =  [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            tableView_make.mj_header = _headerContinue;
            //添加加载控件的
            _footerContinue = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadForContinue)];
            [_footerContinue setTitle:@"" forState:MJRefreshStateIdle];
            [tableView_make setMj_footer:_footerContinue];
        }else{
            tableView_completon = myTableView;
            //添加刷新控件的
            _headerCompletion = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForCompletion)];
            _headerCompletion.lastUpdatedTimeLabel.hidden = YES;
            [_headerCompletion setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_headerCompletion setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_headerCompletion setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];            _headerCompletion.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            tableView_completon.mj_header = _headerCompletion;
            //添加加载控件的
            _footerCompletion = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadForCompletion)];
            [_footerCompletion setTitle:@"" forState:MJRefreshStateIdle];
            tableView_completon.mj_footer = _footerCompletion;
        }
        [myTableView registerClass:[JHOrderTableViewCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[JHRunTableViewCell class] forCellReuseIdentifier:@"cell1"];
        [myTableView registerClass:[JHRunTableViewCellOther class] forCellReuseIdentifier:@"cell2"];
        [myTableView registerClass:[JHRunPetTableViewCell class] forCellReuseIdentifier:@"cell3"];
        [myTableView registerClass:[JHSeatTableViewCell class] forCellReuseIdentifier:@"cell4"];
        [myTableView registerClass:[JHRunOtherTableViewCell class] forCellReuseIdentifier:@"cell5"];
        [myTableView registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell6"];
        myTableView.showsVerticalScrollIndicator = NO;
        myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        myTableView.tableFooterView = [UIView new];
        myTableView.backgroundColor =[UIColor colorWithWhite:0.98 alpha:1];
        myTableView.delegate = self;
        myTableView.dataSource= self;
    }
    
}
#pragma mark - 这是滑动视图的代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isMove = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isMove) {
        if (scrollView == myScrollView) {
            if (scrollView.contentOffset.x == 0) {
                segmentControl.selectedSegmentIndex = 0;
            }else if (scrollView.contentOffset.x == WIDTH){
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
        JHRunModel * model = Continue_array[indexPath.row];
        if ([model.type isEqualToString:@"song"]) {
            return 240;
        }else{
            return 200;
        }
     }
    }else{
        if (completion_array.count == 0) {
            return HEIGHT - (NAVI_HEIGHT+55);
        }else{
        JHRunModel * model = completion_array[indexPath.row];
        if ([model.type isEqualToString:@"song"]) {
            return 240;
        }else{
            return 200;
        }
      }
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView_make) {
        if (Continue_array.count == 0) {
            JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell6" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
        JHRunModel * model = Continue_array[indexPath.row];
        if ([model.type isEqualToString:@"buy"]) {
            //帮我买
            JHOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.btn_cancel.tag = 1;
            cell.btn_pay.tag = 1;
            cell.btn_pay.myTag = indexPath.row;
            cell.btn_cancel.myTag = indexPath.row;
            cell.model = model;
            [cell.btn_cancel addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }else if ([model.type isEqualToString:@"paidui"]){
            //代排队
            JHRunTableViewCellOther * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.model = model;
            cell.btn_cancel.tag = 2;
            cell.btn_pay.tag = 2;
            cell.btn_pay.myTag = indexPath.row;
            cell.btn_cancel.myTag = indexPath.row;
            [cell.btn_cancel addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if ([model.type isEqualToString:@"chongwu"]){
            //宠物照顾
            JHRunPetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.model = model;
            cell.btn_cancel.tag = 3;
            cell.btn_pay.tag = 3;
            cell.btn_pay.myTag = indexPath.row;
            cell.btn_cancel.myTag = indexPath.row;
            [cell.btn_cancel addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if ([model.type isEqualToString:@"seat"]){
            //餐馆占座
            JHSeatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            cell.model = model;
            cell.btn_cancel.tag = 4;
            cell.btn_pay.tag = 4;
            cell.btn_pay.myTag = indexPath.row;
            cell.btn_cancel.myTag = indexPath.row;
            [cell.btn_cancel addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if([model.type isEqualToString:@"other"]){
            //其他
            JHRunOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
            cell.btn_cancel.tag = 5;
            cell.btn_pay.tag = 5;
            cell.btn_pay.myTag = indexPath.row;
            cell.btn_cancel.myTag = indexPath.row;
            cell.model = model;
            [cell.btn_cancel addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }
        else if([model.type isEqualToString:@"song"]) {
            //帮我送
            JHRunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.model = model;
            cell.btn_cancel.tag = 0;
            cell.btn_pay.tag = 0;
            cell.btn_pay.myTag = indexPath.row;
            cell.btn_cancel.myTag = indexPath.row;
            [cell.btn_cancel addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }
        else{
            UITableViewCell * cell = [[UITableViewCell alloc]init];
            return cell;
        }
       }
    }else{
        
        if (completion_array.count == 0) {
            JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell6" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
        JHRunModel * model = completion_array[indexPath.row];
        if ([model.type isEqualToString:@"buy"]) {
            //帮我买
            JHOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.btn_cancel.tag = 1;
            cell.btn_pay.tag = 1;
            cell.btn_pay.myTag = indexPath.row;
            cell.model = model;
            //[cell.btn_cancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToEvaluate:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }else if ([model.type isEqualToString:@"paidui"]){
            //代排队
            JHRunTableViewCellOther * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.model = model;
            cell.btn_cancel.tag = 2;
            cell.btn_pay.myTag = indexPath.row;
            cell.btn_pay.tag = 2;
            //[cell.btn_cancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToEvaluate:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if ([model.type isEqualToString:@"chongwu"]){
            //宠物照顾
            JHRunPetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.model = model;
            cell.btn_cancel.tag = 3;
            cell.btn_pay.tag = 3;
            cell.btn_pay.myTag = indexPath.row;
            //[cell.btn_cancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToEvaluate:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if ([model.type isEqualToString:@"seat"]){
            //餐馆占座
            JHSeatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            cell.model = model;
            cell.btn_cancel.tag = 4;
            cell.btn_pay.tag = 4;
            cell.btn_pay.myTag = indexPath.row;
            //[cell.btn_cancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToEvaluate:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if([model.type isEqualToString:@"other"]){
            //其他
            JHRunOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
            cell.btn_cancel.tag = 5;
            cell.btn_pay.tag = 5;
            cell.model = model;
            cell.btn_pay.myTag = indexPath.row;
            //[cell.btn_cancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToEvaluate:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }
        else if([model.type isEqualToString:@"song"]){
            //帮我送
            JHRunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.model = model;
            cell.btn_cancel.tag = 0;
            cell.btn_pay.tag = 0;
            cell.btn_pay.myTag = indexPath.row;
            //[cell.btn_cancel addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_pay addTarget:self action:@selector(clickToEvaluate:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
  
        }else{
            UITableViewCell * cell = [[UITableViewCell alloc]init];
            return cell;
        }
        }
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tableView_make) {
        JHRunModel * model = Continue_array[indexPath.row];
        if ([model.type isEqualToString:@"buy"]) {
            //帮我买订单详情
            JHBuyOrderDetailViewController * vc = [[JHBuyOrderDetailViewController alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForContinue];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"song"]){
            JHSendOrderDetailVC * vc = [[JHSendOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForContinue];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"paidui"]){
            JHQueueOrderDetailVC * vc = [[JHQueueOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForContinue];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"chongwu"]){
            JHPetOrderDetailVC * vc = [[JHPetOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForContinue];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"seat"]){
            JHSeatOrderDetailVC * vc = [[JHSeatOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForContinue];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([model.type isEqualToString:@"other"]){
            JHOtherOrderDetailVC * vc = [[JHOtherOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
            [self refreshForContinue];
            }];

            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        JHRunModel * model = completion_array[indexPath.row];
        if ([model.type isEqualToString:@"buy"]) {
            //帮我买订单详情
            JHBuyOrderDetailViewController * vc = [[JHBuyOrderDetailViewController alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForCompletion];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"song"]){
            JHSendOrderDetailVC * vc = [[JHSendOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForCompletion];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"paidui"]){
            JHQueueOrderDetailVC * vc = [[JHQueueOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"chongwu"]){
            JHPetOrderDetailVC * vc = [[JHPetOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForCompletion];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"seat"]){
            JHSeatOrderDetailVC * vc = [[JHSeatOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForCompletion];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([model.type isEqualToString:@"other"]){
            JHOtherOrderDetailVC * vc = [[JHOtherOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self refreshForCompletion];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - 这是进行中的点击取消订单的方法
-(void)clickToCancel:(JHOrderBtn *)sender{
//    switch (sender.tag) {
//        case 0:
//            NSLog(@"点击帮我送的取消");
//            break;
//        case 1:
//            NSLog(@"点击帮我买的取消");
//            break;
//        case 2:
//            NSLog(@"点击代排队的取消");
//            break;
//        case 3:
//            NSLog(@"点击宠物照顾的取消");
//            break;
//        case 4:
//            NSLog(@"点击餐馆占座的取消");
//            break;
//        case 5:
//            NSLog(@"点击其他的取消");
//            break;
//        default:
//            break;
//    }
    SHOW_HUD
    JHRunModel * model = Continue_array[sender.myTag];
    [self cancelOrderWithOrder_id:model.order_id withRow:sender.myTag];

}
#pragma mark - 这是进行中的点击去支付的按钮
-(void)clickToPay:(JHOrderBtn *)sender{
//    switch (sender.tag) {
//        case 0:
//            NSLog(@"点击帮我送");
//            break;
//        case 1:
//            NSLog(@"点击帮我买");
//            break;
//        case 2:
//            NSLog(@"点击代排队");
//            break;
//        case 3:
//            NSLog(@"点击宠物照顾");
//            break;
//        case 4:
//            NSLog(@"点击餐馆占座");
//            break;
//        case 5:
//            NSLog(@"点击其他");
//            break;
//        default:
//            break;
//    }
    JHRunModel * model = Continue_array[sender.myTag];
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount =model.amount;
        //[NSString stringWithFormat:@"%ld", [model.danbao_amount integerValue] + [model.paotui_amount integerValue]];
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
               [self refreshForContinue];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"补差价", nil)]){
        NSLog(@"点击的是补差价的方法");
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.chajia;
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
    else{
        NSLog(@"点击的是取消订单");
        SHOW_HUD
        [self cancelOrderWithOrder_id:model.order_id withRow:sender.myTag];
    }
    
}
#pragma mark - 这是发送取消订单的请求
-(void)cancelOrderWithOrder_id:(NSString *)order_id withRow:(NSInteger)row{
    isCancel = YES;
    [HttpTool postWithAPI:@"client/order/cancel" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
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

//#pragma mark - 这是已完成点击删除订单的方法
//-(void)clickToRemove:(UIButton *)sender{
//    switch (sender.tag) {
//        case 0:
//            NSLog(@"点击帮我送的删除");
//            break;
//        case 1:
//             NSLog(@"点击帮我买的删除");
//            break;
//        case 2:
//             NSLog(@"点击代排队的删除");
//            break;
//        case 3:
//             NSLog(@"点击宠物照顾的删除");
//            break;
//        case 4:
//             NSLog(@"点击餐馆占座的删除");
//            break;
//        case 5:
//             NSLog(@"点击其他的删除");
//            break;
//        default:
//            break;
//    }
//}
#pragma mark - 这是已完成点击去评价的方法
-(void)clickToEvaluate:(JHOrderBtn *)sender{
    JHRunModel * model = completion_array[sender.myTag];
//    switch (sender.tag) {
//        case 0:
//            NSLog(@"点击帮我送的评价");
//            break;
//        case 1:
//            NSLog(@"点击帮我买的评价");
//            break;
//        case 2:
//            NSLog(@"点击代排队的评价");
//            break;
//        case 3:
//            NSLog(@"点击宠物照顾的评价");
//            break;
//        case 4:
//            NSLog(@"点击餐馆占座的评价");
//            break;
//        case 5:
//            NSLog(@"点击其他的评价");
//            break;
//        default:
//            break;
//    }
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]) {
        JHPersonEvaluationVC * vc = [[JHPersonEvaluationVC alloc]init];
        vc.order_id = model.order_id;
        vc.number = model.jifen;
        vc.isTuan = NO;
        vc.personEvaluationSuccess = ^{
            [self refreshForCompletion];
        };
        [self.navigationController pushViewController:vc animated:YES];
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
#pragma mark - 这是加载已完成的方法
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

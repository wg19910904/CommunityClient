//
//  JHOrderForCenter.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHOrderForCenter.h"
#import <Masonry.h>
#import "JHTakeawayViewController.h"
#import "JHOrderTableViewCell.h"
#import "OrderModel.h"
#import "JHWMPayOrderVC.h"
#import "JHRunOederListViewController.h"
#import "JHHouseKeepListVC.h"
#import "JHUpKeepListVCViewController.h"
#import "TakeawayTableViewCellOne.h"
#import "JHUPKeepOrderListCell.h"
#import "JHRunTableViewCell.h"
#import "JHRunTableViewCellOther.h"
#import "JHRunPetTableViewCell.h"
#import "JHSeatTableViewCell.h"
#import "JHRunOtherTableViewCell.h"
#import "JHHouseOrderListCell.h"
#import "JHOrderDetailViewController.h"
#import "JHGrounpDetailController.h"
#import "JHBuyOrderDetailViewController.h"
#import "JHSendOrderDetailVC.h"
#import "JHOtherOrderDetailVC.h"
#import "JHPetOrderDetailVC.h"
#import "JHQueueOrderDetailVC.h"
#import "JHSeatOrderDetailVC.h"
#import "JHHouseOrderDeatailVC.h"
#import "JHUpKeepOrderDetailVC.h"
#import "JHGroupListController.h"
#import <MJRefresh.h>
#import "DSToast.h"
 
#import "JHTakeyawayModel.h"
#import "JHRunModel.h"
#import "JHGroupModel.h"
#import "JHHouseModel.h"
#import "JHUpkeepModel.h"
#import "JHAllCell.h"
#import "JHShopEvaluationVC.h"
#import "JHGroupListTableViewCell.h"
#import "JHPersonEvaluationVC.h"
#import "JHPrivilegeListVC.h"
#import "JHPrivilegeListCell.h"
#import "JHPrivilegeListModel.h"
#import "JHPrivilegedDetailVC.h"
@interface JHOrderForCenter ()<UITableViewDelegate,UITableViewDataSource>
{
UITableView * myTableView_all;//指向显示订单的表
MJRefreshNormalHeader * _header;//全部订单的下拉刷新
MJRefreshAutoNormalFooter * _footer;//全部订单的上拉加载
DSToast * toast;
int page_num;
NSMutableArray * infoArray;
NSMutableArray * typeArray;
BOOL  isFirst;
BOOL isCancel;
}
@end
@implementation JHOrderForCenter
- (void)viewDidLoad {
    [super viewDidLoad];
   
    if ([self.type integerValue] == 1) {
        self.navigationItem.title = NSLocalizedString(@"待付款", nil);
    }else if([self.type integerValue] == 2){
        self.navigationItem.title = NSLocalizedString(@"待评价", nil);
    }else if([self.type integerValue] == 3){
        self.navigationItem.title = NSLocalizedString(@"已取消", nil);
    }
    infoArray = [NSMutableArray array];
    typeArray = [NSMutableArray array];
    page_num = 1;
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    //创建表
    [self creatUITableView];
    SHOW_HUD
    //创建请求
    [self postHttpWithPage:[NSString stringWithFormat:@"%d",page_num] withType:self.type];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page withType:(NSString *)typ{
    NSDictionary * dic = @{@"page":page, @"type":typ};
    [HttpTool postWithAPI:@"client/member/order/items_all" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSArray * tempArray = json[@"data"][@"orders"];
            for (NSDictionary * dic in tempArray) {
                NSString * type = nil;
                if ([dic[@"from"] isEqualToString:@"paotui"]||[dic[@"from"] isEqualToString:@"tuan"]) {
                    type = dic[@"order"][@"type"];
                }else if([dic[@"from"] isEqualToString:@"house"]||[dic[@"from"] isEqualToString:@"weixiu"]||([dic[@"from"] isEqualToString:@"waimai"]&&[dic[@"online_pay"] isEqualToString:@"1"])|| [dic[@"from"] isEqualToString:@"maidan"]){
                    type = dic[@"from"];
                }
                if (type == nil) {
                    
                }else{
                    [typeArray addObject:type];
                }
            }
            NSLog(@"%@",typeArray);
            if (tempArray.count == 0 && [page intValue] > 1) {
                [self creatWithMessage:NSLocalizedString(@"亲,没有更多数据了", nil)];
                [_footer endRefreshing];
                return ;
            }
            for (NSDictionary * dic in tempArray) {
                NSObject * model = nil;
                if ([dic[@"from"] isEqualToString:@"house"]){
                    model = [JHHouseModel creatJHHouseModelWithDictiionary:dic];
                }else if ([dic[@"from"] isEqualToString:@"weixiu"]){
                    model = [JHUpkeepModel creatJHUpkeepModelWithDictionary:dic];
                }else if ([dic[@"from"] isEqualToString:@"waimai"]&&[dic[@"online_pay"] isEqualToString:@"1"]){
                    model = [JHTakeyawayModel creatJHTakeyawayWithDictionary:dic];
                }else if ([dic[@"from"] isEqualToString:@"tuan"]){
                    model = [JHGroupModel creatJHGroupModelWithDictionary:dic];
                }else if ([dic[@"from"] isEqualToString:@"paotui"]){
                    model = [JHRunModel creatJHRunModelWithDictionry:dic];
                }else if ([dic[@"from"] isEqualToString:@"maidan"]){
                    model = [JHPrivilegeListModel shareJHPrivilegeListModelWithDictionary:dic];
                }
                if (model == nil) {
                    
                }else{
                [infoArray addObject:model];
                }
            }
            if(!isFirst){
                [self.view addSubview:myTableView_all];
                isFirst = YES;
            }
            HIDE_HUD
            if (isCancel) {
                [self creatWithMessage:NSLocalizedString(@"取消订单成功", nil)];
            }
            [myTableView_all reloadData];
            [_header endRefreshing];
            [_footer endRefreshing];
            NSLog(@"%@",infoArray);
            
        }else{
            HIDE_HUD
            if(!isFirst){
                [self.view addSubview:myTableView_all];
                isFirst = YES;
            }
            [myTableView_all reloadData];
            [_header endRefreshing];
            [_footer endRefreshing];
            [self creatUIAalertControllerWithMessage:json[@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        HIDE_HUD
        [_header endRefreshing];
        [_footer endRefreshing];
        [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
    }];
}
#pragma mark - 这是创建scrollview的方法
-(void)creatUITableView{
    
    UITableView *   myTableView = [[UITableView alloc]init];
    myTableView.frame = CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT);
    myTableView.tableFooterView = [UIView new];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView_all = myTableView;
    [myTableView_all registerClass:[JHOrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    [myTableView_all registerClass:[TakeawayTableViewCellOne class] forCellReuseIdentifier:@"cell1"];
    [myTableView_all registerClass:[JHRunTableViewCell class] forCellReuseIdentifier:@"cell2"];
    [myTableView_all registerClass:[JHRunTableViewCellOther class] forCellReuseIdentifier:@"cell3"];
    [myTableView_all registerClass:[JHRunPetTableViewCell class] forCellReuseIdentifier:@"cell4"];
    [myTableView_all registerClass:[JHSeatTableViewCell class] forCellReuseIdentifier:@"cell5"];
    [myTableView_all registerClass:[JHRunOtherTableViewCell class] forCellReuseIdentifier:@"cell6"];
    [myTableView_all registerClass:[JHHouseOrderListCell class] forCellReuseIdentifier:@"cell7"];
    [myTableView_all registerClass:[JHUPKeepOrderListCell class] forCellReuseIdentifier:@"cell8"];
    [myTableView_all registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell0"];
    [myTableView_all registerClass:[JHGroupListTableViewCell class] forCellReuseIdentifier:@"cell10"];
    [myTableView_all registerClass:[JHPrivilegeListCell class] forCellReuseIdentifier:@"cell11"];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRfresh)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您刷新中", nil) forState:MJRefreshStateRefreshing];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    myTableView_all.mj_header = _header;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
    [_footer setTitle:@""forState:MJRefreshStateIdle];//普通闲置状态
    [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
            myTableView_all.mj_footer = _footer;
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
#pragma mark - 这是表的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   if (infoArray.count == 0){
        return 1;
   }else{
        return infoArray.count;
        }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        if (infoArray.count == 0) {
            return HEIGHT - (NAVI_HEIGHT+55) - 49;
        }else{
            NSString * type = typeArray[indexPath.row];
            if ([type isEqualToString:@"waimai"]||[type isEqualToString:@"quan"]||[type isEqualToString:@"tuan"]){
                return 175;
            }else if ([type isEqualToString:@"song"]){
                return 240;
            }else if ([type isEqualToString:@"maidan"]){
                return 170;
            }
            else{
                return 200;
            }
            
        }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (infoArray.count == 0) {
            JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            NSString * type = typeArray[indexPath.row];
            if ([type isEqualToString:@"waimai"]) {
                TakeawayTableViewCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
                JHTakeyawayModel * model = infoArray[indexPath.row];
                cell.model = model;
                cell.btn.tag = indexPath.row;
                cell.btn.myType = 0;
                [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.cancelBtn addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                cell.cancelBtn.tag = indexPath.row;
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }else if ([type isEqualToString:@"tuan"]||[type isEqualToString:@"quan"]){
                JHGroupListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell10" forIndexPath:indexPath];
                JHGroupModel * model = infoArray[indexPath.row];
                cell.model = model;
                cell.btn.tag = indexPath.row;
                [cell.btn addTarget:self action:@selector(groupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.cancelBtn addTarget:self action:@selector(groupClickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                cell.cancelBtn.tag = indexPath.row;
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else if ([type isEqualToString:@"buy"]){
                //帮我买
                JHOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                JHRunModel * model = infoArray[indexPath.row];
                cell.btn_cancel.tag = 1;
                cell.btn_pay.tag = 1;
                cell.btn_pay.myTag = indexPath.row;
                cell.btn_cancel.myTag = indexPath.row;
                cell.model = model;
                [cell.btn_cancel addTarget:self action:@selector(runClickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_pay addTarget:self action:@selector(runClickToPay:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                
            }else if ([type isEqualToString:@"song"]){
                //帮我送
                JHRunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
                JHRunModel * model = infoArray[indexPath.row];
                cell.btn_cancel.myTag = indexPath.row;
                cell.model = model;
                cell.btn_cancel.tag = 0;
                cell.btn_pay.tag = 0;
                cell.btn_pay.myTag = indexPath.row;
                [cell.btn_cancel addTarget:self action:@selector(runClickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_pay addTarget:self action:@selector(runClickToPay:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if ([type isEqualToString:@"paidui"]){
                //代排队
                JHRunTableViewCellOther * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
                JHRunModel * model = infoArray[indexPath.row];
                cell.btn_cancel.myTag = indexPath.row;
                cell.model = model;
                cell.btn_cancel.tag = 2;
                cell.btn_pay.tag = 2;
                cell.btn_pay.myTag = indexPath.row;
                [cell.btn_cancel addTarget:self action:@selector(runClickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_pay addTarget:self action:@selector(runClickToPay:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                
            }else if ([type isEqualToString:@"chongwu"]){
                //宠物照顾
                JHRunPetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
                JHRunModel * model = infoArray[indexPath.row];
                cell.btn_cancel.myTag = indexPath.row;
                cell.model = model;
                cell.btn_cancel.tag = 3;
                cell.btn_pay.tag = 3;
                cell.btn_pay.myTag = indexPath.row;
                [cell.btn_cancel addTarget:self action:@selector(runClickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_pay addTarget:self action:@selector(runClickToPay:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                
            }else if ([type isEqualToString:@"seat"]){
                //餐馆占座
                JHSeatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
                JHRunModel * model = infoArray[indexPath.row];
                cell.model = model;
                cell.btn_cancel.tag = 4;
                cell.btn_pay.tag = 4;
                cell.btn_pay.myTag = indexPath.row;
                cell.btn_cancel.myTag = indexPath.row;
                [cell.btn_cancel addTarget:self action:@selector(runClickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_pay addTarget:self action:@selector(runClickToPay:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if ([type isEqualToString:@"other"]){
                //其他
                JHRunOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell6" forIndexPath:indexPath];
                JHRunModel * model = infoArray[indexPath.row];
                cell.btn_cancel.tag = 5;
                cell.btn_pay.tag = 5;
                cell.btn_pay.myTag = indexPath.row;
                cell.btn_cancel.myTag = indexPath.row;
                cell.model = model;
                [cell.btn_cancel addTarget:self action:@selector(runClickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_pay addTarget:self action:@selector(runClickToPay:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if ([type isEqualToString:@"house"]){
                JHHouseOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell7" forIndexPath:indexPath];
                JHHouseModel * model = infoArray[indexPath.row];
                cell.model = model;
                cell.btn_cancel.tag = indexPath.row;
                //点击取消订单
                [cell.btn_cancel addTarget:self action:@selector(houseClickToCancel:) forControlEvents:UIControlEventTouchUpInside];
                //去支付
                cell.btn_pay.tag = indexPath.row;
                [cell.btn_pay addTarget:self action:@selector(houseClickToPay:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if ([type isEqualToString:@"maidan"]){
                JHPrivilegeListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell11" forIndexPath:indexPath];
                JHPrivilegeListModel * model = infoArray[indexPath.row];
                cell.model = model;
                cell.btn_cancel.tag = indexPath.row;
                //点击取消订单
                [cell.btn_cancel addTarget:self action:@selector(clickToCancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                //去支付/评价
                cell.btn_evalute.tag = indexPath.row;
                [cell.btn_evalute addTarget:self action:@selector(clickToPayOrEvaluate:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            else{
                JHUPKeepOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell8" forIndexPath:indexPath];
                JHUpkeepModel * model = infoArray[indexPath.row];
                cell.model = model;
                cell.btn_cancel.tag = indexPath.row;
                //点击取消订单
                [cell.btn_cancel addTarget:self action:@selector(upkeepClickToCancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                //去支付
                cell.btn_pay.tag = indexPath.row;
                [cell.btn_pay addTarget:self action:@selector(upkeepClickToPay:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString * type = typeArray[indexPath.row];
        if([type isEqualToString:@"tuan"]||[type isEqualToString:@"quan"]){
            //团购和劵
            JHGroupModel * model = infoArray[indexPath.row];
            JHGrounpDetailController * vc = [[JHGrounpDetailController alloc]init];
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];

            vc.order_id = model.order_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"waimai"]){
            JHTakeyawayModel * model = infoArray[indexPath.row];
            //外卖
            JHOrderDetailViewController * vc = [[JHOrderDetailViewController alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBloack:^{
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"buy"]){
            //帮我买
            JHRunModel * model = infoArray[indexPath.row];
            JHBuyOrderDetailViewController * vc = [[JHBuyOrderDetailViewController alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"song"]){
            //帮我送
            JHRunModel * model = infoArray[indexPath.row];
            JHSendOrderDetailVC * vc = [[JHSendOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"paidui"]){
            //代排队
            JHRunModel * model = infoArray[indexPath.row];
            JHQueueOrderDetailVC * vc = [[JHQueueOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"chongwu"]){
            //宠物照顾
            JHRunModel * model = infoArray[indexPath.row];
            JHPetOrderDetailVC * vc = [[JHPetOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"seat"]){
            //餐馆占座
            JHRunModel * model = infoArray[indexPath.row];
            JHSeatOrderDetailVC * vc = [[JHSeatOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"other"]){
            //其他
            JHRunModel * model = infoArray[indexPath.row];
            JHOtherOrderDetailVC * vc = [[JHOtherOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"house"]){
            //家政
            JHHouseModel * model = infoArray[indexPath.row];
            JHHouseOrderDeatailVC * vc = [[JHHouseOrderDeatailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"maidan"]){
            JHPrivilegeListModel * model = infoArray[indexPath.row];
            JHPrivilegedDetailVC * vc = [[JHPrivilegedDetailVC alloc]init];
            vc.order_id = model.order_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            //维修
            JHUpkeepModel * model = infoArray[indexPath.row];
            JHUpKeepOrderDetailVC * vc = [[JHUpKeepOrderDetailVC alloc]init];
            vc.order_id = model.order_id;
            [vc setMyBlock:^(void){
                [self downRfresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
#pragma mark - 这是外卖点击去支付还是去评价的按钮点击方法
-(void)btnClick:(JHOrderBtn *)sender{
    NSLog(@"点击了按钮%ld",(long)sender.tag);
    JHTakeyawayModel * model = infoArray[sender.tag];
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        NSLog(@"点击了去支付的按钮");
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.amount;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self downRfresh];
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
 
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"确认完成", nil)]){
        [HttpTool postWithAPI:@"client/order/confirm" withParams:@{@"order_id":model.order_id} success:^(id json) {
            NSLog(@"%@==%@",json[@"message"],model.order_id);
            if ([json[@"error"] isEqualToString:@"0"]) {
                HIDE_HUD
                [self downRfresh];
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
//        vc.isZiti = [model.pei_type integerValue] == 3 ? YES : NO;
        vc.shopEvaluationSuccess = ^{
            [self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击了取消订单的按钮");
    }
    else{
        
    }
}
#pragma mark - 这是外卖在待支付状态下点击取消的按钮调用的方法
-(void)clickToCancel:(UIButton *)sender{
    NSLog(@"你点击了取消订单");
    SHOW_HUD
    JHTakeyawayModel * model = infoArray[sender.tag];
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
            [self downRfresh];
        }else{
            [self creatUIAalertControllerWithMessage:json[@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器失败", nil)];
    }];
}
#pragma mark - 这是跑腿的点击取消订单的方法
-(void)runClickToCancel:(JHOrderBtn *)sender{
    SHOW_HUD
    JHRunModel * model = infoArray[sender.myTag];
    [self cancelOrderWithOrder_id:model.order_id withRow:sender.myTag];
}
#pragma mark - 这是跑腿点击去支付的按钮
-(void)runClickToPay:(JHOrderBtn *)sender{
    JHRunModel * model = infoArray[sender.myTag];
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount =  [NSString stringWithFormat:@"%.2f", [model.danbao_amount floatValue] + [model.paotui_amount floatValue]];
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self downRfresh];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"确认完成", nil)]){
        [HttpTool postWithAPI:@"client/order/confirm" withParams:@{@"order_id":model.order_id} success:^(id json) {
            NSLog(@"%@==%@",json[@"message"],model.order_id);
            if ([json[@"error"] isEqualToString:@"0"]) {
                [self downRfresh];
            }else{
                [self creatUIAalertControllerWithMessage:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
            NSLog(@"%@",error.localizedDescription);
        }];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"补差价", nil)]){
        NSLog(@"点击的是补差价的方法");

        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount =model.chajia;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                 [self downRfresh];
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]) {
        JHPersonEvaluationVC * vc = [[JHPersonEvaluationVC alloc]init];
        vc.order_id = model.order_id;
        vc.number = model.jifen;
        vc.isTuan = NO;
        vc.personEvaluationSuccess = ^{
            [self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        NSLog(@"点击的是取消订单");
        SHOW_HUD
        [self cancelOrderWithOrder_id:model.order_id withRow:sender.myTag];
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
}
#pragma mark - 这是买单的取消的方法
-(void)clickToCancelOrder:(UIButton *)sender{
    JHPrivilegeListModel * model = infoArray[sender.tag];
   [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
}
#pragma mark - 这是买单点击支付还是评价的方法
-(void)clickToPayOrEvaluate:(UIButton *)sender{
    JHPrivilegeListModel * model = nil;
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        NSLog(@"点击了去支付的按钮");
        model = infoArray[sender.tag];
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.amount;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
               [self downRfresh];
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        NSLog(@"点击了去评价的按钮");
        model = infoArray[sender.tag];
        JHPersonEvaluationVC * vc = [JHPersonEvaluationVC new];
        vc.isTuan = YES;
        vc.number = model.jifen;
        vc.order_id = model.order_id;
        vc.personEvaluationSuccess = ^{
            [self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        model = infoArray[sender.tag];
        NSLog(@"点击了取消订单的按钮");
       [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
    }
    else{
        NSLog(@"点击了已评价的按钮");
    }
    
}

#pragma mark - 这是团购点击去支付还是去评价的按钮点击方法
-(void)groupBtnClick:(UIButton *)sender{
    NSLog(@"点击了按钮%ld",(long)sender.tag);
    JHGroupModel * model = infoArray[sender.tag];
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        NSLog(@"点击了去支付的按钮");
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.total_price;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self downRfresh];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        NSLog(@"点击了去评价的按钮");
        JHPersonEvaluationVC * vc = [JHPersonEvaluationVC new];
        vc.isTuan = YES;
        vc.number = model.jifen;
        vc.order_id = model.order_id;
        vc.personEvaluationSuccess = ^{
            [self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"点击了已评价的按钮");
    }
}
#pragma mark - 这是团购点击取消的方法
-(void)groupClickToCancel:(UIButton *)sender{
    NSLog(@"点击的是取消订单的方法");
    SHOW_HUD
    JHGroupModel * model = infoArray[sender.tag];
    [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
}
#pragma mark - 这是家政点击取消订单的方法
-(void)houseClickToCancel:(UIButton *)sender{
    NSLog(@"这是点击取消订单的方法");
    JHHouseModel * model = infoArray[sender.tag];
    SHOW_HUD
    [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
}
#pragma mark - 这是家政点击去支付的方法
-(void)houseClickToPay:(UIButton *)sender{
    NSLog(@"这是点击去支付的方法");
    JHHouseModel * model = infoArray[sender.tag];
    if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]){
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.danbao_amount;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                 [self downRfresh];
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"补差价", nil)]){
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.chajia;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self downRfresh];
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"确认完成", nil)]){
        model = infoArray[sender.tag];
        [HttpTool postWithAPI:@"client/order/confirm" withParams:@{@"order_id":model.order_id} success:^(id json) {
            NSLog(@"%@==%@",json[@"message"],model.order_id);
            if ([json[@"error"] isEqualToString:@"0"]) {
                [self downRfresh];
                HIDE_HUD
            }else{
                [self creatUIAalertControllerWithMessage:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
            NSLog(@"%@",error.localizedDescription);
        }];
    }

    else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        JHPersonEvaluationVC * vc = [[JHPersonEvaluationVC alloc]init];
        vc.order_id = model.order_id;
        vc.number = model.jifen;
        vc.isTuan = NO;
        vc.personEvaluationSuccess = ^{
            [self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击的是取消订单");
        SHOW_HUD
        [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
    }else{
        
    }
}

#pragma mark - 这是维修点击取消订单的方法
-(void)upkeepClickToCancelOrder:(UIButton *)sender{
    NSLog(@"这是点击取消订单的方法");
    SHOW_HUD
    JHUpkeepModel * model = infoArray[sender.tag];
    [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
}
#pragma mark - 这是维修点击去支付的方法
-(void)upkeepClickToPay:(UIButton *)sender{
    NSLog(@"这是点击去支付的方法");
    JHUpkeepModel * model = infoArray[sender.tag];
    if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]){
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.danbao_amount;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self downRfresh];
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"确认完成", nil)]){
        model = infoArray[sender.tag];
        [HttpTool postWithAPI:@"client/order/confirm" withParams:@{@"order_id":model.order_id} success:^(id json) {
            NSLog(@"%@==%@",json[@"message"],model.order_id);
            if ([json[@"error"] isEqualToString:@"0"]) {
                [self downRfresh];
                HIDE_HUD
            }else{
                [self creatUIAalertControllerWithMessage:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
            NSLog(@"%@",error.localizedDescription);
        }];
    }
    else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"补差价", nil)]){
        NSLog(@"点击的是补差价");
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.chajia;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self downRfresh];
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        JHPersonEvaluationVC * vc = [[JHPersonEvaluationVC alloc]init];
        vc.order_id = model.order_id;
        vc.number = model.jifen;
        vc.isTuan = NO;
        vc.personEvaluationSuccess = ^{
            [self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击的是取消订单");
        SHOW_HUD
        [self cancelOrderWithOrder_id:model.order_id withRow:sender.tag];
    }else{
        
    }
}
#pragma mark - 这是下拉刷新的方法
-(void)downRfresh{
    SHOW_HUD
    [infoArray removeAllObjects];
    [typeArray removeAllObjects];
    page_num = 1;
    //创建请求
    [self postHttpWithPage:[NSString stringWithFormat:@"%d",page_num] withType:self.type];
}
#pragma mark - 这是上拉加载
-(void)upRefresh{
    page_num ++;
    //创建请求
    [self postHttpWithPage:[NSString stringWithFormat:@"%d",page_num] withType:self.type];
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

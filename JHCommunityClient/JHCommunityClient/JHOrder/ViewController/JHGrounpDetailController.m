//
//  JHGrounpDetailController.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGrounpDetailController.h"
#import "JHGroupTableViewCellOne.h"
#import "JHGroupTableViewCellTwo.h"
#import "JHGroupTableViewCellThree.h"
#import "JHGroupTableViewCellFour.h"
#import <MJRefresh.h>
 
#import "JHGroupDetailModel.h"
#import "JHTuanGouProductDetailVC.h"
#import "JHPEvaluateVC.h"
#import "JHGroupCellLast.h"
#import "JHPathMapVC.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHWMPayOrderVC.h"
#import "JHPersonEvaluationVC.h"
#import "JHGroupListController.h"
@interface JHGrounpDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTableView;//表格
    MJRefreshNormalHeader * _header;//下拉刷新
    JHGroupDetailModel * detailModel;
    BOOL isFirst;
    NSArray * detailArray;
    UIButton * btn_evaluate;
    UIBarButtonItem * rightItem;
    BOOL isTuanVC;

}
@end
@implementation JHGrounpDetailController

//重写返回的方法
-(void)clickBackBtn{
    NSArray<JHBaseVC *>*vcArray = self.navigationController.viewControllers;
    for (JHBaseVC *obj in vcArray) {
        if([obj isKindOfClass:[JHGroupListController class]]){
             isTuanVC = YES;
            [self.navigationController popToViewController:obj animated:YES];
            
        }else if ([obj isKindOfClass:[JHTuanGouProductDetailVC class]]){
            isTuanVC = YES;
            [self.navigationController popToViewController:obj animated:YES];
        }
        
    }
    if (!isTuanVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = NSLocalizedString(@"订单详情", nil);
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    //创建表视图
    [self creatTableView];
    SHOW_HUD
    //发送请求
    [self postHttp];
}
#pragma mark - 这是评价后可以查看评价法的按钮
-(void)creatSeeEvaluateBtn{
    if (btn_evaluate == nil) {
        btn_evaluate = [[UIButton alloc]init];
         btn_evaluate.frame = FRAME(0, HEIGHT - 50, WIDTH, 50);
        btn_evaluate.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn_evaluate addTarget:self action:@selector(clickToSeeEvaluate:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_evaluate];
    }
    if([detailModel.order_status intValue] == 0 && [detailModel.pay_status intValue] == 0){
         btn_evaluate.hidden = NO;
        [btn_evaluate setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
        [btn_evaluate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [btn_evaluate setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
        myTableView.frame = CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50);
        
    }else if ([detailModel.order_status intValue] == 0){
         btn_evaluate.hidden = NO;
        [btn_evaluate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_evaluate setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
       [btn_evaluate setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
        myTableView.frame = CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50);
        
    }else if ([detailModel.order_status intValue] == 8 && [detailModel.comment_status intValue] == 0){
       btn_evaluate.hidden = NO;
       [btn_evaluate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_evaluate setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        [btn_evaluate setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
        myTableView.frame = CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50);
    }
    else if ([detailModel.order_status integerValue] == 8 && [detailModel.comment_status integerValue] == 1) {
        
        [btn_evaluate setTitle:NSLocalizedString(@"查看评价", nil) forState:UIControlStateNormal];
        [btn_evaluate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_evaluate.hidden = NO;
       [btn_evaluate setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
        myTableView.frame = CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50);
    }else{
        btn_evaluate.hidden = YES;
        myTableView.frame = CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT);
    }
    if (rightItem == nil) {
        rightItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickToBackMoney:)];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
    }
    if([detailModel.order_status isEqualToString:@"5"]){
        self.navigationItem.rightBarButtonItem = rightItem;
        rightItem.title = NSLocalizedString(@"申请退款", nil);
    }else if([detailModel.order_status intValue] == 0 && [detailModel.pay_status intValue] == 0){
        self.navigationItem.rightBarButtonItem = rightItem;
        rightItem.title = NSLocalizedString(@"取消订单", nil);
    }
    else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
#pragma mark - 这是点击申请退款的按钮
-(void)clickToBackMoney:(UIBarButtonItem *)sender{
    if ([sender.title isEqualToString:NSLocalizedString(@"申请退款", nil)]) {
        SHOW_HUD
       NSLog(@"点击申请退款");
        [HttpTool postWithAPI:@"client/tuan/order/cancel" withParams:@{@"order_id":detailModel.order_id} success:^(id json) {
            if ([json[@"error"] isEqualToString:@"0"]) {
                HIDE_HUD
                [self creatUIAlertControlWithMessage:NSLocalizedString(@"退款成功", nil)];
                if (self.myBlock) {
                    self.myBlock();
                }
                
            }else{
                HIDE_HUD
                [self creatUIAlertControlWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }];

    }else{
        NSLog(@"取消订单");
        [self clickToCancel];
    }
}
#pragma maek - 这是点击取消订单的方法
-(void)clickToCancel{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/order/cancel" withParams:@{@"order_id":detailModel.order_id} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            HIDE_HUD
            //刷新数据
            [self downRefresh];
            if (self.myBlock) {
                self.myBlock();
            }
        }else{
            HIDE_HUD
            [self creatUIAlertControlWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error:%@",error.localizedDescription);
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
    }];

}
#pragma mark - 这是点击进入查看评价的方法
-(void)clickToSeeEvaluate:(UIButton *)sender{
    NSLog(@"查看评价");
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"查看评价", nil)]) {
        JHPEvaluateVC * vc  = [[JHPEvaluateVC alloc]init];
        vc.order_id = detailModel.order_id;
        vc.isTuan = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]){

        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = detailModel.order_id;
        vc.amount = detailModel.amount;
        vc.isDetailVC = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self downRefresh];
                if (self.myBlock) {
                    self.myBlock();
                }
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        JHPersonEvaluationVC * vc = [JHPersonEvaluationVC new];
        vc.isTuan = YES;
        vc.number = detailModel.jifen;
        vc.order_id = detailModel.order_id;
        vc.personEvaluationSuccess = ^{
            [self downRefresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 这是订单详情发送的情况
-(void)postHttp{
    NSDictionary * dic = @{@"order_id":self.order_id};
    [HttpTool postWithAPI:@"client/member/order/detail" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSDictionary * dic = json[@"data"][@"order"];
            detailModel = [JHGroupDetailModel creatJHGroupDetailModelWithDictionary:dic];
            if (!isFirst) {
                [self.view addSubview:myTableView];
                isFirst = YES;
            }
            detailArray = @[[NSString stringWithFormat:NSLocalizedString(@"订单号:%@", nil),detailModel.order_id],
                           [NSString stringWithFormat:NSLocalizedString(@"购买手机号 : %@", nil),detailModel.mobile],
                           [NSString stringWithFormat:NSLocalizedString(@"付款时间 : %@", nil),detailModel.pay_time],
                           [NSString stringWithFormat:NSLocalizedString(@"数量 : %@", nil),detailModel.tuan_number],
                            [NSString stringWithFormat:NSLocalizedString(@"优惠劵抵扣 : -¥ %@",nil),detailModel.coupon],
                            [NSString stringWithFormat:NSLocalizedString(@"红包抵扣 : -¥ %@", nil),detailModel.hongbao],
                           [NSString stringWithFormat:NSLocalizedString(@"总价 : ¥%@", nil),detailModel.amount]];

            //创建查看评价的方法
            [self creatSeeEvaluateBtn];
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
#pragma mark - 创建表视图
-(void)creatTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
//  [self.view addSubview:myTableView];
    myTableView.tableFooterView = [UIView new];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];                            
    [myTableView registerClass:[JHGroupTableViewCellOne class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[JHGroupTableViewCellTwo class] forCellReuseIdentifier:@"cell1"]; 
    [myTableView registerClass:[JHGroupTableViewCellThree class] forCellReuseIdentifier:@"cell2"];
    [myTableView registerClass:[JHGroupTableViewCellFour class] forCellReuseIdentifier:@"cell4"];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell3"];
     [myTableView registerClass:[JHGroupCellLast class] forCellReuseIdentifier:@"cell0"];
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
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11+detailModel.modelArray.count + 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else if(indexPath.row == 1){
        return 50;
    }else if (indexPath.row>1 &&indexPath.row <= detailModel.modelArray.count+1){
        return 30;
    }
    else if (indexPath.row == detailModel.modelArray.count+2&&[detailModel.pay_status isEqualToString:@"0"]){
        return 15;
    }else if(indexPath.row == detailModel.modelArray.count+2){
        return 195;
    }
    else if(indexPath.row == detailModel.modelArray.count+4){
        return 15;
    }
    else if (indexPath.row == detailModel.modelArray.count+3){
        return 120;
    }else{
        return 40;
    }
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JHGroupTableViewCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.model = detailModel;
        return cell;
    }else if (indexPath.row == 1){
        JHGroupTableViewCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.model = detailModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row>1 &&indexPath.row <= detailModel.modelArray.count+1){
        JHGroupTableViewCellFour * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.model = detailModel;
        return cell;
    }else if (indexPath.row == detailModel.modelArray.count+2){
        JHGroupCellLast * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        cell.model = detailModel;
        return cell;
    }
    else if ( indexPath.row == detailModel.modelArray.count+4){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView * view = [cell viewWithTag:1000];
        [view removeFromSuperview];
        view = nil;
        //创建分割线
        UIView * label_line = [[UIView alloc]init];
        label_line.tag = 1000;
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        label_line.frame = FRAME(0, 14.5, WIDTH, 0.5);
        [cell addSubview:label_line];
        return cell;
    }else if (indexPath.row == detailModel.modelArray.count+3){
        JHGroupTableViewCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.model = detailModel;
        [cell.btnCall addTarget:self action:@selector(clickToCall) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        {
            static NSString * idenfifer = @"cell8";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfifer];
            }
            if (indexPath.row == detailModel.modelArray.count+5) {
                cell.textLabel.text = NSLocalizedString(@"订单详情", nil);
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            } else{
                cell.textLabel.text = detailArray[indexPath.row - detailModel.modelArray.count - 6];
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
            }
            UIView * view = [cell viewWithTag:100];
            [view removeFromSuperview];
            view = nil;
            //添加一个分割线
            UIView * label = [[UIView alloc]init];
            label.frame = FRAME(0, 39.5, WIDTH, 0.5);
            label.tag = 100;
            label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        JHTuanGouProductDetailVC * vc = [[JHTuanGouProductDetailVC alloc]init];
        vc.titleString = detailModel.tuan_title;
        vc.tuan_id = detailModel.tuan_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == detailModel.modelArray.count+3){
        JHPathMapVC * mapVC = [[JHPathMapVC alloc]init];
        mapVC.lat = detailModel.lat;
        mapVC.lng = detailModel.lng;
        NSLog(@"%@,%@",mapVC.lat,mapVC.lng);
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}
#pragma mark - 这是点击打电话的方法
-(void)clickToCall{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:detailModel.shopMobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击取消
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"呼叫", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击呼叫
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",detailModel.shopMobile]]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    [self postHttp];
}
#pragma mark - 创建提示框
-(void)creatUIAlertControlWithMessage:(NSString *)msg{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clickBackBtn];
//        if ([msg isEqualToString:NSLocalizedString(@"退款成功", nil)]) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end

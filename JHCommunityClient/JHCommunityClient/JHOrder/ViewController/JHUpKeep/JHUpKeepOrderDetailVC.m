//
//  JHUpKeepOrderDetailVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHUpKeepOrderDetailVC.h"
#import "JHUPKeepOrderDetailCellOne.h"
#import "JHUPKeepOrderDetailCellTwo.h"
#import "JHUPKeepOrderDetailCellThree.h"
#import "JHUPKeepOrderDetailCellFour.h"
#import "JHUPKeepOrderDetailCellFive.h"
#import "JHUPKeepOrderDetailCellSix.h"
#import <MJRefresh.h>
 
#import "JHUpKeepProgressModel.h"
#import "JHUpkeepDetailModel.h"
#import "JHWMPayOrderVC.h"
#import "JHShopEvaluationVC.h"
#import <AVFoundation/AVFoundation.h>
#import "JHPersonEvaluationVC.h"
#import "JHPersonComplainVC.h"
#import "JHPEvaluateVC.h"
@interface JHUpKeepOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AVAudioPlayerDelegate>
{
    UIButton * oldBtn;//指向旧的按钮
    UILabel * label_seleter;//选中的显示条
    UIScrollView * myScrollview;//创建底部的scrollview
    NSMutableArray * btnArray;//存放两个btn的
    BOOL isMove;//判断是否是滑动
    UITableView * myTableView_order;//指向订单进度的表
    UITableView * myTableView_detail;//指向订单详情的表
    float height;
     NSArray * array;//填充假数据的
    UIImageView * imageView;
    MJRefreshNormalHeader * _headerDetail;//下拉订单详情刷新需要的
    MJRefreshNormalHeader * _header;//下拉订单进度需要的
    BOOL isFirst_progress;
    BOOL isFirst_detail;
    UIButton * btn_getMore;
    JHUpkeepDetailModel * model_detail;
    JHUpKeepProgressModel * model_progress;
    BOOL isCall;
    AVAudioPlayer * _player;
    NSInteger num;
    NSArray * money_array;
    NSInteger position;
    UIButton * btn_call;
    NSString * phone;
    NSString * phone1;
}
@end
@implementation JHUpKeepOrderDetailVC

//重写返回的方法
-(void)clickBackBtn{
    if (self.isPayCome) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    btnArray = [NSMutableArray array];
    //创建头部的两个按钮
    [self creatHeaderView];
    //创建底部的view
    [self creatButtomView];
    //创建中间的Scrollview
    [self creatUIScrollView];
    SHOW_HUD
    //订单进度的请求
    [self postProgressHtttp];
}
#pragma mark 发送订单进度的请求
-(void)postProgressHtttp{
    NSDictionary * dic = @{@"order_id":self.order_id};
    [HttpTool postWithAPI:@"client/member/order/log" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            HIDE_HUD
            model_progress = [JHUpKeepProgressModel creatJHUpKeepProgressModelWithDictionary:json[@"data"][@"log"]];
            if (!isFirst_progress) {
                [myScrollview addSubview:myTableView_order];
                isFirst_progress = YES;
            }
            [self judgeBtnState:btn_getMore];
            for (int i = 0; i < model_progress.modelArray.count; i ++) {
                JHUModel * model = model_progress.modelArray[i];
                if ([model.from isEqualToString:@"staff"]) {
                    position = i +1;
                    phone = model_progress.mobile_staff;
                }else if ([model.from isEqualToString:@"shop"]){
                    position = i +1;
                    phone = model_progress.mobile_shop;
                }
            }
            [myTableView_order reloadData];
            [_header endRefreshing];
        }else{
            [self creatUIAlertControlWithMessage:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 发送订单详情的方法
-(void)postDetailHttp{
    NSDictionary * dic = @{@"order_id":self.order_id};
    [HttpTool postWithAPI:@"client/member/order/detail" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            HIDE_HUD
            model_detail = [JHUpkeepDetailModel creatJHUpkeepDetailModelWithDictionary:json[@"data"][@"order"]];
            if (!isFirst_detail) {
                [myScrollview addSubview:myTableView_detail];
                isFirst_detail = YES;
            }
            NSString * pay = nil;
            if([model_detail.order_status intValue] == 0 && [model_detail.pay_status intValue] == 0){
                pay = NSLocalizedString(@"定金(未支付)", nil);
            }else{
                pay = NSLocalizedString(@"定金(已支付)", nil);
            }
            if (([model_detail.order_status intValue] == 0&&[model_detail.staff_id integerValue] == 0)||[model_detail.order_status integerValue] == -1) {
                array = @[@"",@"",[NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),model_detail.order_id],
                          [NSString stringWithFormat:NSLocalizedString(@"联系人:%@", nil),model_detail.contact],
                          [NSString stringWithFormat:NSLocalizedString(@"联系电话:%@", nil),model_detail.mobile],
                           [NSString stringWithFormat:NSLocalizedString(@"服务类型:%@", nil),model_detail.cate_title],
                          [NSString stringWithFormat:NSLocalizedString(@"服务地址:%@", nil),model_detail.addr],
                          [NSString stringWithFormat:NSLocalizedString(@"服务时间:%@", nil),model_detail.fuwu_time],
                          [NSString stringWithFormat:NSLocalizedString(@"支付方式:%@", nil),model_detail.online_pay],@"",@"",@"",@"",
                          NSLocalizedString(@"服务人员信息", nil),NSLocalizedString(@"联系人:等待系统指派人员", nil),@"",pay];
            }else if ([model_detail.order_status integerValue] > 3){
                array = @[@"",@"",[NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),model_detail.order_id],
                          [NSString stringWithFormat:NSLocalizedString(@"联系人:%@", nil),model_detail.contact],
                          [NSString stringWithFormat:NSLocalizedString(@"联系电话:%@", nil),model_detail.mobile],
                           [NSString stringWithFormat:NSLocalizedString(@"服务类型:%@", nil),model_detail.cate_title],
                          [NSString stringWithFormat:NSLocalizedString(@"服务地址:%@", nil),model_detail.addr],
                          [NSString stringWithFormat:NSLocalizedString(@"服务时间:%@", nil),model_detail.fuwu_time],
                          [NSString stringWithFormat:NSLocalizedString(@"支付方式:%@", nil),model_detail.online_pay],@"",@"",@"",@"",
                          NSLocalizedString(@"服务人员信息", nil),
                          [NSString stringWithFormat:NSLocalizedString(@"联系人:%@", nil),model_detail.name? model_detail.name:@""],
                          [NSString stringWithFormat:NSLocalizedString(@"联系电话:%@", nil),model_detail.mobile_service? model_detail.mobile_service:@""],@"",NSLocalizedString(@"订单总额", nil),pay,[model_detail.hongbao integerValue] == 0? @"":NSLocalizedString(@"红包抵扣", nil),NSLocalizedString(@"实际支付(已付)", nil)];
                NSLog(@"%@",model_detail.jiesuan_price);
                NSInteger last_money = [model_detail.jiesuan_price integerValue] -  [model_detail.hongbao integerValue];
                NSLog(@"%ld",last_money);
                money_array = @[[NSString stringWithFormat:@"¥%@",model_detail.jiesuan_price],
                                [NSString stringWithFormat:@"¥%@",model_detail.danbao_amount],
                                [model_detail.hongbao integerValue] == 0? @"":
                                [NSString stringWithFormat:@"¥%@",model_detail.hongbao],
                                [NSString stringWithFormat:@"¥%ld",last_money]];
            }else if ([model_detail.staff_id integerValue]>0||[model_detail.order_status integerValue] == 3||[model_detail.order_status integerValue] == 5||([model_detail.order_status integerValue] == 1&&[model_detail.staff_id integerValue] > 0)){
                array = @[@"",@"",[NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),model_detail.order_id],
                          [NSString stringWithFormat:NSLocalizedString(@"联系人:%@", nil),model_detail.contact],
                          [NSString stringWithFormat:NSLocalizedString(@"联系电话:%@", nil),model_detail.mobile],
                           [NSString stringWithFormat:NSLocalizedString(@"服务类型:%@", nil),model_detail.cate_title],
                          [NSString stringWithFormat:NSLocalizedString(@"服务地址:%@", nil),model_detail.addr],
                          [NSString stringWithFormat:NSLocalizedString(@"服务时间:%@", nil),model_detail.fuwu_time],
                          [NSString stringWithFormat:NSLocalizedString(@"支付方式:%@", nil),model_detail.online_pay],@"",@"",@"",@"",
                          NSLocalizedString(@"服务人员信息", nil),
                          [NSString stringWithFormat:NSLocalizedString(@"联系人:%@", nil),model_detail.name? model_detail.name:@""],
                          [NSString stringWithFormat:NSLocalizedString(@"联系电话:%@", nil),model_detail.mobile_service? model_detail.mobile_service:@""],@"",pay];
                
            }
            phone1 = model_detail.mobile_service;
            [self judgeBtnState:btn_getMore];
            [myTableView_detail reloadData];
            [_headerDetail endRefreshing];
        }else{
            HIDE_HUD
            [self creatUIAlertControlWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [_headerDetail endRefreshing];
        NSLog(@"%@",error.localizedDescription);
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
    }];
}

#pragma mark - 创建头部的按钮
-(void)creatHeaderView{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.frame = FRAME(0, NAVI_HEIGHT, WIDTH, 40);
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME(WIDTH/2*i+0.5, 0, WIDTH/2-0.5, 40);
        [view addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            oldBtn = btn;
            [btn setTitle:NSLocalizedString(@"订单进度", nil) forState:UIControlStateNormal];
        }else{
            [btn setTitle:NSLocalizedString(@"订单详情", nil) forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:btn];
    }
    //创建底部的分割线
    UIView * label_buttom = [[UIView alloc]init];
    label_buttom.frame = FRAME(0, 39.5, WIDTH, 0.5);
    label_buttom.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:label_buttom];
    //创建选中时的绿色的显示条
    label_seleter = [[UILabel alloc]init];
    label_seleter.frame = FRAME(0, 39, WIDTH/2, 1);
    label_seleter.backgroundColor = THEME_COLOR;
    [view addSubview:label_seleter];
}
#pragma mark - 这是点击头部按钮的方法
-(void)btnChange:(UIButton *)sender{
    isMove = NO;
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    if (!isMove) {
    [UIView animateWithDuration:0.1 animations:^{
        label_seleter.frame = FRAME(WIDTH/2*sender.tag, 39, WIDTH/2, 1);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        myScrollview.contentOffset = CGPointMake(WIDTH*sender.tag, 0);
    }];
        if (sender.tag == 1) {
            if (!isFirst_detail) {
                SHOW_HUD
                [self postDetailHttp];
            }

        }
    }
}
#pragma mark - 这是创建底部的view的方法
-(void)creatButtomView{
    UIView * view = [[UIView alloc]init];
    view.frame = FRAME(0, HEIGHT - 60, WIDTH, 60);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    //创建分割线
    UIView * view_line = [[UIView alloc]init];
    view_line.frame = FRAME(0, 0, WIDTH, 0.5);
    view_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [view addSubview:view_line];
    //创建再来一单的按钮
    btn_getMore = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_getMore.frame = FRAME(WIDTH - 115, 10, 100, 40);
    [view addSubview:btn_getMore];
    btn_getMore.layer.cornerRadius  = 2;
    btn_getMore.layer.masksToBounds = YES;
    [btn_getMore addTarget:self action:@selector(clickToMore:) forControlEvents:UIControlEventTouchUpInside];
    //创建投诉的按钮
    UIButton * btn_complain = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_complain.frame = FRAME(10, 1, 60, 59);
    //btn_complain.backgroundColor = [UIColor orangeColor];
    [view addSubview:btn_complain];
    UIImageView * imageV_complain = [[UIImageView alloc]init];
    //imageV_complain.backgroundColor =[UIColor redColor];
    imageV_complain.image = [UIImage imageNamed:@"complain"];
    imageV_complain.frame = FRAME(15, 10, 25, 25);
    [btn_complain addSubview:imageV_complain];
    UILabel * label_complain = [[UILabel alloc]init];
    label_complain.frame = FRAME(0, 40, 55, 15);
    label_complain.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    label_complain.textAlignment = NSTextAlignmentCenter;
    label_complain.text = NSLocalizedString(@"投诉", nil);
    label_complain.font = [UIFont systemFontOfSize:14];
    [btn_complain addSubview:label_complain];
    [btn_complain addTarget:self action:@selector(clicktoComplain) forControlEvents:UIControlEventTouchUpInside];
    //创建中间的分割线
    UILabel * label_lineOne = [[UILabel alloc]init];
    label_lineOne.frame = FRAME(80, 10, 1, 40);
    label_lineOne.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [view addSubview:label_lineOne];
    //创建催单的按纽
    UIButton * btn_cuidan = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_cuidan.frame = FRAME(91, 1, 60, 59);
    [view addSubview:btn_cuidan];
    UIImageView * imageV_cuidan = [[UIImageView alloc]init];
    //imageV_cuidan.backgroundColor = [UIColor redColor];
    imageV_cuidan.image = [UIImage imageNamed:@"cui"];
    imageV_cuidan.frame = FRAME(15, 10, 25, 25);
    [btn_cuidan addSubview:imageV_cuidan];
    UILabel * label_cuidan = [[UILabel alloc]init];
    label_cuidan.frame = FRAME(0, 40, 55, 15);
    label_cuidan.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    label_cuidan.textAlignment = NSTextAlignmentCenter;
    label_cuidan.text = NSLocalizedString(@"催单", nil);
    label_cuidan.font = [UIFont systemFontOfSize:14];
    [btn_cuidan addSubview:label_cuidan];
    [btn_cuidan addTarget:self action:@selector(clicktoCuiDan) forControlEvents:UIControlEventTouchUpInside];
    //创建分割线
    UILabel * label_lineTwo = [[UILabel alloc]init];
    label_lineTwo.frame = FRAME(160, 10, 1, 40);
    label_lineTwo.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [view addSubview:label_lineTwo];
}
#pragma mark - 这是创建中间的滑动视图的方法
-(void)creatUIScrollView{
    myScrollview  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT+40, WIDTH, HEIGHT - NAVI_HEIGHT-60-40)];
    myScrollview.pagingEnabled = YES;
    myScrollview.bounces = NO;
    myScrollview.showsHorizontalScrollIndicator = NO;
    myScrollview.showsVerticalScrollIndicator = NO;
    myScrollview.delegate = self;
    myScrollview.contentSize = CGSizeMake(WIDTH*2, HEIGHT - NAVI_HEIGHT-60-40);
    [self.view addSubview:myScrollview];
    for (int i = 0; i<2; i++) {
        UITableView *   myTableView = [[UITableView alloc]init];
        myTableView.frame = CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT - NAVI_HEIGHT-60-40);
        myTableView.tableFooterView = [UIView new];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.showsVerticalScrollIndicator = NO;
        if(i == 0){
            myTableView_order = myTableView;
            [myTableView_order registerClass:[JHUPKeepOrderDetailCellOne class] forCellReuseIdentifier:@"cell"];
            [myTableView_order registerClass:[JHUPKeepOrderDetailCellTwo class] forCellReuseIdentifier:@"cell2"];
            _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForOrder)];
            _header.lastUpdatedTimeLabel.hidden = YES;
            [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];            _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            [myTableView_order setMj_header:_header];
        }else{
            myTableView_detail = myTableView;
            [myTableView_detail registerClass:[JHUPKeepOrderDetailCellThree class] forCellReuseIdentifier:@"cell3"];
            [myTableView_detail registerClass:[JHUPKeepOrderDetailCellFour class] forCellReuseIdentifier:@"cell4"];
            [myTableView_detail registerClass:[JHUPKeepOrderDetailCellFive class] forCellReuseIdentifier:@"cell5"];
            [myTableView_detail registerClass:[JHUPKeepOrderDetailCellSix class] forCellReuseIdentifier:@"cell6"];
            _headerDetail = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForDetail)];
            _headerDetail.lastUpdatedTimeLabel.hidden = YES;
            [_headerDetail setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_headerDetail setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_headerDetail setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            _headerDetail.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            myTableView_detail.mj_header = _headerDetail;
        }
        [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
    }
}
#pragma mark - 这是scrollview的代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isMove = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    if (isMove) {
        if (scrollView == myScrollview) {
            if (scrollView.contentOffset.x < WIDTH/2) {
                oldBtn.selected = NO;
                UIButton * btn = btnArray[0];
                btn.selected = YES;
                oldBtn = btn;
            }else {
                oldBtn.selected = NO;
                UIButton * btn = btnArray[1];
                btn.selected = YES;
                oldBtn = btn;
                if (!isFirst_detail&&scrollView.contentOffset.x==WIDTH) {
                    SHOW_HUD
                    [self postDetailHttp];
                }
            }
            label_seleter.frame = FRAME(scrollView.contentOffset.x/2, 39, WIDTH/2, 1);
        }
    }
}

#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == myTableView_order) {
        return 2+model_progress.modelArray.count;
    }else{
        if([model_detail.order_status intValue] == 0 && [model_detail.pay_status intValue] == 0 && [model_detail.staff_id integerValue] == 0){
            return 17;
        }else if([model_detail.order_status integerValue] == 0&&[model_detail.staff_id integerValue] == 0){
            return 17;
        }else if ([model_detail.order_status integerValue] == 8){
            return 21;
        }
        else if (([model_detail.staff_id integerValue] > 0&&[model_detail.order_status integerValue] >=0) ||[model_detail.order_status integerValue] == 3||[model_detail.order_status integerValue]==5||([model_detail.order_status integerValue] == 1&&[model_detail.staff_id integerValue] > 0)){
            return 18;
        }else if ([model_detail.order_status integerValue] == -1){
            return 12;
        }
        else{
            return 17;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == myTableView_order) {
        if (indexPath.row == 0) {
            return 60;
        }else if (indexPath.row == 1){
            return 15;
        }else{
            return 80;
        }
    }else{
        if (indexPath.row == 0) {
            return 60;
        }else if(indexPath.row == 1||indexPath.row == 12){
            return 15;
        }else if (indexPath.row == 15 && [model_detail.order_status integerValue] == 0 && [model_detail.staff_id integerValue] == 0){
            return 15;
        }else if (indexPath.row == 16 && (([model_detail.staff_id integerValue] > 0&&[model_detail.order_status integerValue] >=0)||[model_detail.order_status integerValue] == 3||[model_detail.order_status integerValue] == 5||[model_detail.order_status integerValue] == 8||([model_detail.order_status integerValue] == 1&&[model_detail.staff_id integerValue] > 0)||[model_detail.staff_id integerValue]>0)){
            return 15;
        }
        else if (indexPath.row == 9){
            NSString * str = [NSString stringWithFormat:NSLocalizedString(@"服务要求:%@", nil),model_detail.intro];
            CGSize size = [str boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            height = size.height;
                return height + 30;
        }else if (indexPath.row == 10){
                return 50;
        }else if (indexPath.row == 11){
            if (model_detail.photoArray.count == 0) {
            return 0;
            }else{
                return (WIDTH - 50)/4+20;
            }
        }else if ([model_detail.hongbao integerValue] == 0&&indexPath.row == 19){
            return 0;
        }
        else{
                return 40;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == myTableView_order) {
        if (indexPath.row == 0) {
            JHUPKeepOrderDetailCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model_progress;
            [cell.btn addTarget:self action:@selector(clickToDoThings:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 1){
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            JHUPKeepOrderDetailCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            cell.model= model_progress;
//            if (indexPath.row == position+1) {
//                if (btn_call) {
//                    [btn_call removeFromSuperview];
//                    btn_call = nil;
//                }
//                if (btn_call == nil) {
//                    btn_call = [[UIButton alloc]init];
//                    btn_call.frame = FRAME(WIDTH - 50, 20, 40, 40);
//                    [cell addSubview:btn_call];
//                    [btn_call setImage:[UIImage imageNamed:@"phone01"] forState:UIControlStateNormal];
//                }
//            }
//            btn_call.tag = indexPath.row;
//            [btn_call addTarget:self action:@selector(clickToCall) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        if (indexPath.row == 0) {
            JHUPKeepOrderDetailCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model_detail;
            [cell.btn addTarget:self action:@selector(clickToback) forControlEvents:UIControlEventTouchUpInside];
            return cell;
 
        }else if(indexPath.row == 1||indexPath.row == 12){
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 15 && [model_detail.order_status integerValue] == 0&&[model_detail.staff_id integerValue] == 0){
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (indexPath.row == 16 && (([model_detail.staff_id integerValue] > 0&&[model_detail.order_status integerValue] >=0)||[model_detail.order_status integerValue] == 3||[model_detail.order_status integerValue] == 5 || [model_detail.order_status integerValue] == 8||([model_detail.order_status integerValue] == 1&&[model_detail.staff_id integerValue] > 0))){
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else if (indexPath.row == 9){
            JHUPKeepOrderDetailCellFour * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            cell.height = height;
            cell.myLabel.text = [NSString stringWithFormat:NSLocalizedString(@"服务要求:%@", nil),model_detail.intro];
            return cell;
        }else if (indexPath.row == 10){
            JHUPKeepOrderDetailCellFive * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.voice = model_detail.voice;
            cell.voice_time = model_detail.voice_time;
            UITapGestureRecognizer * tapGuester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToPlay:)];
            cell.imageVoice.userInteractionEnabled = YES;
            [cell.imageVoice addGestureRecognizer:tapGuester];
            cell.animationImage.image = [UIImage imageNamed:@"sy1"];
            cell.animationImage.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"sy3"],
                                                   [UIImage imageNamed:@"sy2"],
                                                   [UIImage imageNamed:@"sy1"],nil];
            cell.animationImage.animationDuration = 1;
            cell.animationImage.animationRepeatCount = 0;
            imageView = cell.animationImage;
            return cell;
        }else if (indexPath.row == 11){
            JHUPKeepOrderDetailCellSix * cell = [tableView dequeueReusableCellWithIdentifier:@"cell6" forIndexPath:indexPath];
            cell.photoArray = model_detail.photoArray;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            static NSString * identifier = @"ce";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            UIButton * btn = [cell viewWithTag:1024];
            [btn removeFromSuperview];
            btn = nil;
            cell.detailTextLabel.text = @"";
            cell.textLabel.text = array[indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row == 2){
                cell.detailTextLabel.text = model_detail.dateline;
                cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                cell.detailTextLabel.font =[UIFont systemFontOfSize:13];
            }
            if (indexPath.row == 15) {
                UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, 5, 30, 30)];
                btn.tag = 1024;
                [btn setImage:[UIImage imageNamed:@"phone01"] forState:UIControlStateNormal];
                [cell addSubview:btn];
                [btn addTarget:self action:@selector(clickToCallOther) forControlEvents:UIControlEventTouchUpInside];
            }

            if(indexPath.row == 16&&[model_detail.order_status integerValue] == 0){
                if([model_detail.order_status intValue] == 0 && [model_detail.pay_status intValue] == 0){
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model_detail.danbao_amount];
                }else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model_detail.danbao_amount];
                }
                cell.detailTextLabel.textColor = [UIColor orangeColor];
                cell.detailTextLabel.font =[UIFont systemFontOfSize:13];
            }else if (indexPath.row == 17&&([model_detail.order_status integerValue] == 3||[model_detail.order_status integerValue] == 5||([model_detail.order_status integerValue] == 1&&[model_detail.staff_id integerValue] > 0)||[model_detail.staff_id integerValue] >0)&&[model_detail.order_status integerValue] != 8){
                if([model_detail.order_status intValue] == 0 && [model_detail.pay_status intValue] == 0){
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model_detail.danbao_amount];
                }else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model_detail.danbao_amount];
                }
                cell.detailTextLabel.textColor = [UIColor orangeColor];
                cell.detailTextLabel.font =[UIFont systemFontOfSize:13];
            }else if (indexPath.row > 16 && [model_detail.order_status intValue] == 8){
                cell.detailTextLabel.text = money_array[indexPath.row - 17];
                cell.detailTextLabel.textColor = [UIColor orangeColor];
                cell.detailTextLabel.font =[UIFont systemFontOfSize:13];
            }
            //创建分割线
            UIView * view = [cell viewWithTag:100];
            [view removeFromSuperview];
            view = nil;
            UIView * label = [[UIView alloc]init];
            label.frame = FRAME(0, 39.5, WIDTH, 0.5);
            label.tag = 100;
            label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            [cell addSubview:label];
            return cell;

        }
    }
}
#pragma mark - 这是点击订单详情的第一个cell按钮的方法
-(void)clickToback{
    NSLog(@"这是点击订单详情的第一个cell按钮的方法");
}
#pragma mark - 这是点击去评价支付补差价的方法
-(void)clickToMore:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model_progress.order_id;
        vc.amount = model_progress.danbao_amount;
        vc.isDetailVC = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self refreshForDetail];
                if (self.myBlock) {
                    self.myBlock();
                }
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"补差价", nil)]){
        NSLog(@"点击的是补差价");
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model_progress.order_id;
        vc.amount = model_progress.chajia;
        vc.isDetailVC = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self refreshForOrder];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"查看评价", nil)]){
        NSLog(@"查看评价");
        JHPEvaluateVC * vc = [[JHPEvaluateVC alloc]init];
        vc.order_id = model_progress.order_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"确认完成", nil)]){
        [HttpTool postWithAPI:@"client/order/confirm" withParams:@{@"order_id":model_progress.order_id} success:^(id json) {
            if ([json[@"error"] isEqualToString:@"0"]) {
                SHOW_HUD
                [self refreshForDetail];
                if (self.myBlock) {
                    self.myBlock();
                }
            }else{
                [self creatUIAlertControlWithMessage:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
            NSLog(@"%@",error.localizedDescription);
        }];
        
    }
    else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击的是取消订单");
        SHOW_HUD
        [self cancelOrderWithOrder_id:model_progress.order_id];
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        NSLog(@"点击的去评价");
        JHPersonEvaluationVC * vc = [[JHPersonEvaluationVC alloc]init];
        vc.number = model_progress.jifen;
        vc.order_id = model_progress.order_id;
        vc.personEvaluationSuccess = ^{
            [self refreshForOrder];
            if (isFirst_detail) {
                [self refreshForDetail];
            }
            if (self.myBlock) {
                self.myBlock();
            }

        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"这样的状态下就不要点击了");
    }
}
#pragma mark - 这是发送取消订单的请求
-(void)cancelOrderWithOrder_id:(NSString *)order_id {
    [HttpTool postWithAPI:@"client/order/cancel" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            HIDE_HUD
            //刷新数据
            [self refreshForOrder];
            if (isFirst_detail) {
                [self refreshForDetail];
            }
            if (self.myBlock) {
                self.myBlock();
            }

        }else{
            HIDE_HUD
            [self creatUIAlertControlWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
    }];
}

#pragma mark - 这是点击呼叫师傅的方法
-(void)clickToCall{
    [self clickWithMobile:phone];
}
#pragma mark - 这是点击呼叫师傅的其他方法
-(void)clickToCallOther{
    [self clickWithMobile:phone1];
}
//提示拨号的提示框
-(void)clickWithMobile:(NSString *)mobile{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:mobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"呼叫", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //呼叫
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",mobile]]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 这是点击投诉的方法
-(void)clicktoComplain{
    NSLog(@"这是投诉的方法");
    if ([model_progress.pay_status integerValue] == 1) {
        JHPersonComplainVC * vc = [[JHPersonComplainVC alloc]init];
        vc.order_id = model_progress.order_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"您暂时还无法进行此操作", nil)];
    }
}
#pragma mark - 这是点击催单的方法
-(void)clicktoCuiDan{
    NSLog(@"这是点击催单的方法");
    if ([model_progress.order_status integerValue]>0 && [model_progress.order_status integerValue] < 4) {
        [HttpTool postWithAPI:@"client/order/cuidan" withParams:@{@"order_id":model_progress.order_id} success:^(id json) {
            NSLog(@"json:%@",json);
            if ([json[@"error"] isEqualToString:@"0"]) {
                [self creatUIAlertControlWithMessage:NSLocalizedString(@"催单成功", nil)];
            }else{
                [self creatUIAlertControlWithMessage:json[@"message"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"error:%@",error.localizedDescription);
            [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }];
    }else{
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"该时段无法催单", nil)];
    }
}
#pragma mark - 这是点击第一个单元格上的按钮的方法
-(void)clickToDoThings:(UIButton *)sender{
    SHOW_HUD
    [self cancelOrderWithOrder_id:model_progress.order_id];
}
#pragma mark - 这是订单详情点击播放语音的方法
-(void)clickToPlay:(UITapGestureRecognizer *)tap{
    //如果语音正在播放,暂停
    if ([_player isPlaying]) {
        [imageView stopAnimating];
        [_player pause];
        return;
    }
    //如果语音不是在播放,开始播放 
    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model_detail.voice]]];
    _player = [[AVAudioPlayer alloc]initWithData:data error:nil];
    _player.delegate = self;
    [_player play];
    [imageView startAnimating];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [imageView stopAnimating];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    NSLog(@"error:%@",error.localizedDescription);
}
#pragma mark - 这是刷新订单进度的
-(void)refreshForOrder{
    [self postProgressHtttp];
}
#pragma mark - 这是刷新订单详情的
-(void)refreshForDetail{
    [self refreshForOrder];
    //处理刷新结果的
    [self postDetailHttp];
}
#pragma mark - 创建提示框
-(void)creatUIAlertControlWithMessage:(NSString *)msg{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - ************判断按钮的状态***********
-(void)judgeBtnState:(UIButton *)sender{
    if([model_progress.order_status integerValue] == 0 && [model_progress.pay_status integerValue] == 0){
        [sender setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
        
    }else if ([model_progress.order_status integerValue] == 0&& [model_progress.pay_status integerValue] == 1){
        [sender setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
        
    }else if ([model_progress.order_status intValue] == 8 && [model_progress.comment_status intValue] == 0){
        [sender setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
    }else if([model_progress.order_status intValue] == 8 && [model_progress.comment_status intValue] == 1){
        [sender setTitle:NSLocalizedString(@"查看评价", nil) forState:UIControlStateNormal];
        sender.backgroundColor = THEME_COLOR;
    }else if([model_progress.order_status intValue] == 2){
        [sender setTitle:NSLocalizedString(@"等待服务", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else if ([model_progress.staff_id integerValue] > 0  && [model_progress.order_status intValue] == 1){
        [sender setTitle:NSLocalizedString(@"等待服务", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }else if ([model_progress.order_status intValue] == 5 && [model_progress.jiesuan_price floatValue] != [self totalAmount]){
        [sender setTitle:NSLocalizedString(@"补差价", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
    }else if([model_progress.order_status intValue] == 5 && [model_progress.jiesuan_price floatValue] == [self totalAmount]){
        [sender setTitle:NSLocalizedString(@"确认完成", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
    }else if([model_progress.order_status integerValue] == -1){
        [sender setTitle:NSLocalizedString(@"订单已取消", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else if([model_progress.order_status integerValue] == 3){
        [sender setTitle:NSLocalizedString(@"服务中", nil) forState:UIControlStateNormal];
         sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }else if ([model_progress.order_status integerValue] == 4){
        [sender setTitle:NSLocalizedString(@"待结算", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else{
         sender.backgroundColor = [UIColor clearColor];
    }
}
-(float)totalAmount{
    return model_progress.amount.floatValue + model_progress.hongbao.floatValue;
}
@end

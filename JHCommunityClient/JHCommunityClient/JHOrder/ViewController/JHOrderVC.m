//
//  JHOrderVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/25.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHOrderVC.h"
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
#import "JHLoginVC.h"
#import "JHPrivilegeListNewVC.h"
#import "JHPrivilegeListCell.h"
#import "JHPrivilegeListModel.h"
#import "JHPrivilegedDetailVC.h"
#import "JHTempWebViewVC.h"
#import "JHShareModel.h"
@interface JHOrderVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView * myTableView_type;//指向按分类划分的表
    UITableView * myTableView_all;//指向显示全部订单的表
    NSMutableArray * titleArray;
    NSMutableArray * imageArray;
    UIButton * oldBtn;//指向旧的按钮
    UILabel * label_seleter;//选中的显示条
    UIScrollView * myScrollview;//创建底部的scrollview
    NSMutableArray * btnArray;//存放两个btn的
    BOOL isMove;//判断是否是滑动
    UIImageView * imageV;
    MJRefreshNormalHeader * _header;//全部订单的下拉刷新
    MJRefreshAutoNormalFooter * _footer;//全部订单的上拉加载
    DSToast * toast;
    int page_num;
    NSMutableArray * infoArray;
    NSMutableArray * typeArray;
    BOOL  isFirst;
    BOOL  isCancel;
    BOOL  isBack;
    BOOL isleave;
    NSString *token;
    NSInteger selecter;
}
@end

@implementation JHOrderVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    isleave = NO;
    //获取token
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    token = [userDefaults objectForKey:@"token"];
    if (!token) {
        if (selecter == 0) {
             [self creatUIAalertControllerWithMessage:NSLocalizedString(@"您还没有登录,不能访问", nil)];
        }
    }else{
        if (selecter == 0) {
            [self downRfresh]; 
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    HIDE_HUD
}

-(void)doSomeThing:(NSNotification *)noti{
    //当从我的界面查看全部订单跳过时需要的代码
    [myScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    label_seleter.frame = FRAME(0, 39, WIDTH/2, 1);
    oldBtn.selected = NO;
    UIButton * btn = btnArray[0];
    btn.selected  = YES;
    oldBtn = btn;
}
//-(void)LoginSuccess:(NSNotification *)info{
//    //登录成功后刷新全部的订单列表
//    [self downRfresh];
//}
-(void)leavesuccess:(NSNotification *)info{
    isleave = YES;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    token = [userDefaults objectForKey:@"token"];
    [self downRfresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    btnArray = [NSMutableArray array];
    infoArray = [NSMutableArray array];
    typeArray = [NSMutableArray array];
    self.backBtn.hidden = YES;
    page_num = 1;
    selecter = 0;
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    titleArray = @[NSLocalizedString(@"           团购", nil),
                   NSLocalizedString(@"           优惠", nil),
                   NSLocalizedString(@"           外卖", nil)
                  ].mutableCopy;
    imageArray = @[@"groupBuy",@"youhui",@"waimaiNewIcon"].mutableCopy;
    if ([JHShareModel shareModel].have_weidian == 1) {
        [titleArray addObject:NSLocalizedString(@"           商城", nil)];
        [imageArray addObject:@"shop-1"];
    }
    if ([JHShareModel shareModel].have_staff == 1) {
        [titleArray addObjectsFromArray:@[@"",
                                          NSLocalizedString(@"           家政", nil),
                                          NSLocalizedString(@"           维修", nil),
                                          NSLocalizedString(@"           跑腿", nil)]];
        [imageArray addObjectsFromArray:@[@"",@"home-1",@"upkeep",@"run"]];
    }
    //创建头部的按钮
    [self creatHeaderView];
    //创建底部的滑动视图
    [self creatUIScrollView];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(doSomeThing:) name:@"SeeAllOrder" object:nil];
//   NSNotificationCenter * center1 = [NSNotificationCenter defaultCenter];
//    [center1 addObserver:self selector:@selector(LoginSuccess:) name:@"loginSuccess" object:nil];
    NSNotificationCenter * center2 = [NSNotificationCenter defaultCenter];
    [center2 addObserver:self selector:@selector(leavesuccess:) name:@"leavesuccess" object:nil];
    //SHOW_HUD
    //创建请求
    //[self postHttpWithPage:[NSString stringWithFormat:@"%d",page_num]];
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
            [btn setTitle:NSLocalizedString(@"全部", nil) forState:UIControlStateNormal];
        }else{
            [btn setTitle:NSLocalizedString(@"按分类", nil) forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:btn];
    }
    //创建中级的分割线
    UIView * label_line = [[UIView alloc]init];
    label_line.frame = FRAME(WIDTH/2-0.5, 5, 1, 30);
    label_line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:label_line];
    //创建底部的分割线
    UIView * label_buttom = [[UIView alloc]init];
    label_buttom.frame = FRAME(0,39.5,WIDTH,0.5);
    label_buttom.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:label_buttom];
    //创建选中时的绿色的显示条
    label_seleter = [[UILabel alloc]init];
    label_seleter.frame = FRAME(0,39,WIDTH/2, 1);
    label_seleter.backgroundColor = THEME_COLOR;
    [view addSubview:label_seleter];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page{
    NSDictionary * dic = @{@"page":page};
    [HttpTool postWithAPI:@"client/member/order/items_all" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSArray * tempArray = json[@"data"][@"orders"];
            for (NSDictionary * dic in tempArray) {
                NSString * type = nil;
                if ([dic[@"from"] isEqualToString:@"paotui"]||[dic[@"from"] isEqualToString:@"tuan"]) {
                    type = dic[@"order"][@"type"];
                }else if([dic[@"from"] isEqualToString:@"house"]||[dic[@"from"] isEqualToString:@"weixiu"]||[dic[@"from"] isEqualToString:@"waimai"] || [dic[@"from"] isEqualToString:@"maidan"]){
                    type = dic[@"from"];
                }
                if (type == nil) {
                    
                }else{
                   [typeArray addObject:type];
                }
            }
            NSLog(@"%ld",typeArray.count);
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
                }else if ([dic[@"from"] isEqualToString:@"waimai"]){
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
                [myScrollview addSubview:myTableView_all];
                isFirst = YES;
            }
            HIDE_HUD
            if (isCancel) {
             [self creatWithMessage:NSLocalizedString(@"取消订单成功", nil)];
            }
            if (isBack) {
                [self creatWithMessage:NSLocalizedString(@"金额已成功退回,请注意查收", nil)];
            }
            [myTableView_all reloadData];
            [_header endRefreshing];
            [_footer endRefreshing];
            NSLog(@"%@",infoArray);
        }else{
            HIDE_HUD
            if(!isFirst){
                [myScrollview addSubview:myTableView_all];
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
#pragma mark - 这是点击头部按钮的方法
-(void)btnChange:(UIButton *)sender{
    selecter = sender.tag;
    if (sender.tag == 0) {
        [self downRfresh];
    }
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
    }
}
#pragma mark - 这是创建scrollview的方法
-(void)creatUIScrollView{
    if (myScrollview == nil) {
        myScrollview = [[UIScrollView alloc]init];
        myScrollview.frame = FRAME(0,NAVI_HEIGHT+40, WIDTH, HEIGHT-NAVI_HEIGHT-40-49);
        myScrollview.pagingEnabled = YES;
        myScrollview.bounces = NO;
        myScrollview.delegate = self;
        myScrollview.showsHorizontalScrollIndicator = NO;
        myScrollview.showsVerticalScrollIndicator = NO;
        myScrollview.contentSize = CGSizeMake(WIDTH*2, HEIGHT-(NAVI_HEIGHT+40)-49);
        [self.view addSubview:myScrollview];
        for (int i = 0; i < 2; i++) {
            UITableView *   myTableView = [[UITableView alloc]init];
            myTableView.frame = CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT-(NAVI_HEIGHT+40)-49);
            myTableView.tableFooterView = [UIView new];
            myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
            myTableView.showsVerticalScrollIndicator = NO;
            if(i == 0){
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
            }else{
                myTableView_type = myTableView;
                [myScrollview addSubview:myTableView_type];
            }
            
            myTableView.delegate = self;
            myTableView.dataSource = self;
        }
    }
}
#pragma mark - 这是表的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == myTableView_all) {
        if (!token) {
            return 0;
        }
        else if (infoArray.count == 0){
            return 1;
        }else{
            return infoArray.count;
        }
    }else{
            return titleArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == myTableView_all) {
       
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
    }else{
        NSInteger num = 4;
        if ([JHShareModel shareModel].have_staff == 1 && [JHShareModel shareModel].have_weidian == 0) {
            num = 3;
        }
       if (indexPath.row == num) {
        return 15;
       }else{
        return 50;
       }
   }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == myTableView_all) {
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
    else{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
        NSInteger num = 4;
        if ([JHShareModel shareModel].have_staff == 1 && [JHShareModel shareModel].have_weidian == 0) {
            num = 3;
        }
    if (indexPath.row == num) {
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
    }else{
        imageV = [[UIImageView alloc]init];
        imageV.image = IMAGE(imageArray[indexPath.row]);
        imageV.frame = FRAME(15, 10, 30, 30);
        [cell addSubview:imageV];
        cell.textLabel.text = titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //创建分割线
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(0.5);
    }];
    return cell;
   }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      if (tableView == myTableView_all) {
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
           //[self downRfresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"buy"]){
        //帮我买
        JHRunModel * model = infoArray[indexPath.row];
        JHBuyOrderDetailViewController * vc = [[JHBuyOrderDetailViewController alloc]init];
        vc.order_id = model.order_id;
        [vc setMyBlock:^(void){
            //[self downRfresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"song"]){
        //帮我送
        JHRunModel * model = infoArray[indexPath.row];
        JHSendOrderDetailVC * vc = [[JHSendOrderDetailVC alloc]init];
        vc.order_id = model.order_id;
        [vc setMyBlock:^(void){
            //[self downRfresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"paidui"]){
        //代排队
        JHRunModel * model = infoArray[indexPath.row];
        JHQueueOrderDetailVC * vc = [[JHQueueOrderDetailVC alloc]init];
         vc.order_id = model.order_id;
        [vc setMyBlock:^(void){
            //[self downRfresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"chongwu"]){
        //宠物照顾
         JHRunModel * model = infoArray[indexPath.row];
        JHPetOrderDetailVC * vc = [[JHPetOrderDetailVC alloc]init];
         vc.order_id = model.order_id;
        [vc setMyBlock:^(void){
            //[self downRfresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"seat"]){
        //餐馆占座
        JHRunModel * model = infoArray[indexPath.row];
        JHSeatOrderDetailVC * vc = [[JHSeatOrderDetailVC alloc]init];
        vc.order_id = model.order_id;
        [vc setMyBlock:^(void){
            //[self downRfresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"other"]){
        //其他
        JHRunModel * model = infoArray[indexPath.row];
        JHOtherOrderDetailVC * vc = [[JHOtherOrderDetailVC alloc]init];
        vc.order_id = model.order_id;
        [vc setMyBlock:^(void){
            //[self downRfresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"house"]){
        //家政
        JHHouseModel * model = infoArray[indexPath.row];
        JHHouseOrderDeatailVC * vc = [[JHHouseOrderDeatailVC alloc]init];
        vc.order_id = model.order_id;
        [vc setMyBlock:^(void){
            //[self downRfresh];
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
            //[self downRfresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    }else{
    JHBaseVC * vc = nil;
        NSInteger jiazheng = 5;
        NSInteger weixiu = 6;
        NSInteger paotui = 7;
        if ([JHShareModel shareModel].have_weidian == 0) {
            jiazheng = 4;
            weixiu = 5;
            paotui = 6;
        }
        if (indexPath.row == 0) {
            vc = [[JHGroupListController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            vc = [[JHPrivilegeListNewVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            vc = [[JHTakeawayViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            if ([JHShareModel shareModel].have_weidian == 1) {
                vc = [[JHTempWebViewVC alloc]init];
                JHTempWebViewVC *vc2 = (JHTempWebViewVC *)vc;
                vc2.isShangQuan = YES;
                vc2.isMall_order = YES;
                [vc2 setValue:MALL_ORDER_LINK forKey:@"url"];
                vc2.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc2 animated:YES];
            }
        }else if (indexPath.row == jiazheng){
            vc = [[JHHouseKeepListVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == weixiu){
            vc = [[JHUpKeepListVCViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == paotui){
            vc = [[JHRunOederListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
  }
}
#pragma mark - 这是滑动视图的代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isMove = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isMove) {
        NSLog(@"%f",scrollView.contentOffset.x);
        if (scrollView == myScrollview) {
            if (scrollView.contentOffset.x < WIDTH/2){
                //[self btnChange:btnArray[0]];
                oldBtn.selected = NO;
                UIButton * btn = btnArray[0];
                btn.selected = YES;
                oldBtn = btn;
            }else {
                //[self btnChange:btnArray[1]];
                oldBtn.selected = NO;
                UIButton * btn = btnArray[1];
                btn.selected = YES;
                oldBtn = btn;
            }
            label_seleter.frame = FRAME(scrollView.contentOffset.x/2, 39, WIDTH/2, 1);
        }
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
    }

    else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        NSLog(@"点击了去评价的按钮");
        JHShopEvaluationVC * vc = [[JHShopEvaluationVC alloc]init];
//        vc.deliverTime = model.dateline;
//        vc.number = model.jifen;
        vc.order_id = model.order_id;
//        vc.isZiti = model.pei_type.integerValue == 3 ? YES : NO;
        vc.shopEvaluationSuccess = ^{
            //[self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击了取消订单的按钮");
        [self cancelOrderWithOrder_id:model.order_id];
    }
    else{
        
    }
}
#pragma mark - 这是发送取消订单的请求
-(void)cancelOrderWithOrder_id:(NSString *)order_id{
    isCancel  = YES;
    [HttpTool postWithAPI:@"client/order/cancel" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
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
#pragma mark - 这是waiami在待支付状态下点击取消的按钮调用的方法
-(void)clickToCancel:(UIButton *)sender{
    NSLog(@"你点击了取消订单");
    JHTakeyawayModel * model = infoArray[sender.tag];
    [self cancelOrderWithOrder_id:model.order_id];
}
#pragma mark - 这是paotui的点击取消订单的方法
-(void)runClickToCancel:(JHOrderBtn *)sender{
    JHRunModel * model = infoArray[sender.myTag];
    [self cancelOrderWithOrder_id:model.order_id];
}
#pragma mark - 这是paotui点击去支付的按钮
-(void)runClickToPay:(JHOrderBtn *)sender{
    JHRunModel * model = infoArray[sender.myTag];
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = [NSString stringWithFormat:@"%ld", [model.danbao_amount integerValue] + [model.paotui_amount integerValue]];
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
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
    }

    else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"补差价", nil)]){
        NSLog(@"点击的是补差价的方法");
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.chajia;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]) {
        JHPersonEvaluationVC * vc = [[JHPersonEvaluationVC alloc]init];
        vc.order_id = model.order_id;
        vc.number = model.jifen;
        vc.isTuan = NO;
        vc.personEvaluationSuccess = ^{
            //[self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        NSLog(@"点击的是取消订单");
        [self cancelOrderWithOrder_id:model.order_id];
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
            //[self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"申请退款", nil)]){
        NSLog(@"申请退款");
       
        [HttpTool postWithAPI:@"client/tuan/order/cancel" withParams:@{@"order_id":model.order_id} success:^(id json) {
            if ([json[@"error"] isEqualToString:@"0"]) {
                 isBack = YES;
                [self downRfresh];
            }else{
              
                [self creatUIAalertControllerWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
            }
        } failure:^(NSError *error) {
           
            [self creatUIAalertControllerWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }];
        
    }

    else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"这是取消订单的方法");
        [self cancelOrderWithOrder_id:model.order_id];
    }
    else{
        NSLog(@"点击了已评价的按钮");
        
    }
}
#pragma mark - 这是买单的取消的方法
-(void)clickToCancelOrder:(UIButton *)sender{
    JHPrivilegeListModel * model = infoArray[sender.tag];
    [self cancelOrderWithOrder_id:model.order_id];
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
            //[self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        model = infoArray[sender.tag];
        NSLog(@"点击了取消订单的按钮");
        [self cancelOrderWithOrder_id:model.order_id];
    }
    else{
        NSLog(@"点击了已评价的按钮");
    }

}
#pragma mark - 这是团购点击取消的方法
-(void)groupClickToCancel:(UIButton *)sender{
    NSLog(@"点击的是取消订单的方法");
    JHGroupModel * model = infoArray[sender.tag];
    [self cancelOrderWithOrder_id:model.order_id];
}
#pragma mark - 这是家政点击取消订单的方法
-(void)houseClickToCancel:(UIButton *)sender{
    NSLog(@"这是点击取消订单的方法");
    JHHouseModel * model = infoArray[sender.tag];
    [self cancelOrderWithOrder_id:model.order_id];
}
#pragma mark - 这是家政点击去支付的方法
-(void)houseClickToPay:(UIButton *)sender{
    NSLog(@"这是点击去支付的方法");
    JHHouseModel * model = infoArray[sender.tag];
    if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]){
        
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.amount;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
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
            //[self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击的是取消订单");
        [self cancelOrderWithOrder_id:model.order_id];
    }else{
        
    }
}

#pragma mark - 这是维修点击取消订单的方法
-(void)upkeepClickToCancelOrder:(UIButton *)sender{
    NSLog(@"这是点击取消订单的方法");
    JHUpkeepModel * model = infoArray[sender.tag];
    [self cancelOrderWithOrder_id:model.order_id];
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
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"补差价", nil)]){
        NSLog(@"点击的是补差价");
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model.order_id;
        vc.amount = model.chajia;
        vc.isOrder = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
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
           // [self downRfresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击的是取消订单");
        [self cancelOrderWithOrder_id:model.order_id];
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
    [self postHttpWithPage:[NSString stringWithFormat:@"%d",page_num]];
}
#pragma mark - 这是上拉加载
-(void)upRefresh{
    page_num ++;
    //创建请求
    [self postHttpWithPage:[NSString stringWithFormat:@"%d",page_num]];
}
#pragma mark - 展示错误信息的
-(void)creatUIAalertControllerWithMessage:(NSString *)msg{
    if (isleave) {
        return;
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    //获取token
    if (token) {
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:nil]];
    }else{
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"去登录", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        JHLoginVC * vc = [[JHLoginVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 创建提示
-(void)creatWithMessage:(NSString *)msg{
    if (toast == nil) {
        toast = [[DSToast alloc]initWithText:msg];
        [toast showInView:self.view  showType:DSToastShowTypeCenter withBlock:^{
            toast = nil;
            isCancel = NO;
            isBack = NO;
        }];
    }
    
}
@end

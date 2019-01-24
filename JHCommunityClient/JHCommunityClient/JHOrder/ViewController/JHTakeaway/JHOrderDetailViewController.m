//
//  JHOrderDetailViewController.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHOrderDetailViewController.h"
#import "TakeawayOrderProgressCellOne.h"
#import "TakeawayOrderProgressCellTwo.h"
#import "TakeawayOrderDetailCell.h"
#import "TakeawayOrderDetailCellOne.h"
#import "TakeawayOrderDetailCellTwo.h"
#import <MJRefresh.h>
#import <MAMapKit/MAMapKit.h>
 
#import "JHTakeawayDetailModel.h"
#import "JHTakewayProgressModel.h"
#import "JHWMPayOrderVC.h"
#import "JHShopEvaluationVC.h"
#import "UIImageView+NetStatus.h"
#import "JHComplainVC.h"
#import "JHSupermarketMainVC.h"
#import "JHWaiMaiMainVC.h"
#import "JHSEvalauteVC.h"
#import "JHTakeawayMengBan.h"
#import "JHOrderInfoModel.h"
#import "JHPlaceWaimaiOrderVC.h"
#import "JHOrderForCenter.h"
#import "JHTakeawayViewController.h"
#import "JHShowAlert.h"
@interface JHOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{
    UIButton * oldBtn;//指向旧的按钮
    UILabel * label_seleter;//选中的显示条
    UIScrollView * myScrollview;//创建底部的scrollview
    NSMutableArray * btnArray;//存放两个btn的
    BOOL isMove;//判断是否是滑动
    UITableView * myTableView_order;//指向订单进度的表
    UITableView * myTableView_detail;//指向订单详情的表
    MJRefreshNormalHeader * header_refresh;//下拉刷新
    XHMapView * _mapView;//用来显示跑腿员和我们之间的距离的
    BOOL isYes;
    MJRefreshNormalHeader * _header;//这是订单进度的下拉刷新的
    MJRefreshNormalHeader * _header_detail;//这是下拉刷新订单详情的
    JHTakeawayDetailModel * model_detail;
    JHTakewayProgressModel * model_progress;
    BOOL isFirst_progress;
    BOOL isFirst_detail;
    NSArray * textLalbelArray;
    UIButton * btn_getMore;
    BOOL isCall;
    UIButton * btn_call;
    NSInteger position;
    NSString * phone;//订单进度那个电话号码
    float lat;//当前的外卖的纬度
    float lng;//当前的外卖的经度
    BOOL isFirstMap;//判断是不是第一次加载地图
    float last_distance;
    float user_lat;
    float user_lng;
    NSTimer * timer;//开启一个定时器,每隔10秒钟刷新一下配送员的位置
    UIButton * btn_cuidan;
    UILabel * label_lineTwo;
    UIButton * btn_complain;
    UILabel * label_lineOne;
    UIView * view_bj;
    BOOL _isWaiMai;
    NSDictionary * dic_location;
    NSString *str_beizhu;//保存备注信息的
    float height_bei;//高度
    NSString *shop_num; //商家电话
    NSString *staff_num; //骑手电话
}
@end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
@implementation JHOrderDetailViewController
//重写返回的方法
-(void)clickBackBtn{
    NSArray<JHBaseVC *> * array = self.navigationController.viewControllers;
    for (JHBaseVC *vc in array) {
        if ([vc isKindOfClass:[JHOrderForCenter class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        }else if ([vc isKindOfClass:[JHTakeawayViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self stopNSTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    last_distance = MAXFLOAT;
    btnArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.navigationItem.title = NSLocalizedString(@"我的订单", nil);
    //添加右边的打电话的按钮
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"phone03"] style:UIBarButtonItemStylePlain target:self action:@selector(clickToCallShop)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //创建头部的两个按钮
    [self creatHeaderView];
    //创建底部的view
    [self creatButtomView];
    //创建中间的Scrollview
    [self creatUIScrollView];
    SHOW_HUD
    //发送订单进度的请求
    [self postProgressHtttp];
}
#pragma mark - 这是打电话给商家的方法
-(void)clickToCallShop{
    //弹出选择电话界面
    NSArray *titleArr;
    NSArray *phoneArr;
    if ([staff_num integerValue] > 0) {
        titleArr = @[NSLocalizedString(@"联系商家", nil),
                     NSLocalizedString(@"联系骑手", nil)
                     ];
        phoneArr = @[shop_num,staff_num];
    }else{
        titleArr = @[NSLocalizedString(@"联系商家", nil)];
        phoneArr = @[shop_num];
    }
    [JHShowAlert showSheetAlertWithTextArr:titleArr withController:self withClickBlock:^(NSInteger tag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneArr[tag]]]];
    }];
//    [self creatUIAlertWithPhone:model_progress.mobile];
}
#pragma mark - 发送订单进度的请求
-(void)postProgressHtttp{
    NSDictionary * dic = @{@"order_id":self.order_id};
    [HttpTool postWithAPI:@"client/member/order/log" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            HIDE_HUD
            btn_complain.hidden = NO;
            label_lineOne.hidden = NO;
            view_bj.hidden = NO;
            model_progress = [JHTakewayProgressModel creatJHTakewayProgressModelWithDictionary:json[@"data"][@"log"]];
            shop_num = json[@"data"][@"log"][@"shop"][@"mobile"];
            if ([model_progress.pei_type integerValue] == 3) {
                btn_cuidan.hidden = YES;
                label_lineTwo.hidden = YES;
            }else{
                btn_cuidan.hidden = NO;
                label_lineTwo.hidden = NO;
            }
            if (!isFirst_progress) {
                [myScrollview addSubview:myTableView_order];
                isFirst_progress = YES;
            }
            [self judgeBtnState:btn_getMore];
            for (int i = 0; i < model_progress.modelArray.count;i++) {
                JHOtherModel * model = model_progress.modelArray[i];
                if ([model.from isEqualToString:@"staff"]&&([model_progress.pei_type isEqualToString:@"1"]||[model_progress.pei_type isEqualToString:@"2"])) {
                    position = i +1;
                    phone = model_progress.mobile_staff;
                    staff_num = model_progress.mobile_staff;
                    lat = [model_progress.lat_staff floatValue];
                    lng = [model_progress.lng_staff floatValue];
                    dic_location = @{@"lat":model_progress.lat_staff,
                                     @"lng":model_progress.lng_staff,
                                     @"phone":phone};
                }else if ([model.from isEqualToString:@"shop"]&&[model_progress.pei_type isEqualToString:@"0"]){
                    position = i +1;
                    shop_num = phone;
                    lat = [model_progress.lat_shop floatValue];
                    lng = [model_progress.lng_shop floatValue];
                }
            }
            if (([model_progress.order_status integerValue] == 1 || [model_progress.order_status integerValue] == 2 || [model_progress.order_status integerValue] == 3) && model_progress.staff_id.integerValue > 0 ) {
                if (!isYes) {
                    //开启定时器
                    [self startNSTimer];
                }
                if ([model_progress.pei_type integerValue] == 0||[model_progress.pei_type integerValue] == 3) {
                    isYes = NO;
                }else {
                    if (lat == 0 || lng == 0) {
                        isYes =  NO;
                    }else{
                        isYes = YES;
                    }

                }
                
            }else if([model_progress.order_status integerValue] == 8 || [model_progress.order_status integerValue] == 4){
                isYes = NO;
                //关闭定时器
                [self stopNSTimer];
            }
            [myTableView_order reloadData];
        }else{
            [self creatUIAlertControlWithMessage:json[@"message"]];
        }
        [_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
         NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 发送订单详情的请求
-(void)postDetailHttp{
    NSDictionary * dic = @{@"order_id":self.order_id};
    [HttpTool postWithAPI:@"client/member/order/detail" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
                model_detail = [JHTakeawayDetailModel creatJHTakeawayDetailModelWithDictionary:json[@"data"][@"order"]];
                if (!isFirst_detail) {
                    [myScrollview addSubview:myTableView_detail];
                    isFirst_detail = YES;
                }
                NSString * type = nil;
                NSString * mobile = nil;
                if ([model_detail.pei_type intValue] == 0) {
                    type = NSLocalizedString(@"商家自己送", nil);
                    mobile = model_detail.shop_mobile;
                }else if ([model_detail.pei_type intValue] == 1){
                    type = NSLocalizedString(@"第三方配送", nil);
                    mobile = model_detail.staff_mobile;
                }else if ([model_detail.pei_type intValue] == 2){
                    type = NSLocalizedString(@"配送员代购", nil);
                    mobile = model_detail.staff_mobile;
                }
                else if([model_detail.pei_type intValue] == 3){
                    type = NSLocalizedString(@"自提", nil);
                    mobile = model_detail.mobile;
                }
            str_beizhu = [NSString stringWithFormat:NSLocalizedString(@"备注:%@", nil),model_detail.intro.length==0?NSLocalizedString(@"无", nil):model_detail.intro];
                textLalbelArray = @[
                [NSString stringWithFormat:NSLocalizedString(@"联系人:%@", nil),model_detail.contact],
                [NSString stringWithFormat:NSLocalizedString(@"联系电话:%@", nil),model_detail.mobile],
                [model_detail.pei_type intValue] == 3?
                [NSString stringWithFormat:NSLocalizedString(@"自提地址:%@", nil),model_detail.addr]:
                [NSString stringWithFormat:NSLocalizedString(@"服务地址:%@", nil),model_detail.addr],
                [NSString stringWithFormat:NSLocalizedString(@"下单时间:%@", nil),model_detail.dateline],
                [model_progress.online_pay integerValue] == 1?
                [NSString stringWithFormat:NSLocalizedString(@"支付方式:%@", nil),model_detail.pay_code]:
                [NSString stringWithFormat:NSLocalizedString(@"支付方式:%@", nil),NSLocalizedString(@"货到付款", nil)],
                [NSString stringWithFormat:NSLocalizedString(@"送达时间:%@", nil),model_detail.lastTime],
                str_beizhu, @"",@"",
                [NSString stringWithFormat:NSLocalizedString(@"配送方式:%@", nil),type],
                [NSString stringWithFormat:NSLocalizedString(@"联系电话:%@", nil),mobile],
                @""];
                [self judgeBtnState:btn_getMore];
                [myTableView_detail reloadData];
                [_header endRefreshing];
                [_header_detail endRefreshing];
        }else{
            HIDE_HUD
            [self creatUIAlertControlWithMessage:json[@"message"]?json[@"message"]:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [_header_detail endRefreshing];
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
        if(sender.tag == 1){
            if (!isFirst_detail) {
                SHOW_HUD
                //发送详情的请求
                [self postDetailHttp];
            }
        }
        [UIView animateWithDuration:0.1 animations:^{
          label_seleter.frame = FRAME(WIDTH/2*sender.tag, 39, WIDTH/2, 1);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            myScrollview.contentOffset = CGPointMake(WIDTH*sender.tag, 0);
        }];

    }
}
#pragma mark - 这是创建底部的view的方法
-(void)creatButtomView{
    UIView * view = [[UIView alloc]init];
    view.frame = FRAME(0, HEIGHT - 60, WIDTH, 60);
    view.backgroundColor = [UIColor whiteColor];
    view_bj = view;
    view.hidden = YES;
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
    btn_complain = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_complain.frame = FRAME(10, 1, 60, 59);
    //btn_complain.backgroundColor = [UIColor orangeColor];
    btn_complain.hidden = YES;
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
    label_lineOne = [[UILabel alloc]init];
    label_lineOne.frame = FRAME(80, 10, 1, 40);
    label_lineOne.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    label_lineOne.hidden = YES;
    [view addSubview:label_lineOne];
    //创建催单的按纽
    btn_cuidan = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_cuidan.frame = FRAME(91, 1, 60, 59);
    [view addSubview:btn_cuidan];
    btn_cuidan.hidden = YES;
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
    label_lineTwo = [[UILabel alloc]init];
    label_lineTwo.hidden = YES;
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
       // [myScrollview addSubview:myTableView];
        myTableView.tableFooterView = [UIView new];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.showsVerticalScrollIndicator = NO;
        if(i == 0){
            myTableView_order = myTableView;
            [myTableView_order registerClass:[TakeawayOrderProgressCellOne class] forCellReuseIdentifier:@"cell"];
            [myTableView_order registerClass:[TakeawayOrderProgressCellTwo class] forCellReuseIdentifier:@"cell2"];
            _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefreshForOrder)];
            _header.lastUpdatedTimeLabel.hidden = YES;
            [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            myTableView_order.mj_header = _header;
        }else{
            myTableView_detail = myTableView;
            [myTableView_detail registerClass:[TakeawayOrderDetailCell class] forCellReuseIdentifier:@"cell3"];
            [myTableView_detail registerClass:[TakeawayOrderDetailCellOne class] forCellReuseIdentifier:@"cell4"];
            [myTableView_detail registerClass:[TakeawayOrderDetailCellTwo class] forCellReuseIdentifier:@"cell5"];
            _header_detail = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefreshForDetail)];
            _header_detail.lastUpdatedTimeLabel.hidden = YES;
            [_header_detail setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_header_detail setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_header_detail setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            _header_detail.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            myTableView_detail.mj_header = _header_detail;
        }
        [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
    }
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == myTableView_order) {
        return 2+model_progress.modelArray.count;
    }else{
        if (model_detail.staff_mobile == nil&&([model_detail.pei_type isEqualToString:@"1"]||[model_detail.pei_type isEqualToString:@"2"])) {
            return 20 + model_detail.modelArray.count;
        }else if([model_detail.order_status integerValue] < 3){
            return 20 + model_detail.modelArray.count;
        }else if([model_detail.pei_type isEqualToString:@"4"]){
            return 20 + model_detail.modelArray.count;
        }
        else{
            return 24 + model_detail.modelArray.count;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == myTableView_order) {
        if (indexPath.row == 0) {
            return 60;
        }else if (indexPath.row == 1){
            if(isYes){
                return 150;
            }else{
                return 15;
            }
        }else{
                return 80;
        }
    }else{
        if (indexPath.row == 0) {
            return 60;
        }else if (indexPath.row == 1||indexPath.row == model_detail.modelArray.count+10||indexPath.row == model_detail.modelArray.count + 19 || indexPath.row == model_detail.modelArray.count + 23){
            return 15;
        }
        else if (indexPath.row == model_detail.modelArray.count + 3){
            if ([model_detail.freight floatValue]>0) {
                return 50;
            }else{
                return 0;
            }
        }
        else if (indexPath.row == model_detail.modelArray.count + 4){
            if ([model_detail.package_price floatValue]>0) {
                return 50;
            }else{
                return 0;
            }
        } else if(indexPath.row == model_detail.modelArray.count + 5){
            if ([model_progress.first_youhui floatValue] > 0) {
                return 50;
            }else{
                return 0;
            }
        }else if (indexPath.row == model_detail.modelArray.count + 6){
            if ([model_detail.order_youhui floatValue]>0) {
                return 50;
            }else{
                return 0;
            }
        }
        else if (indexPath.row == model_detail.modelArray.count + 7){
            if ([model_detail.coupon floatValue]>0) {
                return 50;
            }else{
                return 0;
            }
        }
        else if (indexPath.row == model_detail.modelArray.count +8){
            if ([model_detail.hongbao floatValue]>0) {
                return 50;
            }else{
                return 0;
            }
        }
       else if (indexPath.row == model_detail.modelArray.count + 9){
            if ([model_detail.money doubleValue]) {
                return 100;
            }
            return 50;
        }else if (indexPath.row == model_detail.modelArray.count + 18){
            CGSize size = [str_beizhu boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(13)} context:nil].size;
            height_bei = size.height;
            if (height_bei+10 < 50) {
                return 50;
            }else{
                return height_bei + 10;
            }
            
        }
        else{
            return 50;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == myTableView_order) {
        if (indexPath.row == 0) {
            TakeawayOrderProgressCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.model = model_progress;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if(indexPath.row == 1){
            if (isYes) {
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
                //添加地图
                [self creatMapViewWithCell:cell];
                //cell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                [_mapView removeFromSuperview];
                _mapView = nil;
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
                cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else{
            TakeawayOrderProgressCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            cell.infoArray = model_progress.modelArray;
            cell.model= model_progress;
//            if (indexPath.row == position+ 1) {
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
//            [btn_call addTarget:self action:@selector(clickToCall:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    }else{
        if (indexPath.row == 0) {
            TakeawayOrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.model = model_detail;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.btn_backOrder addTarget:self action:@selector(clicktoBackOrder) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if (indexPath.row == 1||indexPath.row == model_detail.modelArray.count +10||indexPath.row == model_detail.modelArray.count + 19 || indexPath.row == model_detail.modelArray.count + 23){
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView * view = [cell viewWithTag:200];
            [view removeFromSuperview];
            view = nil;
            if(indexPath.row != 20){
            //添加一个分割线
            UIView * label = [[UIView alloc]init];
            label.frame = FRAME(0, 14.5, WIDTH, 0.5);
            label.tag = 200;
            label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            [cell addSubview:label];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 2){
            TakeawayOrderDetailCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model_detail.logo_waimai];
            [cell.imageV sd_image:[NSURL URLWithString:url] plimage:[UIImage imageNamed:@"supermarketproduct"]];
            cell.label.text = model_detail.title_waimai;
            return cell;
        }else if (indexPath.row <= model_detail.modelArray.count + 8 && indexPath.row > 2){
            static NSString * identifer = @"indentiderCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            if (indexPath.row == model_detail.modelArray.count + 3) {
                if ([model_detail.freight floatValue] > 0) {
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.detailTextLabel.textColor = [UIColor redColor];
                    cell.textLabel.text = NSLocalizedString(@"配送费", nil);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model_detail.freight];
                }else{
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                }
                
            }else if (indexPath.row == model_detail.modelArray.count + 4){
                if ([model_detail.package_price  floatValue] > 0) {
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.detailTextLabel.textColor = [UIColor redColor];
                    cell.textLabel.text = NSLocalizedString(@"打包费", nil);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model_detail.package_price];
                }else{
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                }
                
            }else if (indexPath.row == model_detail.modelArray.count + 5){
                if ([model_detail.first_youhui floatValue]>0) {
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.detailTextLabel.textColor = [UIColor redColor];

                    cell.textLabel.text = NSLocalizedString(@"首单优惠",nil);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"-¥%@",model_detail.first_youhui];
                }else{
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                }
            }else if (indexPath.row == model_detail.modelArray.count + 6){
                if ([model_detail.order_youhui floatValue] > 0) {
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.detailTextLabel.textColor = [UIColor redColor];
                    cell.textLabel.text = NSLocalizedString(@"满减优惠", nil);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"-¥%@",model_detail.order_youhui];
                }else{
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                }
                
            }
            else if (indexPath.row == model_detail.modelArray.count + 7){
                if ([model_detail.coupon floatValue]>0) {
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.detailTextLabel.textColor = [UIColor redColor];

                    cell.textLabel.text = NSLocalizedString(@"优惠劵抵扣",nil);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"-¥%@",model_detail.coupon];

                }else{
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                }
            }else if (indexPath.row == model_detail.modelArray.count + 8){
                if ([model_detail.hongbao floatValue]>0) {
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.detailTextLabel.textColor = [UIColor redColor];
                    cell.textLabel.text = NSLocalizedString(@"红包抵扣",nil);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"-¥%@",model_detail.hongbao];

                }else{
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                }
            }            else{
                JHModel * model = model_detail.modelArray[indexPath.row - 3];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
                cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
                NSString *str = model.product_name;
                if (model.product_name.length *13 + 40 > WIDTH) {
                    NSInteger a = WIDTH/13;
                    str = [model.product_name substringToIndex:a];
                    str = [str  substringToIndex:str.length - 10];
                    str = [str stringByAppendingString:@"..."];
                }
                cell.textLabel.text = str;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"x%@ ¥%@",model.product_number,model.product_price];
                
            }
            UIView * view = [cell viewWithTag:100];
            [view removeFromSuperview];
            view = nil;
            //添加一个分割线
            UIView * label = [[UIView alloc]init];
            label.frame = FRAME(0, 49.5, WIDTH, 0.5);
            label.tag = 100;
            label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == model_detail.modelArray.count + 9){
            TakeawayOrderDetailCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
            cell.model = model_detail;
//            if ([model_progress.order_status integerValue] == 8 || [model_progress.order_status integerValue] == -1 ) {
//                cell.btn_more.hidden = NO;
//            }else{
//                cell.btn_more.hidden = YES;
//            }
            [cell.btn_more addTarget:self action:@selector(clickToGetMore) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == model_detail.modelArray.count + 18){
            static NSString *str = @"beizhu";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *view = [cell viewWithTag:205];
            [view removeFromSuperview];
            UILabel *label = [[UILabel alloc]init];
            NSInteger h;
            if (height_bei + 10 > 50) {
                h = height_bei;
            }else{
                h = 40;
            }
            label.frame = FRAME(20, 5, WIDTH, h);
            label.tag = 205;
            label.font = FONT(13);
            label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
            label.text = str_beizhu;
            label.numberOfLines = 0;
            [cell addSubview:label];
            return cell;
        }
        else{
           static NSString * idenfifer = @"ce";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenfifer];
            }
            UILabel * _label =  [cell viewWithTag:1010];
            [_label removeFromSuperview];
            _label = nil;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.text = @"";
            cell.textLabel.text = @"";

            if (indexPath.row == model_detail.modelArray.count + 11) {
                cell.textLabel.text = NSLocalizedString(@"订单详情", nil);

                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"订单号:%@", nil),model_detail.order_id];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
                cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
            }else if (indexPath.row == model_detail.modelArray.count + 20){
                cell.textLabel.text = NSLocalizedString(@"配送信息", nil);

                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            }
            else if (indexPath.row == model_detail.modelArray.count + 15){
                if (_label == nil) {
                    UILabel * addr_label = [[UILabel alloc]init];
                    addr_label.font = [UIFont systemFontOfSize:13];
                    addr_label.frame = FRAME(20, 5, WIDTH - 30, 40);
                    addr_label.numberOfLines = 2;
                    addr_label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
                    [cell addSubview:addr_label];
                    addr_label.tag = 1010;
                    addr_label.text = textLalbelArray[3];
                }
            }else{
                cell.textLabel.text = textLalbelArray[indexPath.row - model_detail.modelArray.count - 12];
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
            }
            UIView * view = [cell viewWithTag:100];
            [view removeFromSuperview];
            view = nil;
            //添加一个分割线
            UIView * label = [[UIView alloc]init];
            label.frame = FRAME(0, 49.5, WIDTH, 0.5);
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
    if (tableView == myTableView_detail&&indexPath.row == 2) {
        NSLog(@"shop_id:%@",model_detail.shop_id);
        if ([model_detail.tmpl_type isEqualToString:@"market"]) {
            JHSupermarketMainVC * vc = [[JHSupermarketMainVC alloc]init];
            vc.shop_id = model_detail.shop_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            JHWaiMaiMainVC * vc = [[JHWaiMaiMainVC alloc]init];
            vc.shop_id = model_detail.shop_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - 这是订单详情界面的申请退单的点击方法
-(void)clicktoBackOrder{
    NSLog(@"申请退款");
}
#pragma mark - 这是订单详情界面的再来一份的按钮
-(void)clickToGetMore{
    JHOrderInfoModel * order_model = [JHOrderInfoModel shareModel];
    [order_model addShopProductsWith:model_detail.product_array
                         withShop_id:model_detail.shop_id];
    JHPlaceWaimaiOrderVC * vc = [[JHPlaceWaimaiOrderVC alloc]init];
    vc.shop_id = model_detail.shop_id;
    vc.isFromAgain = YES;
    vc.amount = [order_model getAllProductPrice:model_detail.shop_id];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是scrollview的代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isMove = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isMove) {
        if (scrollView == myScrollview) {
            if (scrollView.contentOffset.x < WIDTH/2) {
                oldBtn.selected = NO;
                UIButton * btn = btnArray[0];
                btn.selected = YES;
                oldBtn = btn;
            }else {
                if (!isFirst_detail&&scrollView.contentOffset.x == WIDTH) {
                    SHOW_HUD
                    //发送详情的请求
                    [self postDetailHttp];
                }
                oldBtn.selected = NO;
                UIButton * btn = btnArray[1];
                btn.selected = YES;
                oldBtn = btn;
            }
            label_seleter.frame = FRAME(scrollView.contentOffset.x/2, 39, WIDTH/2, 1);
        }
    }
}
#pragma mark - 这是点击呼叫外卖小哥的方法
-(void)clickToCall:(UIButton *)sender{
    //弹出选择电话界面
    NSArray *titleArr;
    NSArray *phoneArr;
    if ([staff_num integerValue] > 0) {
        titleArr = @[NSLocalizedString(@"联系商家", nil),
                     NSLocalizedString(@"联系骑手", nil)
                     ];
        phoneArr = @[shop_num,staff_num];
    }else{
        titleArr = @[NSLocalizedString(@"联系商家", nil)];
        phoneArr = @[shop_num];
    }
    [JHShowAlert showSheetAlertWithTextArr:titleArr withController:self withClickBlock:^(NSInteger tag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneArr[tag]]]];
    }];
//    [self creatUIAlertWithPhone:phone];
}
#pragma mark - 这是弹出警告是否打电话的警告框
-(void)creatUIAlertWithPhone:(NSString *)mobile{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:mobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击取消
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"呼叫", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击呼叫
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",mobile]]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - 这是在去支付的情况下点击取消订单调用的方法
-(void)btnClick:(UIButton *)sender{
    SHOW_HUD
    [self cancelOrderWithOrder_id:model_progress.order_id];
}
#pragma mark - 这是点击去支付/去评价/取消订单的方法的方法
-(void)clickToMore:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去支付", nil)]) {
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = model_progress.order_id;
        vc.amount = model_progress.amount;
        vc.isDetailVC = YES;
        [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            if (success) {
                [self downRefreshForDetail];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"自提码", nil)]){
         [JHTakeawayMengBan shareMengBanWithCode:model_progress.spend_number withType:model_progress.spend_status];
    }
    else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"确认完成", nil)]){
        [HttpTool postWithAPI:@"client/order/confirm" withParams:@{@"order_id":model_progress.order_id} success:^(id json) {
            if ([json[@"error"] isEqualToString:@"0"]) {
                SHOW_HUD
                [self downRefreshForDetail];
                if (self.myBloack) {
                    self.myBloack();
                }
            }else{
                [self creatUIAlertControlWithMessage:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器出错,请稍后重试", nil)];
            NSLog(@"%@",error.localizedDescription);
        }];
    }else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"查看评价", nil)]){
        NSLog(@"点击了查看评价");
        JHSEvalauteVC * vc = [[JHSEvalauteVC alloc]init];
        vc.order_id = model_progress.order_id;
        vc.isZiti = ([model_progress.pei_type intValue] == 3) ? YES : NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"去评价", nil)]){
        NSLog(@"取消的是去评价的方法");
        JHShopEvaluationVC * vc = [[JHShopEvaluationVC alloc]init];
        vc.order_id = model_progress.order_id;
//        vc.deliverTime = model_progress.dateline;
//        vc.number = model_progress.jifen;
//        vc.isZiti = ([model_progress.pei_type intValue] == 3) ? YES : NO;
        vc.shopEvaluationSuccess = ^{
            if(self.myBloack){
               self.myBloack();
            }
            if (isFirst_detail) {
                [self downRefreshForDetail];
            }
            [self downRefreshForOrder];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消订单", nil)]){
        NSLog(@"点击的是取消订单");
        //取消订单
        SHOW_HUD
        [self cancelOrderWithOrder_id:model_progress.order_id];
        
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
            [self downRefreshForOrder];
            if (isFirst_detail) {
                [self downRefreshForDetail];
            }
            if (self.myBloack) {
                 self.myBloack();
            }
        }else{
            [self creatUIAlertControlWithMessage:json[@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器失败", nil)];
    }];
}
#pragma mark - 这是点击投诉的方法
-(void)clicktoComplain{
    NSLog(@"这是投诉的方法");
    if ([model_progress.order_status integerValue] >= 2) {
        JHComplainVC * vc = [[JHComplainVC alloc]init];
        vc.order_id = model_progress.order_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
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
            [self creatUIAlertControlWithMessage:NSLocalizedString(@"连接服务器失败", nil)];
        }];
    }else{
            [self creatUIAlertControlWithMessage:NSLocalizedString(@"该时段无法催单", nil)];
    }
}
#pragma mark - 创建mapView
-(void)creatMapViewWithCell:(UITableViewCell *)cell{
    if (_mapView == nil) {
        _mapView = [[XHMapView alloc] initWithFrame:CGRectMake(0,0, WIDTH,150)];
        [cell addSubview:_mapView];
    }
    _mapView.lat = lat;
    _mapView.lng = lng;
    CLLocationCoordinate2D pei = CLLocationCoordinate2DMake(lat,lng);
    CLLocationCoordinate2D custom = CLLocationCoordinate2DMake(model_progress.lat.doubleValue,model_progress.lng.doubleValue);
    [_mapView changeDistanceWithCustomCoordinate:custom peiCoordinate:pei];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _mapView.lat = lat;
        _mapView.lng = lng;
    });
}
#pragma mark - 这是订单进度下拉刷新的方法
-(void)downRefreshForOrder{
    isFirstMap = NO;
    //发送订单进度的请求
    [self postProgressHtttp];
}
#pragma mark - 这是订单详情下拉刷新的方法
-(void)downRefreshForDetail{
    [self downRefreshForOrder];
    //发送详情的请求
    [self postDetailHttp];

}
#pragma mark - 创建提示框
-(void)creatUIAlertControlWithMessage:(NSString *)msg{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - ************开启定时器*************
-(void)startNSTimer{
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    }
    [timer fire];
}
#pragma mark - 定时器调用的方法
-(void)updateLocation{
    [self downRefreshForOrder];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_LOCATION" object:nil userInfo:dic_location];
}
#pragma mark - 关闭定时器
-(void)stopNSTimer{
    [timer invalidate];
     timer = nil;
}
#pragma mark - ************判断按钮的状态***********
-(void)judgeBtnState:(UIButton *)sender{
    if([model_progress.order_status integerValue] == 0 && [model_progress.pay_status integerValue] == 0&&[model_progress.online_pay isEqualToString:@"1"]){
        [sender setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
        
    }else if (([model_progress.order_status integerValue] == 0&& [model_progress.pay_status integerValue] == 1)||([model_progress.order_status integerValue] == 0&&[model_progress.online_pay isEqualToString:@"0"])){
        [sender setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
        
    }else if(([model_progress.order_status integerValue] == 1||[model_progress.order_status integerValue] == 2) && [model_progress.pei_type integerValue] != 3){
        [sender setTitle:NSLocalizedString(@"等待配送", nil) forState:UIControlStateNormal];
        if (model_progress.pei_type.integerValue == 4) {
            [sender setTitle:NSLocalizedString(@"等待出餐", nil) forState:UIControlStateNormal];
        }
        sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }else if(([model_progress.order_status integerValue] == 1||[model_progress.order_status integerValue] == 2) && [model_progress.pei_type integerValue] == 3){
        [sender setTitle:NSLocalizedString(@"自提码", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
    }
    else if ([model_progress.order_status integerValue]== 4||[model_progress.order_status integerValue] == 3){
        [sender setTitle:NSLocalizedString(@"确认完成", nil) forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor orangeColor];
    }
    else if ([model_progress.order_status intValue] == 8 && [model_progress.comment_status intValue] == 0){
        [sender setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        sender.backgroundColor = THEME_COLOR;
    }else if([model_progress.order_status intValue] == 8 && [model_progress.comment_status intValue] == 1){
        [sender setTitle:NSLocalizedString(@"查看评价", nil) forState:UIControlStateNormal];
        sender.backgroundColor = THEME_COLOR;
        ;
    }else if ([model_progress.staff_id integerValue] > 0  && [model_progress.order_status intValue] == 1){
        [sender setTitle:NSLocalizedString(@"等待配送", nil) forState:UIControlStateNormal];
        if (model_progress.pei_type.integerValue == 4) {
            [sender setTitle:NSLocalizedString(@"等待出餐", nil) forState:UIControlStateNormal];
        }
        sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
//    else if([model_progress.order_status integerValue] == 3){
//        [sender setTitle:NSLocalizedString(@"服务中", nil) forState:UIControlStateNormal];
//        sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
 //   }
else if([model_progress.order_status intValue] == -1){
        [sender setTitle:NSLocalizedString(@"订单已取消", nil) forState:UIControlStateNormal];
        sender.titleLabel.adjustsFontSizeToFitWidth = YES;
        sender.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else{
        sender.backgroundColor = [UIColor clearColor];
    }
}
@end

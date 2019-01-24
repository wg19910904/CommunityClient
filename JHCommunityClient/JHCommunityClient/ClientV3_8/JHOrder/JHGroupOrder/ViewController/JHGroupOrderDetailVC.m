//
//  JHGroupOrderDetailVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHGroupOrderDetailVC.h"
#import <MJRefresh.h>
#import "JHGroupOrderDetailShopCell.h"
#import "JHAllOrderTableFooterView.h"
#import "JHGroupOrderDetailProductCell.h"
#import "JHGroupOrderDetailCouponCell.h"
#import "YFLabTableViewCell.h"
#import "YFTypeBtn.h"

@interface JHGroupOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,JHOrderStatusActionProtocol>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)JHGroupOrderModel *orderDetailModel;
@end

@implementation JHGroupOrderDetailVC

-(void)viewDidLoad{
    
    [super viewDidLoad];

    self.navigationItem.title =  NSLocalizedString(@"订单详情", NSStringFromClass([self class]));
    [self setUpView];
    [self getData];
    
}

-(void)clickBackBtn{
    if(self.tabBarController.selectedIndex == 4){
        JHBaseVC * vc = self.navigationController.viewControllers[1];
        if (self.isPayCome) {
            [self.navigationController popToViewController:vc animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.orderDetailModel) {
        [self hiddenEmptyView];
        return 3;
    }else{
       [self showEmptyViewWithImgName:@"nomessage" desStr:nil btnTitle:nil inView:tableView];
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.orderDetailModel.ticket_number length] == 0 ? 1 : 2;
    }
    return section == 2 ? self.orderDetailModel.orderInfoArr.count : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JHGroupOrderDetailProductCell *cell=[JHGroupOrderDetailProductCell initWithTableView:tableView reuseIdentifier:@"JHGroupOrderDetailProductCell"];
            [cell reloadCellWithModel:self.orderDetailModel];
            return cell;
        }else{
            JHGroupOrderDetailCouponCell *cell=[JHGroupOrderDetailCouponCell initWithTableView:tableView reuseIdentifier:@"JHGroupOrderDetailCouponCell"];
            [cell reloadCellWithModel:self.orderDetailModel];
            return cell;
        }
    }else if (indexPath.section == 1) {
        JHGroupOrderDetailShopCell *cell=[JHGroupOrderDetailShopCell initWithTableView:tableView reuseIdentifier:@"JHGroupOrderDetailShopCell"];
        
        __weak typeof(self) weakSelf=self;
        cell.goShopDetail = ^(BOOL success, NSString *msg) {
            [weakSelf pushToNextVcWithVcName:@"JHShopHomepageVC" params:@{@"shop_id":weakSelf.orderDetailModel.shop_id}];
        };
        cell.telCallblock = ^(BOOL success, NSString *msg) {
            [weakSelf showMobile:weakSelf.orderDetailModel.shop_phone];
        };
        [cell reloadCellWithModel:self.orderDetailModel];
        return cell;
    }
   
    YFLabTableViewCell *cell=[YFLabTableViewCell initWithTableView:tableView reuseIdentifier:@"YFLabTableViewCell"];
    cell.lineView.hidden = indexPath.row != 3;
    if (self.orderDetailModel.haveCouponOrRedWrap && indexPath.row != 3) {
        cell.lineView.hidden = (indexPath.row != self.orderDetailModel.orderInfoArr.count -2 -1);
    }
    
    NSDictionary *dic = self.orderDetailModel.orderInfoArr[indexPath.row];
    
    [cell reloadCellWithTitle:dic[@"title"] center:dic[@"center"] right:dic[@"right"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 45 : 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) return self.orderDetailModel.order_button.count == 0 ? 8 : 45 + 16;
    if (section == 1) return 40 + 16;
    else return 40 + 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    UILabel *lab = [UILabel new];
    if (section == 0) {
        view.backgroundColor = Orange_COLOR;
        UIImageView *imgView = [UIImageView new];
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.offset(0);
            make.width.offset(20);
            make.height.offset(20);
        }];
        
        BOOL cancel = self.orderDetailModel.order_status == -1 && self.orderDetailModel.pay_status == 0;
        BOOL success = self.orderDetailModel.order_status == -1 && self.orderDetailModel.pay_status == 1;
        success = self.orderDetailModel.order_status == 8 && self.orderDetailModel.comment_status == 1;
        
        NSString *img = @"order_wait_pay";
        if (cancel) img = @"order_pay_error";
        if (success) img = @"order_pay_success";
        imgView.image = IMAGE(img);
        view.backgroundColor = cancel ? HEX(@"c5c5c5", 1.0) : Orange_COLOR;
        
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(15);
            make.centerY.offset(0);
            make.height.offset(20);
        }];
        lab.font = FONT(17);
        lab.textColor = [UIColor whiteColor];
        lab.text = self.orderDetailModel.order_status_label;
    }else{
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.offset(0);
            make.height.offset(20);
        }];
        lab.font = FONT(14);
        lab.textColor = HEX(@"999999", 1.0);
        lab.text = section == 1 ?  NSLocalizedString(@"商家信息", NSStringFromClass([self class])) :  NSLocalizedString(@"订单详情", NSStringFromClass([self class]));
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.bottom.offset=-0.5;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=BACKGROUND_COLOR;
    }
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *returnView;
    if (section == 0) {
        if (self.orderDetailModel.order_button.count != 0) {
            JHAllOrderTableFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JHAllOrderDetailFooterView"];
            if (!footerView) {
                footerView = [[JHAllOrderTableFooterView alloc] initWithReuseIdentifier:@"JHAllOrderDetailFooterView" btnMasRect:JHAllOrderFooterBtnMasRectMake(20, (7.5+8), (7.5+8), 80, 20)];
                footerView.delegate = self;
            }
            
            [footerView reloadViewWith:self.orderDetailModel];
            
            returnView = footerView;
        }else{
            returnView = [UIView new];
        }
        
    }else{
        UIButton *back_btn = [UIButton new];
        back_btn.tag = 100 + section;
        back_btn.backgroundColor = [UIColor whiteColor];
        [back_btn addTarget:self action:@selector(clickFooter:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lab = [UILabel new];
        [back_btn addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.offset(8 + 10);
            make.height.offset(20);
        }];
        lab.font = FONT(14);
        lab.textColor = HEX(@"333333", 1.0);
        lab.text = section == 1 ?  NSLocalizedString(@"查看图文详情", NSStringFromClass([self class])) :  NSLocalizedString(@"遇到问题", NSStringFromClass([self class]));
        
        UIImageView *arrowImgView = [UIImageView new];
        [back_btn addSubview:arrowImgView];
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.centerY.equalTo(lab.mas_centerY);
            make.width.offset(10);
            make.height.offset(20);
        }];
        arrowImgView.contentMode = UIViewContentModeCenter;
        arrowImgView.image = IMAGE(@"arrowR");
        
        if (section == 2) {
            UILabel *rightLab = [UILabel new];
            [back_btn addSubview:rightLab];
            [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-40);
                make.centerY.equalTo(lab.mas_centerY);
                make.height.offset(20);
            }];
            rightLab.font = FONT(14);
            rightLab.textColor = HEX(@"333333", 1.0);
            rightLab.text =  NSLocalizedString(@"呼叫人工服务", NSStringFromClass([self class]));
        }

       returnView = back_btn;
    }
    
    UIView *top_lineView=[UIView new];
    [returnView addSubview:top_lineView];
    [top_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=8;
    }];
    top_lineView.backgroundColor=BACKGROUND_COLOR;
    
    if (section != 2) {
        UIView *bottom_lineView=[UIView new];
        [returnView addSubview:bottom_lineView];
        [bottom_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.bottom.offset=0;
            make.right.offset=0;
            make.height.offset=8;
        }];
        bottom_lineView.backgroundColor=BACKGROUND_COLOR;
    }
    
    return returnView;
}


// 点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {// 团购商品详情
        [self pushToNextVcWithVcName:@"JHTuanGouProductDetailVC" params:@{@"tuan_id":self.orderDetailModel.tuan_id,@"shop_id":self.orderDetailModel.shop_id}];
    }
}

#pragma mark ====== Functions =======
// 获取订单详情数据
-(void)getData{
    
    SHOW_HUD
    [JHGroupOrderModel getGroupOrderDetail:self.order_id block:^(id model, NSString *msg) {
        HIDE_HUD
        [self.tableView.mj_header endRefreshing];
        if (model) {
            self.orderDetailModel = model;
            [self.tableView reloadData];
        }else [self showToastAlertMessageWithTitle:msg];
    }];
    
}

// 点击footerView
-(void)clickFooter:(UIButton *)btn{
    if (btn.tag - 100 == 1) {// 查看图文详情
        [self pushToNextVcWithVcName:@"JHTempWebViewVC" params:@{@"url":self.orderDetailModel.link}];
    }else{// 遇到问题
        [self showMobile:self.orderDetailModel.site_phone];
    }
}

#pragma mark ====== JHOrderStatusActionProtocol =======
// 钱款去向
-(void)moneyDirectionWithOrder_id:(NSString *)order_id tuikuan_url:(NSString *)url{
    [self pushToNextVcWithVcName:@"JHTempWebViewVC" params:@{@"url":url}];
}
// 取消订单
-(void)cancleOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHGroupOrderModel cancelOrderWith:order_id block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            [self getData];
        }
        [self showToastAlertMessageWithTitle:msg];
    }];
}

// 去支付
-(void)payOrderWithOrder_id:(NSString *)order_id amount:(NSString *)amount{
    
    __weak typeof(self) weakSelf=self;
    MsgBlock block = ^(BOOL success, NSString *msg){
        if (success) {
            [weakSelf getData];
            [self showToastAlertMessageWithTitle:msg];
        }
        
    };
    [self pushToNextVcWithVcName:@"JHWMPayOrderVC"
                          params:@{@"order_id":order_id,
                                   @"amount":amount,
                                   @"isDetailVC":@(YES),
                                   @"isTuan":@(YES),
                                   @"paySuccessBlock":block}];

}

// 退款
-(void)refundOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHGroupOrderModel refundOrderWith:order_id block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            [self getData];
        }
        [self showToastAlertMessageWithTitle:msg];
    }];
}

// 查看券码
-(void)viewCodeWithOrder_id:(NSString *)order_id ticket_url:(NSString *)url{
    [self pushToNextVcWithVcName:@"JHTempWebViewVC" params:@{@"url":url}];
}

// 去评价
-(void)commentOrderWithOrder_id:(NSString *)order_id{
    __weak typeof(self) weakSelf=self;
    void (^evaluateSuccess)(void) = ^(){
        [weakSelf getData];
    };
    [self pushToNextVcWithVcName:@"JHPersonEvaluationVC"
                          params:@{@"order_id":order_id,
                                   @"isTuan":@(YES),
                                   @"personEvaluationSuccess":evaluateSuccess
                                   }];
    
}

// 查看评价
-(void)viewCommentWithOrder_id:(NSString *)order_id pei_type:(NSString *)pei_type{
    [self pushToNextVcWithVcName:@"JHPEvaluateVC" params:@{@"order_id":order_id,@"isTuan":@(YES)}];
}

@end

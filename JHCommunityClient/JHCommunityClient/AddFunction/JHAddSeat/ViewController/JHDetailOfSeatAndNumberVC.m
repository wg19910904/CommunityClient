//
//  JHDetailOfSeatAndNumberVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHDetailOfSeatAndNumberVC.h"
#import <MJRefresh.h>
#import "GetNumberCell.h"
#import "SeatCell.h"
#import "TitleBtnLeft.h"
#import "SeatNumberBottomView.h"
#import "YFAlertView.h"
#import "CancelSeatView.h"
#import "JHPathMapVC.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHShopHomepageVC.h"
 
@interface JHDetailOfSeatAndNumberVC()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)SeatNumberBottomView *bottomView;
@property(nonatomic,strong)YFAlertView *alerView;
@property(nonatomic,strong)CancelSeatView *cancelView;
@property(nonatomic,strong)SeatModel *seatModel;
@property(nonatomic,strong)GetNumberModel *numberModel;
@property(nonatomic,strong)NSArray *reasonArray;
@end

@implementation JHDetailOfSeatAndNumberVC


-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self getDetail];
     self.navigationItem.title=self.is_seat ? NSLocalizedString(@"订座详情", nil) : NSLocalizedString(@"号单详情", nil);
    [self getCancelResule];
}
#pragma mark - 获取取消理由
-(void)getCancelResule{
    NSString  *str = self.is_seat ? @"client/yuyue/dingzuo/cancelreason" : @"client/yuyue/paidui/cancelreason";
    [HttpTool postWithAPI:str withParams:@{} success:^(id json) {
        if ([json[@"error"] isEqualToString:@"0"]) {
            self.reasonArray = json[@"data"][@"items"];
        }else{
            
        }
    } failure:^(NSError *error) {
        [self showMsg:NSLocalizedString(@"网络链接有误!", nil)];
    }];
}
-(void)clickBackBtn{
    if (self.tabBarController.selectedIndex == 0 || self.tabBarController.selectedIndex == 1) {
        NSArray * array = self.navigationController.viewControllers;
        JHBaseVC * vc = array[1];
        [self.navigationController popToViewController:vc animated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)setUpView{
    
    [self creatRightBtnWith:@"call-white" sel:@selector(onClickTel) edgeInsets:UIEdgeInsetsMake(7.5, 20, 7.5, -10)];

    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=HEX(@"fafafa", 1.0);
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDetail];
    }];
    
    SeatNumberBottomView *bottomView=[[SeatNumberBottomView alloc] initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    [self.view addSubview:bottomView];
    bottomView.is_seat=self.is_seat;
    self.bottomView=bottomView;
    bottomView.status=WAITSHOPSURE;
    
    
    bottomView.cancleOrder=^{//取消订单
        self.cancelView.cancelArr=self.reasonArray;
        [self.cancelView show];
        __weak typeof(self) weakSelf=self;
        self.cancelView.clickSure=^(NSString *cancelStr){
            if (cancelStr.length==0) {
                [weakSelf showMsg:NSLocalizedString(@"您还没选择取消理由", nil) ];
            }else{
                [weakSelf cancelOrderWithStr:cancelStr];
            }
        };
    };
    
    bottomView.deleteOrder=^{//删除订单
        if (self.is_seat) self.alerView.desStr=@"确定删除该预约订单?确定删除后当前订单不在显示";
        else self.alerView.desStr=@"删除后您的排号信息无法恢复,请您谨慎选择";
        [self.alerView show];
        __weak typeof(self) weakSelf=self;
        self.alerView.clickSure=^(){
            [weakSelf deleteOrder];
        };
    };
    
}
#pragma mark - 取消订单的判断
-(void)cancelOrderWithStr:(NSString *)str{
    if (self.is_seat) {
        [ SeatModel cancelDingZuoWithId:self.order_id reasonStr:str  block:^(NSArray *arr, NSString *msg) {
            if (!msg) {
                [self getDetail];
            }else{
                [self showMsg:msg];
            }
        }];
    }else{
        [ GetNumberModel cancelPaiDuiWithId:self.order_id reasonStr:str  block:^(NSArray *arr, NSString *msg,int count) {
            if (!msg) {
                [self getDetail];
            }else{
                [self showMsg:msg];
            }
        }];

    }
}
#pragma mark - 删除订单的判断
-(void)deleteOrder{
    if (self.is_seat) {
        [ SeatModel deleteDingZuoWithId:self.order_id block:^(NSArray *arr, NSString *msg) {
            if (!msg) {
                [self clickBackBtn];
            }else{
                [self showMsg:msg];
            }
        }];
    }else{
        [ GetNumberModel deletePaiDuiWithId:self.order_id block:^(NSArray *arr, NSString *msg,int count) {
            if (!msg) {
                 [self clickBackBtn];
            }else{
                [self showMsg:msg];
            }
        }];
        
    }
}

#pragma mark ======打电话=======
-(void)onClickTel{
    [self showMobile:self.is_seat? self.seatModel.shop_detail[@"phone"] : self.numberModel.shop_detail[@"phone"]];
}

#pragma mark ======获取详情=======
-(void)getDetail{
    SHOW_HUD
    if (self.is_seat) {
        [SeatModel getSeatModelDetail:self.order_id block:^(SeatModel *model, NSString *msg) {
            HIDE_HUD
            [self.tableView.mj_header endRefreshing];
            if (model) {
                if (!self.tableView) [self setUpView];
                 self.seatModel=model;
                [self.tableView reloadData];
                [self setBottomStatus];
            }else [self showMsg:msg];
        }];
    }else{
        [GetNumberModel getNumberDetail:self.order_id block:^(GetNumberModel *model, NSString *msg) {
            HIDE_HUD
            [self.tableView.mj_header endRefreshing];
            if (model) {
                if (!self.tableView) [self setUpView];
                self.numberModel=model;
                [self.tableView reloadData];
                [self setBottomStatus];
            }else [self showMsg:msg];
        }];
    }
    
}

-(void)setBottomStatus{
    int status = self.is_seat ? self.seatModel.order_status:self.numberModel.order_status;
    switch (status) {
        case 0:
        {
            self.bottomView.y=HEIGHT-50;
             self.bottomView.status=WAITSHOPSURE;
        }
            break;
        case 1:
        {
            self.bottomView.y=HEIGHT;
             self.bottomView.status=SUCCESS;
        }
            break;
            
        case 2:
        {
            self.bottomView.y=HEIGHT-50;
            self.bottomView.status=COMPLETE;
        }
            break;
        default:
        {
            self.bottomView.y=HEIGHT-50;
             self.bottomView.status=CANCEL;
        }
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section==1) {
        
        if (self.is_seat) {
            static NSString * ID=@"JHDetailSeatCell";
            SeatCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell=[[SeatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            
//            BOOL is_show=YES;
//            if (self.tabBarController.selectedIndex!=1 &&4!=0) is_show=YES;
            
            [cell reloadCellWithModel:self.seatModel is_detail:YES show_goShop:YES];
//            if (is_show) {
                cell.clickGoShopDetail=^{//商家详情
                    JHShopHomepageVC *vc = [[JHShopHomepageVC alloc] init];
                    vc.shop_id = self.seatModel.shop_id;
                    [self.navigationController pushViewController:vc animated:YES];
                };
//            }
            
            return cell;
       
        }else{
            static NSString * ID=@"JHDetailNumberCell";
            GetNumberCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell=[[GetNumberCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            
//            BOOL is_show=YES;
//            if (self.tabBarController.selectedIndex!=1 && self.tabBarController.selectedIndex!=0) is_show=YES;
            
            [cell reloadCellWithModel:self.numberModel is_detail:YES show_goShop:YES];
//            if (is_show) {
                cell.clickGoShopDetail=^{//商家详情
                    JHShopHomepageVC *vc = [[JHShopHomepageVC alloc] init];
                    vc.shop_id = self.numberModel.shop_id;
                    [self.navigationController pushViewController:vc animated:YES];
                };
//            }
            
            return cell;
            
        }
    }else{
        static NSString * ID=@"JHDetailSeatAndNumberNormalCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
       
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            TitleBtnLeft *statusBtn=[TitleBtnLeft new];
            [cell.contentView addSubview:statusBtn];
            [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=10;
                make.top.offset=10;
                make.height.offset=20;
            }];
            statusBtn.titleFont=FONT(14);
            statusBtn.titleColor=HEX(@"333333", 1.0);
            statusBtn.tag=100;
            statusBtn.userInteractionEnabled=NO;
            if (indexPath.section==2){
                UIImageView *imgView=[UIImageView new];
                [cell.contentView addSubview:imgView];
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset=-10;
                    make.centerY.offset=0;
                    make.width.offset=20;
                    make.height.offset=20;
                }];
                imgView.contentMode=UIViewContentModeCenter;
                imgView.image=IMAGE(@"arrow-r copy");
            }
        }
        
        TitleBtnLeft *statusBtn=(TitleBtnLeft *)[cell viewWithTag:100];
        NSString *imgStr=@"";
        NSString *titleStr=@"";
        if (indexPath.section==0) {
            
            if(self.is_seat){
                imgStr=@"icon-wait";
                titleStr=self.seatModel.order_status_label;
            }else{
                imgStr=@"icon-select-click";
                titleStr=self.numberModel.order_status_label;
            }
        }else{
            imgStr=@"icon-location";
            titleStr=@"查看餐厅位置信息";
        }
        statusBtn.imgName=imgStr;
        statusBtn.titleStr=titleStr;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1)  return 180;
    return 40;
}

#pragma mark ======查看位置信息=======
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return;
    }
    JHPathMapVC *vc = [[JHPathMapVC alloc] init];
    vc.is_hiddenPath=YES;
    double latG;
    double lngG;
    float lat = self.is_seat?[self.seatModel.shop_detail[@"lat"] floatValue] :  [self.numberModel.shop_detail[@"lat"] floatValue];
    float lng = self.is_seat?[self.seatModel.shop_detail[@"lng"] floatValue] :  [self.numberModel.shop_detail[@"lng"] floatValue];
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:lat
                                                 WithBD_lon:lng
                                                 WithGD_lat:&latG
                                                 WithGD_lon:&lngG];
    vc.lat = @(latG).stringValue;
    vc.lng = @(lngG).stringValue;
    vc.shopName = self.is_seat?self.seatModel.shop_detail[@"title"]:self.numberModel.shop_detail[@"title"];
    vc.shopAddr = self.is_seat?self.seatModel.shop_detail[@"addr"]:self.numberModel.shop_detail[@"addr"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(YFAlertView*)alerView{
    if (_alerView==nil) {
        _alerView=[[YFAlertView alloc] initWithFrame:FRAME(0, 0, WIDTH-40, 100)];
    }
    return _alerView;
}

-(CancelSeatView *)cancelView{
    if (_cancelView==nil) {
        _cancelView=[[CancelSeatView alloc] initWithFrame:FRAME(0, 0, WIDTH-40, 100)];
    }
    return _cancelView;
}

@end

//
//  JHIntegrationOrderDetailVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHIntegrationOrderDetailVC.h"
#import "JHIntegrationOrderListCell.h"
#import "JHIntegrationDetailCell.h"
#import "JHIntegrationCancelMengBan.h"
#import "JHIntegrationOrderProductModel.h"
 
#import "JHIntegralMallVC.h"
#import "JHIntegrationOrderListVC.h"
#import "JHIntegrationOrderListModel.h"
#import "TransformTime.h"
#import "JHIntegrationOrderProductModel.h"
#import "JHWMPayOrderVC.h"
#import "JHShowAlert.h"
@interface JHIntegrationOrderDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_integrationOrderDetailTableView;
    UIButton *_bottomBnt;//底部按钮
    UIButton *_cancelBnt;//取消订单按钮
    BOOL _isIntegration;
    JHIntegrationOrderListModel *_detailModel;
}
@end

@implementation JHIntegrationOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"订单详情", nil);
    [self requestData];
}
#pragma mark--===重新返回方法
- (void)clickBackBtn{
    if(_isPayCome){
        NSArray *vc = self.navigationController.viewControllers;
        [vc enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[JHIntegrationOrderListVC class]]){
                [self.navigationController popToViewController:obj animated:YES];
                _isIntegration = YES;
                *stop = YES;
            }
        }];
        if(!_isIntegration){
            [vc enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:[JHIntegralMallVC class]]){
                    [self.navigationController popToViewController:obj animated:YES];
                    *stop = YES;
                }
            }];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}
#pragma mark-====创建底部按钮
- (void)creatBottomButton{
    [_bottomBnt removeFromSuperview];
    _bottomBnt = nil;
    _bottomBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBnt.frame = FRAME(0, HEIGHT - 50, WIDTH, 50);
    _bottomBnt.titleLabel.font = FONT(16);
    _bottomBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomBnt addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if([_detailModel.pay_status integerValue] == 0 && [_detailModel.order_status integerValue] != -1){
        //未支付
        [_bottomBnt setBackgroundColor:HEX(@"ff6600", 1.0f) forState:UIControlStateNormal];
        [_bottomBnt setBackgroundColor:HEX(@"ff6600", 0.6f) forState:UIControlStateHighlighted];
        [_bottomBnt setBackgroundColor:HEX(@"ff6600", 0.6f) forState:UIControlStateSelected];
        [_bottomBnt setTitle:NSLocalizedString(@"支付订单", nil) forState:UIControlStateNormal];
        [self.view addSubview:_bottomBnt];
        _integrationOrderDetailTableView.frame = FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50);
    }
    if([_detailModel.order_status integerValue] >= 3 && [_detailModel.order_status integerValue] < 8){
        [_bottomBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [_bottomBnt setBackgroundColor:THEME_COLOR forState:UIControlStateHighlighted];
        [_bottomBnt setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
        [_bottomBnt setTitle:NSLocalizedString(@"确认收货", nil) forState:UIControlStateNormal];
        [self.view addSubview:_bottomBnt];
        _integrationOrderDetailTableView.frame = FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50);
    }
}

#pragma mark-===底部按钮点击事件
- (void)clickBottomButton:(UIButton *)sender{
    NSLog(@"点击底部按钮");
    if([sender.currentTitle isEqualToString:NSLocalizedString(@"确认收货", nil)]){
        [HttpTool postWithAPI:@"client/mall/order/confirm" withParams:@{@"order_id":_detailModel.order_id} success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                if(self.confirmBlock){
                    self.confirmBlock();
                }
                [self requestData];
                HIDE_HUD
            }else{
                HIDE_HUD
                [self showNoNetOrBusy:NO];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"erorr%@",error.localizedDescription);
            [self showNoNetOrBusy:YES];
        }];
  
    }else if ([sender.currentTitle isEqualToString:NSLocalizedString(@"支付订单", nil)]){
        
        JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
        vc.order_id = _detailModel.order_id;
        vc.amount = _detailModel.amount;
        vc.isIntegration = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark-===创建导航栏右侧取消订单按钮
- (void)createCancelButton{
     [_cancelBnt removeFromSuperview];
      _cancelBnt = nil;
        _cancelBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBnt.layer.cornerRadius = 4.0f;
        _cancelBnt.layer.borderColor = [UIColor whiteColor].CGColor;
        _cancelBnt.layer.borderWidth = 0.5f;
        _cancelBnt.clipsToBounds = YES;
        _cancelBnt.titleLabel.font = FONT(14);
        _cancelBnt.frame = FRAME(0,0, 70, 30);
        _cancelBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelBnt setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        [_cancelBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBnt addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
     if([_detailModel.order_status integerValue] == 0){
         UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_cancelBnt];
         self.navigationItem.rightBarButtonItem = item;
     }
}
#pragma mark--==取消订单按钮点击事件
- (void)clickCancelButton{
    NSLog(@"取消按钮");
    [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil)
                        withMessage:NSLocalizedString(@"您确定要取消该订单吗?", nil)
                     withBtn_cancel:NSLocalizedString(@"取消", nil)
                       withBtn_sure:NSLocalizedString(@"确定", nil) withCancelBlock:nil withSureBlock:^{
        [self cancleOrder:self.order_id];
    }];
}
#pragma mark -取消订单调用的接口
-(void)cancleOrder:(NSString *)order_id{
    SHOW_HUD
    NSDictionary *dic = @{@"order_id":order_id,@"reason":@""};
    NSString *api = @"client/mall/order/cancel";
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        HIDE_HUD
        if([json[@"error"] isEqualToString:@"0"]){
            [self.navigationController popViewControllerAnimated:YES];
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        }else{
            [self showMsg:json[@"error"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showMsg:NSLocalizedString(@"连接网络错误,请稍后再试!", nil)];
        
    }];
}
#pragma mark-====请求网络数据
- (void)requestData{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/mall/order/detail" withParams:@{@"order_id":self.order_id} success:^(id json) {
        
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            _detailModel = [[JHIntegrationOrderListModel alloc] init];
            [_detailModel setValuesForKeysWithDictionary:json[@"data"][@"order"]];
            for(NSDictionary *dic in _detailModel.product_list){
                JHIntegrationOrderProductModel *productModel = [[JHIntegrationOrderProductModel alloc] init];
                [productModel setValuesForKeysWithDictionary:dic];
                [_detailModel.productArray addObject:productModel];
            }
            [self createIntegrationOrderDetailTableView];
            [self createCancelButton];
            [self creatBottomButton];
            HIDE_HUD
        }else{
            HIDE_HUD
            [self showNoNetOrBusy:NO];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
        [self showNoNetOrBusy:YES];
        
    }];
}
#pragma mark-===创建订单详情表视图
- (void)createIntegrationOrderDetailTableView{
    if(_integrationOrderDetailTableView == nil){
        _integrationOrderDetailTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _integrationOrderDetailTableView.delegate = self;
        _integrationOrderDetailTableView.dataSource = self;
        _integrationOrderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [UIView new];
        view.backgroundColor = BACK_COLOR;
        _integrationOrderDetailTableView.backgroundView = view;
        _integrationOrderDetailTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_integrationOrderDetailTableView];
    }else{
        [_integrationOrderDetailTableView reloadData];
    }
}
#pragma mark--=====UITableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
      return _detailModel.productArray.count;
    else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0)
        return 40;
    else
        return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 50;
    else
        return 10;
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 80;
    else
        return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        JHIntegrationOrderListCell *cell = [[JHIntegrationOrderListCell alloc] init];
        cell.integrationProductModel = _detailModel.productArray[indexPath.row];
        return cell;
    }else{
        JHIntegrationDetailCell *cell = [[JHIntegrationDetailCell alloc] init];
        [cell setDetailModel:_detailModel];
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
        line.backgroundColor = LINE_COLOR;
        [backView addSubview:line];
        UILabel *title = [[UILabel alloc] initWithFrame:FRAME(10, 0, 80, 40)];
        title.font = FONT(14);
        title.textColor = HEX(@"333333", 1.0f);
        title.text = NSLocalizedString(@"合计", nil);
        [backView addSubview:title];
        UILabel *totalFee = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 130, 0, 120, 40)];
        totalFee.textColor = HEX(@"ff6600", 1.0f);
        totalFee.text = [NSString stringWithFormat:NSLocalizedString(@"¥%@", nil),_detailModel.amount];
        totalFee.font = FONT(14);
        totalFee.textAlignment = NSTextAlignmentRight;
        [backView addSubview:totalFee];
        return backView;
    }else
        return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [UIView new];
        view.backgroundColor = BACK_COLOR;
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:FRAME(0, 10, WIDTH, 40)];
        [view addSubview:statusLabel];
        statusLabel.backgroundColor = [UIColor whiteColor];
        statusLabel.font = FONT(14);
        statusLabel.textColor = HEX(@"333333", 1.0f);
        statusLabel.text = [NSString stringWithFormat:@"  %@-%@",_detailModel.order_status_label,[TransformTime transfromWithString:_detailModel.dateline withFormat:@"yyyy-MM-dd HH:mm"]];
        NSMutableAttributedString *statusAttributed = [[NSMutableAttributedString alloc] initWithString:statusLabel.text];
        NSRange range = [statusLabel.text rangeOfString:[NSString stringWithFormat:@"-%@",[TransformTime transfromWithString:_detailModel.dateline withFormat:@"yyyy-MM-dd HH:mm"]]];
        [statusAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:range];
        [statusAttributed addAttributes:@{NSFontAttributeName:FONT(12)} range:range];
        statusLabel.attributedText = statusAttributed;
        UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
        line.backgroundColor = LINE_COLOR;
        [view addSubview:line];
        return view;
    }else
        return nil;
}
@end

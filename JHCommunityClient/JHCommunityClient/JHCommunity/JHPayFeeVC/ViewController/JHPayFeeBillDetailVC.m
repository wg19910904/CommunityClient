//
//  JHPayFeeBillDetailVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPayFeeBillDetailVC.h"
#import "JHPayBillDetailCell.h"
#import "JHPayFeeVC.h"
#import "CommunityHttpTool.h"
#import "JHPayFeeBillDetailFrameModel.h"
#import "JHPayFeeBillListModel.h"
#import "JHPayFeeBillListVC.h"
@interface JHPayFeeBillDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_payBillDetailTableView;
    UIButton *_payBnt;//立即缴费按钮
    JHPayFeeBillDetailFrameModel *_frameModel ;
}
@end

@implementation JHPayFeeBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"账单详情", nil);
     _frameModel = [[JHPayFeeBillDetailFrameModel alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initPayButton];
    [self requesData];
}
#pragma mark--==请求网络
- (void)requesData{
    SHOW_HUD
    NSDictionary *dioc = @{@"bill_id":self.bill_id};
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/bill/detail" withParams:dioc success:^(id json) {
        NSLog(@"%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
           
            JHPayFeeBillListModel *model = [[JHPayFeeBillListModel alloc] init];
            [model setValuesForKeysWithDictionary:json[@"data"]];
            _frameModel.payFeeBillListModel = model;
            [self createPayBillDetailTableView];
        }else{
            
            [self showNoNetOrBusy:NO];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showNoNetOrBusy:YES];
    }];
}
#pragma mark--===重写返回按钮点击方法
- (void)clickBackBtn{
    NSArray *vc = self.navigationController.viewControllers;
    [vc enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[JHPayFeeBillListVC class]]){
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }else{
            *stop = NO;
        }
    }];
}
#pragma mark--==初始化立即缴费按钮
- (void)initPayButton{
    _payBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBnt.frame = FRAME(15, 0, WIDTH - 30, 40);
    [_payBnt setTitle:NSLocalizedString(@"立即缴费", nil) forState:0];
    [_payBnt setTitleColor:[UIColor whiteColor] forState:0];
    _payBnt.titleLabel.font = FONT(16);
    _payBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_payBnt setBackgroundColor:THEME_COLOR forState:0];
    [_payBnt setBackgroundColor:HEX(@"59C181",0.3f) forState:UIControlStateHighlighted];
    [_payBnt setBackgroundColor:HEX(@"59C181",0.3f) forState:UIControlStateSelected];
    [_payBnt addTarget:self action:@selector(clickPayFeeButton) forControlEvents:UIControlEventTouchUpInside];
    _payBnt.layer.cornerRadius = 4.0f;
    _payBnt.clipsToBounds = YES;
}
#pragma mark--==立即缴费按钮点击事件
- (void)clickPayFeeButton{
    NSLog(@"缴费去");
    JHPayFeeVC *payFee = [[JHPayFeeVC alloc] init];
    payFee.order_id = _frameModel.payFeeBillListModel.bill_id;
    payFee.totalMoney = _frameModel.payFeeBillListModel.total_price;
    [self.navigationController pushViewController:payFee animated:YES];
}
#pragma mark--==创建表视图
- (void)createPayBillDetailTableView{
    if(_payBillDetailTableView == nil){
        _payBillDetailTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _payBillDetailTableView.delegate = self;
        _payBillDetailTableView.dataSource = self;
        _payBillDetailTableView.showsVerticalScrollIndicator = NO;
        _payBillDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        _payBillDetailTableView.backgroundView = view;
        [self.view addSubview:_payBillDetailTableView];
    }else{
        [_payBillDetailTableView reloadData];
    }
}
#pragma mark--===UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([_frameModel.payFeeBillListModel.pay_status isEqualToString:@"0"])
       return 2;
    else
        return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return _frameModel.rowHeight;
    else
        return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 70;
    else
        return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            JHPayBillDetailCell *cell = [[JHPayBillDetailCell alloc] init];
            [cell setPayFeeBillDetailFrameModel:_frameModel];
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = BACK_COLOR;
            [cell.contentView addSubview:_payBnt];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [UIView new];
        UIImageView *iconImg = [UIImageView new];
        [view addSubview:iconImg];
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        iconImg.image = IMAGE(@"pay_1");
        UILabel *title = [UILabel new];
        title.font = FONT(16);
        title.text = [NSString stringWithFormat:@"%@",_frameModel.payFeeBillListModel.bill_title];
        title.textColor = HEX(@"191a19", 1.0f);
        [view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImg.mas_right).offset = 15;
            make.right.offset = 0;
            make.height.offset = 15;
            make.centerY.equalTo(view);
        }];
        return view;
    }
    return nil;
}
@end

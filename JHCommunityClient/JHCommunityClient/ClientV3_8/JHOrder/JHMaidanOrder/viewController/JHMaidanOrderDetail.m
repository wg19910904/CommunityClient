//
//  JHMaidanOrderDetail.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMaidanOrderDetail.h"
#import <MJRefresh.h>
#import "JHMaiDanModel.h"
@interface JHMaidanOrderDetail ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;//订单详情
@property(nonatomic,strong)JHMaiDanModel *orderDetailModel;
@property(nonatomic,strong)UIButton *actionBtn; //点击事件
@end

@implementation JHMaidanOrderDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"订单详情", nil);
    [self.view addSubview:self.tableView];
    [self getData];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_orderDetailModel) {
        [self showEmptyViewWithImgName:@"noMessage" desStr:nil btnTitle:nil inView:self.view];
        return 0;
    }else{
        [self hiddenEmptyView];
        return 4;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSArray *cellName = @[@"JHMaidanOrderDetailStatusCell",@"JHMaidanOrderDetailShopNameCell",
                          @"JHMaidanOrderDetailInfoCell",@"JHMaidanOrderDetailOtherCell"];
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName[row]];
    if (cell == nil) {
        Class cell_class = NSClassFromString(cellName[row]);
        cell = [(UITableViewCell *)[cell_class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName[row]];
    }
    [cell  setValue:self.orderDetailModel forKey:@"cellModel"];
    return cell;
}

#pragma mark - addBottomView
- (void)addBottomView{
    if (_actionBtn == nil) {
        UIView *bottomView = [UIView new];
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset = 0;
            make.height.offset = 64;
        }];
        //添加分割线
        UIView *lineV = [UIView new];
        [bottomView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset = 0;
            make.height.offset = 0.5;
        }];
        lineV.backgroundColor = LINE_COLOR;
        //添加按钮
        _actionBtn = [UIButton new];
        [bottomView addSubview:_actionBtn];
        [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.height.offset = 32;
            make.width.offset = 88;
            make.centerY.offset = 0;
        }];
        _actionBtn.layer.borderColor = Orange_COLOR.CGColor;
        [_actionBtn setBackgroundColor:HEX(@"ffffff", 1.0) forState:(UIControlStateNormal)];
        [_actionBtn setBackgroundColor:HEX(@"ffffff", 1.0) forState:(UIControlStateSelected)];
        _actionBtn.layer.borderWidth = 1;
        _actionBtn.layer.cornerRadius = 2;
        _actionBtn.clipsToBounds = YES;
    }
    //刷新状态
    [_actionBtn setTitleColor:Orange_COLOR forState:UIControlStateNormal];
    [_actionBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ====== Functions =======
- (void)getData{
    SHOW_HUD
    [JHMaiDanModel getMDOrderDetail:self.order_id block:^(JHMaiDanModel* model, NSString *msg) {
        HIDE_HUD
        [self.tableView.mj_header endRefreshing];
        if (model) {
            self.orderDetailModel = model;
            [self.tableView reloadData];
            NSDictionary *dic = [model.order_button firstObject];
            [_actionBtn setTitle:dic[@"title"] forState:(UIControlStateNormal)];
        }else [self showToastAlertMessageWithTitle:msg];
    }];
    [self addBottomView];
}

// 点击评价或查看评价按钮
-(void)clickBtn{
    NSDictionary *dic= [self.orderDetailModel.order_button firstObject];
    if ([dic[@"action"] isEqualToString:@"comment_order"]) { // 去评价
        [self commentOrderWithOrder_id:self.orderDetailModel.order_id];
    }else if ([dic[@"action"] isEqualToString:@"view_comment"]) { // 查看评价
        [self viewCommentWithOrder_id:self.orderDetailModel.order_id pei_type:@""];
    }
}

// 去评价
-(void)commentOrderWithOrder_id:(NSString *)order_id{
    
    __weak typeof(self) weakSelf=self;
    void (^Success)() = ^{
        [weakSelf getData];
    };
    [self pushToNextVcWithVcName:@"JHPersonEvaluationVC" params:@{@"order_id":order_id,@"isTuan":@(YES),@"personEvaluationSuccess":Success}];

}

// 查看评价
-(void)viewCommentWithOrder_id:(NSString *)order_id pei_type:(NSString *)pei_type{
     [self pushToNextVcWithVcName:@"JHPEvaluateVC" params:@{@"order_id":order_id,@"isTuan":@(YES)}];
}

#pragma mark - lazyLoad detailT
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = ({
            UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
            table.backgroundColor = BACK_COLOR;
            table.showsVerticalScrollIndicator = NO;
            table.delegate = self;
            table.dataSource = self;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.estimatedRowHeight = 110;
            table.rowHeight = UITableViewAutomaticDimension;
            table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
            table.sectionHeaderHeight = 0.01;
            table;
        });
    }
    return _tableView;
}

@end

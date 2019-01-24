//
//  JHMaidanOrderlist.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMaidanOrderList.h"
#import <MJRefresh.h>
#import "JHMaidanListCell.h"
#import "JHMaidanOrderDetail.h"

@interface JHMaidanOrderList ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView; //买单订单列表
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation JHMaidanOrderList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.navigationItem.title = NSLocalizedString(@"到店买单", nil);
    [self.view addSubview:self.tableView];
    [self getData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.dataSource.count;
    if (count == 0) {
        [self showEmptyViewWithImgName:@"noMessage" desStr:nil btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHMaidanListCell *listCell = [JHMaidanListCell initWithTableView:tableView reuseIdentifier:@"JHMaidanListCell"];
    JHMaiDanModel *model = self.dataSource[indexPath.section];
    listCell.cellModel = model;
   
    __weak typeof(self) weakSelf=self;
    listCell.clickComment = ^(BOOL success, NSString *msg) {
         NSDictionary *dic= [model.order_button firstObject];
        if ([dic[@"action"] isEqualToString:@"comment_order"]) { // 去评价
            [weakSelf commentOrderWithOrder_id:model.order_id];
        }else if ([dic[@"action"] isEqualToString:@"view_comment"]) { // 查看评价
            [weakSelf viewCommentWithOrder_id:model.order_id pei_type:0];
        }
    };
    return listCell;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHMaiDanModel *model = self.dataSource[indexPath.section];
    [self pushToNextVcWithVcName:@"JHMaidanOrderDetail" params:@{@"order_id":model.order_id}];
}

#pragma mark ====== Functions =======
- (void)getData{
    SHOW_HUD_INVIEW(self.view)
    [JHMaiDanModel getMDOrderListPage:self.page block:^(NSArray *arr, NSString *msg) {
        
        HIDE_HUD_FOR_VIEW(self.view)
        [self.tableView.mj_header endRefreshing];
        if (arr) {
            if (self.page == 1) {
                [self.tableView.mj_footer resetNoMoreData];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
            }else{
                if (arr.count == 0) {
                    [self showHaveNoMoreData];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.tableView.mj_footer endRefreshing];
                    [self.dataSource addObjectsFromArray:arr];
                }
            }
            [self.tableView reloadData];
        }else [self showToastAlertMessageWithTitle:msg];
        
    }];
}

// 去评价
-(void)commentOrderWithOrder_id:(NSString *)order_id{

    __weak typeof(self) weakSelf=self;
    void (^evaluateSuccess)(void) = ^(){
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self pushToNextVcWithVcName:@"JHPersonEvaluationVC"
                          params:@{@"order_id":order_id,
                                   @"isTuan":@(YES),
                                   @"personEvaluationSuccess":evaluateSuccess
                                   }];
//    [self pushToNextVcWithVcName:@"JHPersonEvaluationVC" params:@{@"order_id":order_id}];
    
}

// 查看评价
-(void)viewCommentWithOrder_id:(NSString *)order_id pei_type:(int)pei_type{
    [self pushToNextVcWithVcName:@"JHPEvaluateVC" params:@{@"order_id":order_id,@"isTuan":@(YES)}];
}

#pragma mark - lazyLoad listT
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

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
            //添加上拉加载
            __weak typeof(self) weakSelf=self;
            table.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakSelf.page = 1;
                [weakSelf getData];
            }];
            
            //添加下拉刷新
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                weakSelf.page++;
                [weakSelf getData];
            }];
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
            table.mj_footer = footer;
            table.mj_footer.automaticallyHidden=YES;
            table;
        });
    }
    return _tableView;
}


@end

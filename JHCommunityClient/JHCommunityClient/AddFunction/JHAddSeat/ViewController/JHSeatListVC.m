//
//  JHSeatListVc.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSeatListVC.h"
#import <MJRefresh.h>
#import "SeatCell.h"
#import "JHDetailOfSeatAndNumberVC.h"

@interface JHSeatListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@end

@implementation JHSeatListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.page=1;
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
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
        weakSelf.page=1;
        [weakSelf getData];
    }];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getData];
    }];
    self.tableView.mj_footer.automaticallyHidden=YES;
    
}

#pragma mark ======获取数据=======
-(void)getData{
    HIDE_HUD
    SHOW_HUD
    
    [SeatModel getSeatListWithPage:self.page block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        if (!self.tableView) [self setUpView];
        [self.tableView.mj_header endRefreshing];
        if (arr) {
            if (self.page==1) {
                [self.tableView.mj_footer resetNoMoreData];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
            }else{
                [self.dataSource addObjectsFromArray:arr];
                if (arr.count==0) [self.tableView.mj_footer endRefreshingWithNoMoreData];
                else [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        }else [self showMsg:msg];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataSource.count==0) {
        [self showEmptyViewWithImgName:@"404" desStr:@"" btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHSeatListCell";
    SeatCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[SeatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    SeatModel *model=self.dataSource[indexPath.section];
    [cell reloadCellWithModel:model is_detail:NO show_goShop:NO];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHDetailOfSeatAndNumberVC *detail=[[JHDetailOfSeatAndNumberVC alloc] init];
    detail.is_seat=YES;
    SeatModel *model=self.dataSource[indexPath.section];
    detail.order_id=model.dingzuo_id;
    [self.superVC.navigationController pushViewController:detail animated:YES];
}

-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end

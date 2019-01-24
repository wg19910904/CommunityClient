//
//  JHTuanGouFilterListVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/28.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTuanGouFilterListVC.h"
#import "YFFilterView.h"
#import "TuanGouCell.h"
#import <MJRefresh.h>

@interface JHTuanGouFilterListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)YFFilterView *filterView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@end

@implementation JHTuanGouFilterListVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"团购", nil);
    self.page = 1;
    [self setUpView];
    
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+44, WIDTH, HEIGHT-NAVI_HEIGHT-44) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=1;
        [weakSelf getData];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getData];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    self.tableView.mj_footer=footer;
    self.tableView.mj_footer.automaticallyHidden=YES;
    
    YFFilterView *filterView = [[YFFilterView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 44) titleArr:@[NSLocalizedString(@"全部", nil) ,NSLocalizedString(@"区域", nil),NSLocalizedString(@"排序", nil)]];
    filterView.firstArr = @[];
    filterView.secondArr = @[];
    filterView.thirdArr = @[];
    [self.view addSubview:filterView];
    self.filterView = filterView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    if (self.dataSource.count == 0) {
    //        [self showEmptyViewWithImgName:@"noMessage" desStr:@"" btnTitle:nil inView:tableView];
    //    }else{
    //        [self hiddenEmptyView];
    //    }
    return 10;//self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"TuanGouCell";
    TuanGouCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[TuanGouCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
//    TuanGouModel *model = self.dataSource[indexPath.row];
    
    [cell reloadCellWithModel:nil];

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark ======Functions=======
#pragma mark ======获取数据=======
-(void)getData{
   
}

-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end

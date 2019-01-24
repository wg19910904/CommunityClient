//
//  JHRecommendedView.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/16.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHRecommendedView.h"
#import <MJRefresh.h>
#import "JHHeadLinesBaseCell.h"
#import "JHheadLinesCellFactory.h"
#import "JHTempWebViewVC.h"
 
#import "JHHeadLinesModel.h"
#import "JHTempJumpWithRouteModel.h"
@interface JHRecommendedView ()<UITableViewDelegate,UITableViewDataSource>{
    MJRefreshNormalHeader *_header;
    MJRefreshAutoNormalFooter *_footer;
    NSInteger  page;
    NSMutableArray *dataArr;
    
}
@property(nonatomic,strong)UITableView *myTableView;
@end

@implementation JHRecommendedView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initData];
    [self getData];
    
}
-(void)initData{
    page = 1;
    dataArr = @[].mutableCopy;
}
#pragma mark - 获取数据
-(void)getData{
    [HttpTool postWithAPI:@"client/headline/index/index" withParams:@{@"cat_id":self.cat_id,@"page":@(page)} success:^(id json) {
        NSLog(@"client/headline/index/index-------%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page == 1) {
                [dataArr removeAllObjects];
            }
            for (NSDictionary *dic  in json[@"data"][@"items"]) {
                JHHeadLinesModel *model = [[JHHeadLinesModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [dataArr addObject:model];
            }
        }else{
            
            [self showMsg:json[@"message"]];
        }
          [self myTableView];
        [_header endRefreshing];
        [_footer endRefreshing];
    } failure:^(NSError *error) {
        [self showMsg:NSLocalizedString(@"服务器繁忙,请稍后再试",nil)];
        [_header endRefreshing];
        [_footer endRefreshing];
        
    }];
  
  
}
#pragma mark - 创建表视图
-(UITableView *)myTableView{
    
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.view.bounds.size.height) style:UITableViewStylePlain];
        [self.view addSubview:_myTableView];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.backgroundColor = HEX(@"f2f2f2", 1);
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新",nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦",nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中",nil) forState:MJRefreshStateRefreshing];
        _myTableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...",nil) forState:MJRefreshStateRefreshing];
         _footer.onlyRefreshPerDrag = YES;
        _myTableView.mj_footer = _footer;
    }else{
        [_myTableView reloadData];
    }
    
    return _myTableView;
}
#pragma mark - 表格代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (dataArr.count!=0) {
        [self hiddenEmptyView];
     return dataArr.count;
    
    }else{
        [self showEmptyViewWithImgName:@"" desStr:@"" btnTitle:nil inView:tableView];
        return 0;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == dataArr.count -1) {
        return 0.01;
    }
    return 0.01;
};
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 0.01
    ;}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     JHHeadLinesModel*model = dataArr[indexPath.section];
    return [JHheadLinesCellFactory getCellHeight:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHHeadLinesModel *model = dataArr[indexPath.section];
    //编译时、运行时
    NSString *cellIndentifier = [JHheadLinesCellFactory getCellIdentifier:model];
    
    JHHeadLinesBaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!baseCell) {
        baseCell = [JHheadLinesCellFactory getCell:model withCellStyle:UITableViewCellStyleDefault withCellIdentifier:cellIndentifier];
    }
    
    [baseCell setModel:model];
    
    
    return baseCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    JHBaseVC *vc;
    JHHeadLinesModel *model = dataArr[indexPath.section];
    JHTempWebViewVC * vc = [[JHTempWebViewVC alloc]init];
    vc.url = model.linkurl;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 上下拉刷新
-(void)downRefresh{
    page = 1;
    [self getData];
}
-(void)upLoadData{
    page ++;
    [self getData];
    
    
}
@end

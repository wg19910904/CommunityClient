//
//  JHWaiMaiFilterListVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/28.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHWaiMaiFilterListVC.h"
#import "YFFilterView.h"
#import "WaiMaiShopperCell.h"
#import <MJRefresh.h>
#import "JHSearchShopVC.h"
#import "JHShopHomepageVC.h"
#import "JHWaiMaiMainVC.h"
#import "JHShareModel.h"
@interface JHWaiMaiFilterListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)YFFilterView *filterView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *filter_id;
@property(nonatomic,copy)NSString *paixu_id;
@property(nonatomic,copy)NSString *business_id;
@property(nonatomic,strong)UIBarButtonItem *searchItem;//搜索的按钮
@end

@implementation JHWaiMaiFilterListVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    if (self.isShop) {
         self.navigationItem.title = NSLocalizedString(@"商家", nil);
    }else{
         self.navigationItem.title = NSLocalizedString(@"外卖", nil);
    }
    [JHShareModel shareModel].isShop = self.isShop;
    [self setUpView];
    
    self.cate_id = @"";
    self.filter_id = @"";
    self.paixu_id = @"";
    self.business_id = @"";
    
    self.page = 1;
    [self getData];
    if (self.isShowSearch) {
         [self searchItem];
    }
}
#pragma mark - 搜索的按钮
-(UIBarButtonItem *)searchItem{
    if (!_searchItem) {
        _searchItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"index_btn_searchFr") style:UIBarButtonItemStylePlain target:self action:@selector(clickToSearch)];
        self.navigationItem.rightBarButtonItem = _searchItem;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    return _searchItem;
}
#pragma mark - 点击的是搜索的按钮
-(void)clickToSearch{
    NSLog(@"点击的是搜索的按钮");
    JHSearchShopVC *vc = [[JHSearchShopVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    NSInteger num = self.navigationController.viewControllers.count;
    CGFloat h = 0;
    if (num == 1) {
        h = 49;
    }
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+44, WIDTH, HEIGHT-NAVI_HEIGHT-h-44) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
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
    
    YFFilterView *filterView = [[YFFilterView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 44) titleArr:@[NSLocalizedString(@"分类", nil),NSLocalizedString(@"排序", nil),NSLocalizedString(@"筛选", nil)]];
    filterView.isShop = self.isShop;
    filterView.firstArr = @[];
    filterView.secondArr = @[];
    filterView.thirdArr = @[];
    [self.view addSubview:filterView];
    
    filterView.chooseFilter = ^(NSString *filter,NSString *filter1,int index){
        if (index == 1) {
            weakSelf.cate_id = filter;
        }else if(index == 2){
            weakSelf.paixu_id = filter;
        }else{
            weakSelf.filter_id = filter;
        }
        self.page = 1;
        [weakSelf getData];
    };
    self.filterView = filterView;
    [filterView getData];
    filterView.firstSelectedType = self.cateId;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataSource.count == 0) {
        [self showEmptyViewWithImgName:@"noMessage" desStr:@"" btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *ID=@"WaiMaiShopperCell";
        WaiMaiShopperCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WaiMaiShopperCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.isHomePage = self.isShop;
        WaiMaiShopperModel *model = self.dataSource[indexPath.row];
        [cell setMyBlock:^(NSInteger index){
        [self jumpToShopHomepageWith:index];
        }];
        [cell reloadCellWithModel:model isFliterList:self.isShop];
        cell.reloadYouhuiCell = ^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self jumpToShopHomepageWith:indexPath.row];
}
-(void)jumpToShopHomepageWith:(NSInteger)index{
    if (self.isShop) {
        WaiMaiShopperModel *model = self.dataSource[index];
        JHShopHomepageVC *vc = [[JHShopHomepageVC alloc] init];
        vc.shop_id = model.shop_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JHWaiMaiMainVC *vc = [[JHWaiMaiMainVC alloc] init];
        WaiMaiShopperModel *model = self.dataSource[index];
        vc.shop_id = model.shop_id;
//        vc.restStatus = model.yysj_status;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    WaiMaiShopperModel *model = self.dataSource[indexPath.row];
    CGFloat height = 3 * 30;
    if (model.showYouHui || model.activity_list.count <= 3) {
        height = model.activity_list.count * 30 ;
    }
    return 100 + height ;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark ======Functions=======
#pragma mark ======获取数据=======
-(void)getData{
    SHOW_HUD
    [WaiMaiShopperModel getShopFilterListWith:self.page cate_id:self.cate_id title:@"" area_id:self.filter_id paixu_id:self.paixu_id buiness:self.business_id block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (arr) {
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
            }else{
                if (arr.count == 0)  [self showHaveNoMoreData];
                else [self.dataSource addObjectsFromArray:arr];
            }
            [self.tableView reloadData];
        }else [self showToastAlertMessageWithTitle:msg];

    }];
    
}
- (NSString *)cate_id{
    if (_cate_id.length == 0) {
        return self.cateId?self.cateId:@"";
    }
    return _cate_id;
}
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end

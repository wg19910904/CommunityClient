//
//  JHNewWaiMaiHomeVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHNewWaiMaiHomeVC.h"
#import <MJRefresh.h>
#import "UINavigationBar+Awesome.h"
#import "MJBannnerPlayer.h"
#import "WaiMaiHomeKindCell.h"
#import "WaiMaiSpecialCell.h"
#import "WaiMaiShopperCell.h"
#import "JHWaiMaiFilterListVC.h"
#import "JHWaiMaiSearchListVC.h"
#import "WaiMaiHomeModel.h"
#import "JHShopHomepageVC.h"
#import "JHTempJumpWithRouteModel.h"
#import "JHWaiMaiMainVC.h"
#import "JHSupermarketMainVC.h"
#import "JHWaiMaiFilterListVC.h"
#import "HomeTitleView.h"
#import "JHShareModel.h"
#import "JHAddressMainVC.h"
@interface JHNewWaiMaiHomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isHavePageController;
}
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@property(nonatomic,weak)MJBannnerPlayer *bannerPlayer;
@property(nonatomic,weak)UIButton *searchBtn;
@property(nonatomic,assign)BOOL backToHome;
@property(nonatomic,strong)WaiMaiHomeModel *homeModel;
@property(nonatomic,strong)HomeTitleView *titleView;//顶部展示当前位置的View
@property(nonatomic,strong)UIButton *searchItem;//搜索的按钮
@end

@implementation JHNewWaiMaiHomeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat alpha = self.tableView.contentOffset.y / 100;
    alpha = MIN(alpha, 1.0);
    [UIView animateWithDuration:0.3 animations:^{
         [self.navigationController.navigationBar yf_setBackgroundColor:THEME_COLOR_WHITE_Alpha(alpha)];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.backToHome) {
        [self.navigationController.navigationBar yf_setBackgroundColor:NEW_THEME_COLOR];
    }
}
-(void)clickBackBtn{
    [super clickBackBtn];
    self.backToHome = YES;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
     [self titleView];
    [self setUpView];
    [self searchItem];
    self.page = 1;
    [self getData];
    
    
}
-(UIButton *)searchItem{
    if (!_searchItem) {
        _searchItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 39)];
        [_searchItem setImage:IMAGE(@"index_btn_searchFr") forState:UIControlStateNormal];
        [self.view addSubview:_searchItem];
        [_searchItem addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_searchItem];
        self.navigationItem.rightBarButtonItem = item;
        //        [_searchItem mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.right.offset = -10;
        //            make.top.offset = 25;
        //            make.width.height.offset = 30;
        //        }];
        
    }
    return _searchItem;
}
-(void)setUpView{
    
    self.view.backgroundColor = BACK_COLOR;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
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
    
    MJBannnerPlayer *bannerPlayer = [[MJBannnerPlayer alloc] initWithUrlArray:@[@""] withSize:CGRectMake(0, 0, WIDTH, WIDTH/2) withTimeInterval:2.0];
    tableView.tableHeaderView = bannerPlayer;
    self.bannerPlayer = bannerPlayer;
    bannerPlayer.clickAD = ^(NSInteger index){
        NSDictionary *dic = weakSelf.homeModel.banners[index];
        [weakSelf goWebVCWith:dic[@"link"]];
        NSLog(@"waimai-ad %ld",index);
    };
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 250, 30)];
//    [btn setImage:IMAGE(@"address_search") forState:UIControlStateNormal];
//    [btn setTitle:NSLocalizedString(@" 输入商家",nil)  forState:UIControlStateNormal];
//    btn.titleLabel.font = FONT(14);
//    [btn setTitleColor:HEX(@"999999", 1.0) forState:UIControlStateNormal];
//    self.navigationItem.titleView = btn;
//    btn.layer.cornerRadius=15;
//    btn.clipsToBounds=YES;
//    btn.backgroundColor = HEX(@"ffffff", 0.7);
//    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    
    [self creatRightBtnWith:@"" sel:nil edgeInsets:UIEdgeInsetsZero];

}
-(HomeTitleView *)titleView{
    if (!_titleView) {
        _titleView = [HomeTitleView showViewWithTitle:[JHShareModel shareModel].lastCommunity frame:FRAME(0, 0, 160, 30) withView:self.navigationItem];
        [_titleView addTarget:self action:@selector(clickTopView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleView;
}
-(void)clickTopView{
    JHAddressMainVC *vc = [[JHAddressMainVC alloc] init];
    [vc setRefreshBlock:^{  //执行刷新
        [self getData];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.homeModel) {
        [self showEmptyViewWithImgName:@"noMessage" desStr:nil btnTitle:nil inView:tableView];
        return 0;
    }else{
        [self hiddenEmptyView];
        return 3;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.dataSource.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf=self;
    if (indexPath.section == 0) {
        static NSString *ID=@"WaiMaiHomeKindCell";
        WaiMaiHomeKindCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WaiMaiHomeKindCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell reloadCellWith:self.homeModel.index_cate];
        cell.clickIndex = ^(NSInteger index){// 点击不同的分类
            NSLog(@"waimai-kind %ld",index);
            [weakSelf goShopKindListFilter:index];
        };
        return cell;
    }else if (indexPath.section == 1){
        static NSString *ID=@"WaiMaiSpecialCell";
        WaiMaiSpecialCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WaiMaiSpecialCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell reloadCellWith:self.homeModel.advs];
         __weak typeof(self) weakSelf=self;
        cell.clickIndex = ^(NSInteger index){// 点击广告
            NSDictionary *dic = weakSelf.homeModel.advs[index];
            [weakSelf goWebVCWith:dic[@"link"]];
            NSLog(@"waimai-ad %ld",index);
        };
        return cell;
    }else{
        static NSString *ID=@"WaiMaiShopperCell";
        WaiMaiShopperCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WaiMaiShopperCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        WaiMaiShopperModel *model = self.dataSource[indexPath.row];
        cell.index = indexPath.row;
        [cell setMyBlock:^(NSInteger index){
             [self jumpToWaimainVcWithIndex:index];
        }];
        [cell reloadCellWithModel:model isFliterList:NO];
        cell.reloadYouhuiCell = ^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_homeModel.index_cate.count <= 5) {
            return WIDTH/5;
        }
        return isHavePageController ? WIDTH/4 * 2 + 20 : WIDTH/4 * 2 ;
    }else if (indexPath.section == 1){
        return 85*(WIDTH/375);
    }else{
        WaiMaiShopperModel *model = self.dataSource[indexPath.row];
        CGFloat height = 3 * 30;
        if (model.showYouHui || model.activity_list.count <= 3) {
           height = model.activity_list.count * 30 ;
        }
        return 100 + height ;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    if (section == 2) {
        return 50;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIControl *view = [[UIControl alloc] initWithFrame:FRAME(0, 0, WIDTH, 50)];
        view.backgroundColor = BACK_COLOR;
        [view addTarget:self action:@selector(clictToMoreShop) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lab = [UILabel new];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=10;
            make.width.offset=WIDTH-100;
            make.height.offset=40;
        }];
        lab.text = NSLocalizedString(@"   推荐商家",nil);
        lab.font = FONT(14);
        lab.backgroundColor = [UIColor whiteColor];
        lab.textColor = HEX(@"666666", 1.0);
        UILabel *lab1 = [UILabel new];
        [view addSubview:lab1];
        lab1.textAlignment = NSTextAlignmentCenter;
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-0;
            make.top.offset=10;
            make.width.offset=100;
            make.height.offset=40;
        }];
        lab1.text = NSLocalizedString(@"更多商家>",nil);
        lab1.font = FONT(14);
        lab1.backgroundColor = [UIColor whiteColor];
        lab1.textColor = HEX(@"666666", 1.0);
//        UIButton *btn = [UIButton new];
//        [view addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.offset=-10;
//            make.top.offset=10;
//            make.height.offset=40;
//        }];
//        [btn setTitle:NSLocalizedString(@"更多>>", nil) forState:UIControlStateNormal];
//        btn.titleLabel.font = FONT(14);
//        [btn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(clickMoreShopper) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.bottom.offset=-1;
            make.right.offset=0;
            make.height.offset=1;
        }];
        lineView.backgroundColor=LINE_COLOR;
        
        return view;
    }
    return nil;
}
-(void)clictToMoreShop{
    JHWaiMaiFilterListVC *vc = [[JHWaiMaiFilterListVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ======点击cell=======
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        [self jumpToWaimainVcWithIndex:indexPath.row];
    }
}
-(void)jumpToWaimainVcWithIndex:(NSInteger)index{
    WaiMaiShopperModel *model = self.dataSource[index];
    if ([model.tmpl_type isEqualToString:@"market"]) {
        JHSupermarketMainVC *vc = [[JHSupermarketMainVC alloc]init];
        vc.shop_id = model.shop_id;
        vc.restStatus = model.yysj_status;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JHWaiMaiMainVC *vc = [[JHWaiMaiMainVC alloc] init];
        vc.shop_id = model.shop_id;
//        vc.restStatus = model.yysj_status;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark ======ScrollViewDelegate=======
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat alpha = scrollView.contentOffset.y / 100;
    alpha = MIN(MAX(alpha, 0), 1.0);
    [self.navigationController.navigationBar yf_setBackgroundColor:THEME_COLOR_WHITE_Alpha(alpha)];
    
    CGFloat elementsAlpha = -scrollView.contentOffset.y / NAVI_HEIGHT;
    elementsAlpha = 1 - MIN(MAX(elementsAlpha, 0), 1.0);
    [self.navigationController.navigationBar yf_setElementsAlpha:elementsAlpha];
    
}
#pragma mark ======Functions =======
#pragma mark ======获取数据=======
-(void)getData{
        _titleView.titleText = [JHShareModel shareModel].lastCommunity;
    SHOW_HUD
    [WaiMaiHomeModel getHomeListWith:self.page block:^(WaiMaiHomeModel *model, NSString *msg) {
        HIDE_HUD
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (msg) {
            [self showToastAlertMessageWithTitle:msg];
        }else{
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:model.items];
                self.homeModel = model;
                if (self.homeModel.index_cate.count > 8) {
                    isHavePageController = YES;
                }else{
                    isHavePageController = NO;
                }
                NSMutableArray * arr = [NSMutableArray array];
                for (NSDictionary *dic in model.banners) {
                    NSString *url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"thumb"]];
                    [arr addObject:url];
                }
                self.bannerPlayer.urlArray = arr.copy;
            }else{
                [self.dataSource addObjectsFromArray:model.items];
            }
            [self.tableView reloadData];
        }
    }];
}
#pragma mark ======点击不同分类=======
-(void)goShopKindListFilter:(NSInteger)index{
  
    JHBaseVC *vc;
    NSDictionary *dic = _homeModel.index_cate[index];
    vc = [JHTempJumpWithRouteModel jumpWithLink:dic[@"link"]];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ======点击搜索=======
-(void)clickSearch{
    JHWaiMaiSearchListVC *searchVC = [[JHWaiMaiSearchListVC alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark ======更多商家=======
-(void)clickMoreShopper{
    
}
#pragma mark ======网页链接=======
-(void)goWebVCWith:(NSString *)url{
    JHBaseVC *vc = [JHTempJumpWithRouteModel jumpWithLink:url];
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end

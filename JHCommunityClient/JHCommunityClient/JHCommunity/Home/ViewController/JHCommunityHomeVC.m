//
//  JHCommunityHomeVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHCommunityHomeVC.h"
#import "CommunityHeaderView.h"
#import "JHConvenientServiceVC.h"
#import "NearShopCell.h"
#import <MJRefresh.h>
#import "MarqueeLabel.h"
#import "JHChooseCommunityVC.h"
#import "JHTouSuVC.h"
#import "JHRepairVC.h"
#import "JHPropertyNotifyVC.h"
#import "JHPayFeeBillListVC.h"
#import "JHRangeOfNeighbourVC.h"
#import "JHRunVC.h"
#import "JHCommunityAllCateVC.h"
#import "JHShareModel.h"
#import "CommunityHomeModel.h"
#import "JHWaiMaiMainVC.h"
#import "JHSupermarketMainVC.h"
#import "JHWaiMaiListVC.h"
#import "JHTempWebViewVC.h"
#import "JudgeToken.h"
#import "JHBaseNavVC.h"
#import "JHWaiMaiFilterListVC.h"
#import "JHTempJumpWithRouteModel.h"
@interface JHCommunityHomeVC ()<UITableViewDataSource,UITableViewDelegate>{
    UIImageView *rightArrowIv;
    UIControl *addressView;
    MarqueeLabel *addressLabel;
}
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)CommunityHomeModel *homeModel;
@property(nonatomic,weak)CommunityHeaderView *headView;
@property(nonatomic,assign)int page;

@end

@implementation JHCommunityHomeVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleChooseCommunity];
}
#pragma mark--==处理选择小区
- (void)handleChooseCommunity{
    [JudgeToken judgeTokenWithVC:self withBlock:^{
        self.page=1;
        self.navigationItem.titleView=[self creatAddressView];
        if ([JHShareModel shareModel].communityModel) {
            [self getHomeData];
        }else {
            [self setTitleViewFrame:NSLocalizedString(@"手动选择小区", nil)];
            JHChooseCommunityVC *choose=[[JHChooseCommunityVC alloc] init];
            choose.chooseCommunity = ^(MineCommunityModel *model){
                [self setTitleViewFrame:model.xiaoqu_title];
                [self getHomeData];
            };
            [choose setMyBlock:^{
                if (self.navigationController.viewControllers.count > 1) {
                     [self.navigationController popViewControllerAnimated:NO];
                }
            }];
            choose.hidesBottomBarWhenPushed = YES;
            JHBaseNavVC *navVC = [[JHBaseNavVC alloc] initWithRootViewController:choose];
            [self  presentViewController:navVC animated:YES completion:nil];
        }
        
    }];
}
-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    CommunityHeaderView *headView=[CommunityHeaderView new];
    
    headView= [headView initViewWith:self.homeModel.banner_list kinds:@[@{@"title":NSLocalizedString(@"通知", nil),@"icon":@"community_notify"},@{@"title":NSLocalizedString(@"缴费", nil),@"icon":@"community_pay"},@{@"title":NSLocalizedString(@"报修", nil),@"icon":@"community_repairs"},@{@"title":NSLocalizedString(@"投诉", nil),@"icon":@"community_complain"},@{@"title":NSLocalizedString(@"便民", nil),@"icon":@"community_serve"},@{@"title":NSLocalizedString(@"跑腿", nil),@"icon":@"community_run"},@{@"title":NSLocalizedString(@"商家", nil),@"icon":@"community_business"},@{@"title":NSLocalizedString(@"邻里", nil),@"icon":@"community_neighbourhood"}] scrArr:self.homeModel.news_list bottomAds:self.homeModel.adv_list time:2.0 scrollH:WIDTH * 0.375];
    self.tableView.tableHeaderView=headView;
    self.headView=headView;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=1;
        [weakSelf getHomeData];
    }];
    headView.clickMsg=^(NSInteger index){
        NSLog(@"点击的第%ld滚动数据",index);
        JHTempWebViewVC *web=[[JHTempWebViewVC alloc]init];
        NSDictionary *dic=self.homeModel.news_list[index];
        web.url=dic[@"link"];
        web.navigationItem.title=NSLocalizedString(@"通知", nil);
        [self.navigationController pushViewController:web animated:YES];
    };
    
    headView.clickKind=^(NSInteger index){
        switch (index) {
            case 0:{//物业通知
                JHPropertyNotifyVC *notify = [[JHPropertyNotifyVC alloc] init];
                notify.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:notify animated:YES];
            }
                break;
            case 1:{//缴费
                JHPayFeeBillListVC *payFee = [[JHPayFeeBillListVC alloc] init];
                 payFee.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:payFee animated:YES];
            }
                break;
            case 2:{//保修
                JHRepairVC *repair = [[JHRepairVC alloc] init];
                 repair.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:repair animated:YES];
            }
                break;
            case 3:{//投诉建议
                JHTouSuVC *tousu = [[JHTouSuVC alloc] init];
                 tousu.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tousu animated:YES];
            }
                break;
            case 4:{//便民服务
                JHConvenientServiceVC *convenientService = [[JHConvenientServiceVC alloc] init];
                 convenientService.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:convenientService animated:YES];
            }
                break;
            case 5:{//跑腿
                JHRunVC *run=[[JHRunVC alloc]init];
                run.hidesBottomBarWhenPushed=YES;
                run.is_from_community=YES;
                [self.navigationController pushViewController:run animated:YES];
            }
                break;
            case 6:{//商家
                JHWaiMaiFilterListVC *allCate = [[JHWaiMaiFilterListVC alloc] init];
                 allCate.hidesBottomBarWhenPushed = YES;
                allCate.isShop = YES;
                [self.navigationController pushViewController:allCate animated:YES];
            }
                break;
            case 7:{//社区邻里
                JHRangeOfNeighbourVC *neighbour=[[JHRangeOfNeighbourVC alloc] init];
                 neighbour.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:neighbour animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    
    headView.clickADs=^(NSInteger index,BOOL is_bottom){
        NSLog(@"点击的第%ld广告  是不是底部的广告 %d",index,is_bottom);
        if (is_bottom) {//商家上面的两个广告
            NSDictionary *dic=self.homeModel.adv_list[index];
            JHBaseVC *vc = [JHTempJumpWithRouteModel jumpWithLink:dic[@"link"]];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{//轮播广告
            NSDictionary *dic=self.homeModel.banner_list[index];
            JHBaseVC *vc = [JHTempJumpWithRouteModel jumpWithLink:dic[@"link"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    };
}

#pragma mark - 创建导航栏中间自定义视图
- (UIView *)creatAddressView
{
    addressView = [[UIControl alloc] init];
    //创建跑马灯 设置时间为12秒
    addressLabel = [[MarqueeLabel alloc] init];
    addressLabel.scrollDuration = 9;
    rightArrowIv = [UIImageView new];
    NSString *str=[JHShareModel shareModel].communityModel.xiaoqu_title;
    [self setTitleViewFrame:str];
    [addressView addSubview:addressLabel];
    [addressView addSubview:rightArrowIv];
    //为addressView添加手势
    [addressView addTarget:self action:@selector(clickNaviAddressView) forControlEvents:UIControlEventTouchUpInside];
    return addressView;
}

#pragma mark - 设置titleview的各控件位置
- (void)setTitleViewFrame:(NSString *)titleName
{
    addressView.frame = CGRectMake(0, 0, WIDTH - 100, 40);
    //添加label
    addressLabel.frame = CGRectMake(18, 0, WIDTH - 100, 40);
    addressLabel.text = titleName;
    addressLabel.textColor = TEXT_COLOR;
    addressLabel.font = FONT(18);
    
    //重设label的宽度
    CGFloat width_label = [addressLabel.text length] * 16;
    width_label = width_label > 140 ? 140 : width_label;
    addressLabel.frame = CGRectMake((addressView.width-width_label-10)/2.0-10, 0, width_label + 10, 40);
    
    //添加右侧向下的箭头
    rightArrowIv.frame = CGRectMake(CGRectGetMaxX(addressLabel.frame) + 5, 16, 10, 6);
    rightArrowIv.image = [UIImage imageNamed:@"community_unfold"];
}

#pragma mark ======选择小区的按钮=======
-(void)clickNaviAddressView{
    
    JHChooseCommunityVC *choose=[[JHChooseCommunityVC alloc] init];
    choose.chooseCommunity=^(MineCommunityModel *model){
        [self setTitleViewFrame:model.xiaoqu_title];
        [self getHomeData];
    };
    choose.hidesBottomBarWhenPushed=YES;
    JHBaseNavVC *navVC = [[JHBaseNavVC alloc] initWithRootViewController:choose];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

#pragma mark ======获取首页的数据=======
-(void)getHomeData{
    
    SHOW_HUD
    [CommunityHomeModel getHomeDataWithYezhu_id:[JHShareModel shareModel].communityModel.yezhu_id block:^(CommunityHomeModel *model, NSString *msg) {
        HIDE_HUD
        if (model) {
            self.homeModel=model;
            if (!self.tableView) [self setUpView];
            else [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }else{
           [self showMsg:msg];
        }
        HIDE_HUD
    }];
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homeModel.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"CommunityShopCell";
    NearShopCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[NearShopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NearShopModel *model=self.homeModel.items[indexPath.row];
    [cell reloadCellWithModel:model];
    
    return cell;
}

#pragma mark ======点击附近的商家=======
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取模型数据
    NearShopModel *model=self.homeModel.items[indexPath.row];
    NSString *type = model.tmpl_type;
    if ([type isEqualToString:@"waimai"]) {
        //跳转
        JHWaiMaiMainVC *vc = [[JHWaiMaiMainVC alloc] init];
        vc.shop_id = model.shop_id;
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JHSupermarketMainVC *vc = [[JHSupermarketMainVC alloc] init];
        vc.shop_id = model.shop_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    UILabel *lab=[UILabel new];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=15;
        make.top.offset=10;
        make.width.offset=WIDTH-30;
        make.height.offset=20;
    }];
    lab.text=NSLocalizedString(@"周边推荐商家", nil);
    lab.textColor=HEX(@"545454", 1.0);
    lab.font=FONT(14);
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearShopModel *model=self.homeModel.items[indexPath.row];
    return  model.youhuiArr.count*30+90;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.headView.adView.timer invalidate];
    self.headView.adView.timer=nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!self.headView.adView.timer)   [self.headView.adView initTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!self.headView.adView.timer)   [self.headView.adView initTimer];
}

@end

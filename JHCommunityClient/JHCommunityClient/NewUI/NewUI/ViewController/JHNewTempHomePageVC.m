//
//  JHNewTempHomePageVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/12.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewTempHomePageVC.h"
#import "BottomCell.h"
#import "SectionHeaderView.h"
#import "NewHomeTitleView.h"
#import "TempHomeTopCell.h"
#import "TempHomeSignCell.h"
#import "TempHomeChannelCell.h"
#import "TempHomeAdvCell.h"
#import "TempHomeToolCell.h"
#import "JHTempClientNewsModel.h"
#import "JHTempNewsMainVC.h"
#import "JHTempNewsListVC.h"
#import "JHTuanGouListVC.h"
#import "UINavigationBar+Awesome.h"
#import "JHSearchShopVC.h"
#import "JHAddressMainVC.h"
#import "JHShareModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHMessageVC.h"
#import "JHTempHomePageViewModel.h"
#import <MJRefresh.h>
#import "JHTempWebViewVC.h"
#import "JHShopHomepageVC.h"
#import "JHTempAdvModel.h"
#import "JHTempJumpWithRouteModel.h"
#import "JHTempRedBagView.h"
#import "JHShowAlert.h"
#import "JHLoginVC.h"
 
#import <UIImageView+WebCache.h>
#import "XHQRCodeVC.h"
#import "JHWaimaiMineViewModel.h"
#import "TempHomeHeadlinesCell.h"
#import "TempHomeShopSelectCell.h"
#import "TempHomeNewAdvCell.h"
#import "TempHomeClassifyCell.h"
#import "TempHomeNearbyCell.h"
#import "TempHomeShopListCell.h"
#import "JHNewMyCenterTwoCell.h"
#import "AppDelegate.h"
#import "JHShareModel.h"

@interface JHNewTempHomePageVC ()<UITableViewDelegate,UITableViewDataSource>{
    float alpha;
    MJRefreshNormalHeader *_header;
    MJRefreshAutoNormalFooter *_footer;
    BOOL isHavePageController;
    NSInteger page;
    //用来存储转换生成的百度坐标
    double bd_lat;
    double bd_lon;
    UIImageView *imageV;
    UIView *lineV;
    UIButton *_redBagView;
}
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)UIButton *addrBtn;//左侧地址按钮
@property(nonatomic,strong)UIButton *scanBtn;//右侧扫描
@property(nonatomic,strong)NewHomeTitleView *titleView;//顶部展示当前位置的View
@property(nonatomic,strong)JHTempHomePageModel *homeModel;
@property(nonatomic,strong)NSMutableArray *shopDataSource;//推荐商家数组
@property(nonatomic,assign)BOOL can_change_color;
@property(nonatomic,assign)BOOL isFirst;


@end

@implementation JHNewTempHomePageVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.can_change_color = YES;
        [self.navigationController.navigationBar yf_setBackgroundColor:THEME_COLOR_WHITE_Alpha(alpha)];
    [self version];
    if ([JHShareModel shareModel].payment.count == 0 || ![JHShareModel shareModel].payment) {
        [NoticeCenter postNotificationName:@"postAppInfo" object:nil];
    }

    
   
}
-(void)version{
    if (![JHShareModel shareModel].isNotUpdate) {
        [JHTempHomePageViewModel postToSureThatIsNeedUpgradeVersion];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.can_change_color = NO;
    [self.navigationController.navigationBar yf_setBackgroundColor:HEX(@"F8F8F8", 1)];
//    [self.n]
//      [self.navigationController.navigationBar setBackgroundImage:IMAGE(@"barBackImage") forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_isFirst) {
        _isFirst = NO;
        return;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = YES;
    [self getMemerData];
    page = 1;
    [self initData];
    //设置左边地址按钮
    [self addrBtn];
    //设置右边扫一扫按钮
    [self scanBtn];

    [self.view addSubview:self.myTableView];

    [self getCurrentLoaction];
    //设置头部搜索
    [self titleView];
}
-(void)getMemerData{
    [JHWaimaiMineViewModel postToGetUserInfoWithBlock:^(NSString *error) {
    }];
    
}
#pragma mark - 判断首次进入是否选择了地址
- (void)getCurrentLoaction{
    __weak typeof(self)weakself = self;
    SHOW_HUD
    [[XHPlaceTool sharePlaceTool] getCurrentPlaceWithSuccess:^(XHLocationInfo *model) {
     
        [[XHPlaceTool sharePlaceTool] aroundSearchWithSuccess:^(NSArray<XHLocationInfo *> *pois) {
            if (pois.count) {
                XHLocationInfo *model = pois[0];
                [JHShareModel shareModel].lastCommunity = model.name;
                [JHShareModel shareModel].lat = model.coordinate.latitude;
                [JHShareModel shareModel].lng = model.coordinate.longitude;
                [XHMapKitManager shareManager].currentCity = model.city;
                //通知首页刷新
                [weakself getData];
            }else{
                //进入地址选择
                [weakself addrBtnClick];
            }
            
        } failure:^(NSString *error) {
            //进入地址选择
            [weakself addrBtnClick];
        }];
    } failure:^(NSString *error) {
        [self showToastAlertMessageWithTitle:error];
    }];
    
}
-(UIButton *)redBagView{
    if (!_redBagView) {
        _redBagView = [[UIButton alloc]init];
        [_redBagView setBackgroundImage:IMAGE(@"red_icon") forState:UIControlStateNormal];
        [_redBagView addTarget:self action:@selector(clickRedBag) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panWay:)];
        [_redBagView addGestureRecognizer:panGesture];
        [self.view addSubview:_redBagView];
        [_redBagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 128*(HEIGHT/667);
            make.right.offset = -12;
            make.width.offset = 64*(HEIGHT/667);
            make.height.offset = 64*(HEIGHT/667);
        }];
    }
    return _redBagView;
}
-(void)clickRedBag{
    
    if(![JHShareModel shareModel].token){
        [self showAlertView:NSLocalizedString(@"您还未登录,请先登录", nil)];
        return;
    }
    JHBaseVC *vc;
    vc = [JHTempJumpWithRouteModel jumpWithLink:_homeModel.hongbao_link];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 拖动手势
-(void)panWay:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan locationInView:self.view];
    if (point.x <= 25*(HEIGHT/667)) {
        CGFloat x = 25*(HEIGHT/667);
        point = CGPointMake(x, point.y);
    }
    if (point.x >= WIDTH - 25*(HEIGHT/667)){
        CGFloat x = WIDTH -25*(HEIGHT/667);
        point = CGPointMake(x, point.y);
    }
    if (point.y <= 64 + 32*(HEIGHT/667)){
        CGFloat y = 64 + 32*(HEIGHT/667);
        point = CGPointMake(point.x,y);
    }
    if (point.y >= HEIGHT-49 -32*(HEIGHT/667)){
        CGFloat y = HEIGHT-49 -32*(HEIGHT/667);
        point = CGPointMake(point.x,y);
    }
    pan.view.center = point;
}
#pragma mark - 获取数据
-(void)getData{
    [_addrBtn setTitle:[XHMapKitManager shareManager].currentCity forState:0];
    [_addrBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_addrBtn.imageView.size.width, 0, _addrBtn.imageView.size.width)];
    [_addrBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _addrBtn.titleLabel.bounds.size.width, 0, -_addrBtn.titleLabel.bounds.size.width)];
    _addrBtn.titleLabel.font = FONT(17);
    _addrBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:[JHShareModel shareModel].lat
                                                 WithGD_lon:[JHShareModel shareModel].lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
   
    [HttpTool postWithAPI:@"client/v3/index/index"
               withParams:@{@"lat" :@(bd_lat),
                            @"lng" : @(bd_lon)} success:^(id json) {
                                HIDE_HUD
                                NSLog(@"client/v3/index/index===%@",json);
                                if([json[@"error"] isEqualToString:@"0"]){
                                    [self redBagView];
                                    _homeModel = [JHTempHomePageModel mj_objectWithKeyValues:json[@"data"]];
                                    if (_homeModel.index_cate.count > 10) {
                                        isHavePageController = YES;
                                    }else{
                                        isHavePageController = NO;
                                    }
                                    if (page ==  1) {
                                        self.shopDataSource = _homeModel.items.mutableCopy;
                                    }else{
                                        for (WaiMaiShopperModel *model in _homeModel.items) {
                                            [self.shopDataSource addObject:model];
                                        }
                                    }
                                    
                                    [self.myTableView reloadData];
                                }else{
                                    [self showMsg:json[@"message"]];
                                }
                                [_header endRefreshing];
                                [_footer endRefreshing];
                                
                            } failure:^(NSError *error) {
                                HIDE_HUD
                                [self showMsg:NOTCONNECT_STR];
                                [_header endRefreshing];
                                [_footer endRefreshing];
                            }];
    
    
}
#pragma mark - 左侧地址按钮创建
-(UIButton *)addrBtn{
    if(!_addrBtn){
        _addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addrBtn addTarget:self action:@selector(addrBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addrBtn.frame = CGRectMake(0, 0, 80, 30);
        [self.view addSubview:_scanBtn];
        [_addrBtn setImage:IMAGE(@"index_btn_arrow_down_white") forState:0];
        [_addrBtn setTitle:@"" forState:0];
        [_addrBtn.titleLabel adjustsFontSizeToFitWidth];
        [_addrBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_addrBtn.imageView.size.width, 0, _addrBtn.imageView.size.width)];
        [_addrBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _addrBtn.titleLabel.bounds.size.width, 0, -_addrBtn.titleLabel.bounds.size.width)];

    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:_addrBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}
return _addrBtn;
}

#pragma mark - 点击左边地址按钮
-(void)addrBtnClick{
    JHAddressMainVC *vc = [[JHAddressMainVC alloc] init];
    vc.cityName = _addrBtn.titleLabel.text;
    [vc setRefreshBlock:^{  //执行刷新
        page = 1;
        [self getData];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 扫一扫按钮
-(UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [[UIButton alloc]initWithFrame:FRAME(0, 0, 22, 22)];
        [_scanBtn setImage:IMAGE(@"home_Sweep") forState:UIControlStateNormal];
        [self.view addSubview:_scanBtn];
        [_scanBtn addTarget:self
                     action:@selector(clickScanBtn)
           forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];
        self.navigationItem.rightBarButtonItem = item;
    }
    return _scanBtn;
}
#pragma mark - 头部搜索栏
-(NewHomeTitleView *)titleView{
    if (!_titleView) {
        if (!_titleView) {
            _titleView = [NewHomeTitleView showViewWithTitle:@"" frame:FRAME(0, 0, 240, 25) withView:self.navigationItem];
            [_titleView addTarget:self action:@selector(clickTopView) forControlEvents:UIControlEventTouchUpInside];
        }
        return _titleView;
    }
    return _titleView;
}
#pragma mark - 点击头部title
-(void)clickTopView{
    JHSearchShopVC *vc = [[JHSearchShopVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 点击扫一扫按钮
-(void)clickScanBtn{
    XHQRCodeVC *scanVC = [[XHQRCodeVC alloc] init];
    scanVC.hidesBottomBarWhenPushed = YES;
    scanVC.completionBlock = ^(NSString *result){
        [self.navigationController popViewControllerAnimated:YES];
        JHTempWebViewVC *web = [[JHTempWebViewVC alloc] init];
        web.isWeidian = YES;
        web.url = result;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
    
}
-(void)initData{
    self.navigationItem.title = @"";

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(version) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

#pragma mark - 创建表视图
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = BACK_COLOR;
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
    }
    return _myTableView;
}

-(void)downRefresh{
    page =1;
    [self getData];
}

-(void)upLoadData{
    page++;
//    SHOW_HUD
    [HttpTool postWithAPI:@"client/v3/index/shopitems"
               withParams:@{@"lat" : @(bd_lat),
                            @"lng" : @(bd_lon),
                            @"page":@(page)
                            } success:^(id json) {
//                                HIDE_HUD
                                NSLog(@"-----client/v3/index/shopitems%@",json);
                                if ([json[@"error"] isEqualToString:@"0"]) {
                                    if ([json[@"data"][@"items"] count]== 0) {
                                        [self showHaveNoMoreData];
                                    }else{
                                        for (NSDictionary *dic in json[@"data"][@"items"]) {
                                             WaiMaiShopperModel*model = [WaiMaiShopperModel mj_objectWithKeyValues:dic];
                                            [self.shopDataSource addObject:model];
                                        }
                                        [ _myTableView reloadData];
                                    }
                                }else{
                                    [self showMsg:json[@"message"]];
                                }
                                
                                [_header endRefreshing];
                                [_footer endRefreshing];
                            } failure:^(NSError *error) {
//                                HIDE_HUD
                                [self showMsg:NOTCONNECT_STR];
                                [_header endRefreshing];
                                [_footer endRefreshing];
                            }];
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_homeModel) {
        [self hiddenEmptyView];
        if(section == 0)
            return 8;
        else
            return self.shopDataSource.count;
    }else{
        [self showEmptyViewWithImgName:@"" desStr:@"" btnTitle:nil inView:tableView];
        return 0;
    }
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL have_gongqiu = [[JHShareModel shareModel].add_function[@"have_gongqiu"] boolValue];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return WIDTH/2;

            case 1:
               
                if (_homeModel.index_cate.count <= 5) {
                    return WIDTH/4;
                }
                return isHavePageController ? WIDTH/4 * 2 + 20 : WIDTH/4 * 2 ; 
            case 2:
                return 72;
            case 3:
                return 210*WIDTH/375;
            case 4:
                return 120*WIDTH/375;
            case 5:
                return 175*WIDTH/375;
            case 6:
                return 128*WIDTH/375;
            case 7:
                return have_gongqiu? 110*WIDTH/375:0.01;
                
            default:
                return 284;
        }
    }else{
        return 100;
        
    }
    
    return 1;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==  1) {
        UIView * view = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *titleL = [[UILabel alloc ]initWithFrame:FRAME(0, 0, WIDTH, 40)];
        titleL.text = NSLocalizedString(@"———— 猜你喜欢 ————",nil);
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = HEX(@"333333", 1);
        titleL.font = FONT(14);
        [view addSubview:titleL];
//        UIView *line = [[UIView alloc]initWithFrame:FRAME(0, 39, WIDTH, 1)];
//        [view addSubview:line];
//        line.backgroundColor = HEX(@"e5e5e5", 1);
        return view;
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 40;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf = self;
    if(indexPath.section == 0){
        switch (indexPath.row ) {
            case 0://轮播
                {
                static NSString *str_topCell = @"TempHomeTopCell";
                TempHomeTopCell *cell = [tableView dequeueReusableCellWithIdentifier:str_topCell];
                if (!cell) {
                    cell = [[TempHomeTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_topCell];
                }
                cell.array = _homeModel.banners.mutableCopy;
                [cell setClickBlock:^(NSInteger tag){
                    //点击轮播图
                    [weakSelf clickLunBoFor:tag];
                }];
                return cell;
        }
            case 1://分类
            {
                static NSString *str_channelCell = @"TempHomeChannelCell";
                TempHomeChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:str_channelCell];

                if (!cell) {
                    cell = [[TempHomeChannelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_channelCell];
                }
                cell.array = _homeModel.index_cate;
                __weak typeof (self)weakSelf = self;
                [cell setMyBlock:^(NSInteger tag) {
                    [weakSelf clickJumpToOtherVC:tag];
                }];
                return cell;
            }
            case 2://头条新闻
            {
                static NSString *str_headlinesCell = @"TempHomeHeadlinesCell";
                TempHomeHeadlinesCell *cell = [tableView dequeueReusableCellWithIdentifier:str_headlinesCell];
                if (!cell) {
                    cell = [[TempHomeHeadlinesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_headlinesCell];
                }
                cell.arr = _homeModel.top_line;
                __weak typeof (self)weakSelf = self;
                cell.clickBlock = ^(NSInteger tag) {
                    [weakSelf clickTop_lineFor:tag];
                };
                return cell;
            }
            case 3://四个广告
            {
                static NSString *str_headlinesCell = @"TempHomeNewAdvCell";
                TempHomeNewAdvCell *cell = [tableView dequeueReusableCellWithIdentifier:str_headlinesCell];
                if (!cell) {
                    cell = [[TempHomeNewAdvCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_headlinesCell];
                }
                cell.array = _homeModel.fileds;
                __weak typeof (self)weakSelf = self;
                cell.clickAdvBlock = ^(NSInteger tag) {
                    [weakSelf cliekTuanFor:tag];
                };
                return cell;
            }
            case 4://大广告页
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    imageV  = [UIImageView new];
                    imageV.userInteractionEnabled = YES;
                   imageV.frame =FRAME(0, 0, WIDTH, 120*WIDTH/375);

                    [cell addSubview:imageV];
                    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
                    [imageV addGestureRecognizer:tap];
                }
                [imageV sd_setImageWithURL:[NSURL URLWithString:_homeModel.tender[@"thumb"]] placeholderImage:PHAIMAGE];

                return cell;
            }
            case 5://商家精选
            {
                static NSString *str_shopSelectCell = @"TempHomeShopSelectCell";
                TempHomeShopSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:str_shopSelectCell];
                if (!cell) {
                    cell = [[TempHomeShopSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_shopSelectCell];
                }
                [cell.moreBtn addTarget:self action:@selector(homeshopBtnClick) forControlEvents:UIControlEventTouchUpInside];
                cell.array =_homeModel.merchants;
                __weak typeof (self)weakSelf = self;
                cell.clickBlock = ^(NSInteger tag) {
                    [weakSelf clickShopFor:tag];
                };

                return cell;
            }
            case 6://附近商家
            {
                static NSString *str_nearbyCell = @"TempHomeNearbyCell";
                TempHomeNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:str_nearbyCell];
                if (!cell) {
                    cell = [[TempHomeNearbyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_nearbyCell];
                }
                cell.array = _homeModel.nearby;
                __weak typeof (self)weakSelf =self;
                cell.clickBlock = ^(NSInteger tag) {
                    [weakSelf clickNearbyFor:tag];
                };
                return cell;
            }
            case 7://分类信息
            {
                static NSString *str_shopSelectCell = @"TempHomeClassifyCell";
                TempHomeClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:str_shopSelectCell];
                if (!cell) {
                    cell = [[TempHomeClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_shopSelectCell];
                }
                [cell.moreBtn addTarget:self action:@selector(classifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
                cell.array = _homeModel.lifes;
                cell.clickBlock = ^(NSInteger tag) {
                    [weakSelf CLickClassifyFor:tag];
                };
                return cell;
            }
            default:
                break;
        }
    }else{//商家列表
        static NSString *str_shopSelectCell = @"TempHomeShopListCell";
        TempHomeShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:str_shopSelectCell];
        if (!cell) {
            cell = [[TempHomeShopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_shopSelectCell];
        }
        cell.model = self.shopDataSource[indexPath.row];
        return cell;

    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        WaiMaiShopperModel *model = self.shopDataSource[indexPath.row];
        JHShopHomepageVC *vc = [[JHShopHomepageVC alloc] init];
        vc.shop_id = model.shop_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 点击轮播图跳转
-(void)clickLunBoFor:(NSInteger )tag{
    NSLog(@"点击了轮播图%ld",tag);
    JHBaseVC *vc;
    JHTempAdvModel *model = _homeModel.banners[tag];
    vc = [JHTempJumpWithRouteModel jumpWithLink:model.link];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 点击频道跳转界面
-(void)clickJumpToOtherVC:(NSInteger)tag{
    
    JHBaseVC *vc;
    JHTempAdvModel *model = _homeModel.index_cate[tag];
    if ([model.link containsString:@"topline"]){
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tabVC = (UITabBarController *)[app valueForKey:@"rootVC"];
        tabVC.selectedIndex = 2;
        tabVC.tabBar.hidden = NO;
        return;
    }
    vc = [JHTempJumpWithRouteModel jumpWithLink:model.link];
    [self.navigationController pushViewController:vc animated:YES];
    
 
    
    
}
#pragma mark - 点击头条广告跳转
-(void)clickTop_lineFor:(NSInteger )tag{
      NSLog(@"点击了top_line%ld",tag);
    JHBaseVC *vc;
    JHTempAdvModel *model = _homeModel.top_line[tag];
    vc = [JHTempJumpWithRouteModel jumpWithLink:model.link];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 点击了精选团购
-(void)cliekTuanFor:(NSInteger )tag{
    JHBaseVC *vc;
    JHTempAdvModel *model = _homeModel.fileds[tag];
    vc = [JHTempJumpWithRouteModel jumpWithLink:model.link];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark - 点击广告图片
-(void)imageClick:(UIGestureRecognizer *)tap{
    NSLog(@"点击了");
    JHBaseVC *vc;
//    NSDictionary *dic = _homeModel.tender;
    vc = [JHTempJumpWithRouteModel jumpWithLink:_homeModel.tender[@"link"]];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 点击精选商家
-(void)clickShopFor:(NSInteger )tag{
     NSLog(@"点击了shop%ld",tag);
    JHBaseVC *vc;
    JHTempAdvModel *model = _homeModel.merchants[tag];
    vc = [JHTempJumpWithRouteModel jumpWithLink:model.link];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 点击精选商家更多按钮
-(void)homeshopBtnClick{
    
    JHTuanGouListVC *vc  = [[JHTuanGouListVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击附近商家
-(void)clickNearbyFor:(NSInteger )tag{
    NSLog(@"点击了Nearby%ld",tag);
    JHBaseVC *vc;
    JHTempAdvModel *model = _homeModel.nearby[tag];
    vc = [JHTempJumpWithRouteModel jumpWithLink:model.link];
    [self.navigationController pushViewController:vc animated:YES];
    

    
    
}
#pragma mark - 点击分类信息
-(void)CLickClassifyFor:(NSInteger )tag{

    JHBaseVC *vc;
    JHTempAdvModel *model = _homeModel.lifes[tag];
    vc = [JHTempJumpWithRouteModel jumpWithLink:model.link];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)classifyBtnClick{
    JHBaseVC *vc;
//    JHTempAdvModel *model = _homeModel.lifes[tag];
    vc = [JHTempJumpWithRouteModel jumpWithLink:_homeModel.life_link];
    [self.navigationController pushViewController:vc animated:YES];
}

//由于下面的代理设置了表的偏移,在点击导航自动返回时会出现偏移,故此方法用以中和
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [scrollView setContentOffset:CGPointMake(0, 0)];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    float y = scrollView.contentOffset.y;
    float a = y/(WIDTH/2-NAVI_HEIGHT);
    alpha = a;
//    NSLog(@"----------%lf",a);
    //_navView.alpha = a;
    if (self.myTableView.mj_header.state != MJRefreshStateRefreshing && self.can_change_color) {
        [self.navigationController.navigationBar yf_setBackgroundColor:THEME_COLOR_WHITE_Alpha(alpha)];
    }
  

    float b = 717+WIDTH/2-NAVI_HEIGHT;
    if (_homeModel.tools == 0) {
        b = 717+WIDTH/2-NAVI_HEIGHT -269;
    }
    if (y >=b) {
        scrollView.contentInset = UIEdgeInsetsMake(NAVI_HEIGHT, 0, 0, 0);
    }else
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    

    
    if (a> 0.5){
        [_addrBtn setTitleColor:TEXT_COLOR forState:0];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.titleView.bg_color = HEX(@"CCCCCC", 0.6);
        [_addrBtn setImage:IMAGE(@"arrow_down_black") forState:0];
        [_scanBtn setImage:IMAGE(@"home_Sweep_black") forState:0];
        
       
        
    }
    else{
        [_addrBtn setTitleColor:[UIColor whiteColor] forState:0];
//         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
         self.titleView.bg_color = HEX(@"eeeeee", 0.6);
           [_addrBtn setImage:IMAGE(@"index_btn_arrow_down_white") forState:0];
            [_scanBtn setImage:IMAGE(@"home_Sweep") forState:0];
        
       
    }

//分界线的阴影效果
    if(a>0.99){
        if (!lineV) {
            lineV = [[UIView alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 1)];
            [self.view addSubview:lineV];
        }
        lineV.backgroundColor = HEX(@"FFFFFF", 1);
        lineV.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        lineV.layer.shadowOpacity = 0.5;//阴影透明度，默认为0，如果不设置的话看不到阴影，切记，这是个大坑
        lineV.layer.shadowOffset = CGSizeMake(0, 0.2);//设置偏移量
    }else{
        lineV.backgroundColor =[UIColor clearColor];
        lineV.layer.shadowOpacity = 0;
    }

    
}
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"去登录", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JHLoginVC *loginVC = [[JHLoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
    [alertController addAction:loginAction];
    [self  presentViewController:alertController animated:YES completion:nil];
    
}
@end

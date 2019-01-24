//
//  JHIntegralMallVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//积分商城

#import "JHIntegralMallVC.h"
#import "IntegrationMallCell.h"
#import "IntegrationMallModel.h"
#import "CustomView.h"
#import "JHIntegrationVC.h"
#import "JHIntegrationGoodDetailVC.h"
#import "MJRefresh.h"
 
#import "JHSubmitIntegrationOrderVC.h"
#import "IntegrationMallCateBntModel.h"
#import "UIImageView+NetStatus.h"
#import "MemberInfoModel.h"
#import "MBProgressHUD.h"
#import "JHIntegralMallListVC.h"
#import "DSToast.h"
#import "IntegrationAdvModel.h"
#import "MyTapGesture.h"
#import "JHAdvVC.h"
#import "AppDelegate.h"
#import "JHIntegrationOrderListVC.h"
#import "JHSubmitIntegrationOrderVC.h"
#import "JHIntegrationCartModel.h"
#import "JudgeToken.h"
#import "JHTempJumpWithRouteModel.h"
@interface JHIntegralMallVC ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIScrollView *_scrollView;//广告栏
    NSInteger _currentIndex;
    NSTimer *_timer;//定时器
    UILabel *_codeLabel;//我的积分
    UICollectionView *_collectionView;
    //MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    UIView *_backView;
    UIView *_cateBntBackView;//选择按钮背景视图
    NSMutableArray *_dataArray;
    NSMutableArray *_cateBntArray;
    UIView *_thread1;
    UIView *_thread2;
    UIView *_thread3;
    UIView *_thread4;
    NSInteger _page;
    MemberInfoModel *_infoModel;
    DSToast *toast;
    NSMutableArray *_advArray;
    UIButton *_cartBnt;//购物车按钮
    UILabel *_badgeLabel;//购物车上面的数字
    DSToast *_badgeToast;
    DSToast *_maxToast;
}
@end

@implementation JHIntegralMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"积分商城", nil);
    self.view.backgroundColor = BACK_COLOR;
    [self initSubViews];
    [self creatTimer];
    [self loadNewData];
}

#pragma mark-===初始化相关子控件
- (void)initSubViews{
    _infoModel = [MemberInfoModel shareModel];
    _advArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _cateBntArray = [NSMutableArray array];
    _cateBntBackView = [UIView new];
    _thread1 = [UIView new];
    _thread2 = [UIView new];
    _thread3 = [UIView new];
    _thread4 = [UIView new];
    _scrollView = [UIScrollView new];
    _backView = [UIView new];
    _codeLabel = [UILabel new];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if(_infoModel.jifen.length == 0 || _infoModel.jifen == nil || token.length == 0)
        _codeLabel.text = @"0";
    else
        _codeLabel.text = _infoModel.jifen;
    
    _backView.frame = FRAME(0,WIDTH / 3.2, WIDTH, 50);
    _backView.backgroundColor = [UIColor whiteColor];
    _thread1.frame = FRAME( WIDTH / 2 -1, 10, 1, 30);
    _thread1.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [_backView addSubview:_thread1];
    _thread2.frame = FRAME(0, 49.5, WIDTH, 0.5);
    _thread2.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [_backView addSubview:_thread2];
    _codeLabel.frame = FRAME(70, 25, 90, 15);
    _codeLabel.font = FONT(14);
    _codeLabel.textColor = HEX(@"f85357", 1.0f);
    for(int i = 0 ; i < 2; i++)
    {
        UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        bnt.frame = FRAME(i * WIDTH/2, 0, WIDTH / 2, 50);
        UIImageView *iconImg = [[UIImageView alloc] init];
        UILabel *mycodeLabel = [[UILabel alloc] init];
        mycodeLabel.font = FONT(14);
        mycodeLabel.textColor = [UIColor blackColor];
        if(i == 0)
        {
            iconImg.image = IMAGE(@"liwu");
            mycodeLabel.frame = FRAME(70, 10, 60, 10);
            mycodeLabel.text = NSLocalizedString(@"我的积分", nil);
            [bnt addSubview:_codeLabel];
            iconImg.frame = FRAME(35, 10, 25, 25);
        }else{
            iconImg.image = IMAGE(@"integral_order");
            mycodeLabel.frame = FRAME(70, 17, 60, 10);
            mycodeLabel.text = NSLocalizedString(@"商城订单", nil);
            iconImg.frame = FRAME(35, 12.5,20, 20);
        }
        [bnt addSubview:iconImg];
        [bnt addSubview:mycodeLabel];
        bnt.tag = i + 1;
        [bnt addTarget:self action:@selector(clickBnt:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:bnt];
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_cartBnt removeFromSuperview];
    _cartBnt = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self createCartButton];
}
#pragma mark-===创建购物车按钮
- (void)createCartButton{
    if(_cartBnt == nil){
        _cartBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cartBnt setBackgroundImage:IMAGE(@"integral_Shopping-Cart") forState:UIControlStateNormal];
        [_cartBnt setBackgroundImage:IMAGE(@"integral_Shopping-Cart") forState:UIControlStateHighlighted];
        [_cartBnt setBackgroundImage:IMAGE(@"integral_Shopping-Cart") forState:UIControlStateSelected];
        [_cartBnt addTarget:self action:@selector(clickCartButton) forControlEvents:UIControlEventTouchUpInside];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:_cartBnt];
        [_cartBnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.bottom.offset = -40;
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        _cartBnt.layer.cornerRadius = 30.f;
        _cartBnt.clipsToBounds = YES;
        _badgeLabel = [UILabel new];
        _badgeLabel.font = FONT(10);
        
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.backgroundColor = HEX(@"FE2600", 1.0f);
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        [_cartBnt addSubview:_badgeLabel];
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.top.offset = 10;
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        _badgeLabel.layer.cornerRadius = 10.0f;
        _badgeLabel.clipsToBounds = YES;
        [self refreshCartButton];
    }else{
        [self refreshCartButton];
    }
}
#pragma mark--==购物车按钮点击事件
- (void)clickCartButton{
    if(_badgeLabel.text.length == 0 || [_badgeLabel.text isEqualToString:@"0"]){
        [self showNoGood];
    }else{
        //调到提交订单
        JHSubmitIntegrationOrderVC *submitOrder = [[JHSubmitIntegrationOrderVC alloc] init];
        [self.navigationController pushViewController:submitOrder animated:YES];
    }
}
#pragma mark--===刷新购物车按钮
- (void)refreshCartButton{
    _badgeLabel.text = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalNumer];
    if([_badgeLabel.text integerValue] <= 0){
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.hidden = NO;
    }
}
#pragma mark=======创建分类选择按钮=======
- (void)createCateBnt
{
    _cateBntBackView.backgroundColor = [UIColor whiteColor];
    CGFloat width = (375 - 50) / 4;
    CGFloat space = (WIDTH - width * 4) / 5;
    _thread3.frame = FRAME(0, 0, WIDTH, 0.5);
    _thread3.backgroundColor = LINE_COLOR;
    [_cateBntBackView addSubview:_thread3];
    _thread4.backgroundColor = LINE_COLOR;
    [_cateBntBackView addSubview:_thread4];
    [_thread4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
    for(int i = 0; i < _cateBntArray.count + 1; i ++)
    {
        UIButton *cateBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        cateBnt.frame = FRAME(space + (i%4) * (space + width),10 + i/4 * (width + 10),width, width);
        [_cateBntBackView addSubview:cateBnt];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(20, 5,width - 40, width - 40)];
        [cateBnt addSubview:imgView];
        NSString *img = nil;
        NSString *title = nil;
        if(i == _cateBntArray.count){
            imgView.image = IMAGE(@"icon_more");
            title = NSLocalizedString(@"更多", nil);
        }else{
            IntegrationMallCateBntModel *model = [[IntegrationMallCateBntModel alloc] init];
            model = _cateBntArray[i];
            img = model.icon;
            title = model.title;
            NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:img]];
            [imgView sd_image:url plimage:IMAGE(@"jfcategory")];
            
        }
        cateBnt.tag = i + 1;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(0, width - 25, width, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = FONT(11);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = title;
        [cateBnt addSubview:titleLabel];
        [cateBnt addTarget:self action:@selector(cateBnt:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark===分类按钮点击事件============
- (void)cateBnt:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    JHIntegralMallListVC *mallListVc = [[JHIntegralMallListVC alloc] init];
    if(sender.tag - 1 == _cateBntArray.count){
        mallListVc.cate_id = @"0";
        mallListVc.navTitle = NSLocalizedString(@"全部", nil);
    }else{
        mallListVc.cate_id = [NSString stringWithFormat:@"%@",[_cateBntArray[sender.tag-1] cate_id]];
        mallListVc.navTitle = [_cateBntArray[sender.tag-1] title];
    }
 
    [self.navigationController pushViewController:mallListVc animated:YES];
}
#pragma mark=======我的积分按钮,兑换记录按钮点击事件============
- (void)clickBnt:(UIButton *)sender
{
    [JudgeToken judgeTokenWithVC:self withBlock:^{
        [self loadNewData];
    }];
    
    NSLog(@"===%ld",(long)sender.tag);
    if(sender.tag == 1){
        JHIntegrationVC *integration = [[JHIntegrationVC alloc] init];
        [self.navigationController pushViewController:integration animated:YES];
    }else{
        JHIntegrationOrderListVC *integrationListVC = [[JHIntegrationOrderListVC alloc] init];
        [self.navigationController pushViewController:integrationListVC animated:YES];
    }
    
}
#pragma mark========创建collectionView============
- (void)createCollectionView
{
    if(_collectionView == nil)
    {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = BACK_COLOR;
        [_collectionView registerClass:[IntegrationMallCell class] forCellWithReuseIdentifier:@"dis"];
        [_collectionView registerClass:[CustomView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supply"];
        [self.view addSubview:_collectionView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _collectionView.mj_header = _header;
//        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        [_footer setTitle:@"" forState:MJRefreshStateIdle];
//        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
//        _collectionView.mj_footer = _footer;
        [self createCateBnt];
        [self createScrollView];
    }else{
        [_collectionView reloadData];
    }
    
}
#pragma mark=========加载第一页数据===========
- (void)loadNewData
{
    SHOW_HUD
//    _page = 1;
//    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"client/mall/product/index" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]) {
            [_advArray removeAllObjects];
            [_cateBntArray removeAllObjects];
            [_dataArray removeAllObjects];
            
            NSArray *bannerArr = json[@"data"][@"banner_list"];
            for(NSDictionary *dic in bannerArr){
                IntegrationAdvModel *model = [[IntegrationAdvModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_advArray addObject:model];
            }
            if (_advArray.count > 0) [_advArray addObject:_advArray[0]];
            
            NSArray *navList = json[@"data"][@"nav_list"];
            for(NSDictionary *dic in navList){
                IntegrationMallCateBntModel *model = [[IntegrationMallCateBntModel alloc] init];
                [model  setValuesForKeysWithDictionary:dic];
                [_cateBntArray addObject:model];
            }
            _codeLabel.text = json[@"data"][@"jifen"];
            CGFloat width = (375 - 50) / 4;
            if((_cateBntArray.count + 1) % 4 == 0){
                _cateBntBackView.frame = FRAME(0, WIDTH / 3.2 + 60, WIDTH, (width + 10) * ((_cateBntArray.count + 1) / 4));
            }else{
                _cateBntBackView.frame = FRAME(0, WIDTH / 3.2 + 60, WIDTH, (width + 10) * ((_cateBntArray.count + 1) / 4 + 1));
            }
            
            
            NSArray *itemsArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemsArray)
            {
                IntegrationMallModel *model = [[IntegrationMallModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self createCollectionView];
            HIDE_HUD
        }else{
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据加载失败,原因%@", nil),json[@"message"]]];
        }
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
        
    }];
}

#pragma mark===========UICollectionViewDelegate==============
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IntegrationMallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dis" forIndexPath:indexPath];
    cell.addBnt.tag = indexPath.item + 1;
    [cell.addBnt addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.integrationMallModel = _dataArray[indexPath.item];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-30)/2, ((WIDTH - 30)/2 - 10)/1.35 + 60);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld=====",(long)indexPath.item);
    JHIntegrationGoodDetailVC *goodDetail = [[JHIntegrationGoodDetailVC alloc] init];
    goodDetail.product_id = [_dataArray[indexPath.item] product_id];
    goodDetail.detailModel = _dataArray[indexPath.item];
    [self.navigationController pushViewController:goodDetail animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CustomView *view;
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        view = [_collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supply" forIndexPath:indexPath];
        [view addSubview:_scrollView];
        [view addSubview:_backView];
        [view addSubview:_cateBntBackView];
    }
    
    return view;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat width =  (375 - 50) / 4;
    if((_cateBntArray.count + 1) % 4 == 0)
        return CGSizeMake(WIDTH, WIDTH / 3.2 + 70 + (width + 10) * ((_cateBntArray.count + 1) / 4));
    else
        return CGSizeMake(WIDTH, WIDTH / 3.2 + 70 + (width + 10) * ((_cateBntArray.count + 1) / 4 + 1));
    
    
}
#pragma mark========每个单元格中兑换按钮点击事件==========
- (void)clickAddButton:(UIButton *)sender
{
    NSLog(@"%ld===",(long)sender.tag);
    IntegrationMallModel *model = _dataArray[sender.tag - 1];
    JHIntegrationCartModel *cartModel = [JHIntegrationCartModel shareIntegrationCartModel];
    NSInteger num = 0;
    for(NSDictionary *dic in cartModel.integrationCartInfo){
        if([dic[@"product_id"] integerValue] == [model.product_id integerValue]){
            num = [dic[@"product_number"] integerValue];
        }
    }
    if(num >= [model.sku integerValue]){
        [self showMaxNum];
        return;
    }
    [cartModel addIntegrationCartInfoWithProduct_id:model.product_id
                                 withProduct_title:model.title
                                         withImage_url:model.photo
                                         withPrice:model.price
                                         withJifen:model.jifen
                                       withFreight:model.freight
                                            withSku:model.sku];
    [self refreshCartButton];
}
#pragma mark==========创建广告栏轮播图============
- (void)createScrollView
{
    _scrollView.frame = FRAME(0, 0, WIDTH, WIDTH / 3.2);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    for(int i = 0;i < _advArray.count; i ++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(i*WIDTH, 0, WIDTH, WIDTH / 3.2)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        MyTapGesture *advTap = [[MyTapGesture alloc] initWithTarget:self action:@selector(advTap:)];
        advTap.tag = i + 1;
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:advTap];
        NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:[_advArray[i] thumb]]];
        [imgView sd_image:url plimage:IMAGE(@"jfproduct640x200")];
        [_scrollView addSubview:imgView];
    }
    _scrollView.contentSize = CGSizeMake(WIDTH *_advArray.count, 0);
    _scrollView.delegate = self;
    _currentIndex = 0;
    
}
#pragma mark=====点击轮播图进入广告详情=====
- (void)advTap:(MyTapGesture *)sender
{
    IntegrationAdvModel *advModel = _advArray[sender.tag - 1];
    UIViewController *Vc = [JHTempJumpWithRouteModel jumpWithLink:advModel.link];
    [self.navigationController pushViewController:Vc animated:YES];
}
#pragma mark=========UIScrollViewDelegate===============
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint pt = scrollView.contentOffset;
    _currentIndex = pt.x/WIDTH;
    if(_currentIndex == _advArray.count - 1)
    {
        _currentIndex = 0;
        [_scrollView setContentOffset:CGPointMake(WIDTH * _currentIndex, 0) animated:NO];
    }
}
#pragma mark========创建定时器==========
- (void)creatTimer
{
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(beginTimer) userInfo:nil repeats:YES];
}
#pragma mark========开始图片轮播=========
- (void)beginTimer
{
    if (_currentIndex < _advArray.count) {
        _currentIndex ++;
        [_scrollView setContentOffset:CGPointMake(_currentIndex * WIDTH, 0) animated:YES];
    }else {
        _currentIndex = 0;
        [_scrollView setContentOffset:CGPointMake(_currentIndex * WIDTH, 0) animated:NO];
        _currentIndex++;
        [_scrollView setContentOffset:CGPointMake(_currentIndex * WIDTH, 0) animated:YES];
        
        
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self creatTimer];
}
#pragma  mark=====停止定时器=============
- (void)removeTimer
{
    [_timer invalidate];
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark - 没有数据时展示
- (void)showHaveNoMoreData
{
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
        [toast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            toast = nil;
        }];
    }
    
}
#pragma mark--===购物车无数据
- (void)showNoGood{
    if (_badgeToast == nil) {
        _badgeToast = [[DSToast alloc] initWithText:NSLocalizedString(@"您还没有选择商品", nil)];
        [_badgeToast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            _badgeToast = nil;
        }];
    }

}
#pragma mark--===购物车无数据
- (void)showMaxNum{
    if (_maxToast == nil) {
        _maxToast = [[DSToast alloc] initWithText:NSLocalizedString(@"库存不足!", nil)];
        [_maxToast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            _maxToast = nil;
        }];
    }
    
}
@end

//
//  JHWaiMaiMainVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiMainVC.h"
#import "JHWaiMaiMenuVC.h"
#import "JHWaiMaiEvaluateVC.h"
#import "JHWaiMaiBusinessVC.h"
 
#import "ZQShareView.h"
#import "RestView.h"

static NSString *KJHWaiMaiMainCollectionViewCellID = @"KJHWaiMaiMainCollectionViewCellID";

@interface JHWaiMaiMainVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,copy)NSString *restStatus;
@property(nonatomic,strong)ZQShareView *shareView;
@end

@implementation JHWaiMaiMainVC
{
    //创建子导航栏的背景view
    UIView *_naviBackView;
    //子导航三个按钮
    UIButton *_menuBtn;
    UIButton *_evaluateBtn;
    UIButton *_businessBtn;
    //创建按钮下方的滚动条
    UIView *_scrollIndicateView;
    //子控制器数组
    NSArray *_controllers;
    UIButton *productBtn;
    
    NSDictionary *shareDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //后台获取店铺title
    [self getShopTitle];
    shareDic = @{};
    //初始化必备数据
    [self setNecessaryDate];
    [self createMainCollection];
    [self createNavBar];
    
}

- (void)judgeShowRest:(NSString *)status
{
    if (!status) return;
    if ([status isEqualToString:@"0"]) {
        RestView *restV = [[RestView alloc] init];
        [restV setBackBlock:^(){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [restV show];
    }
}
#pragma mark - 设置必备数据
- (void)setNecessaryDate
{
    JHWaiMaiMenuVC *waimaiMenuVC = [[JHWaiMaiMenuVC alloc] init];
    waimaiMenuVC.shop_id = _shop_id;
    waimaiMenuVC.fatherVC = self;
    JHWaiMaiEvaluateVC *waimaiEvaluateVC = [[JHWaiMaiEvaluateVC alloc] init];
    waimaiEvaluateVC.shop_id = _shop_id;
    JHWaiMaiBusinessVC *waimaiBusinessVC = [[JHWaiMaiBusinessVC alloc] init];
    waimaiBusinessVC.shop_id = _shop_id;
    _controllers = @[waimaiMenuVC,waimaiEvaluateVC,waimaiBusinessVC];
    for (UIViewController *controller in _controllers) {
        [self addChildViewController:controller];
    }
}
#pragma mark - 后台获取店铺title
- (void)getShopTitle
{
    [HttpTool postWithAPI:@"client/shop/detail"
               withParams:@{@"shop_id":_shop_id}
                  success:^(id json) {
                      NSLog(@"%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              _restStatus = json[@"data"][@"detail"][@"waimai_detail"][@"yysj_status"];
                              //判断是否展示打烊
                              [self judgeShowRest:_restStatus];
                              self.navigationItem.title = json[@"data"][@"detail"][@"waimai_detail"][@"title"];
                              shareDic = (NSDictionary *)json[@"data"][@"share"];
                              self.shareView.shareDic = shareDic;
                          });
                      }
                  }
                  failure:^(NSError *error) {
                  }];
}
#pragma mark - 创建页面内导航栏
- (void)createNavBar
{
    //创建背景view
    _naviBackView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, 40)];
    _naviBackView.backgroundColor = [UIColor whiteColor];
    _menuBtn = [UIButton new];
    _evaluateBtn = [UIButton new];
    _businessBtn = [UIButton new];
    _scrollIndicateView = [UIView new];
    //创建数组
    NSArray *btnArray = @[_menuBtn,_evaluateBtn,_businessBtn];
    NSArray *titleArray = @[NSLocalizedString(@"菜单", nil),NSLocalizedString(@"评价", nil),NSLocalizedString(@"商家", nil)];
    
    //循环创建按钮
    for (int i = 0; i < 3; i++) {
        UIButton *currentBtn = (UIButton *)btnArray[i];
        currentBtn.frame = CGRectMake(WIDTH / 3 * i, 0, WIDTH / 3, 40);
        [currentBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [currentBtn setTitleColor:[UIColor colorWithHex:@"333333" alpha:1.0]
                         forState:UIControlStateNormal];
        [currentBtn setTitleColor:THEME_COLOR
                         forState:UIControlStateSelected];
        currentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        currentBtn.backgroundColor = [UIColor whiteColor];
        currentBtn.tag = i;
        [currentBtn addTarget:self action:@selector(clickNaviBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_naviBackView addSubview:currentBtn];
        
        
    }
    CGFloat width = WIDTH / 3;
    for (int i = 0; i < 2; i++) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( width * (i + 1), 5, 1, 25)];
        lineView.backgroundColor = LINE_COLOR;
        [_naviBackView addSubview:lineView];
        
    }
    //为背景视图添加分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:229/ 255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [_naviBackView addSubview:lineView];
    //初始化指示器
    _scrollIndicateView.frame = CGRectMake(15, 38, WIDTH / 3 - 30, 2);
    _scrollIndicateView.backgroundColor = THEME_COLOR;
    [_naviBackView addSubview:_scrollIndicateView];
    
    [self.view addSubview:_naviBackView];
}
#pragma mark - 初始化表视图
- (void)createMainCollection
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(WIDTH, HEIGHT - NAVI_HEIGHT-40);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置上下左右的留白
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+40, WIDTH, HEIGHT - NAVI_HEIGHT-40) collectionViewLayout:layout];
        //注册Cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:KJHWaiMaiMainCollectionViewCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
    }
}
#pragma mark - 返回多少单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:KJHWaiMaiMainCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIViewController *controller = _controllers[indexPath.row];
    controller.view.frame = cell.bounds;
    [cell addSubview:controller.view];
    return cell;
    
}
#pragma mark - 点击子导航栏按钮
- (void)clickNaviBtn:(UIButton *)sender
{
    //点击子导航栏按钮
    NSInteger num = sender.tag;
    //根据tag值改变滑动视图的偏移量,并且获取按钮正确的状态
    [_collectionView setContentOffset:CGPointMake(num * WIDTH , 0) animated:YES];
    [self setFrame];
    
}

#pragma mark - 判断当前按钮的选中状态 及滑动视图应该偏移多少
- (void)setFrame
{
    CGPoint offset = _collectionView.contentOffset;
    //计算当前滚动标签应该所处的center
    CGPoint _scrollIndicateView_center = CGPointMake(WIDTH / 6 + offset.x / 3, 40);
    _scrollIndicateView.center = _scrollIndicateView_center;
    //判断并对选中相应按钮
    CGFloat center_x = _scrollIndicateView_center.x;
    if (center_x == WIDTH / 6) {
        
        _menuBtn.selected = YES;
        _evaluateBtn.selected = NO;
        _businessBtn.selected = NO;
    }
    if (center_x == WIDTH / 2) {
        
        _menuBtn.selected = NO;
        _evaluateBtn.selected = YES;
        _businessBtn.selected = NO;
    }
    if (center_x == WIDTH / 6 * 5) {
        
        _menuBtn.selected = NO;
        _evaluateBtn.selected = NO;
        _businessBtn.selected = YES;
    }
}
#pragma mark - UIScrollViewDlegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setFrame];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.rightBarButtonItems = nil;
    [self.navigationController.navigationBar yf_setBackgroundColor:HEX(@"f8f8f8", 1)];
    [self addShareBtn];
}

- (void)addShareBtn
{
    [self.shareView addShareBntAndCollectionBntWithVC:self withId:_shop_id type:@"1"];
}

-(ZQShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ZQShareView alloc]init];
        _shareView.isUrlImg = YES;
        _shareView.superVC = self;
    }
    return _shareView;
}
@end

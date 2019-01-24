//
//  JHPhotoMainVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPhotoMainVC.h"
#import "JHPhotoAllVC.h"
#import "JHPhotoEnvironmentVC.h"
#import "JHPhotoProductVC.h"
static NSString *KJHPhotoMainCollectionViewCellID = @"JHPhotoMainCollectionViewCellID";
@interface JHPhotoMainVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation JHPhotoMainVC
{
    //创建子导航栏的背景view
    UIView *_naviBackView;
    //子导航三个按钮
    UIButton *_allBtn;
    UIButton *_environmentBtn;
    UIButton *_productBtn;
    //创建按钮下方的滚动条
    UIView *_scrollIndicateView;
    //子控制器数组
    NSArray *_controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化必备数据
    [self setNecessaryDate];
    [self createMainCollection];
    [self createNavBar];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
};
#pragma mark - 设置必备数据
- (void)setNecessaryDate
{
    self.navigationItem.title = NSLocalizedString(@"商家相册", nil);
    JHPhotoAllVC *photoAllVC = [[JHPhotoAllVC alloc] init];
    photoAllVC.shop_id = _shop_id;
    JHPhotoEnvironmentVC *environmentVC = [[JHPhotoEnvironmentVC alloc] init];
    environmentVC.shop_id = _shop_id;
    JHPhotoProductVC *productPhotoVC = [[JHPhotoProductVC alloc] init];
    productPhotoVC.shop_id = _shop_id;
    _controllers = @[photoAllVC,environmentVC,productPhotoVC];
    for (UIViewController *controller in _controllers) {
        [self addChildViewController:controller];
    }
}
#pragma mark - 初始化表视图
- (void)createMainCollection
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(WIDTH , HEIGHT - 99);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置上下左右的留白
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:FRAME(0, 99, WIDTH, HEIGHT - 99) collectionViewLayout:layout];
        //注册Cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:KJHPhotoMainCollectionViewCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
    }
}
#pragma mark - 创建页面内导航栏
- (void)createNavBar
{
    //创建背景view
    _naviBackView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, 35)];
    _naviBackView.backgroundColor = [UIColor whiteColor];
    _allBtn = [UIButton new];
    _environmentBtn = [UIButton new];
    _productBtn = [UIButton new];
    _scrollIndicateView = [UIView new];
    
    //创建数组
    NSArray *btnArray = @[_allBtn,_environmentBtn,_productBtn];
    NSArray *titleArray = @[NSLocalizedString(@"全部", nil),NSLocalizedString(@"环境", nil),NSLocalizedString(@"商品", nil)];
    
    //循环创建按钮
    for (int i = 0; i < 3; i++) {
        UIButton *currentBtn = (UIButton *)btnArray[i];
        currentBtn.frame = CGRectMake(WIDTH / 3 * i, 0, WIDTH / 3, 35);
        [currentBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [currentBtn setTitleColor:[UIColor colorWithHex:@"333333" alpha:1.0]
                         forState:UIControlStateNormal];
        [currentBtn setTitleColor:THEME_COLOR
                         forState:UIControlStateSelected];
        currentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        currentBtn.backgroundColor = [UIColor whiteColor];
        currentBtn.tag = i;
        [currentBtn addTarget:self action:@selector(clickNaviBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _allBtn = currentBtn;
            _allBtn.selected = YES;
        }
        [_naviBackView addSubview:currentBtn];
        
        
    }
    CGFloat width = WIDTH / 3;
    for (int i = 0; i < 2; i++) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( width * (i + 1), 5, 1, 25)];
        lineView.backgroundColor = LINE_COLOR;
        [_naviBackView addSubview:lineView];
        
    }
    //为背景视图添加分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:229/ 255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [_naviBackView addSubview:lineView];
    //初始化指示器
    _scrollIndicateView.frame = CGRectMake(15, 34, WIDTH / 3 - 30, 2);
    _scrollIndicateView.backgroundColor = THEME_COLOR;
    [_naviBackView addSubview:_scrollIndicateView];
    
    [self.view addSubview:_naviBackView];
}
#pragma mark - 返回多少单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:KJHPhotoMainCollectionViewCellID forIndexPath:indexPath];
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
    CGPoint _scrollIndicateView_center = CGPointMake(WIDTH / 6 + offset.x / 3, 35);
    _scrollIndicateView.center = _scrollIndicateView_center;
    //判断并对选中相应按钮
    CGFloat center_x = _scrollIndicateView_center.x;
    if (center_x == WIDTH / 6) {
        
        _allBtn.selected = YES;
        _environmentBtn.selected = NO;
        _productBtn.selected = NO;
    }
    if (center_x == WIDTH / 2) {
        
        _allBtn.selected = NO;
        _environmentBtn.selected = YES;
        _productBtn.selected = NO;
    }
    if (center_x == WIDTH / 6 * 5) {
        
        _allBtn.selected = NO;
        _environmentBtn.selected = NO;
        _productBtn.selected = YES;
    }
}
#pragma mark - UIScrollViewDlegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setFrame];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end

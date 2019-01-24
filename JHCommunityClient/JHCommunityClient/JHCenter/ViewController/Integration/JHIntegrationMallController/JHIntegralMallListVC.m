//
//  JHIntegralMallListVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//积分商城列表

#import "JHIntegralMallListVC.h"
#import "IntegrationMallCell.h"
#import "IntegrationMallModel.h"
#import "CustomView.h"
#import "JHIntegrationVC.h"
#import "JHIntegrationGoodDetailVC.h"
#import "MJRefresh.h"
#import "JHSubmitIntegrationOrderVC.h"
#import "MBProgressHUD.h"
 
#import "DSToast.h"
#import "JHIntegrationCartModel.h"
#import "JHIntegrationDropVC.h"
#import "JHSubmitIntegrationOrderVC.h"
@interface JHIntegralMallListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    NSInteger _page;
    DSToast *toast;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    UIImageView *_backImg;
    JHIntegrationDropVC *_dropVC;
    UIView *_bottomView;//底部视图
    UILabel *_badgeLabel;//购物数字
    UIButton *_submitBnt;//立即购买按钮
    UILabel *_totalPrice;//总价格和总积分
    DSToast *_badgeToast;
    DSToast *_maxToast;
}
@end

@implementation JHIntegralMallListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navTitle;
    self.view.backgroundColor = BACK_COLOR;
    _backImg = [[UIImageView alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    [self initDropView];
    [self createDropButton];
    [self loadNewData];
    [self createBottomView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshBottomView];
}
#pragma mark-===下拉列表额相关
- (void)initDropView{
    _dropVC = [[JHIntegrationDropVC alloc] init];
    _dropVC.cate_id = self.cate_id;
    __unsafe_unretained typeof(self)weakSelf = self;
    [_dropVC setSelectBlock:^(IntegrationMallCateBntModel *model) {
        weakSelf.cate_id = model.cate_id;
        weakSelf.navigationItem.title = model.title;
        [weakSelf loadNewData];
    }];
}
#pragma mark-===创建右侧下拉按钮
- (void)createDropButton{
    UIButton *dropBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    dropBnt.frame = FRAME(0, 0, 44, 44);
    [dropBnt setImageEdgeInsets:UIEdgeInsetsMake(10, 39, 10,0)];
    [dropBnt setImage:IMAGE(@"icon_title_more") forState:UIControlStateNormal];
    [dropBnt setImage:IMAGE(@"icon_title_more") forState:UIControlStateHighlighted];
    [dropBnt setImage:IMAGE(@"icon_title_more") forState:UIControlStateSelected];
    [dropBnt addTarget:self action:@selector(clickDropBnt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:dropBnt];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark-====导航栏右侧下拉按钮点击事件
- (void)clickDropBnt:(UIButton *)sender{
    NSLog(@"下拉列表");
    [self.view addSubview:_dropVC.view];
    if(_dropVC.listTableView.height == 0){
        [_dropVC showDropVC];
    }else{
        [_dropVC hideDropVC];
    }
}
- (void)clickBackBtn{
    if(_dropVC.listTableView.height != 0){
      [_dropVC hideDropVC];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--==创建底部视图
- (void)createBottomView{
    if(_bottomView == nil){
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.right.offset = 0;
            make.bottom.offset = 0;
            make.height.offset = 50;
        }];
        UIImageView *cartImg = [UIImageView new];
        [_bottomView addSubview:cartImg];
        cartImg.image = IMAGE(@"shop_vehicle");
        [cartImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.top.offset = 10;
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        _badgeLabel = [UILabel new];
        _badgeLabel.font = FONT(10);
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:_badgeLabel];
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 5;
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.offset = 32.5;
        }];
        _badgeLabel.layer.cornerRadius = 10.0f;
        _badgeLabel.clipsToBounds = YES;
        _totalPrice = [UILabel new];
        _totalPrice.font = FONT(16);
        _totalPrice.textColor = HEX(@"333333", 1.0f);
        [_bottomView addSubview:_totalPrice];
        [_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cartImg.mas_right).offset = 15;
            make.top.offset = 0;
            make.bottom.offset = 0;
            make.right.offset = -100;
        }];
        _submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBnt.titleLabel.font = FONT(16);
        _submitBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_submitBnt setTitle:NSLocalizedString(@"立即购买", nil) forState:UIControlStateNormal];
        [_submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateHighlighted];
        [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
        [_submitBnt addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
        _submitBnt.frame = FRAME(WIDTH - 100, 0, 100, 50);
        [_bottomView addSubview:_submitBnt];
        UIView *line = [UIView new];
        line.backgroundColor = LINE_COLOR;
        line.frame = FRAME(0, 0, WIDTH, 0.5);
        [_bottomView addSubview:line];
        [self refreshBottomView];
    }else {
        [self refreshBottomView];
    }
}
#pragma mark-===刷新底部视图
- (void)refreshBottomView{
    _badgeLabel.text = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalNumer];
    if([_badgeLabel.text integerValue] <= 0){
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.hidden = NO;
    }
    NSString *totalMoney = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalPayMoney];
    NSString *totalJifen = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalJifen];
    _totalPrice.text = [NSString stringWithFormat:@"¥%@%@ %@积分",totalMoney,MT,totalJifen];
    NSMutableAttributedString *totalPriceAttributed = [[NSMutableAttributedString alloc] initWithString:_totalPrice.text];
    NSRange totalPriceRange1 = [_totalPrice.text rangeOfString:[NSString stringWithFormat:@"%@积分",totalJifen]];
    NSRange totalPriceRange2 = [_totalPrice.text rangeOfString:[NSString stringWithFormat:@"¥%@%@",totalMoney,MT]];
    NSRange totalPriceRange3 = [_totalPrice.text rangeOfString:NSLocalizedString(@"积分", nil)];
    NSRange  totalPriceRange4 = [_totalPrice.text rangeOfString:MT];
    [totalPriceAttributed addAttributes:@{NSFontAttributeName:FONT(12)} range:totalPriceRange4];
    [totalPriceAttributed addAttributes:@{NSFontAttributeName:FONT(14)} range:totalPriceRange1];
    [totalPriceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"ff6600", 1.0f)} range:totalPriceRange2];
    [totalPriceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:totalPriceRange3];
    _totalPrice.attributedText = totalPriceAttributed;

}
#pragma mark-====立即购买按钮点击事件
- (void)clickSubmitButton{
    if([_badgeLabel.text integerValue] <= 0){
        [self showNoGood];
    }else{
        //提交订单界
        JHSubmitIntegrationOrderVC *submitOrder = [[JHSubmitIntegrationOrderVC alloc] init];
        [self.navigationController pushViewController:submitOrder animated:YES];
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
        _collectionView = [[UICollectionView alloc] initWithFrame:FRAME(0, (NAVI_HEIGHT+10), WIDTH, HEIGHT - (NAVI_HEIGHT+10) - 50) collectionViewLayout:flow];
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
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _collectionView.mj_footer = _footer;
        _backImg.frame = FRAME(100, NAVI_HEIGHT, WIDTH - 200, (WIDTH - 200) / 1.4);
        _backImg.image = IMAGE(@"noMessage");
    }else{
        [_collectionView reloadData];
    }
}
#pragma mark=========加载第一页数据===========
- (void)loadNewData
{
    
    SHOW_HUD
    _page = 1;
    NSDictionary *dic = @{@"cate_id":self.cate_id,@"page":@(_page)};
    [HttpTool postWithAPI:@"client/mall/product/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            [_dataArray removeAllObjects];
            NSArray *itemsArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemsArray)
            {
                IntegrationMallModel *model = [[IntegrationMallModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            NSLog(@"%@",_dataArray);
            [self createCollectionView];
            HIDE_HUD
        }else{
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据加载失败,原因%@", nil),json[@"message"]]];
        }
        if(_dataArray.count == 0)
        {
            [_collectionView addSubview:_backImg];
        }
        else
        {
            [_backImg removeFromSuperview];
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
#pragma mark======加载更多数据=============
- (void)loadMoreData
{
    
    SHOW_HUD
    _page ++;
    NSDictionary *dic = @{@"cate_id":self.cate_id,@"page":@(_page)};
    [HttpTool postWithAPI:@"client/mall/product/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            NSArray *itemsArray = json[@"data"][@"items"];
            
            if (itemsArray.count == 0) {
                [self showHaveNoMoreData];
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
                HIDE_HUD
                return ;
            }
            for(NSDictionary *dic in itemsArray)
            {
                IntegrationMallModel *model = [[IntegrationMallModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            
            [self createCollectionView];
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
            HIDE_HUD
        }
        else
        {
            HIDE_HUD
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据加载失败,原因%@", nil),json[@"message"]]];
        }
        if(_dataArray.count == 0)
        {
            [_collectionView addSubview:_backImg];
        }
        else
        {
            [_backImg removeFromSuperview];
        }
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
    cell.integrationMallModel = _dataArray[indexPath.item];
    cell.addBnt.tag = indexPath.item + 1;
    [cell.addBnt addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-30)/2,((WIDTH - 30)/2 - 10)/1.35 + 60);
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
    [self refreshBottomView];
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

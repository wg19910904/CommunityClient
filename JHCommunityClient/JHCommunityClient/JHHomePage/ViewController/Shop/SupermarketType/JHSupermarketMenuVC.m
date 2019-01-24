//
//  JHShopMenuVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSupermarketMenuVC.h"
#import "JHShopMenuCollectionViewCell.h"
#import "JHProductDetailVC.h"
#import <MJRefresh.h>
 
#import "JHWaimaiMenuRightModel.h"
#import "JHOrderInfoModel.h"
#import "JHOrderCartTableViewVC.h"
#import "JudgeToken.h"
#import "JHPlaceWaimaiOrderVC.h"
#import "DSToast.h"
static NSString *KJHShopMainCollectionViewCellID2 = @"JHShopMainCollectionViewCellID2";
@interface JHSupermarketMenuVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)JHOrderInfoModel *orderModel;
@property(nonatomic,strong)JHOrderCartTableViewVC *cartTable;
@property(nonatomic,strong)UIControl *maskView;
@end

@implementation JHSupermarketMenuVC
{
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    //底部购物车view
    UIView *_bottomView;
    UIButton *_cartBtn;
    UILabel *_badgeLabel;
    UILabel *_totalPriceLabel;
    UILabel *_remindLabel;
    UIButton *_orderBtn;
    
    //记录页数
    NSInteger page;
    
    //存储数据模型
    NSMutableArray *dataModelArray;
    //用于展示达到最大购买数量
    DSToast *toast;
    
    //最小购买金额
    CGFloat min_amount;
    
    //用于展示最小购买金额
    UILabel *_infoLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX(@"f7f7f7", 1.0f);
    _orderModel = [JHOrderInfoModel shareModel];
    [self loadNewData];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    if (_mainCollectionView) {
        [_mainCollectionView reloadData];
        [self refreshBottomView];
    }
}
- (void)loadNewData
{
    SHOW_HUD
    page = 1;
    NSDictionary *paramsDic = @{@"shop_id":_shop_id,
                                @"cate_id":(_cate_id ? _cate_id : @""),
                                @"page":@(page)};
    
    [HttpTool postWithAPI:@"client/waimai/product/marketitems"
               withParams:paramsDic
                  success:^(id json) {
                      dataModelArray = [@[] mutableCopy];
                      NSLog(@"client/waimai/product/marketitems---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          //处理数据模型
                          min_amount = [json[@"data"][@"shopinfo"][@"min_amount"] floatValue];
                          [self handleModel:json[@"data"][@"products"]];
                      }
                      [_headerRefresh endRefreshing];
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                      [_headerRefresh endRefreshing];
                  }];
    
}
#pragma mark - 处理数据模型
- (void)handleModel:(NSArray *)dataArray
{
    if (dataArray.count == 0 || !dataArray) {
        [self createMainCollection];
        return;
    }
    for (NSDictionary *dic in dataArray) {
        JHWaimaiMenuRightModel *model = [[JHWaimaiMenuRightModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [dataModelArray addObject:model];
    }
    [self createMainCollection];
    [self createBottomView];
}

- (void)loadMoreData
{
    SHOW_HUD
    page ++ ;
    NSDictionary *paramsDic = @{@"shop_id":_shop_id,
                                @"cate_id":(_cate_id ? _cate_id : @""),
                                @"page":@(page)};
    [HttpTool postWithAPI:@"client/waimai/product/marketitems"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/waimai/product/marketitems---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          //处理数据模型
                          [self handleModel:json[@"data"][@"products"]];
                      }
                      [_footerRefresh endRefreshing];
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      [_footerRefresh endRefreshing];
                      HIDE_HUD
                  }];
}
#pragma mark - 初始化表视图
- (void)createMainCollection
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((WIDTH - 30)/ 2,(WIDTH - 30)/ 2 + 50);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置上下左右的留白
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:FRAME(10,10, WIDTH - 20, HEIGHT - 99 - 50 - 10) collectionViewLayout:layout];
        //注册Cell
        [_mainCollectionView registerClass:[JHShopMenuCollectionViewCell class] forCellWithReuseIdentifier:KJHShopMainCollectionViewCellID2];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = HEX(@"f7f7f7", 1.0f);
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        
        //-----------------刷新和加载更多添加--------------------
        //创建刷新表头
        _headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _headerRefresh.lastUpdatedTimeLabel.hidden = YES;
        [_headerRefresh setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_headerRefresh setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _headerRefresh.stateLabel.textColor = [UIColor colorWithRed:129/255.0
                                                              green:129/255.0
                                                               blue:129/255.0
                                                              alpha:1.0];
        _mainCollectionView.mj_header = _headerRefresh;
        //创建加载表尾
        _footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadMoreData)];
        [_footerRefresh setTitle:@"" forState:MJRefreshStateIdle];//普通闲置状态
        _mainCollectionView.mj_footer = _footerRefresh;
        //----------------------------------------------------
        [self.view addSubview:_mainCollectionView];
    }else{

//        [_mainCollectionView performBatchUpdates:^{
            [_mainCollectionView reloadData];
//        } completion:nil];
    }
}
#pragma mark - 返回多少单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataModelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHShopMenuCollectionViewCell *cell = [_mainCollectionView dequeueReusableCellWithReuseIdentifier:KJHShopMainCollectionViewCellID2 forIndexPath:indexPath];

    cell.dataModel = dataModelArray[indexPath.row];
    //为按钮添加方法
    [cell.addBtn addTarget:self action:@selector(clickAddBtn:)
                      forControlEvents:(UIControlEventTouchUpInside)];
    [cell.subtractBtn addTarget:self action:@selector(clicksubtractBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHProductDetailVC *productDetailVC = [[JHProductDetailVC alloc] init];
    productDetailVC.shop_id = _shop_id;
    JHWaimaiMenuRightModel *dataModel = (JHWaimaiMenuRightModel *)dataModelArray[indexPath.row];
    productDetailVC.titleString = dataModel.title;
    productDetailVC.product_id = dataModel.product_id;
    productDetailVC.productPrice = dataModel.price;
    productDetailVC.package_price = dataModel.package_price;
    productDetailVC.max_num = dataModel.sale_sku;
    productDetailVC.min_amount = min_amount;
    productDetailVC.hidesBottomBarWhenPushed = YES;
    __weak typeof(self)weakSelf = self;
    [productDetailVC setRefreshBlock:^{
        //刷新数据
        [weakSelf refreshMenu];
    }];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}
#pragma mark - 点击cell内的减号
- (void)clicksubtractBtn:(UIButton *)sender
{
    JHShopMenuCollectionViewCell *cell = (JHShopMenuCollectionViewCell *)sender.superview;
    NSIndexPath *indexPath = [_mainCollectionView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSLog(@"点击了第%ld分区第%ld行减号",section,row);
    NSString *num = cell.buy_numLabel.text;
    ([num integerValue] == 1) ? ({
        cell.buy_numLabel.text = [NSString stringWithFormat:@"%ld",[num integerValue] - 1];
        [cell hideSubtractBtn];
    }):({
        cell.buy_numLabel.text = [NSString stringWithFormat:@"%ld",[num integerValue] - 1];
    });
    //购物车移除商品信息
    JHWaimaiMenuRightModel *rightModel = cell.dataModel;
    [_orderModel removeShopCartInfoWithShop_id:_shop_id
                                withProduct_id:rightModel.product_id
                                   withSpec_id:@""];
    NSLog(@"%@",_orderModel.shopCartInfo);
    //刷新底部view
    [self refreshBottomView];
    
}

#pragma mark - 点击cell内的加号
- (void)clickAddBtn:(UIButton *)sender
{
    JHShopMenuCollectionViewCell *cell = (JHShopMenuCollectionViewCell *)[sender superview];
    NSIndexPath *indexPath = [_mainCollectionView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSLog(@"点击了第%ld分区第%ld行加号",section,row);
    JHWaimaiMenuRightModel *model = dataModelArray[row];
    NSString *num = cell.buy_numLabel.text;
    if ((([num integerValue] >= [model.sale_sku integerValue]) && model.sale_type.integerValue == 1) ||
        [num integerValue] >= 99) {
        
        [self showMaxNum];
        return;
    }
    //处理数量标签
    JHWaimaiMenuRightModel *rightModel = cell.dataModel;
    if (cell.buy_numLabel.text.length == 0) {
        [cell showSubtractBtn];
        
    }else{
        NSString *num = cell.buy_numLabel.text;
        cell.buy_numLabel.text = [NSString stringWithFormat:@"%ld",[num integerValue] + 1];
    }
    //购物车添加商品信息
    [_orderModel addShopCartInfoWithShop_id:_shop_id
                             withProduct_id:rightModel.product_id
                          withProduct_title:rightModel.title
                                withSpec_id:@""
                             withSpec_title:@""
                                  withPrice:rightModel.price
                          withPackage_price:rightModel.package_price
                                 withMaxNum:[rightModel.sale_type integerValue]== 0?@"99":rightModel.sale_sku];
    NSLog(@"%@",_orderModel.shopCartInfo);
    //添加抛物线动画
    [self addProductsAnimation:sender.imageView dropToPoint:CGPointMake(30, HEIGHT -40-99) isNeedNotification:YES];
    //刷新底部view
    [self refreshBottomView];

}
#pragma mark - 创建底部view
- (void)createBottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:FRAME(0, HEIGHT - 99 -50, WIDTH, 50)];
        //添加cell上分割线
        UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        lineView.backgroundColor = LINE_COLOR;
        
        _cartBtn = [[UIButton alloc] initWithFrame:FRAME(10, 7.5, 35, 35)];
        [_cartBtn setImage:IMAGE(@"cart") forState:UIControlStateNormal];
        [_cartBtn addTarget:self action:@selector(clickCartBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.frame = FRAME(28, 3, 20, 20);
        _badgeLabel.layer.cornerRadius = 10;
        _badgeLabel.backgroundColor = SPECIAL_COLOR;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = FONT(12);
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.adjustsFontSizeToFitWidth = YES;
        
        _totalPriceLabel = [[UILabel alloc] initWithFrame:FRAME(55, 0, 140, 50)];
        _totalPriceLabel.font = FONT(14);
        _totalPriceLabel.textColor = HEX(@"333333", 1.0f);
        
        _infoLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 110, 0, 95, 50)];
        _infoLabel.textAlignment = NSTextAlignmentRight;
        _infoLabel.font = FONT(15);
        _infoLabel.textColor = HEX(@"666666", 1.0);
        _infoLabel.text = [NSString stringWithFormat:@"%g%@",min_amount,NSLocalizedString(@"元起送", nil)];
        
        _orderBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 90, 7.5, 80, 35)];
        [_orderBtn setBackgroundColor:SPECIAL_COLOR forState:(UIControlStateNormal)];
        [_orderBtn setBackgroundColor:SPECIAL_COLOR_DOWN forState:(UIControlStateHighlighted)];
        [_orderBtn setTitle:NSLocalizedString(@"确认下单", nil)  forState:(UIControlStateNormal)];
        [_orderBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_orderBtn setTitle:NSLocalizedString(@"确认下单", nil) forState:(UIControlStateHighlighted)];
        [_orderBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateHighlighted)];
        [_orderBtn addTarget:self action:@selector(clickOrderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        _orderBtn.titleLabel.font = FONT(15);
        _orderBtn.layer.cornerRadius = 3;
        _orderBtn.layer.masksToBounds = YES;
        
        [_bottomView addSubview:_cartBtn];
        [_bottomView addSubview:_badgeLabel];
        [_bottomView addSubview:_totalPriceLabel];
        [_bottomView addSubview:_infoLabel];
        [_bottomView addSubview:_orderBtn];
        [_bottomView addSubview:lineView];
        [self.view addSubview:_bottomView];
        
        [self refreshBottomView];
    }
}
#pragma mark - 改变bottomView的状态
- (void)refreshBottomView
{
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    //设置徽章标签数量
    NSInteger num = [model getAllProductNum:_shop_id];
    if (num == 0) {
        _badgeLabel.hidden = YES;
        _badgeLabel.text = [NSString stringWithFormat:@"%ld",num];
    }else if(num <= 99){
        
        _badgeLabel.hidden = NO;
        _badgeLabel.text = [NSString stringWithFormat:@"%ld",num];
        
    }else{
        _badgeLabel.text = @"99+";
        
    }
    //根据text,重新设置总价标签的部分颜色颜色
    CGFloat allprice = [model getAllProductPrice:_shop_id];
    NSString *textString1 = [NSString stringWithFormat:NSLocalizedString(@"合计: ¥%g", nil),allprice];
    NSInteger stringLen = textString1.length;
    //富文本
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:textString1];
    
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:SPECIAL_COLOR
                           range:NSMakeRange(4, stringLen - 4)];
    _totalPriceLabel.attributedText = AttributedStr1;
    if (allprice >= min_amount) {
        
        _infoLabel.hidden = YES;
        _orderBtn.hidden = NO;
    }else{
        _infoLabel.hidden = NO;
        _orderBtn.hidden = YES;
    }
}
#pragma mark - 点击了购物车按钮
- (void)clickCartBtn:(UIButton *)sender
{
    if ([_badgeLabel.text integerValue] == 0) {
        
        [self showAlertWithMsg:NSLocalizedString(@"您还没有选择商品", nil)];
        return;
    }
    if (!_cartTable && !_maskView) {
        _cartTable = [[JHOrderCartTableViewVC alloc]init];
        _cartTable.interval = 99;
        _cartTable.shop_id = _shop_id;
        [self addChildViewController:_cartTable];
        CGRect cart_frame = _cartTable.view.frame;
        _cartTable.view.frame = FRAME(0, HEIGHT - 99 - 50, WIDTH, 0);
        [self.view addSubview:_cartTable.view];
        _maskView = [[UIControl alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT- 50)];
        _maskView.backgroundColor = HEX(@"000000", 0.0f);
        [_maskView addTarget:self action:@selector(tapMaskView)
            forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].delegate.window addSubview:_maskView];
        [UIView animateWithDuration:0.2 animations:^{
            
            _cartTable.view.frame = cart_frame;
            _maskView.frame = FRAME(0, 0, WIDTH, HEIGHT-cart_frame.size.height - 50);
            _maskView.backgroundColor = HEX(@"000000", 0.2f);
            _fatherVC.collectionView.scrollEnabled = NO;
        }];
        
        //刷新购物车表视图和menu
        __weak typeof(self)weakSelf = self;
        [_cartTable setRefreshCartAndMenuBlock:^{
            //刷新
            [weakSelf refreshCartTableAndMenu];
        }];
        [_cartTable setClickCleanBtnBlock:^{
            [weakSelf refreshMenuAndTapMaskView];
            
        }];
    }else{
        [self tapMaskView];
    }
}
#pragma mark - 刷新menu页面
- (void)refreshMenu
{
    [_mainCollectionView reloadData];
    [self refreshBottomView];
}
#pragma mark - 刷新购物车表视图和menu
- (void)refreshCartTableAndMenu
{
    _maskView.frame = FRAME(0, 0, WIDTH, HEIGHT - 50 - CGRectGetHeight(_cartTable.view.frame));
    [_cartTable handleData];
    [_cartTable.mainTableView reloadData];
    [_mainCollectionView reloadData];
    [self refreshBottomView];
}
#pragma mark - 刷新menu 点击蒙版
- (void)refreshMenuAndTapMaskView
{
    _maskView.frame = FRAME(0, 0, WIDTH, HEIGHT - 50 - CGRectGetHeight(_cartTable.view.frame));
    [_mainCollectionView reloadData];
    [self tapMaskView];
    [self refreshBottomView];
}
#pragma mark - 点击了蒙版
- (void)tapMaskView
{
     _fatherVC.collectionView.scrollEnabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        
        _cartTable.view.frame = FRAME(0, HEIGHT - 99 - 50, WIDTH, 0);
        _maskView.frame = FRAME(0, 0, WIDTH, HEIGHT- 50);
        _maskView.backgroundColor = HEX(@"000000", 0.0f);
    } completion:^(BOOL finished) {
        [_cartTable removeFromParentViewController];
        [_cartTable.view removeFromSuperview];
        _cartTable = nil;
        [_maskView removeFromSuperview];
        _maskView = nil;
    }];
}
#pragma mark - 点击了确认下单按钮
- (void)clickOrderBtn:(UIButton *)sender
{
    [self tapMaskView];
    [JudgeToken judgeTokenWithVC:self withBlock:^{
        
        //若已经登录,跳转到下单界面
        JHPlaceWaimaiOrderVC *vc = [[JHPlaceWaimaiOrderVC alloc]init];
        vc.shop_id = _shop_id;
        //获取总价格
        JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
        vc.amount = [model getAllProductPrice:_shop_id];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark - show alert
- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
    [controller addAction:sureAction];
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - 没有数据时展示
- (void)showMaxNum
{
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:NSLocalizedString(@"很抱歉\n已经达到最大购买数量", nil)];
        [toast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            toast = nil;
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

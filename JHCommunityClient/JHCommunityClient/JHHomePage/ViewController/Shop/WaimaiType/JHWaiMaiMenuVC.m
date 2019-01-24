//
//  JHWaiMaiMenuVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiMenuVC.h"
#import "JHWaiMaiMenuLeftcell.h"
#import "JHWaiMaiMenuRightCell.h"
 
#import "JHWaimaiMenuLeftModel.h"
#import "JHWaimaiMenuRightModel.h"
#import "JHOrderInfoModel.h"
#import "JHProductDetailVC.h"
#import "JHPlaceWaimaiOrderVC.h"
#import "JHOrderCartTableViewVC.h"
#import "JudgeToken.h"
#import "DSToast.h"
@interface JHWaiMaiMenuVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;
@property(nonatomic,strong)NSArray *cateArray;
@property(nonatomic,strong)JHOrderInfoModel *orderModel;
@property(nonatomic,strong)JHOrderCartTableViewVC *cartTable;
@property(nonatomic,strong)UIControl *maskView;
@property(nonatomic,strong)UILabel *badgeLabel;
@property(nonatomic,copy)UIView *cartView;
@end

@implementation JHWaiMaiMenuVC
{
    UIView *_bottomView;
    UIButton *_cartBtn;
    UILabel *_badgeLabel;
    UILabel *_totalPriceLabel;
    UILabel *_remindLabel;
    UIButton *_orderBtn;
    NSIndexPath *currentIndex;
    BOOL clickleftBtn;
    //存储模型
    NSMutableArray *leftDataModelArray;
    NSMutableArray *rightDataModelArray;
    //用于展示达到最大购买数量
    DSToast *toast;
    
    //最小购买金额
    CGFloat min_amount;
    
    //用于展示最小购买金额
    UILabel *_infoLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderModel = [JHOrderInfoModel shareModel];
    //请求数据
    [self loadNewData];
    currentIndex = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    if (_rightTableView) {
        [_rightTableView reloadData];
        [self refreshBottomView];
    }
}
#pragma mark - 请求新数据
- (void)loadNewData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/waimai/product/items"
               withParams:@{@"shop_id":_shop_id}
                  success:^(id json) {
                      NSLog(@"client/waimai/product/items---%@",json);
                      //处理数据模型
                      min_amount = [json[@"data"][@"shopinfo"][@"min_amount"] floatValue];
                      [self handleModel:json[@"data"][@"products"]];
                      [self createTableView];
                      [self createBottomView];
                      HIDE_HUD
                      
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
    
}
#pragma mark - 创建表视图
- (void)createTableView
{
    if (_leftTableView && _rightTableView) {
        [_leftTableView reloadData];
        [_rightTableView reloadData];
    }else{
        //创建左侧表视图
        _leftTableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, 80, HEIGHT - 50 - NAVI_HEIGHT - 35)
                                                      style:(UITableViewStylePlain)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        
        //创建右侧表视图
        _rightTableView = [[UITableView alloc] initWithFrame:FRAME(80, 0,WIDTH - 90, HEIGHT - 50 - NAVI_HEIGHT - 35)
                                                       style:(UITableViewStylePlain)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_leftTableView];
        [self.view addSubview:_rightTableView];
    }
 
}
#pragma mark - 创建bottomView
- (void)createBottomView
{
    if (!_bottomView) {//底部视图没有创建时,创建
        _bottomView = [[UIView alloc] initWithFrame:FRAME(0, HEIGHT - NAVI_HEIGHT - 35 -50, WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
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
#pragma mark - 刷新bottomView的状态
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

#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _leftTableView) {
        return 1;
    }
    return leftDataModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return leftDataModelArray.count;
    }
    return [rightDataModelArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return 0.01;
    }else{
        return 25;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return nil;
    }
    //创建view
    UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH - 90, 20)];
    backView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(15, 0, WIDTH - 95, 25)];
    titleLabel.text = [(JHWaimaiMenuLeftModel *)leftDataModelArray[section] title];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0
                                           green:51/255.0
                                            blue:51/255.0
                                           alpha:1.0];
    titleLabel.font = FONT(14);
    [backView addSubview:titleLabel];
    return backView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        return 44;
    }
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (tableView == _leftTableView) {
        JHWaiMaiMenuLeftcell *cell = [_leftTableView dequeueReusableCellWithIdentifier:@"JHWaiMaiMenuLeftCellID"];
        if (!cell){
            cell = [[JHWaiMaiMenuLeftcell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHWaiMaiMenuLeftCellID"];
        }
        cell.dataModel = leftDataModelArray[row];
        if (indexPath == currentIndex) {
            //如果是当前应该显示的按钮
            cell.titileLabel.textColor = THEME_COLOR;
            cell.indicateLabel.hidden = NO;
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.titileLabel.textColor = HEX(@"333333", 1.0f);
            cell.indicateLabel.hidden = YES;
            cell.backgroundColor = BACK_COLOR;
        }
        return cell;
    }else{
        JHWaiMaiMenuRightCell *cell = [_rightTableView dequeueReusableCellWithIdentifier:@"JHWaiMaiMenuRightCellID"];
        if (!cell) {
            cell = [[JHWaiMaiMenuRightCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHWaiMaiMenuRightCellID"];
        }
        //为按钮添加方法
        cell.dataModel = (JHWaimaiMenuRightModel *)rightDataModelArray[section][row];
        [cell.addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.subtractBtn addTarget:self action:@selector(clicksubtractBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (tableView == _leftTableView) {
        //必加
        JHWaiMaiMenuLeftcell *cell_ex = [_leftTableView cellForRowAtIndexPath:currentIndex];
        cell_ex.titileLabel.textColor = HEX(@"333333", 1.0f);
        cell_ex.indicateLabel.hidden = YES;
        cell_ex.backgroundColor = BACK_COLOR;
        //获取到对应的cell
        JHWaiMaiMenuLeftcell *cell = [_leftTableView cellForRowAtIndexPath:indexPath];
        cell.titileLabel.textColor = THEME_COLOR;
        cell.indicateLabel.hidden = NO;
        cell.backgroundColor = [UIColor whiteColor];
        currentIndex = indexPath;
        //设置rightTableView的偏移量
        clickleftBtn = YES;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:row];
        //右侧表视图对应的section的行数
        NSInteger cell_num = [_rightTableView  numberOfRowsInSection:row];
        if (cell_num == 0)  return;
        [_rightTableView scrollToRowAtIndexPath:indexpath
                               atScrollPosition:UITableViewScrollPositionTop
                                       animated:YES];
    }else{ //点击菜单cell时
        
        JHProductDetailVC *productDetailVC = [[JHProductDetailVC alloc] init];
        productDetailVC.shop_id = _shop_id;
        JHWaimaiMenuRightModel *dataModel = (JHWaimaiMenuRightModel *)rightDataModelArray[section][row];
        productDetailVC.titleString = dataModel.title;
        productDetailVC.product_id = dataModel.product_id;
        productDetailVC.productPrice = dataModel.price;
        productDetailVC.package_price = dataModel.package_price;
        productDetailVC.max_num = dataModel.sale_sku;
        productDetailVC.min_amount = min_amount;
        __weak typeof(self)weakSelf = self;
        [productDetailVC setRefreshBlock:^{
            //刷新数据
            [weakSelf refreshMenu];
        }];
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }

}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        //获取到对应的cell
        JHWaiMaiMenuLeftcell *cell = [_leftTableView cellForRowAtIndexPath:indexPath];
        cell.titileLabel.textColor = HEX(@"333333", 1.0f);
        cell.indicateLabel.hidden = YES;
        cell.backgroundColor = BACK_COLOR;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (clickleftBtn == NO) {
        if (scrollView == _rightTableView) {
            //获取偏移处的indexPath
            NSIndexPath *indexPath = [_rightTableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
            //获取偏移处的分区
            NSInteger section = indexPath.section;
            [_leftTableView setContentOffset:CGPointMake(0, section*44) animated:YES];
            //将左侧table对应的cell设置为选中
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:section inSection:0];
            //必加
            JHWaiMaiMenuLeftcell *cell_ex = [_leftTableView cellForRowAtIndexPath:currentIndex];
            cell_ex.titileLabel.textColor = HEX(@"333333", 1.0f);
            cell_ex.indicateLabel.hidden = YES;
            cell_ex.backgroundColor = BACK_COLOR;
            //获取到对应的cell
            JHWaiMaiMenuLeftcell *cell = [_leftTableView cellForRowAtIndexPath:indexPath2];
            cell.titileLabel.textColor = THEME_COLOR;
            cell.indicateLabel.hidden = NO;
            cell.backgroundColor = [UIColor whiteColor];
            currentIndex = indexPath2;
        }
    }
}
#pragma mark - 点击cell内的加号
- (void)clickAddBtn:(UIButton *)sender
{
    JHWaiMaiMenuRightCell *cell = (JHWaiMaiMenuRightCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_rightTableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSLog(@"点击了第%ld分区第%ld行加号",section,row);
    JHWaimaiMenuRightModel *model = rightDataModelArray[section][row];
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _rightTableView) {
        clickleftBtn = NO;
    }else{
        clickleftBtn = YES;
    }
}
#pragma mark - 点击cell内的减号
- (void)clicksubtractBtn:(UIButton *)sender
{
    JHWaiMaiMenuRightCell *cell = (JHWaiMaiMenuRightCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_rightTableView indexPathForCell:cell];
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
#pragma mark - 处理模型
- (void)handleModel:(NSArray *)json_data
{
    leftDataModelArray = [@[] mutableCopy];
    rightDataModelArray = [@[] mutableCopy];
    //处理左侧模型
    for (NSDictionary *dic in json_data) {
        JHWaimaiMenuLeftModel *model = [[JHWaimaiMenuLeftModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [leftDataModelArray addObject:model];
    }
    //处理右侧模型
    for (JHWaimaiMenuLeftModel *leftModel in leftDataModelArray) {
        NSMutableArray *temArray = [@[] mutableCopy];
        for (NSDictionary *dic in leftModel.child) {
            JHWaimaiMenuRightModel *model = [[JHWaimaiMenuRightModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [temArray addObject:model];
        }
        [rightDataModelArray addObject:temArray];
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
        _cartTable.interval =NAVI_HEIGHT + 35;//HEIGHT - NAVI_HEIGHT - 35 -50
        _cartTable.shop_id = _shop_id;
        [self addChildViewController:_cartTable];
        CGRect cart_frame = _cartTable.view.frame;
        _cartTable.view.frame = FRAME(0, HEIGHT -NAVI_HEIGHT - 35- 50, WIDTH, 0);
        [self addChildViewController:_cartTable];
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
        //点击购物车的清空按钮
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
    [_rightTableView reloadData];
    [self refreshBottomView];
}
#pragma mark - 刷新购物车表视图和menu
- (void)refreshCartTableAndMenu
{
    [self refreshBottomView];
    _maskView.frame = FRAME(0, 0, WIDTH, HEIGHT - 50 - CGRectGetHeight(_cartTable.view.frame));
    [_cartTable handleData];
    [_cartTable.mainTableView reloadData];
    [_rightTableView reloadData];
    
}
#pragma mark - 刷新menu 点击蒙版 点击购物车表视图的清空按钮
- (void)refreshMenuAndTapMaskView
{
    _maskView.frame = FRAME(0, 0, WIDTH, HEIGHT - 50 - CGRectGetHeight(_cartTable.view.frame));
    [_rightTableView reloadData];
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
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    NSInteger num = [model getAllProductNum:_shop_id];
    if (num <= 0) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先选择购买的物品!", nil)];
        return;
    }
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

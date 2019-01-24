//
//  JHProductDetailVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHProductDetailVC.h"
#import "JHProductDetailCellOne.h"
#import "JHProductDetailCellTwo.h"
 
#import "JHProductDetailSpecsModel.h"
#import "MBProgressHUD.h"
#import "NSObject+CGSize.h"
#import "AppDelegate.h"
#import "JHCartCell.h"
#import "JHOrderInfoModel.h"
#import "JHOrderCartTableViewVC.h"
#import "JudgeToken.h"
#import "JHPlaceWaimaiOrderVC.h"
#import "DSToast.h"
#import "UINavigationBar+Awesome.h"
#import <UIImageView+WebCache.h>
@interface JHProductDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *tableHeaderView;//表头
    UIScrollView *_top_scrollView;
    UIPageControl *pageControl;
    UIButton *top_btn;
}
@property(nonatomic,strong)UITableView *mainTbleView;
@property(nonatomic,strong)JHOrderInfoModel *orderModel;
@property(nonatomic,strong)UIImageView *topIV;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *subtractBtn;
@property(nonatomic,strong)UILabel *buy_numLabel;
@property(nonatomic,assign)NSInteger totalPrice;//总价格
@property(nonatomic,strong)JHProductDetailCellTwo *cellTwo;
@property(nonatomic,strong)UILabel *badgeLabel;
@property(nonatomic,strong)JHOrderCartTableViewVC *cartTable;
@property(nonatomic,strong)UIControl *maskView;
@property (nonatomic,assign)NSInteger guigeBntIndex;
@property(nonatomic,strong)NSDictionary *detailDic;

@end

@implementation JHProductDetailVC
{
    CGFloat height_row2;
    CGFloat height_row3;
    UIView *_bottomView;
    UIButton *_cartBtn;
    UILabel *_totalPriceLabel;
    UILabel *_remindLabel;
    UIButton *_orderBtn;
    NSArray *_bntArray;
    UIButton *_lastBnt;
    UITableView *_cartTableView;//购物车表视图
    UIControl *_cartMenBan;//创建购物车蒙版
    NSMutableArray *_dataArray;//数据源
    
    //json规格数据源
    NSArray *spe_array;
    
    //保存当前的特殊规格商品id
    NSString *last_spec_id;
    
    //用于展示达到最大购买数量
    DSToast *toast;
    
    //用于展示最小购买金额
    UILabel *_infoLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //处理信息
    [self handleInfo];
    [self createBottomView];
    top_btn = [[UIButton alloc]init];
    [top_btn setBackgroundImage:IMAGE(@"top_btn_back") forState:UIControlStateNormal];
    [top_btn addTarget:self action:@selector(clickTopBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:top_btn];
    top_btn.bounds = FRAME(0, 0, 26, 26);
    top_btn.layer.cornerRadius = 13;
    top_btn.layer.masksToBounds = YES;
//    [self createMainTableView];
    
}
#pragma mark - 处理信息
- (void)handleInfo
{
    self.orderModel = [JHOrderInfoModel shareModel];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar yf_setBackgroundColor:THEME_COLOR_WHITE_Alpha(0.0)];
    self.backBtn.alpha = 0;
    [self requestData];
}
#pragma mark - 创建表视图
- (void)createMainTableView
{
    if (!_mainTbleView) {
        _mainTbleView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 50) style:(UITableViewStylePlain)];
        _mainTbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTbleView.delegate = self;
        _mainTbleView.dataSource = self;
        _mainTbleView.backgroundColor = BACK_COLOR;
        _mainTbleView.showsVerticalScrollIndicator = YES;
        _mainTbleView.estimatedRowHeight = 0;
        _mainTbleView.rowHeight = UITableViewAutomaticDimension;;
        tableHeaderView = [[UIView alloc]init];
        tableHeaderView.frame = FRAME(0, 0, WIDTH, WIDTH/3*1.7);
        _mainTbleView.contentInset = UIEdgeInsetsMake(WIDTH/3*1.7, 0, 0, 0);
        _top_scrollView = [[UIScrollView alloc] initWithFrame:FRAME(0, 0, WIDTH, WIDTH/3*1.7)];
        _top_scrollView.delegate = self;
        _top_scrollView.pagingEnabled = YES;
        _top_scrollView.showsHorizontalScrollIndicator = NO;
        _top_scrollView.scrollEnabled = YES;
        pageControl = [[UIPageControl alloc]initWithFrame:FRAME(0, WIDTH/3*1.7-20,80, 20)];
        pageControl.currentPageIndicatorTintColor = THEME_COLOR;
        pageControl.pageIndicatorTintColor = [UIColor blackColor];
        pageControl.currentPage = 0;
        pageControl.center = CGPointMake(tableHeaderView.center.x, pageControl.center.y);
         [self.view addSubview:_mainTbleView];
        [self.view addSubview:tableHeaderView];
        [tableHeaderView addSubview:_top_scrollView];
        [tableHeaderView addSubview:pageControl];
       
    }else{
        [_mainTbleView reloadData];
    }
}
-(void)clickTopBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setDetailDic:(NSDictionary *)detailDic{
    _detailDic = detailDic;
    NSArray *photos = detailDic[@"photos"];
    NSInteger count = photos.count;
    _top_scrollView.contentSize = CGSizeMake(WIDTH * count, 0);
    pageControl.numberOfPages = count;
    if (count == 1) {
        pageControl.hidden = YES;
    }else{
        pageControl.hidden = NO;
    }
    for (int i = 0; i < count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:FRAME(WIDTH * i, 0, WIDTH, WIDTH/3*1.7)];
        iv.tag = i;
        iv.contentMode =  UIViewContentModeScaleAspectFill;
        NSURL *url = [NSURL URLWithString:photos[i]];
        [iv sd_setImageWithURL:url placeholderImage:IMAGE(@"commondefault")];
        [_top_scrollView addSubview:iv];

    }

}
#pragma mark======加载网络数据=========
- (void )requestData
{
    SHOW_HUD
    NSDictionary *dic = @{@"product_id":_product_id};
    [HttpTool postWithAPI:@"client/waimai/product/detail" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            _detailDic = json[@"data"][@"detail"];
            spe_array = _detailDic[@"specs"];
            self.navigationItem.title = json[@"data"][@"detail"][@"title"];
            _titleString = json[@"data"][@"detail"][@"title"];
            _min_amount = [json[@"data"][@"detail"][@"min_amount"] floatValue];
             _infoLabel.text = [NSString stringWithFormat:@"%g%@",_min_amount,NSLocalizedString(@"元起送", nil)];
            _shop_id = json[@"data"][@"detail"][@"shop_id"];
            _max_num = json[@"data"][@"detail"][@"sale_sku"];
            _package_price = json[@"data"][@"detail"][@"package_price"];
            _productPrice = json[@"data"][@"detail"][@"price"];
//            self.detailDic = json[@"data"][@"detail"];x
            
            [self createMainTableView];
           [self setDetailDic:_detailDic];
            HIDE_HUD
        }else{
            [self showAlert:[NSString stringWithFormat:NSLocalizedString(@"加载数据失败,原因:%@", nil),json[@"message"]]];
            HIDE_HUD
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlert:error.localizedDescription];
    }];
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 60;
            break;
            case 1:
            {
//                return  300;
                if (height_row2 == 0.0) {
                    UITableViewCell *cell = (UITableViewCell *)[self tableView:_mainTbleView cellForRowAtIndexPath:indexPath];
                    height_row2 = CGRectGetHeight(cell.frame);
                    [cell removeFromSuperview];
                    cell = nil;
                }
                return height_row2;
            }
                break;
                
            default:
            return 150;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            JHProductDetailCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"JHProductDetailCellOne"];//WithFrame:FRAME(0, 0, WIDTH,60)];
            if (!cell) {
                cell = [[JHProductDetailCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHProductDetailCellOne"];
            }
            cell.dataDic = _detailDic;
            return cell;
        }
            break;

         case 1:
        {
            JHProductDetailCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"JHProductDetailCellTwo"];//WithFrame:FRAME(0, 0, WIDTH,60)];
            if (!cell) {
                cell = [[JHProductDetailCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHProductDetailCellTwo"];
            }
            cell.dataDic = _detailDic;
            //为cell的加减号添加方法
            [cell.addBtn addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
            [cell.subtractBtn addTarget:self action:@selector(clickSub:) forControlEvents:UIControlEventTouchUpInside];
            _bntArray = cell.btnArray;
            if (_bntArray.count > 0) {
                //为cell的特殊规格按钮添加方法
                for(int i = 0; i < _bntArray.count;i++){
                    UIButton *bnt = (UIButton *)_bntArray[i];
                    [bnt addTarget:self action:@selector(guiGeBnt:) forControlEvents:UIControlEventTouchUpInside];
                    bnt.tag = i + 1;
                    if(i == 0){
                        bnt.selected = YES;
                        bnt.layer.borderColor = HEX(@"ff6600", 1.0f).CGColor;
                        _lastBnt = bnt;
                        _guigeBntIndex = 1;
                    }
          #warning  very ugly
                    NSArray *dataArray = _detailDic[@"specs"];
                    last_spec_id = dataArray[0][@"spec_id"];
                    [self getSpecProductNumWithProduct_id:_product_id spec_id:last_spec_id];
                }
            }else{
                //无特殊商品时
                last_spec_id = @"";
                [self getSpecProductNumWithProduct_id:_product_id spec_id:last_spec_id];
            }
//            if (!_cellTwo) {
//                _cellTwo = [[JHProductDetailCellTwo alloc] init];
//                //设置数据
//                _cellTwo.dataDic = _detailDic;
//                //为cell的加减号添加方法
//                [_cellTwo.addBtn addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
//                [_cellTwo.subtractBtn addTarget:self action:@selector(clickSub:) forControlEvents:UIControlEventTouchUpInside];
//                _bntArray = _cellTwo.btnArray;
//                if (_bntArray.count > 0) {
//                    //为cell的特殊规格按钮添加方法
//                    for(int i = 0; i < _bntArray.count;i++){
//                        UIButton *bnt = (UIButton *)_bntArray[i];
//                        [bnt addTarget:self action:@selector(guiGeBnt:) forControlEvents:UIControlEventTouchUpInside];
//                        bnt.tag = i + 1;
//                        if(i == 0){
//                            bnt.selected = YES;
//                            bnt.layer.borderColor = HEX(@"ff6600", 1.0f).CGColor;
//                            _lastBnt = bnt;
//                            _guigeBntIndex = 1;
//                        }
//#warning  very ugly
//                        NSArray *dataArray = _detailDic[@"specs"];
//                        last_spec_id = dataArray[0][@"spec_id"];
//                        [self getSpecProductNumWithProduct_id:_product_id spec_id:last_spec_id];
//                    }
//                }else{
//                    //无特殊商品时
//                    last_spec_id = @"";
//                    [self getSpecProductNumWithProduct_id:_product_id spec_id:last_spec_id];
//                }
//            }
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:FRAME(0, 0, WIDTH, 150)];
            UIWebView *web = [[UIWebView alloc] initWithFrame:FRAME(0, 0, WIDTH, 150)];
            [web loadHTMLString:_detailDic[@"intro"]?_detailDic[@"intro"]:NSLocalizedString(@"暂无简介", nil)  baseURL:nil];
            web.backgroundColor = [UIColor whiteColor];
            [cell addSubview:web];
            
            
            return cell;
        }
             break;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView == _mainTbleView) {
        float y = scrollView.contentOffset.y;
        float a = (y+(WIDTH/3*1.7))/((WIDTH/3*1.7)-64);
        [self.navigationController.navigationBar yf_setBackgroundColor:THEME_COLOR_WHITE_Alpha(a)];
        if (y < -WIDTH/3*1.7) {//往下拖拽
            tableHeaderView.frame = FRAME(0, 0, WIDTH, -y);
            for (UIView * view in tableHeaderView.subviews) {
                if ([view isKindOfClass:[UIPageControl class]]) {
                   view.frame = FRAME(view.frame.origin.x, -y-20, view.frame.size.width, 20);
                }else{
                   view.frame = FRAME(0, 0, view.frame.size.width, -y);
                    for (UIView *imgView  in view.subviews) {
                        if (pageControl.currentPage == imgView.tag) {
                             imgView.frame = FRAME(imgView.tag*WIDTH, 0, view.frame.size.width, -y);
                        }
                    }
                }
            }
        }else{//往上
            CGFloat offset_y = scrollView.contentOffset.y + WIDTH/3*1.7;
            tableHeaderView.frame = FRAME(0, -offset_y, WIDTH, WIDTH/3*1.7);
        }

    }else if (scrollView == _top_scrollView){
        CGFloat offset_x = scrollView.contentOffset.x;
        NSInteger index =  offset_x/WIDTH;
        pageControl.currentPage = index;
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _top_scrollView) {
        NSInteger tag = scrollView.contentOffset.x/WIDTH;
        [self guiGeBnt:_bntArray[tag]];
    }
}
#pragma mark=====规格按钮点击事件========
- (void)guiGeBnt:(UIButton *)sender
{
    
    JHProductDetailCellTwo *cell = [_mainTbleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    JHProductDetailSpecsModel *model = [[JHProductDetailSpecsModel alloc] init];
    model = cell.dataArray[sender.tag - 1];
    cell.priceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"￥%@", nil),model.price];
    if(_lastBnt != nil)
    {
        _lastBnt.selected = NO;
        _lastBnt.layer.borderColor = HEX(@"999999", 1.0f).CGColor;
    }
    sender.selected = YES;
    sender.layer.borderColor = HEX(@"ff6600", 1.0f).CGColor;
    _lastBnt = sender;
    _guigeBntIndex = sender.tag;
    [_top_scrollView setContentOffset:CGPointMake((sender.tag-1)*WIDTH, 0) animated:YES];
    //获取当前购物车保存的该规格商品数量,并展示
    last_spec_id = model.spec_id;
    [self getSpecProductNumWithProduct_id:_product_id spec_id:last_spec_id];
    
}
#pragma mark - 获取特殊商品的数量并展示
- (void)getSpecProductNumWithProduct_id:(NSString *)product_id spec_id:(NSString *)spec_id
{
    JHOrderInfoModel *orderModel = [JHOrderInfoModel shareModel];
    //get all product info
    NSDictionary *cartShopInfo = [orderModel getCartInfoWithShop_id:_shop_id];
    //判断当前购物车是否包含此商品信息
    NSArray *productArray = cartShopInfo[@"products"];
    NSInteger num = 0;
    for (NSDictionary *dic in productArray) {
        if ([dic[@"product_id"] isEqualToString:product_id] && [dic[@"spec_id"] isEqualToString:spec_id]) {
            num += [dic[@"number"] integerValue];
        }
    }
    //处理celltwo数量标签
    [self handleCellTow_numlabel:num];
    //刷新底部状态栏的状态
    [self refreshBottomView];
}
#pragma mark - 处理单个商品的数量标签
- (void)handleCellTow_numlabel:(NSInteger)num
{
    JHProductDetailCellTwo *cellTwo = [_mainTbleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cellTwo.numLabel.text = [NSString stringWithFormat:@"%ld",num];
}
#pragma mark=====加号按钮点击事件=========
- (void)clickAdd:(UIButton *)sender
{
    NSLog(@"点击加号按钮");
    //获取对应的cell
    JHProductDetailCellTwo *cell = [_mainTbleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *spec_id;
    //若存在特殊规格商品
    if (cell.dataArray.count > 0) {
        JHProductDetailSpecsModel *spec_model = [[JHProductDetailSpecsModel alloc] init];
        spec_model = cell.dataArray[_guigeBntIndex - 1];
        NSInteger num = [cell.numLabel.text integerValue];
        if (num >= [spec_model.sale_sku integerValue]) {
            [self showMaxNum];
            return;
        }
        //添加一条商品信息
        [_orderModel addShopCartInfoWithShop_id:_shop_id
                                 withProduct_id:_product_id
                              withProduct_title:_titleString
                                    withSpec_id:spec_model.spec_id
                                 withSpec_title:spec_model.spec_name
                                      withPrice:spec_model.price
                              withPackage_price:spec_model.package_price
                                     withMaxNum:spec_model.sale_sku];
        NSLog(@"%@",_orderModel.shopCartInfo);
        spec_id = spec_model.spec_id;
    }else{
        NSInteger num = [cell.numLabel.text integerValue];
        if (num >= [_detailDic[@"sale_sku"] integerValue]) {
            [self showMaxNum];
            return;
        }
        //不存在特殊规格商品
        [_orderModel addShopCartInfoWithShop_id:_shop_id
                                 withProduct_id:_product_id
                              withProduct_title:_titleString
                                    withSpec_id:@""
                                 withSpec_title:@""
                                      withPrice:_productPrice
                              withPackage_price:_package_price
                                     withMaxNum:_max_num];
        NSLog(@"%@",_orderModel.shopCartInfo);
        spec_id = @"";
    }
    //更新特殊规格商品数量
    last_spec_id = spec_id;
    [self getSpecProductNumWithProduct_id:_product_id spec_id:spec_id];
    
    //添加抛物线动画
    [self addProductsAnimation:sender.imageView
                   dropToPoint:CGPointMake(30, HEIGHT-50)
            isNeedNotification:YES];
    //刷新底部view
    [self refreshBottomView];
    //刷新menu页面
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}
#pragma mark=======减号按钮点击事件=========
- (void)clickSub:(UIButton *)sender
{
    NSLog(@"点击减号按钮");
    //获取对应的cell
    JHProductDetailCellTwo *cell = [_mainTbleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
     NSString *spec_id;
    //若存在特殊规格商品
    if (cell.dataArray.count > 0) {
        JHProductDetailSpecsModel *spec_model = [[JHProductDetailSpecsModel alloc] init];
        spec_model = cell.dataArray[_guigeBntIndex - 1];
        //添加一条商品信息
        [_orderModel removeShopCartInfoWithShop_id:_shop_id
                                    withProduct_id:_product_id
                                       withSpec_id:spec_model.spec_id];
         spec_id = spec_model.spec_id;
    }else{
        //不存在特殊规格商品
        [_orderModel removeShopCartInfoWithShop_id:_shop_id
                                    withProduct_id:_product_id
                                       withSpec_id:@""];
        spec_id = @"";
    }
    //更新特殊规格商品数量
    last_spec_id = spec_id;
    [self getSpecProductNumWithProduct_id:_product_id spec_id:spec_id];
    [self refreshBottomView];
    //刷新menu页面
    if (self.refreshBlock) {
        self.refreshBlock();
    }
    
}
#pragma mark - 创建bottomView
- (void)createBottomView
{
    if (!_bottomView) {//底部视图没有创建时,创建
        _bottomView = [[UIView alloc] initWithFrame:FRAME(0, HEIGHT-50, WIDTH, 50)];
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
        _infoLabel.text = [NSString stringWithFormat:@"%g%@",_min_amount,NSLocalizedString(@"元起送", nil)];
        
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
    
    if (allprice >= _min_amount) {
        
        _infoLabel.hidden = YES;
        _orderBtn.hidden = NO;
    }else{
        _infoLabel.hidden = NO;
        _orderBtn.hidden = YES;
    }
}
#pragma mark - 显示提醒弹窗
- (void)showAlert:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)  message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
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
        _cartTable.interval = 0;
        _cartTable.shop_id = _shop_id;
        [self addChildViewController:_cartTable];
        CGRect cart_frame = _cartTable.view.frame;
        _cartTable.view.frame = FRAME(0, HEIGHT - 50, WIDTH, 0);
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
        }];
        
        //刷新购物车表视图和menu
        __weak typeof(self)weakSelf = self;
        [_cartTable setRefreshCartAndMenuBlock:^{
            //刷新
            [weakSelf refreshCartTable];
        }];
        
        [_cartTable setClickCleanBtnBlock:^{
            [weakSelf refreshMenuAndTapMaskView];
            
        }];
    }else{
        [self tapMaskView];
    }
}
#pragma mark - 点击了蒙版
- (void)tapMaskView
{
    [UIView animateWithDuration:0.2 animations:^{
        
        _cartTable.view.frame = FRAME(0, HEIGHT- 50, WIDTH, 0);
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
#pragma mark - 刷新cartTable
- (void)refreshCartTable
{
    _maskView.frame = FRAME(0, 0, WIDTH, HEIGHT - 50 - CGRectGetHeight(_cartTable.view.frame));
    [_cartTable handleData];
    [_cartTable.mainTableView reloadData];
    //更改数量
    [self getSpecProductNumWithProduct_id:_product_id spec_id:last_spec_id];
    [self refreshBottomView];
}
#pragma mark - 刷新menu 点击蒙版
- (void)refreshMenuAndTapMaskView
{
    [self tapMaskView];
    [self refreshBottomView];
    [self cleanGuige];
}
- (void)cleanGuige
{
    _cellTwo.numLabel.text = @"0";
}
- (void)touch_BackView
{
    [UIView animateWithDuration:0.3 animations:^{
        _cartMenBan.alpha = 0.0f;
        _cartTableView.frame = FRAME(0, HEIGHT - 50, WIDTH, 0);
    } completion:^(BOOL finished) {
        [_cartMenBan removeFromSuperview];
        [_cartTableView removeFromSuperview];
        _cartMenBan = nil;
        _cartTableView = nil;
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

//
//  JHIntegrationGoodDetailVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//商品详情

#import "JHIntegrationGoodDetailVC.h"
#import "JHSubmitIntegrationOrderVC.h"
 
#import "MBProgressHUD.h"
#import "UIImageView+NetStatus.h"
#import "JHIntegrationCartModel.h"
#import "DSToast.h"
@interface JHIntegrationGoodDetailVC ()<UIWebViewDelegate>

{
    UITableView *_tableView;
    UIImageView *_img;
    UIWebView *_webView;
    UIView *_backView;//背景视图
    UIView *_bottomView;//底部视图
    UILabel *_badgeLabel;//购物数字
    UIButton *_submitBnt;//立即购买按钮
    UILabel *_totalPrice;//总价格和总积分
    UILabel *_buyNumber;//购买数量
    DSToast *_badgeToast;
    DSToast *_maxToast;
}
@end

@implementation JHIntegrationGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"商品详情", nil);
    self.view.backgroundColor = BACK_COLOR;
    [self createWebView];
    [self createBottomView];
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
            make.left.offset = 35;
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
    [totalPriceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:totalPriceRange3];
    [totalPriceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"ff6600", 1.0f)} range:totalPriceRange2];
    
    _totalPrice.attributedText = totalPriceAttributed;
}
#pragma mark-====立即购买按钮点击事件
- (void)clickSubmitButton{
    //提交订单界
    if([_badgeLabel.text integerValue] <= 0){
        [self showNoGood];
    }else{
        //提交订单界
        JHSubmitIntegrationOrderVC *submitOrder = [[JHSubmitIntegrationOrderVC alloc] init];
        [self.navigationController pushViewController:submitOrder animated:YES];
    }
}

#pragma mark=======创建webView============
- (void)createWebView
{
    _webView = [[UIWebView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50)];
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(WIDTH/1.6 + 90 + 50, 0, 0, 0);
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    _backView = [[UIView alloc] initWithFrame:FRAME(0, - WIDTH/1.6 - 90 - 50, WIDTH, WIDTH/1.6 + 90 + 50)];
    _backView.backgroundColor = [UIColor whiteColor];
    [_webView.scrollView addSubview:_backView];
    _img = [[UIImageView alloc] initWithFrame:FRAME(0, 0, WIDTH, WIDTH / 1.6)];
    _img.contentMode = UIViewContentModeScaleAspectFill;
    _img.clipsToBounds = YES;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_detailModel.photo]];
    [_img sd_image:url plimage:IMAGE(@"jfproduct640x400")];
    [_backView addSubview:_img];
   //UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, WIDTH / 1.6 + 10, WIDTH - 10, 15)];
    UILabel *titleLabel = [UILabel new];
    [_backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.equalTo(_img.mas_bottom).offset = 15;
        make.right.offset = 0;
        make.height.offset = 14;
    }];
    titleLabel.font = FONT(14);
    titleLabel.text = _detailModel.title;
    titleLabel.textColor = [UIColor blackColor];
   
    //UILabel *codeLabel = [[UILabel alloc] initWithFrame:FRAME(40, WIDTH / 1.6 + 40,WIDTH - 40, 10)];
    UILabel *codeLabel = [UILabel new];
    [_backView addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.equalTo(titleLabel.mas_bottom).offset = 15;
        make.right.offset = 0;
        make.height.offset = 12;
    }];
    codeLabel.font = FONT(12);
    codeLabel.textColor = HEX(@"999999", 1.0f);
    NSString *string = nil;
    string = [NSString stringWithFormat:NSLocalizedString(@"积分%@   数量:%@", nil),_detailModel.jifen,_detailModel.sku];
    NSRange range1 = [string rangeOfString:[NSString stringWithFormat:@"%@",_detailModel.jifen]];
    NSRange range2 = [string rangeOfString:_detailModel.sku];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"333333" alpha:1.0]} range:range1];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"333333" alpha:1.0]} range:range2];
    codeLabel.text = string;
    codeLabel.attributedText = attribute;
    UILabel *line = [UILabel new];
    line.backgroundColor = LINE_COLOR;
    [_backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.height.offset = 0.5;
        make.top.equalTo(codeLabel.mas_bottom).offset = 15;
    }];
    
    UILabel *priceLbel = [UILabel new];
    priceLbel.font = FONT(14);
    priceLbel.text = [NSString stringWithFormat:@"¥%@",_detailModel.price];
    priceLbel.textColor = HEX(@"ff6600", 1.0f);
    [_backView addSubview:priceLbel];
    [priceLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.equalTo(line.mas_bottom).offset = 15;
        make.right.offset = -70;
        make.height.offset = 14;
    }];
    
    UIButton *addBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backView addSubview:addBnt];
    [addBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.top.equalTo(line.mas_bottom).offset = 0;
        make.width.offset = 30;
        make.height.offset = 45;
    }];
    [addBnt addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    addBnt.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 10);
    [addBnt setImage:IMAGE(@"jiahao") forState:UIControlStateNormal];
    
    _buyNumber = [UILabel new];
    _buyNumber.font = FONT(12);
    _buyNumber.text = [[JHIntegrationCartModel shareIntegrationCartModel] getBuyNumberWithProduct_id:_detailModel.product_id];
    _buyNumber.textAlignment = NSTextAlignmentCenter;
    _buyNumber.textColor = HEX(@"333333",1.0f);
    [_backView addSubview:_buyNumber];
    [_buyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -30;
        make.centerY.equalTo(priceLbel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIButton *subBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backView addSubview:subBnt];
    [subBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -50;
        make.top.equalTo(line.mas_bottom).offset = 0;
        make.width.offset = 30;
        make.height.offset = 45;
    }];
    [subBnt addTarget:self action:@selector(clickSubButton) forControlEvents:UIControlEventTouchUpInside];
    subBnt.imageEdgeInsets = UIEdgeInsetsMake(12.5, 10, 12.5, 0);
    [subBnt setImage:IMAGE(@"jian") forState:UIControlStateNormal];
    
    UILabel *goodDetailLable = [[UILabel alloc] initWithFrame:FRAME(0,  WIDTH / 1.6 + 60 + 50, WIDTH, 30)];
    goodDetailLable.font = FONT(12);
    goodDetailLable.textColor = HEX(@"666666", 1.0f);
    goodDetailLable.textAlignment = NSTextAlignmentLeft;
    goodDetailLable.text = NSLocalizedString(@"   商品详情", nil);
    goodDetailLable.backgroundColor = BACK_COLOR;
    [_backView addSubview:goodDetailLable];
    [_webView loadHTMLString:_detailModel.info baseURL:nil];
}
#pragma mark--==加号按钮点击事件
- (void)clickAddButton{
    JHIntegrationCartModel *cartModel = [JHIntegrationCartModel shareIntegrationCartModel];
    NSInteger num = 0;
    for(NSDictionary *dic in cartModel.integrationCartInfo){
        if([dic[@"product_id"] integerValue] == [_detailModel.product_id integerValue]){
            num = [dic[@"product_number"] integerValue];
        }
    }
    if(num >= [_detailModel.sku integerValue]){
        [self showMaxNum];
        return;
    }
    [cartModel addIntegrationCartInfoWithProduct_id:_detailModel.product_id
                                  withProduct_title:_detailModel.title
                                          withImage_url:_detailModel.photo
                                          withPrice:_detailModel.price
                                          withJifen:_detailModel.jifen
                                         withFreight:_detailModel.freight
                                            withSku:_detailModel.sku];
     _buyNumber.text = [NSString stringWithFormat:@"%ld",(num + 1)];
    [self refreshBottomView];

}
#pragma mark-=====减号点击事件
- (void)clickSubButton{
    
    JHIntegrationCartModel *cartModel = [JHIntegrationCartModel shareIntegrationCartModel];
    NSString *num = nil;
    for(NSDictionary *dic in cartModel.integrationCartInfo){
        if([dic[@"product_id"] integerValue] == [_detailModel.product_id integerValue]){
            num = dic[@"product_number"];
        }
    }
    if([num integerValue] - 1 >= 0){
        _buyNumber.text = [NSString stringWithFormat:@"%ld",[num integerValue] - 1];
    }else{
        _buyNumber.text = @"0";
    }
    [cartModel removeIntegrationCartInfoWithProduct_id:_detailModel.product_id];
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

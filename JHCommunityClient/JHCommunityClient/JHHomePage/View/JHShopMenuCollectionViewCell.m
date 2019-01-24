//
//  JHShopMenuCollectionViewCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHShopMenuCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "JHOrderInfoModel.h"
CGFloat const chao_buyLabel_width = 50;
@implementation JHShopMenuCollectionViewCell
{
    UIImageView *_leftIV;
    UILabel *_titleLabel;
    UILabel *_numLabel;
    UILabel *_priceLabel;
    UIButton *_subtractBtn;
    UILabel *_buy_numLabel;
    UIButton *_addBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        //添加子视图
        [self addSubviews];
        [self label_no];
    }
    return self;
}
#pragma mark - 添加子视图
- (void)addSubviews
{
    CGFloat tem_w= (WIDTH - 30)/2;
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LINE_COLOR.CGColor;
    self.backgroundColor = [UIColor whiteColor];
    //添加商品图片
    _leftIV = [[UIImageView alloc] init];
    _leftIV.frame = FRAME(0, 0, tem_w, tem_w);
    _leftIV.image = IMAGE(@"5");
    _leftIV.contentMode =  UIViewContentModeScaleAspectFill;
    _leftIV.clipsToBounds = YES;
    _leftIV.userInteractionEnabled = YES;
    //商品标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = FRAME(10, tem_w, tem_w - 20,25);
    _titleLabel.font = FONT(12);
    _titleLabel.textColor = HEX(@"333333", 1.0f);
    //商家价格
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.frame = FRAME(10, tem_w + 25, tem_w - 20,25);
    _priceLabel.textColor = HEX(@"ff6269", 1.0f);
    _priceLabel.font = FONT(15);
    //减号按钮
    self.subtractBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 40, 40)];
    _subtractBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 10, 5, 10);
    [_subtractBtn setImage:IMAGE(@"jian") forState:(UIControlStateNormal)];
    [_subtractBtn setImage:IMAGE(@"jian") forState:(UIControlStateHighlighted)];
    _subtractBtn.alpha = 0.0f;
    //数量标签
    _buy_numLabel = [[UILabel alloc] initWithFrame:FRAME(0,5,chao_buyLabel_width, 20)];
    _buy_numLabel.textAlignment = NSTextAlignmentCenter;
    _buy_numLabel.textColor = HEX(@"666666", 1.0);
    _buy_numLabel.font = FONT(16);
    //加号按钮
    self.addBtn = [[UIButton alloc] init];
    _addBtn.frame =FRAME(tem_w - 40, tem_w + 10, 40, 40);
    _addBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 10, 5, 10);
    [_addBtn setImage:IMAGE(@"jiahao") forState:(UIControlStateNormal)];
    [_addBtn setImage:IMAGE(@"jiahao") forState:(UIControlStateHighlighted)];
    
    //重新设置数量标签,减号的frame
    _buy_numLabel.center = CGPointMake(_addBtn.center.x - chao_buyLabel_width/2, _addBtn.center.y + 5);
    _subtractBtn.center = _addBtn.center;
    //创建规格按钮
    _specLabel = [[UILabel alloc] initWithFrame:FRAME(tem_w - 80, tem_w + 20, 75, 25)];
    _specLabel.layer.borderColor = LINE_COLOR.CGColor;
    _specLabel.layer.borderWidth = 0.7;
    _specLabel.layer.cornerRadius = 12.5;
    _specLabel.layer.masksToBounds = YES;
    _specLabel.hidden = YES;
    _specLabel.text = NSLocalizedString(@"可选规格", nil);
    _specLabel.textColor = THEME_COLOR;
    _specLabel.textAlignment = NSTextAlignmentCenter;
    _specLabel.font = FONT(15);

    [self addSubview:_leftIV];
    [self addSubview:_titleLabel];
    [self addSubview:_priceLabel];
    [self addSubview:self.subtractBtn];
    [self addSubview:_buy_numLabel];
    [self addSubview:self.addBtn];
    [self addSubview:_specLabel];
}
- (void)setDataModel:(JHWaimaiMenuRightModel *)dataModel
{
    _dataModel = dataModel;
    _buy_numLabel.text = @"";
    _subtractBtn.center = _addBtn.center;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_dataModel.photo]];
    //设置内容
    [_leftIV sd_setImageWithURL:url placeholderImage:IMAGE(@"shangping")];
    _titleLabel.text = _dataModel.title;
    _numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"月售: %@", nil),_dataModel.sales];
    _priceLabel.text = [@"¥" stringByAppendingString:_dataModel.price];
    _addBtn.hidden = NO;
    if ([dataModel.sale_sku integerValue]==0 && [dataModel.sale_type integerValue]!=0 && [dataModel.is_spec integerValue] != 1) {
        _label_no.hidden = NO;
        _addBtn.hidden = YES;
    }else{
        _label_no.hidden = YES;
    }

    //设置是否显示可选规格
    if (dataModel.is_spec.integerValue == 1) {
        _specLabel.hidden = NO;
        _subtractBtn.hidden = YES;
        _addBtn.hidden = YES;
        _buy_numLabel.hidden = YES;
    }else{
        _specLabel.hidden = YES;
        _subtractBtn.hidden = NO;
        _subtractBtn.alpha = 0.0f;
        _buy_numLabel.hidden = NO;
        [self getProduct_numWithShop_id:dataModel.shop_id
                         withProduct_id:dataModel.product_id];
    }
}
#pragma mark - get product num
- (void)getProduct_numWithShop_id:(NSString *)shop_id
                   withProduct_id:(NSString *)product_id
{
    JHOrderInfoModel *orderModel = [JHOrderInfoModel shareModel];
    //get all product info
    NSDictionary *cartShopInfo = [orderModel getCartInfoWithShop_id:shop_id];
    //判断当前购物车是否包含此商品信息
    NSArray *productArray = cartShopInfo[@"products"];
    NSInteger num = 0;
    for (NSDictionary *dic in productArray) {
        if ([dic[@"product_id"] isEqualToString:product_id]) {
            num += [dic[@"number"] integerValue];
            //处理cell的数量标签和减号按钮
            [self handleNUmBtn_And_SubtractBtn:num];
        }
    }
}
#pragma mark - 处理初次展示时,cell的数量标签和减号按钮状态
- (void)handleNUmBtn_And_SubtractBtn:(NSInteger)num
{
    if (num > 0) {
        _buy_numLabel.hidden = NO;
        _buy_numLabel.text = [NSString stringWithFormat:@"%ld",num];
        _subtractBtn.alpha = 1.0f;
        _subtractBtn.center = CGPointMake(_addBtn.center.x - chao_buyLabel_width, _addBtn.center.y);
    }else{
        _subtractBtn.alpha = 0.0f;
        _subtractBtn.center = CGPointMake(_addBtn.center.x , _subtractBtn.center.y);
        _buy_numLabel.text = @"";
    }
}
#pragma mark - 显示减号按钮和数量标签
- (void)showSubtractBtn
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _subtractBtn.alpha = 1.0f;
        _subtractBtn.center = CGPointMake(_addBtn.center.x - chao_buyLabel_width, _subtractBtn.center.y);
        _buy_numLabel.text = @"1";
    }];
}
#pragma mark - 隐藏减号按钮及数量标签
- (void)hideSubtractBtn
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _subtractBtn.alpha = 0.0f;
        _subtractBtn.center = CGPointMake(_addBtn.center.x + chao_buyLabel_width, _subtractBtn.center.y);
        _buy_numLabel.text = @"";
    }];
}

//已售罄
-(UILabel *)label_no{
    if (!_label_no) {
        _label_no = [[UILabel alloc]init];
        _label_no.text = NSLocalizedString(@"已售罄", nil);
        _label_no.textColor = [UIColor whiteColor];
        _label_no.font = FONT(13);
        _label_no.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _label_no.layer.masksToBounds = YES;
        _label_no.layer.cornerRadius = 3;
        _label_no.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label_no];
        [_label_no mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.bottom.offset = -10;
            make.height.offset = 20;
            make.width.offset = 50;
        }];
    }
    return _label_no;
}

@end

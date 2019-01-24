//
//  JHWaiMaiMenuCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiMenuRightCell.h"
#import <UIImageView+WebCache.h>
#import "JHOrderInfoModel.h"
//定义购买数量标签的宽度
CGFloat const buyLabel_width = 60;
@implementation JHWaiMaiMenuRightCell
{
    UIView *_backView;
    UIImageView *_leftIV;
    UILabel *_titleLabel;
    UILabel *_numLabel;
    UILabel *_priceLabel;
    UIButton *_subtractBtn;
    UILabel *_buy_numLabel;
    UIButton *_addBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加子视图
        [self createSubViews];
        [self label_no];
    }
    return self;
}

#pragma mark - 添加子视图
- (void)createSubViews
{
    CGFloat width = WIDTH - 100;
    _backView = [[UIView alloc] initWithFrame:CGRectMake(10, 3, width, 74)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = [UIColor colorWithRed:229/255.0
                                                 green:229/255.0
                                                  blue:229/255.0
                                                 alpha:1.0].CGColor;
    _backView.layer.cornerRadius = 3;
    
    _leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7.5, 55, 55)];
    _leftIV.layer.cornerRadius = 3;
    _leftIV.layer.masksToBounds = YES;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, width, 25)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor =[UIColor colorWithRed:51/255.0
                                          green:51/255.0
                                           blue:51/255.0
                                          alpha:1.0];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, width, 20)];
    _numLabel.textColor = [UIColor colorWithRed:135/255.0
                                         green:135/255.0
                                          blue:135/255.0
                                         alpha:1.0];
    _numLabel.font = [UIFont systemFontOfSize:12];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 45 , 80, 25)];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    _priceLabel.textColor = [UIColor colorWithRed:251/255.0
                                           green:30/255.0
                                            blue:43/255.0
                                           alpha:1.0];
    

    _subtractBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 50, 0, 50,80)];
    _subtractBtn.imageEdgeInsets = UIEdgeInsetsMake(45, 20, 15,10);
    [_subtractBtn setImage:IMAGE(@"jian") forState:(UIControlStateNormal)];
    [_subtractBtn setImage:IMAGE(@"jian") forState:(UIControlStateHighlighted)];
    _subtractBtn.alpha = 0.0;
    
    _buy_numLabel = [[UILabel alloc] initWithFrame:FRAME(width - buyLabel_width - 20,45,buyLabel_width, 20)];
    _buy_numLabel.textAlignment = NSTextAlignmentCenter;
    _buy_numLabel.textColor = HEX(@"666666", 1.0);
    _buy_numLabel.font = FONT(16);
    
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 50, 0, 50,80)];
    _addBtn.imageEdgeInsets = UIEdgeInsetsMake(45,20,15,10);
    [_addBtn setImage:IMAGE(@"jiahao") forState:(UIControlStateNormal)];
    [_addBtn setImage:IMAGE(@"jiahao") forState:(UIControlStateHighlighted)];
    
    //创建规格按钮
    _specLabel = [[UILabel alloc] initWithFrame:FRAME(width - 85, 40, 75, 30)];
    _specLabel.layer.borderColor = LINE_COLOR.CGColor;
    _specLabel.layer.borderWidth = 0.7;
    _specLabel.layer.cornerRadius = 15;
    _specLabel.layer.masksToBounds = YES;
    _specLabel.hidden = YES;
    _specLabel.text = NSLocalizedString(@"可选规格", nil);
    _specLabel.textColor = THEME_COLOR;
    _specLabel.textAlignment = NSTextAlignmentCenter;
    _specLabel.font = FONT(15);
    [_backView addSubview:_specLabel];

    [self addSubview:_backView];
    [_backView addSubview:_leftIV];
    [_backView addSubview:_titleLabel];
    [_backView addSubview:_numLabel];
    [_backView addSubview:_priceLabel];
    [_backView addSubview:_subtractBtn];
    [_backView addSubview:_buy_numLabel];
    [_backView addSubview:_addBtn];
    [_backView addSubview:_numLabel];
}
#pragma mark - 外部数据传入时,设置内容
- (void)setDataModel:(JHWaimaiMenuRightModel *)dataModel
{
    _dataModel = dataModel;
    _buy_numLabel.text = @"";
    _subtractBtn.center = _addBtn.center;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_dataModel.photo]];
    //设置内容
    [_leftIV sd_setImageWithURL:url placeholderImage:IMAGE(@"shangping")];
    _titleLabel.text = _dataModel.title;
    _numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"月售: %g", nil),[_dataModel.sales floatValue]];
    _priceLabel.text = [NSString stringWithFormat:@"¥%g",[_dataModel.price floatValue]];
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
        _subtractBtn.center = CGPointMake(_addBtn.center.x - buyLabel_width, _addBtn.center.y);
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
        _subtractBtn.center = CGPointMake(_addBtn.center.x - buyLabel_width, _subtractBtn.center.y);
        _buy_numLabel.text = @"1";
    }];
}
#pragma mark - 隐藏减号按钮及数量标签
- (void)hideSubtractBtn
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _subtractBtn.alpha = 0.0f;
        _subtractBtn.center = CGPointMake(_addBtn.center.x, _subtractBtn.center.y);
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

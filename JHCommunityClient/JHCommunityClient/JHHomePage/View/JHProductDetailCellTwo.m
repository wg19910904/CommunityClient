//
//  JHProductDetailCellTwo.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHProductDetailCellTwo.h"
#import "NSObject+CGSize.h"
#import "JHProductDetailSpecsModel.h"
@implementation JHProductDetailCellTwo

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        //添加子控件
//        [self createSubViews];
//    }
//    return self;
//}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [self createSubViews];
    }
    return  self;
}
#pragma mark - 添加子控件
- (void)createSubViews
{
    _titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 5, 100, 20)];
    _titleLabel.text = NSLocalizedString(@"规格", nil);
    _titleLabel.textColor = HEX(@"333333", 1.0f);
    _titleLabel.font = FONT(16);

    _priceLabel = [UILabel new];
    _priceLabel.textColor = HEX(@"f85357", 1.0f);
    _priceLabel.font = FONT(14);
    _subtractBtn = [UIButton new];
    _numLabel = [UILabel new];
    _numLabel.font = FONT(14);
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = THEME_COLOR;
    _addBtn = [UIButton new];
    _btnArray = [@[] mutableCopy];
    [self addSubview:_titleLabel];
    [self addSubview:_priceLabel];
    [self addSubview:_subtractBtn];
    [self addSubview:_numLabel];
    [self addSubview:_addBtn];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self label_no];
}
#pragma mark - 外部数据调用时,刷新控件
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _dataArray = [NSMutableArray array];
    //刷新控件
    CGSize totalSize = CGSizeMake(10, 35);
    NSArray *array = _dataDic[@"specs"];
    if (array.count > 0) {
        
        for(NSDictionary *dic in array)
        {
            JHProductDetailSpecsModel *model = [[JHProductDetailSpecsModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        for(int i = 0 ; i < _dataArray.count;i++)
        {
            UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
            bnt.layer.cornerRadius = 6.0f;
            bnt.clipsToBounds = YES;
            bnt.titleLabel.font = FONT(14);
            [bnt setTitleColor:HEX(@"999999", 1.0f) forState:UIControlStateNormal];
            [bnt setTitleColor:HEX(@"ff6600", 1.0f) forState:UIControlStateSelected];
            bnt.layer.borderColor = HEX(@"999999", 1.0f).CGColor;
            bnt.layer.borderWidth = 0.5f;
            [bnt setTitle:[_dataArray[i] spec_name] forState:UIControlStateNormal];
            bnt.titleLabel.textAlignment = NSTextAlignmentCenter;
            CGSize size = [self currentSizeWithString:[NSString stringWithFormat:@"yy%@",bnt.titleLabel.text] font:FONT(14) withWidth:0];
            if(totalSize.width + size.width + 10 > WIDTH) //宽度超过屏幕时,
            {
                totalSize.width = 10;
                totalSize.height += 30;
            }
            bnt.frame = FRAME(totalSize.width, totalSize.height, size.width, 20);
            totalSize.width = size.width + totalSize.width + 10;
            [self.btnArray addObject:bnt];
            [self addSubview:bnt];
        }
        totalSize.height += 30;
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",[_dataArray[0] price]];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",_dataDic[@"price"]];
        _titleLabel.hidden = YES;
    }
    //设置价格标签
    _priceLabel.frame = FRAME(10, totalSize.height, 100, 25);
    //加减号
    _subtractBtn.frame = FRAME(WIDTH - 90,totalSize.height, 20, 30);
    _subtractBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    [_subtractBtn setImage:IMAGE(@"jian") forState:UIControlStateNormal];
    _addBtn.frame = FRAME(WIDTH - 30 ,totalSize.height, 20, 30);
    _addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    [_addBtn setImage:IMAGE(@"jiahao") forState:(UIControlStateNormal)];
    [_addBtn setImage:IMAGE(@"jiahao") forState:(UIControlStateHighlighted)];
    //数量标签
    _numLabel.frame = FRAME(WIDTH - 70,totalSize.height, 40, 20);
    _numLabel.text = @"0";
    //添加分割线
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0,totalSize.height+29.5, WIDTH,0.5)];
    thread.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:thread];
    //设置self的frame
    self.frame = FRAME(0, 0, WIDTH, totalSize.height+30);
    _addBtn.hidden = NO;
    _subtractBtn.hidden = NO;
    _numLabel.hidden= NO;
    _label_no.hidden = YES;
    if ([_dataDic[@"sale_sku"] integerValue]==0 && [_dataDic[@"sale_type"] integerValue]!=0 && [_dataDic[@"is_spec"] integerValue]==0) {
        _label_no.hidden = NO;
        _addBtn.hidden = YES;
        _subtractBtn.hidden = YES;
        _numLabel.hidden = YES;
    }
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

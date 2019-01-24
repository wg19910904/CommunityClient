//
//  JHCartCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHCartCell.h"

@implementation JHCartCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){

        //添加子控件
        [self addSubViews];
    }
    return self;
}
#pragma mark - 添加子控件
- (void)addSubViews
{
    //添加titleLabel / priceLabel / 加减号 及数量标签
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,150, 40)];
    _title.font = [UIFont systemFontOfSize:14];
    _title.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 160, 0, 50, 40)];
    _price.textColor = [UIColor colorWithRed:251/255.0
                                           green:30/255.0
                                            blue:43/255.0
                                           alpha:1.0];
    _price.font = [UIFont systemFontOfSize:12];
    //添加左侧减号按钮
    _subBtn = [[UIButton alloc] init];
    [_subBtn setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    _subBtn.frame = CGRectMake(WIDTH - 100, 5, 30, 30);
    //添加数量标签
    _num = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 75, 5, 30, 30)];
    _num.textAlignment = NSTextAlignmentCenter;
    _num.textColor = THEME_COLOR;
    _num.font = [UIFont systemFontOfSize:13];
    //添加右侧增加按钮
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 50, 5, 30, 30)];
    [_addBtn setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    _addBtn.tag = 4;
    
    [self addSubview:_title];
    [self addSubview:_price];
    [self addSubview:_subBtn];
    [self addSubview:_num];
    [self addSubview:_addBtn];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    //获取当前商品的数量
    _num.text = [dataDic[@"number"] stringValue];
    NSString *product_title = (NSString *)dataDic[@"product_title"];
    NSString *spec_title = (NSString *)dataDic[@"spec_title"];
    _title.text = (spec_title.length > 0 ) ? [NSString stringWithFormat:@"%@-%@",product_title,spec_title]
                                           : product_title;

}
@end

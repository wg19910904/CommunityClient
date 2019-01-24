//
//  JHMaidanOrderDetailInfoCell.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMaidanOrderDetailInfoCell.h"
#define JHMaidanOrderDetailInfoCell_cell_height 32
@implementation JHMaidanOrderDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    NSArray *dataArr = @[@[NSLocalizedString(@"消费金额:", nil),@""],
                         @[NSLocalizedString(@"用户支付:", nil),@""],
                         @[NSLocalizedString(@"订单编号:", nil),@""],
                         @[NSLocalizedString(@"优惠信息:", nil),@""]];
    for (int i = 0; i < 4; i ++) {
        
        UILabel *titleL = [UILabel new];
        [self addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = JHMaidanOrderDetailInfoCell_cell_height*i;
            make.left.offset = 20;
            make.height.offset = JHMaidanOrderDetailInfoCell_cell_height;
            make.bottom.offset = -(3-i)*JHMaidanOrderDetailInfoCell_cell_height;
        }];
        titleL.text = [(NSArray *)dataArr[i] firstObject];
        titleL.textColor = HEX(@"333333", 1.0);
        titleL.font = FONT(14);
        
        UILabel *contentL = [UILabel new];
        [self addSubview:contentL];
        [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = JHMaidanOrderDetailInfoCell_cell_height*i;
            make.right.offset = -20;
            make.height.offset = JHMaidanOrderDetailInfoCell_cell_height;
            make.bottom.offset = -(3-i)*JHMaidanOrderDetailInfoCell_cell_height;
        }];
        contentL.tag = 100 + i;
        contentL.text = [(NSArray *)dataArr[i] lastObject];
        contentL.textColor = HEX(@"333333", 1.0);
        contentL.textAlignment = NSTextAlignmentRight;
        contentL.font = FONT(14);
    }
    
    //添加分隔线
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset = 0;
        make.height.offset = 0.5;
    }];
    lineView.backgroundColor = LINE_COLOR;
}

-(void)setCellModel:(JHMaiDanModel *)cellModel{
 
    UILabel *lab1 = [self viewWithTag:100];
    UILabel *lab2 = [self viewWithTag:101];
    UILabel *lab3 = [self viewWithTag:102];
    UILabel *lab4 = [self viewWithTag:103];
    
    lab1.text = [NSString stringWithFormat: NSLocalizedString(@"¥ %@", NSStringFromClass([self class])),cellModel.total_price];
    lab2.text = [NSString stringWithFormat: NSLocalizedString(@"¥ %@", NSStringFromClass([self class])),cellModel.real_pay];
    lab3.text = cellModel.order_id;
    lab4.text = [NSString stringWithFormat: NSLocalizedString(@"-¥ %@", NSStringFromClass([self class])),cellModel.order_youhui];
    
}

@end

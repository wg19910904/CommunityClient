//
//  JHMaidanOrderDetailOtherCell.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMaidanOrderDetailOtherCell.h"
#define JHMaidanOrderDetailOtherCell_cell_height 32
@implementation JHMaidanOrderDetailOtherCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    NSArray *dataArr = @[@[NSLocalizedString(@"消费时间:", nil),@""],
                         @[NSLocalizedString(@"手机号码:", nil),@""],];
    for (int i = 0; i < 2; i ++) {
        
        UILabel *titleL = [UILabel new];
        [self addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = JHMaidanOrderDetailOtherCell_cell_height*i;
            make.left.offset = 20;
            make.height.offset = JHMaidanOrderDetailOtherCell_cell_height;
            make.bottom.offset = -(1-i)*JHMaidanOrderDetailOtherCell_cell_height;
        }];
        titleL.text = [(NSArray *)dataArr[i] firstObject];
        titleL.textColor = HEX(@"666666", 1.0);
        titleL.font = FONT(14);
        
        UILabel *contentL = [UILabel new];
        [self addSubview:contentL];
        contentL.tag = 100 + i;
        [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = JHMaidanOrderDetailOtherCell_cell_height*i;
            make.right.offset = -20;
            make.height.offset = JHMaidanOrderDetailOtherCell_cell_height;
            make.bottom.offset = -(1-i)*JHMaidanOrderDetailOtherCell_cell_height;
        }];
        contentL.text = [(NSArray *)dataArr[i] lastObject];
        contentL.textColor = HEX(@"666666", 1.0);
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
    lab1.text = cellModel.dateline;
    lab2.text = cellModel.mobile;
}

@end

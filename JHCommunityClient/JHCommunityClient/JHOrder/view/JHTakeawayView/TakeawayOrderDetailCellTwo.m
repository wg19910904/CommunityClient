//
//  TakeawayOrderDetailCellTwo.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "TakeawayOrderDetailCellTwo.h"

@implementation TakeawayOrderDetailCellTwo

-(void)setModel:(JHTakeawayDetailModel *)model{
    _model = model;
    if(self.btn_more == nil){
        CGFloat height = 0.0;
        if ([model.money doubleValue]) {
            //添加扣除余额
            UIView * koukuan = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 50)];
            UILabel *titleL = [[UILabel alloc] initWithFrame:FRAME(20, 0, 80, 50)];
            UILabel *detailTextL = [[UILabel alloc] initWithFrame:FRAME(100, 0, WIDTH-120, 50)];
            detailTextL.textAlignment = NSTextAlignmentRight;
            titleL.font = [UIFont systemFontOfSize:13];
            detailTextL.font = [UIFont systemFontOfSize:13];
            titleL.textColor = [UIColor redColor];
            detailTextL.textColor = [UIColor redColor];
            titleL.text = NSLocalizedString(@"余额抵扣", nil);
            detailTextL.text = [NSString stringWithFormat:@"¥%@",model.money];
            [koukuan addSubview:titleL];
            [koukuan addSubview:detailTextL];
            [self addSubview:koukuan];
            height = 50;
        }
        //创建显示再来一份的按钮
        self.btn_more = [[UIButton alloc]init];
        self.btn_more.frame = FRAME(10, 8+height, 100, 34);
        [self.btn_more setTitle:NSLocalizedString(@"再来一单", nil) forState:UIControlStateNormal];
        [self.btn_more setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        self.btn_more.titleLabel.font = [UIFont systemFontOfSize:13];
        self.btn_more.layer.cornerRadius = 2;
        self.btn_more.layer.masksToBounds = YES;
        self.btn_more.layer.borderColor = THEME_COLOR.CGColor;
        self.btn_more.layer.borderWidth = 1;
        [self addSubview:self.btn_more];
        //创建分割线
        UIView * label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 49.5+height, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
        //创建显示总价的
        self.label_totalMoney  =[[UILabel alloc]init];
        self.label_totalMoney.frame = FRAME(WIDTH - 120, 15+height, 110, 20);
        [self addSubview:self.label_totalMoney];
        self.label_totalMoney.textColor = [UIColor redColor];
        self.label_totalMoney.text = [NSString stringWithFormat:NSLocalizedString(@"合计:¥%@", nil),model.total_price];
        self.label_totalMoney.font = [UIFont systemFontOfSize:15];
        self.label_totalMoney.textAlignment = NSTextAlignmentRight;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    }

@end

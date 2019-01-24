//
//  SendTableViewCellFive.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCellFive.h"
#import "JHCreateOrderSheetView.h"
@interface SendTableViewCellFive()<JHCreateOrderSheetViewDelegate>
{
    BOOL isFirst;
}
@property(nonatomic,strong)JHCreateOrderSheetView *hongBaoSheet;//选择红包的view
@end
@implementation SendTableViewCellFive

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.mySlider == nil) {
        self.hongbao_id = @"0";
        UIView *hongbaoView = [[UIView alloc]init];
        hongbaoView.frame = CGRectMake(0,15 ,WIDTH ,40);
        hongbaoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:hongbaoView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap)];
        [hongbaoView addGestureRecognizer:tap];
        
        
        UILabel *hongbaoAlertL = [UILabel new];
        hongbaoAlertL.text = NSLocalizedString(@"红包抵扣",nil);
        hongbaoAlertL.textColor = HEX(@"333333", 1);
        hongbaoAlertL.font = FONT(13);
        [hongbaoView addSubview:hongbaoAlertL];
        [hongbaoAlertL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.centerY.mas_equalTo(hongbaoView.mas_centerY);
            make.height.offset = 20;
        }];
        
        self.hongbaoL = [UILabel new];
        self.hongbaoL.text = NSLocalizedString(@"暂无可用红包",nil);
        self.hongbaoL.font = FONT(13);
        self.hongbaoL.textColor = HEX(@"ff3300", 1);
        [hongbaoView addSubview:self.hongbaoL];
        [self.hongbaoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.height.offset = 20;
            make.centerY.mas_equalTo(hongbaoView.mas_centerY);
        }];
        
        UIView * view = [[UIView alloc]init];
        view.frame = CGRectMake(0,65,WIDTH ,40);
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];

        self.titleImage = [[UIImageView alloc]init];
        self.titleImage.frame = CGRectMake(10, 12.5, 15, 18);
        self.titleImage.image = [UIImage imageNamed:@"money"];
        [view addSubview:self.titleImage];
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(35, 13.5, 80, 15);
        label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label.text = NSLocalizedString(@"配送费用", nil);
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
        self.moneyLabel = [[UILabel alloc]init];
        self.moneyLabel.frame = CGRectMake(110, 12.5, 100, 15);
        self.moneyLabel.textColor = [UIColor orangeColor];
        self.moneyLabel.font = [UIFont systemFontOfSize:12];
        self.moneyLabel.text = @"¥0";
        [view addSubview:self.moneyLabel];
        self.mySlider = [[UISlider alloc]init];
        self.mySlider.frame = CGRectMake(50, 115, WIDTH-90, 30);
        self.mySlider.minimumValue = 0;
        self.mySlider.maximumValue = 100;
        [self.mySlider setMinimumTrackTintColor:THEME_COLOR];
        //[self.mySlider setMaximumTrackTintColor:THEME_COLOR];
        [self addSubview:self.mySlider];
        self.label1 = [[UILabel alloc]init];
        self.label1.frame = CGRectMake(50,145, 50, 20);
        self.label1.font = [UIFont systemFontOfSize:15];
        self.label1.text = @"0";
        self.label1.textColor = [UIColor colorWithWhite:0.4 alpha:1];;
        [self addSubview:self.label1];
        self.label2 = [[UILabel alloc]init];
        self.label2.frame = CGRectMake(10, 120,30, 20);
        self.label2.font = [UIFont systemFontOfSize:13];
        self.label2.text = NSLocalizedString(@"小费", nil);
        self.label2.adjustsFontSizeToFitWidth = YES;
        self.label2.textAlignment = NSTextAlignmentCenter;
        self.label2.textColor = [UIColor colorWithWhite:0.4 alpha:1];;
        [self addSubview:self.label2];
        self.label3 = [[UILabel alloc]init];
        self.label3.frame = CGRectMake(13, 135, 30, 20);
        self.label3.font = [UIFont systemFontOfSize:13];
        self.label3.text = NSLocalizedString(@"(元)", nil);
        self.label3.adjustsFontSizeToFitWidth = YES;
        self.label3.textAlignment = NSTextAlignmentCenter;
        self.label3.textColor = [UIColor colorWithWhite:0.5 alpha:1];;
        [self addSubview:self.label3];
        self.label_currentMoney = [[UILabel alloc]init];
        self.label_currentMoney.frame = CGRectMake(53, 145, 60, 20);
        self.label_currentMoney.font = [UIFont systemFontOfSize:13];
        self.label_currentMoney.text = @"0";
        self.label_currentMoney.hidden = YES;
        self.label_currentMoney.textColor = [UIColor orangeColor];
        [self addSubview:self.label_currentMoney];
        
    }
}
-(void)clickTap{
    NSLog(@"%@",NSLocalizedString(@"点击了", nil));
    if (_model.hongbaos.count == 0) {
        return;
    }
    self.hongBaoSheet.dataSource = _model.hongbaos;
    self.hongBaoSheet.hongbao_id = self.hongbao_id;
    [self.hongBaoSheet sheetShow];
}
-(void)setModel:(JHPaoTuiHongBaoModel *)model{
    _model = model;
    if ([self.hongbaoL.text isEqualToString:NSLocalizedString(@"不使用红包",nil)]) {
        return;
    }
    self.hongbaoL.text = _model.hongbao[@"deduct_lable"];
    self.hongbao_id = _model.hongbao[@"hongbao_id"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_myBlock && !model.isChange) {
            model.isChange = YES;
            _myBlock(_model.hongbao[@"amount"]);
        }
    });
}
#pragma mark ====== JHCreateOrderSheetViewDelegate =======
-(void)sheetView:(JHCreateOrderSheetView *)sheetView clickIndex:(NSInteger)index choosedValue:(NSString *)str{
    NSString *money = nil;
    if (sheetView == _hongBaoSheet){// 选择红包的回调
            NSDictionary *dic = self.model.hongbaos[index];
            self.hongbaoL.text = [NSString stringWithFormat:NSLocalizedString(@"- ¥%@",nil),dic[@"amount"]];
            self.hongbao_id = dic[@"hongbao_id"];
            money = dic[@"amount"];

        if (_myBlock) {
            _myBlock(money);
        }
    }
}
-(JHCreateOrderSheetView *)hongBaoSheet{
    if (_hongBaoSheet==nil) {
        _hongBaoSheet=[[JHCreateOrderSheetView alloc] initWithTitle:NSLocalizedString(@"选择红包", @"JHWMCreateOrderVC") amount:@"" delegate:self sheetViewType:SheetViewChooseHongBao dataSource:_model.hongbaos];
    }
    return _hongBaoSheet;
}
@end

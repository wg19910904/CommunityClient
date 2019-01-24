
//
//  JHShopHomePageQuanCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHShopHomePageQuanCell.h"
#import "JHTuanGouProductDetailVC.h"
CGFloat JHShopHomePageQuanCell_height;
@implementation JHShopHomePageQuanCell
{
    UIImageView *leftIV;
    UILabel *titleL;
    UILabel *ordersL;
    UIImageView *rightIV;
    
    
    UIControl *view1;
    UIControl *view2;
    UIButton *moreBtn;
    
    NSString *tuan_id1;
    NSString *tuan_id2;
    NSString *titleS1;
    NSString *titleS2;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //makeUI
        [self makeUI];
    }
    return self;
}

#pragma mark - makeUI
- (void)makeUI
{
    leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 7, 16, 16)];
    leftIV.image = IMAGE(@"quan");
    [self addSubview:leftIV];
    
    titleL = [[UILabel alloc] initWithFrame:FRAME(30,0, 200, 40)];
    titleL.text = NSLocalizedString(@"现金抵用券", nil) ;
    titleL.font = FONT(13);
    titleL.textColor = HEX(@"333333", 1.0f);
    [self addSubview:titleL];
    
    ordersL = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 130, 0, 100, 40)];
    ordersL.font = FONT(11);
    ordersL.textColor = HEX(@"999999", 1.0f);
    ordersL.textAlignment = NSTextAlignmentRight;
    [self addSubview:ordersL];
    
    
    rightIV = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 19, 12.5, 9, 15)];
    rightIV.image = IMAGE(@"jiantou_1");
    [self addSubview:rightIV];
    
    view1 = [[UIControl alloc] initWithFrame:FRAME(30, 0, WIDTH-30, 60)];
    [view1 addTarget:self action:@selector(tapView1) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:view1];
    view2 = [[UIControl alloc] initWithFrame:FRAME(30, 60, WIDTH-30, 60)];
    [view2 addTarget:self action:@selector(tapView2) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:view2];
//    
//    moreBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, WIDTH, 30)];
//    [moreBtn setTitle:NSLocalizedString(@"更多现金券 >>", nil) forState:UIControlStateNormal];
//    [moreBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
//    moreBtn.titleLabel.font = FONT(14);
//    [moreBtn addTarget:self action:@selector(tapBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [self addSubview:moreBtn];
}
#pragma mark - 外部数据传入
- (void)setDataDic:(NSDictionary *)dataDic
{
    self.frame = FRAME(0, 0, WIDTH, JHShopHomePageQuanCell_height);
    _dataDic = dataDic;
    if (JHShopHomePageQuanCell_height == 0) {
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
//            obj = nil;
        }];
        
    }else{
        NSArray *dataArray = dataDic[@"childrens"];
        switch (dataArray.count) {
            case 0:
            {
                view1.hidden = YES;
                view2.hidden = YES;
                moreBtn.hidden = YES;
                
                leftIV.frame = FRAME(10, 12, 16, 16);
                NSInteger num = [dataDic[@"total_sales"] integerValue];
                ordersL.text = [NSString stringWithFormat:NSLocalizedString(@"已售%ld", nil),num];
            }
                break;
            case 1:
            {
                titleL.hidden = YES;
                ordersL.hidden  = YES;
                rightIV.hidden = YES;
                view2.hidden = YES;
                leftIV.frame = FRAME(10, 7, 16, 16);
                
                [view1.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [obj removeFromSuperview];
                    obj = nil;
                    
                }];
                NSArray *array = dataDic[@"childrens"];
                tuan_id1 = array[0][@"tuan_id"];
                titleS1 = array[0][@"title"];
                UILabel *title1 = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH - 30, 30)];
                title1.text = array[0][@"title"];
                title1.font = FONT(14);
                title1.textColor = HEX(@"333333", 1.0);
                [view1 addSubview:title1];
                
                UILabel *price1L = [[UILabel alloc] initWithFrame:FRAME(0, 30, 90, 30)];
                price1L.text = [NSString stringWithFormat:NSLocalizedString(@"¥%g", nil),[array[0][@"price"] floatValue]];
                price1L.font = FONT(15);
                price1L.textColor = HEX(@"ff6600", 1.0);
                [view1 addSubview:price1L];
                
                UILabel *s_price1L = [[UILabel alloc] initWithFrame:FRAME(90, 30, 90, 30)];
                s_price1L.text = [NSString stringWithFormat:NSLocalizedString(@"门市价:¥%g", nil),[array[0][@"market_price"] floatValue]];
                s_price1L.font = FONT(12);
                s_price1L.textColor = HEX(@"999999", 1.0);
                [view1 addSubview:s_price1L];
                
                UILabel *num1L= [[UILabel alloc] initWithFrame:FRAME(WIDTH - 160, 15, 100, 30)];
                num1L.text = [NSString stringWithFormat:NSLocalizedString(@"已售%ld", nil),[array[0][@"sales"] integerValue] + [array[0][@"virtual_sales"] integerValue]];
                num1L.font = FONT(12);
                num1L.textColor = HEX(@"999999", 1.0);
                num1L.textAlignment = NSTextAlignmentRight;
                [view1 addSubview:num1L];
                
                UIImageView *right1IV = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 49, 22.5, 9, 15)];
                right1IV.image = IMAGE(@"jiantou_1");
                [view1 addSubview:right1IV];
//                
//                UIView *line1 = [[UIView alloc] initWithFrame:FRAME(0, 59, WIDTH - 30, 0.5)];
//                line1.backgroundColor = LINE_COLOR;
//                [view1 addSubview:line1];
                
//                moreBtn.frame = FRAME(0, 60, WIDTH, 30);
            }
                break;
                
            default:
            {
                titleL.hidden = YES;
                ordersL.hidden  = YES;
                rightIV.hidden = YES;
                leftIV.frame = FRAME(10, 7, 16, 16);
                [view1.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [obj removeFromSuperview];
                    obj = nil;
                }];
                NSArray *array = dataDic[@"childrens"];
                tuan_id1 = array[0][@"tuan_id"];
                titleS1 = array[0][@"title"];
                UILabel *title1 = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH - 30, 30)];
                title1.text = array[0][@"title"];
                title1.font = FONT(14);
                title1.textColor = HEX(@"333333", 1.0);
                [view1 addSubview:title1];
                
                UILabel *price1L = [[UILabel alloc] initWithFrame:FRAME(0, 30, 90, 30)];
                price1L.text = [NSString stringWithFormat:@"¥%g",[array[0][@"price"] floatValue]];
                price1L.font = FONT(15);
                price1L.textColor = HEX(@"ff6600", 1.0);
                [view1 addSubview:price1L];
                
                UILabel *s_price1L = [[UILabel alloc] initWithFrame:FRAME(90, 30, 90, 30)];
                s_price1L.text = [NSString stringWithFormat:NSLocalizedString(@"门市价:¥%g", nil),[array[0][@"market_price"] floatValue]];
                s_price1L.font = FONT(12);
                s_price1L.textColor = HEX(@"999999", 1.0);
                [view1 addSubview:s_price1L];
                
                UILabel *num1L= [[UILabel alloc] initWithFrame:FRAME(WIDTH - 160, 15, 100, 30)];
                num1L.text = [NSString stringWithFormat:NSLocalizedString(@"已售%ld", nil),[array[0][@"sales"] integerValue] + [array[0][@"virtual_sales"] integerValue]];
                num1L.font = FONT(12);
                num1L.textColor = HEX(@"999999", 1.0);
                num1L.textAlignment = NSTextAlignmentRight;
                [view1 addSubview:num1L];
                
                UIImageView *right1IV = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 49, 22.5, 9, 15)];
                right1IV.image = IMAGE(@"jiantou_1");
                [view1 addSubview:right1IV];
                
                UIView *line1 = [[UIView alloc] initWithFrame:FRAME(0, 59, WIDTH - 30, 0.5)];
                line1.backgroundColor = LINE_COLOR;
                [view1 addSubview:line1];
                
                [view2.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [obj removeFromSuperview];
                    obj = nil;
                }];
                tuan_id2 = array[1][@"tuan_id"];
                titleS2 = array[1][@"title"];
                UILabel *title2 = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH - 30, 30)];
                title2.text = array[1][@"title"];
                title2.font = FONT(14);
                title2.textColor = HEX(@"333333", 1.0);
                [view2 addSubview:title2];
                
                UILabel *price2L = [[UILabel alloc] initWithFrame:FRAME(0, 30, 90, 30)];
                price2L.text = [NSString stringWithFormat:@"¥%g",[array[1][@"price"] floatValue]];
                price2L.font = FONT(15);
                price2L.textColor = HEX(@"ff6600", 1.0);
                [view2 addSubview:price2L];
                
                UILabel *s_price2L = [[UILabel alloc] initWithFrame:FRAME(90, 30, 90, 30)];
                s_price2L.text = [NSString stringWithFormat:NSLocalizedString(@"门市价:¥%g", nil),[array[1][@"market_price"] floatValue]];
                s_price2L.font = FONT(12);
                s_price2L.textColor = HEX(@"999999", 1.0);
                [view2 addSubview:s_price2L];
                
                UILabel *num2L= [[UILabel alloc] initWithFrame:FRAME(WIDTH - 160, 15, 100, 30)];
                num2L.text = [NSString stringWithFormat:NSLocalizedString(@"已售%ld", nil),[array[1][@"sales"] integerValue] + [array[1][@"virtual_sales"] integerValue]];
                num2L.font = FONT(12);
                num2L.textColor = HEX(@"999999", 1.0);
                num2L.textAlignment = NSTextAlignmentRight;
                [view2 addSubview:num2L];
                
                UIImageView *right2IV = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 49, 22.5, 9, 15)];
                right2IV.image = IMAGE(@"jiantou_1");
                [view2 addSubview:right2IV];
                
//                UIView *line2 = [[UIView alloc] initWithFrame:FRAME(0, 59, WIDTH - 30, 0.5)];
//                line2.backgroundColor = LINE_COLOR;
//                [view2 addSubview:line2];
                
//                moreBtn.frame = FRAME(0, 120, WIDTH, 30);
            }
                break;
        }
    }
}

- (void)tapView1
{
    JHTuanGouProductDetailVC *vc = [JHTuanGouProductDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tuan_id = tuan_id1;
    vc.titleString = titleS1;
    [self.navVC pushViewController:vc animated:YES];
}

- (void)tapView2
{
    JHTuanGouProductDetailVC *vc = [JHTuanGouProductDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tuan_id = tuan_id2;
    vc.titleString = tuan_id2;
    [self.navVC pushViewController:vc animated:YES];
}
- (void)tapBtn
{
    self.clickMoreBtnBlock();
}

+ (CGFloat)getHeightWithHaveQuan:(NSString *)haveQuan  withDic:(NSDictionary *)dic
{
    if ([haveQuan integerValue] == 0) {
        
        JHShopHomePageQuanCell_height = 0;
    }else{
        NSArray *array = dic[@"childrens"];
        if (array.count == 0) {
            JHShopHomePageQuanCell_height = 40;
        }else if (array.count == 1){
            JHShopHomePageQuanCell_height = 60;
        }else if (array.count == 2){
            JHShopHomePageQuanCell_height = 120;
        }
    }
       return JHShopHomePageQuanCell_height;
}
@end

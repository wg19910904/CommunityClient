//
//  JHWaiMaiListCellID.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiListCell.h"
#import "XHStarView.h"
#import "UIImageView+NetStatus.h"
@implementation JHWaiMaiListCell
{
    /**
     *  定义子控件
     */
    UIImageView *leftIV;
    UILabel *titleLabel;
    XHStarView *starView;
    UILabel *numLabel;
//    UILabel *startPriceLabel;
//    UILabel *deliverFeeLabel;
//    UILabel *deliverTimeLabel;
    UILabel *infoLabel;
    UIImageView *jianIV;
    UIImageView *shouIV;
    UIImageView *zheIV;
    UIView *line1;
    UIView *line2;
    UIView *distanceView;
    UILabel *restL;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加子控件
        [self createSubViews];
    }
    return self;
}
#pragma mark - 添加子控件
- (void)createSubViews
{
    leftIV = [UIImageView new];
    titleLabel = [UILabel new];
    numLabel = [UILabel new];
    infoLabel = [UILabel new];
    jianIV = [UIImageView new];
    shouIV = [UIImageView new];
    zheIV = [UIImageView new];
    line1 = [UIView new];
    line2 = [UIView new];
    
    restL = [UILabel new];
    restL.frame = FRAME(0, 35, 55, 20);
    restL.backgroundColor = HEX(@"000000",0.6f);
    restL.textColor = [UIColor whiteColor];
    restL.font = [UIFont boldSystemFontOfSize:12];
    restL.text = NSLocalizedString(@"休息中", nil);
    restL.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:leftIV];
    [self addSubview:titleLabel];
    [self addSubview:numLabel];
    [self addSubview:infoLabel];
    [self addSubview:jianIV];
    [self addSubview:shouIV];
    [self addSubview:zheIV];
    [self addSubview:line1];
    [self addSubview:line2];
    [leftIV addSubview:restL];
    //添加下边线
    UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0, 79.5, WIDTH, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self addSubview:lineView];
}
#pragma mark - 外部数据传入时,重新设置控件frame
- (void)setDataModel:(JHWaimaiShopItemModel *)dataModel
{
    _dataModel = dataModel;
    //重新设置控件frame和内容
    leftIV.frame = FRAME(5, 12.5, 55, 55);
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_dataModel.logo]];
    [leftIV sd_image:url plimage:IMAGE(@"shopDefault")];
    
    titleLabel.frame = FRAME(70, 5, WIDTH - 80, 20);
    titleLabel.text = _dataModel.title;
    titleLabel.font = FONT(15);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    
    [starView removeFromSuperview];
    starView = nil;
    starView = [XHStarView addEvaluateViewWithStarNO:[_dataModel.score floatValue] withFrame:FRAME(70,34, 70, 11)];
    [self addSubview:starView];
    numLabel.frame = FRAME(150, 30, 80, 20);
    numLabel.font = FONT(11);
    numLabel.textColor = HEX(@"999999", 1.0f);
    numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"月售:%@", nil),_dataModel.orders];
    
    infoLabel.frame = FRAME(70, 53, WIDTH, 20);
    if ([_dataModel.freight_price floatValue] == 0.0) {
        infoLabel.text = [NSString stringWithFormat:@"¥ %g起送 | 免配送费 | %g分钟送达",[_dataModel.min_amount floatValue],[_dataModel.pei_time floatValue]];
    }else{
        infoLabel.text = [NSString stringWithFormat:@"¥ %g起送 | ¥ %g配送费 | %g分钟送达",[_dataModel.min_amount floatValue],[_dataModel.freight_price floatValue],[_dataModel.pei_time floatValue]];
    }
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = FONT(11);
    infoLabel.textColor = HEX(@"999999", 1.0f);
    
    [distanceView removeFromSuperview];
    distanceView = nil;
    //距离标签
    distanceView = [[UIView alloc] initWithFrame:FRAME(WIDTH - 75, 33, 70, 12)];
    UIImageView *zuobiaoIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0.5, 8, 11)];
    zuobiaoIV.image = IMAGE(@"zuobaio2");
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:FRAME(13, 0, 57, 12)];
    distanceLabel.font = FONT(12);
    distanceLabel.text = _dataModel.juli_label;
    distanceLabel.textColor = [UIColor lightGrayColor];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    [distanceView addSubview:zuobiaoIV];
    [distanceView addSubview:distanceLabel];
    [self addSubview:distanceView];
    
    //判断是否显示打烊
    [self judgeRest:dataModel.yysj_status];
}
- (void)judgeRest:(NSString *)status
{
    if ([status isEqualToString:@"1"]) {
        //营业
        restL.hidden = YES;
    }else{
        //休息中
        restL.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    restL.backgroundColor = HEX(@"000000",0.6f);
    starView.backView.backgroundColor = [UIColor colorWithPatternImage:starView.grayStarImage];
    starView.topView.backgroundColor = [UIColor colorWithPatternImage:starView.colorStarImage];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    restL.backgroundColor = HEX(@"000000",0.6f);
    starView.backView.backgroundColor = [UIColor colorWithPatternImage:starView.grayStarImage];
    starView.topView.backgroundColor = [UIColor colorWithPatternImage:starView.colorStarImage];
}
@end

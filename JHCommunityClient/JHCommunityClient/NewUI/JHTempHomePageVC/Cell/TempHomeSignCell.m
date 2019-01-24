//
//  TempHomeSignCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "TempHomeSignCell.h"
#import "YFCubeLab.h"
@interface TempHomeSignCell()
@property(nonatomic,strong)UIView *bottomLine;//底部的分割线线
@property(nonatomic,strong)UIImageView *laba_imgV;//喇叭的图片
@property(nonatomic,strong)UIButton *rightBtn;//签到的按钮
@property(nonatomic,strong)YFCubeLab *noticeL;//展示通知的消息的
@end
@implementation TempHomeSignCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //底部的分割线线
        [self bottomLine];
        //喇叭的图片
        [self laba_imgV];
        //签到的按钮
        [self rightBtn];
        //点击消息
        //[self leftBtn];
    }
    return self;
}
//添加底部的线
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = HEX(@"dedede", 1);
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = -0;
            make.left.offset = 0;
            make.right.offset = -0;
            make.height.offset = 0.5;
        }];
    }
    return _bottomLine;
}
//喇叭的图片
-(UIImageView *)laba_imgV{
    if (!_laba_imgV) {
        _laba_imgV = [[UIImageView alloc]init];
        _laba_imgV.image = IMAGE(@"index_icon_notice");
        [self addSubview:_laba_imgV];
        [_laba_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.offset = 14;
            make.height.offset = 16;
            make.width.offset = 20;
        }];
    }
    return _laba_imgV;
}
//签到的按钮
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn setImage:IMAGE(@"indext_icon_sign") forState:UIControlStateNormal];
        [_rightBtn setTitle:NSLocalizedString(@"签到", nil) forState:UIControlStateNormal];
        [_rightBtn setTitleColor:HEX(@"333333", 1) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = FONT(15);
        [_rightBtn addTarget:self action:@selector(clickSignBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -0;
            make.top.offset = 0;
            make.bottom.offset = -1;
            make.width.offset = 95;
        }];
        //添加分割线
        CALayer *line = [[CALayer alloc]init];
        line.backgroundColor = HEX(@"dedede", 1).CGColor;
        line.frame = FRAME(0, 0, 1, 48);
        [_rightBtn.layer addSublayer:line];
    }
    return _rightBtn;
}
#pragma mark - 点击签到的方法
-(void)clickSignBtn{
    if (self.myBlock) {
        self.myBlock(0,YES);
    }
}
-(void)setArray:(NSArray *)array{
    _array = array;
    [_noticeL removeFromSuperview];
    _noticeL = nil;
    [self noticeL];
}
//展示通知的消息的
-(YFCubeLab *)noticeL{
    if (!_noticeL) {
        _noticeL = [[YFCubeLab alloc]init];
        _noticeL.duration = 0.5;
        _noticeL.font = FONT(14);
        _noticeL.textColor = HEX(@"333333", 1);
        __weak typeof (self)weakSelf = self;
        NSMutableArray *tempArr = @[].mutableCopy;
        for (NSDictionary *dic  in self.array) {
            [tempArr addObject:dic[@"desc"]];
        }
        if (tempArr.count == 0) {
            _noticeL.textArr = @[NSLocalizedString(@"暂无消息", nil)];
        }else{
            _noticeL.textArr = tempArr;
        }

        [_noticeL setClickIndex:^(NSInteger index){
            NSLog(@"%ld",index);
            if (weakSelf.myBlock) {
                weakSelf.myBlock(index,NO);
            }
        }];
        [self addSubview:_noticeL];
        [_noticeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_laba_imgV.mas_right).offset = 8;
            make.top.offset = 14;
            make.right.equalTo(_rightBtn.mas_left).offset = -10;
            make.height.offset = 20;
        }];
    }
    return _noticeL;
}
@end

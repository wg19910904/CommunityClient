//
//  JHWMDetailStatusCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWMOrderDetailStatusCell.h"
#import "YFTypeBtn.h"
#import "NSString+Tool.h"

@interface JHWMOrderDetailStatusCell()
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,weak)YFTypeBtn *statusBtn;
@property(nonatomic,weak)UILabel *payTimeLab;
@end

@implementation JHWMOrderDetailStatusCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *backView = [UIView new];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.height.offset(60);
    }];
    
    YFTypeBtn *statusBtn = [YFTypeBtn new];
    [backView addSubview:statusBtn];
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
        make.height.offset(40);
    }];
    statusBtn.btnType = RightImage;
    statusBtn.imageMargin = 10;
    [statusBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [statusBtn setImage:IMAGE(@"arrowR") forState:UIControlStateNormal];
    statusBtn.titleLabel.font = FONT(16);
    statusBtn.userInteractionEnabled = NO;
    self.statusBtn = statusBtn;
    
    UILabel *payTimeLab = [UILabel new];
    [backView addSubview:payTimeLab];
    [payTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(statusBtn.mas_bottom).offset(-5);
        make.height.offset(20);
    }];
    payTimeLab.textColor = TEXT_COLOR;
    payTimeLab.font = FONT(12);
    payTimeLab.textAlignment = NSTextAlignmentCenter;
    payTimeLab.hidden = YES;
    self.payTimeLab = payTimeLab;
    
}

-(void)setStatusStr:(NSString *)statusStr{
    [self.statusBtn setTitle:statusStr forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(_pay_left_time <=0 ? 10 : 0);
    }];
    self.payTimeLab.hidden = _pay_left_time <=0;
}

#pragma mark ====== 支付倒计时处理 =======
-(void)setPay_left_time:(NSInteger)pay_left_time{
    _pay_left_time = pay_left_time;
    [self layoutSubviews];
    if (pay_left_time <=0) {
        [self stopTimer];
        return;
    }
    [self startTimer];
}

-(void)startTimer{
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
-(void)onTimer{
    _pay_left_time --;
    if (_pay_left_time <= 0) {
        [self stopTimer];
        YF_SAFE_BLOCK(self.cancelOrderBlock,NO,@"");
        [self layoutSubviews];
    }
    NSString *str = @"";
    NSInteger mint = _pay_left_time / 60;
    NSInteger sec = _pay_left_time % 60;
    if (mint == 0 ) {
        str = [NSString stringWithFormat: NSLocalizedString(@"%02ld秒", NSStringFromClass([self class])),sec];
    }else{
        str = [NSString stringWithFormat: NSLocalizedString(@"%02ld分%02ld秒", NSStringFromClass([self class])),mint,sec];
    }
  
    self.payTimeLab.attributedText = [NSString getAttributeString:[NSString stringWithFormat: NSLocalizedString(@"请于%@内付款,超时将自动取消订单", nil),str] dealStr:str strAttributeDic:@{NSForegroundColorAttributeName : Orange_COLOR}];
        
}

-(void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end

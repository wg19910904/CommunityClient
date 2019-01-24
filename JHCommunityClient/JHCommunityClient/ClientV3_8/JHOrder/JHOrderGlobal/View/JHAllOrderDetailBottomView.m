//
//  JHAllOrderDetailBottomView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHAllOrderDetailBottomView.h"

@interface JHAllOrderDetailBottomView()
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)id model;
@property(nonatomic,assign)JHAllOrderFooterBtnMasRect btnMasRect;
@property(nonatomic,assign)NSInteger pay_left_time;// 支付剩余时间
@property(nonatomic,weak)UIButton *pay_btn;
@property(nonatomic,copy)NSString *normal_pay_title;// 去支付
@end

@implementation JHAllOrderDetailBottomView
-(instancetype)initWithFrame:(CGRect)frame btnMasRect:(JHAllOrderFooterBtnMasRect)btnMasRect{
    _btnMasRect = btnMasRect;
    return [self initWithFrame:frame];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *lineView=[UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    self.backgroundColor = [UIColor whiteColor];
    UIButton *beforeBtn = nil;
    for (NSInteger i=0; i<4; i++) {
        
        UIButton *action_btn = [UIButton new];
        [self addSubview:action_btn];
        
        [action_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (beforeBtn) {
                make.right.equalTo(beforeBtn.mas_left).offset(-_btnMasRect.btn_margin);
            }else{
                make.right.offset=-(_btnMasRect.right_margin + (_btnMasRect.width_margin + _btnMasRect.btn_margin)* i);
            }
            make.top.offset(_btnMasRect.top_margin);
            make.bottom.offset(-_btnMasRect.bottom_margin);
            make.width.offset(_btnMasRect.width_margin);
        }];
        beforeBtn = action_btn;
        action_btn.layer.cornerRadius=4;
        action_btn.clipsToBounds=YES;
        action_btn.titleLabel.font = FONT(12);
        action_btn.tag = 100 + i;
        action_btn.layer.borderWidth=1;
        [action_btn setTitleColor:Orange_COLOR forState:UIControlStateSelected];
        [action_btn setTitleColor:HEX(@"999999", 1.0) forState:UIControlStateNormal];
        [action_btn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        action_btn.hidden = YES;
    }
}

#pragma mark ====== Functions =======
-(void)reloadViewWith:(id)model{
    _model = model;
    /*
     action = "money_direction";
     enable = 1;
     highlight = 0;
     title = "\U94b1\U6b3e\U53bb\U5411";
     is_pay_button:1
     */
    Ivar order_status_var = class_getInstanceVariable([model class], "_order_button");
    NSArray *order_status_arr = (NSArray *)object_getIvar(model, order_status_var);
    // 剩余支付时间
    Ivar limit_time_var = class_getInstanceVariable([model class], "_limit_time");
    NSString *limit_time = (NSString *)object_getIvar(model, limit_time_var);
    
    Ivar limit_time_str_var = class_getInstanceVariable([model class], "_limit_time_str");
    NSString *limit_time_str = (NSString *)object_getIvar(model, limit_time_str_var);
    self.pay_left_time = [limit_time integerValue];
    
    for (NSInteger i=0; i<4; i++) {
        
        UIButton *btn = [self viewWithTag:100 + i];
        
        if (i < order_status_arr.count) {
            
            NSDictionary *dic = order_status_arr[order_status_arr.count - 1 - i];
            btn.hidden = NO;
            BOOL highlight = [dic[@"highlight"] boolValue];
            BOOL enable = [dic[@"enable"] boolValue];
            btn.selected = highlight && enable;
            btn.userInteractionEnabled = enable;
            
            btn.layer.borderColor = highlight ? Orange_COLOR.CGColor : HEX(@"999999", 1.0).CGColor;
            if ([dic[@"is_pay_button"] boolValue] && [limit_time integerValue] > 0) {
                self.pay_btn = btn;
                
                self.normal_pay_title = dic[@"title"];
                NSString *str = limit_time_str.length == 0 ? dic[@"title"] : [NSString stringWithFormat:@"%@(%@)",dic[@"title"],limit_time_str];
                CGFloat width = getSize(str, 25, 12).width + 10;
                [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(width);
                }];
                [btn setTitle:str forState:UIControlStateNormal];
            }else{
                [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
                [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(_btnMasRect.width_margin);
                }];
            }
        }else{
            btn.hidden = YES;
        }
        
    }
    
}

-(void)clickActionBtn:(UIButton *)btn{
    
    Ivar order_id_var = class_getInstanceVariable([self.model class], "_order_id");
    NSString *order_id = (NSString *)object_getIvar(self.model, order_id_var);
    
    Ivar tuikuan_url_var = class_getInstanceVariable([self.model class], "_tuikuan_url");
    NSString *tuikuan_url = (NSString *)object_getIvar(self.model, tuikuan_url_var);
    
    Ivar amount_var = class_getInstanceVariable([self.model class], "_amount");
    NSString *amount = (NSString *)object_getIvar(self.model, amount_var);
    
    Ivar ticket_url_var = class_getInstanceVariable([self.model class], "_ticket_url");
    NSString *ticket_url = (NSString *)object_getIvar(self.model, ticket_url_var);
    
    Ivar pei_type_var = class_getInstanceVariable([self.model class], "_pei_type");
    NSString *pei_type = (NSString *)object_getIvar(self.model, pei_type_var);
    
    Ivar order_status_var = class_getInstanceVariable([self.model class], "_order_button");
    NSArray *order_status = (NSArray *)object_getIvar(self.model, order_status_var);
    
    NSInteger index = btn.tag - 100;
    NSDictionary *dic = order_status[order_status.count - 1 - index];
    
    NSString *action_name = dic[@"action"];
    if ([action_name length] == 0) return;
    
    if ([action_name isEqualToString:@"money_direction"]) {     // 钱款去向
        if (RespondsSelector(self.delegate, @selector(moneyDirectionWithOrder_id:tuikuan_url:))) {
            [self.delegate moneyDirectionWithOrder_id:order_id tuikuan_url:tuikuan_url];
        }
    }else if ([action_name isEqualToString:@"cancel_order"]) {  // 取消订单
        if (RespondsSelector(self.delegate, @selector(cancleOrderWithOrder_id:))) {
            [self.delegate cancleOrderWithOrder_id:order_id];
        }
    }else if ([action_name isEqualToString:@"refund_order"]) {  // 退款
        if (RespondsSelector(self.delegate, @selector(refundOrderWithOrder_id:))) {
            [self.delegate refundOrderWithOrder_id:order_id];
        }
    }else if ([action_name isEqualToString:@"pay_order"]) {     // 去支付
        if (RespondsSelector(self.delegate, @selector(payOrderWithOrder_id:amount:))) {
            [self.delegate payOrderWithOrder_id:order_id amount:amount];
        }
    }else if ([action_name isEqualToString:@"view_code"]) {     // 查看券码
        if (RespondsSelector(self.delegate, @selector(viewCodeWithOrder_id:ticket_url:))) {
            [self.delegate viewCodeWithOrder_id:order_id ticket_url:ticket_url];
        }
    }else if ([action_name isEqualToString:@"comment_order"]) { // 去评价
        if (RespondsSelector(self.delegate, @selector(commentOrderWithOrder_id:))) {
            [self.delegate commentOrderWithOrder_id:order_id];
        }
    }else if ([action_name isEqualToString:@"again_order"]) {   // 再来一单
        if (RespondsSelector(self.delegate, @selector(againOrderWithOrder:))) {
            [self.delegate againOrderWithOrder:self.model];
        }
    }else if ([action_name isEqualToString:@"cui_order"]) {     // 催单
        if (RespondsSelector(self.delegate, @selector(cuiOrderWithOrder_id:))) {
            [self.delegate cuiOrderWithOrder_id:order_id];
        }
    }else if ([action_name isEqualToString:@"confirm_order"]) { // 确认送达
        if (RespondsSelector(self.delegate, @selector(confirmOrderWithOrder_id:))) {
            [self.delegate confirmOrderWithOrder_id:order_id];
        }
    }else if ([action_name isEqualToString:@"view_comment"]) {  // 查看评价
        if (RespondsSelector(self.delegate, @selector(viewCommentWithOrder_id:pei_type:))) {
            [self.delegate viewCommentWithOrder_id:order_id pei_type:pei_type];
        }
    }
    
}

#pragma mark ====== 支付倒计时处理 =======
-(void)setPay_left_time:(NSInteger)pay_left_time{
    _pay_left_time = pay_left_time;
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
        Ivar order_id_var = class_getInstanceVariable([self.model class], "_order_id");
        NSString *order_id = (NSString *)object_getIvar(self.model, order_id_var);
        if (RespondsSelector(self.delegate, @selector(cancleOrderWithOrder_id:))) {
            [self.delegate cancleOrderWithOrder_id:order_id];
        }
    }
    NSString *str = @"";
    if (_pay_left_time > 0) {
        NSInteger mint = _pay_left_time / 60;
        NSInteger sec = _pay_left_time % 60;
        if (mint == 0 ) {
            str = [NSString stringWithFormat: NSLocalizedString(@"剩余%02ld秒", NSStringFromClass([self class])),sec];
        }else{
            str = [NSString stringWithFormat: NSLocalizedString(@"剩余%02ld分%02ld秒", NSStringFromClass([self class])),mint,sec];
        }
        
        NSString *title = [NSString stringWithFormat:@"%@(%@)",_normal_pay_title ,str];
        [self.pay_btn setTitle:title forState:UIControlStateNormal];
        
    }else{
        [self.pay_btn setTitle:_normal_pay_title forState:UIControlStateNormal];
        [self.pay_btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(_btnMasRect.width_margin);
        }];
    }
    
}

-(void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end

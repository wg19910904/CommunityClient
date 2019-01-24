//
//  JHYouHuiOrderMainVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/4/7.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHYouHuiOrderMainVC.h"
 
#import "JHWMPayOrderVC.h"
#import "NSObject+CGSize.h"
#import "UILabel+SuitableHeight.h"
#import "JHYouHuiMaiDanCell.h"
#import "JHLoginVC.h"
#import "JHYouHuiJuanModel.h"
#import "JHCreateOrderSheetView.h"
#import "JHYouHuiJuanDetailModel.h"
@interface JHYouHuiOrderMainVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JHCreateOrderSheetViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UITextField *totalPriceField;//消费总额
@property(nonatomic,strong)UILabel *youhui_Label;
@property(nonatomic,strong)UILabel *finalLabel;
@property(nonatomic,strong)UIControl *maskView;
@property(nonatomic,strong)UITextField *no_youhuiField;
@property(nonatomic,strong)UIButton *no_youhuiBtn;
@property(nonatomic,strong)UILabel *youhuiLabel;
//----记录用户输入的金额,不参与优惠的金额,优惠的金额及需要支付的金额
@property(nonatomic,assign)CGFloat inputAmount;
@property(nonatomic,assign)CGFloat no_youhui_amount;
@property(nonatomic,assign)CGFloat youhuiAmount;
@property(nonatomic,assign)CGFloat lastAmount;
@property(nonatomic,strong)UIButton *youhuijuan_Btn;
@property(nonatomic,strong)JHYouHuiJuanModel *model;
@property(nonatomic,strong)NSMutableArray *youhuiJuanArr;
@property(nonatomic,strong)JHCreateOrderSheetView *youHuiJuanSheet;//选择红包的view
@property(nonatomic,copy)NSString *coupon_id;
@property(nonatomic,assign)BOOL isFirst;


@end

@implementation JHYouHuiOrderMainVC
{
    //存储优惠info
    NSDictionary *youhuiInfo;
    //error
    NSInteger error_code;
    NSTimer *timer;
    NSInteger jishu;
 
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _youhuiJuanArr =@[].mutableCopy;
//    _coupon_id = @"";
    _isFirst = YES;
    jishu = 0;
    self.navigationItem.title = _titleString;
    self.view.backgroundColor = HEX(@"f7f9fa", 1.0f);
    [self createMainTableView];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_totalPriceField];
    //请求优惠数据
    [self getYouhuiInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardMiss:) name:UIKeyboardWillHideNotification object:nil];

    dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
    
    // 串行队列中执行异步任务
    dispatch_async(queue, ^{
        timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(doAnything) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

        [[NSRunLoop currentRunLoop] run];

    });
    
}
-(void)doAnything{
    jishu++;
    if (jishu == 6) {
        [self getYouHuiJuan];
    }
}
#pragma mark - 初始化主表视图,刷新表视图
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT -NAVI_HEIGHT) style:(UITableViewStyleGrouped)];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - 获取优惠信息
- (void)getYouhuiInfo
{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/shop/youhui/rule"
               withParams:@{@"shop_id":_shop_id}
                  success:^(id json) { 
                      NSLog(@"client/shop/youhui/rule---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          //更新ui
                          youhuiInfo = json[@"data"];
//                          youhuiType = json[@"type"]; // 1 为折扣, 0 为满减
                          [self performSelectorInBackground:@selector(updataYouhuiInfo) withObject:nil];
                      }else{
                          [self showALertWithMsg:json[@"message"]];
 
                      }
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                      [self showALertWithMsg:NSLocalizedString(@"网络异常", nil)];
                  }];
}
#pragma mark - 更新ui信息
- (void)updataYouhuiInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _youhuiLabel.text = youhuiInfo[@"title"];
        [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                              withRowAnimation:(UITableViewRowAnimationNone)];
    });
}
#pragma mark - 请求优惠劵的接口
-(void)getYouHuiJuan{
    NSLog(@"getYouHuiJuan");
//    SHOW_HUD
    NSDictionary *dic =@{@"shop_id":_shop_id,@"amount":[NSString stringWithFormat:@"%lf",_inputAmount >0?_inputAmount:0],@"unyouhui":[NSString stringWithFormat:@"%lf",_no_youhui_amount>0?_no_youhui_amount:0 ] ,@"coupon_id":_coupon_id.length>0?_coupon_id:@"0"};
    
    [HttpTool postWithAPI:@"client/shop/youhui/preinfo" withParams:dic success:^(id json) {
//        HIDE_HUD
        NSLog(@"%@",json);
        if(json[@"error"]){
            
                _model = [JHYouHuiJuanModel mj_objectWithKeyValues:json[@"data"]];
//            if (_isFirst) {
                self.coupon_id = _model.coupon[@"coupon_id"];
                [_mainTableView reloadSections:[[NSIndexSet alloc]initWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
//                _isFirst = NO;
//            }
          
            [self handleLastAmount];
            
        }else{
            [self showALertWithMsg:json[@"message"]];
        }
        
    } failure:^(NSError *error) {
//        HIDE_HUD
        
        [self showALertWithMsg:NSLocalizedString(@"网络异常", nil)];
    }];
    
}
//#pragma mark - 请求优惠劵的接口
//-(void)getYouHuiJuan1{
//    NSLog(@"getYouHuiJuan");
//    SHOW_HUD
//    [HttpTool postWithAPI:@"client/shop/youhui/preinfo" withParams:@{@"shop_id":_shop_id,@"amount":@"123",@"unyouhui":@"",@"coupon_id":_coupon_id} success:^(id json) {
//        HIDE_HUD
//        NSLog(@"%@",json);
//        if(json[@"error"]){
//            _model = [JHYouHuiJuanModel mj_objectWithKeyValues:json[@"data"]];
//
//
//        }else{
//            [self showALertWithMsg:json[@"message"]];
//        }
//
//    } failure:^(NSError *error) {
//        HIDE_HUD
//
//        [self showALertWithMsg:NSLocalizedString(@"网络异常", nil)];
//    }];
//
//}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0.01;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        case 1:
            return [JHYouHuiMaiDanCell getHeight:youhuiInfo[@"title"]];
            break;
        case 2:
            return 40;
            break;
        case 3:
            return 100;
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = HEX(@"f7f9fa", 1.0f);
            if (!_totalPriceField) {
                _totalPriceField = [[UITextField alloc]initWithFrame:FRAME(10, 10, WIDTH-20, 50)];
                _totalPriceField.layer.cornerRadius = 3;
                _totalPriceField.layer.masksToBounds = YES;
                _totalPriceField.layer.borderWidth = 0.7;
                _totalPriceField.layer.borderColor = LINE_COLOR.CGColor;
                _totalPriceField.textAlignment = NSTextAlignmentRight;
                _totalPriceField.textColor = RED_COLOR;
                _totalPriceField.font = FONT(30);
                //添加左侧消费金额提醒
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 100, 50)];
                titleLabel.text = NSLocalizedString(@"消费金额:", nil);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.font = FONT(18);
                titleLabel.textAlignment = NSTextAlignmentCenter;
                _totalPriceField.leftViewMode = UITextFieldViewModeAlways;
                _totalPriceField.leftView = titleLabel;
                _totalPriceField.backgroundColor = [UIColor whiteColor];
                _totalPriceField.rightViewMode = UITextFieldViewModeAlways;
                _totalPriceField.rightView = [[UIView alloc]initWithFrame:FRAME(0, 0, 10, 50)];
                _totalPriceField.keyboardType = UIKeyboardTypeDecimalPad;
                _totalPriceField.delegate = self;
                
            }
            [cell addSubview:_totalPriceField];
            if (_no_youhui_amount == 0.0) {
                //添加不享受优惠金额按钮
                _no_youhuiBtn = [[UIButton alloc] initWithFrame:FRAME(10, 60, WIDTH - 20, 40)];
                UIImageView *leftIV = [[UIImageView alloc]initWithFrame:FRAME(0, 12.5, 15, 15)];
                leftIV.image = IMAGE(@"youhuiAdd");
                [_no_youhuiBtn addSubview:leftIV];
                [_no_youhuiBtn setTitle:NSLocalizedString(@"输入不享受优惠金额", nil) forState:(UIControlStateNormal)];
                //设置按钮的文字对齐
                [_no_youhuiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -WIDTH+50+9*20, 0, 0)];
                [_no_youhuiBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
                [_no_youhuiBtn addTarget:self action:@selector(createMaskView) forControlEvents:(UIControlEventTouchUpInside)];
                [cell addSubview:_no_youhuiBtn];

            }else{
                //显示不享受金额
                UILabel *show_no_youhui = [[UILabel alloc]initWithFrame:FRAME(10, 60, WIDTH - 20, 40)];
                show_no_youhui.font = FONT(15);
                show_no_youhui.userInteractionEnabled = YES;
                show_no_youhui.textColor = HEX(@"666666", 1.0f);
                NSString *textString1 = [NSString stringWithFormat:NSLocalizedString(@"不享受优惠金额:¥%g  修改", nil),_no_youhui_amount];
                NSInteger stringLen = textString1.length;
                //富文本
                NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:textString1];
                
                [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                                       value:THEME_COLOR
                                       range:NSMakeRange(stringLen - 3, 3)];
                show_no_youhui.attributedText = AttributedStr1;
                
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createMaskView)];
                [show_no_youhui addGestureRecognizer:gesture];
                [cell addSubview:show_no_youhui];

            }
            //添加下边线
            CALayer *lineLayer = [[CALayer alloc]init];
            lineLayer.frame = FRAME(0, 99.5, WIDTH, 0.5);
            lineLayer.backgroundColor = LINE_COLOR.CGColor;
            [cell.layer addSublayer:lineLayer];
            return cell;
        }
            break;
        case 1:
        {
            JHYouHuiMaiDanCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHYouHuiMaiDanCell"];
            if (!cell) {
                cell = [[JHYouHuiMaiDanCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                 reuseIdentifier:@"JHYouHuiMaiDanCell"];
            }
            if (youhuiInfo[@"title"] && [youhuiInfo[@"title"] length] > 0) {
#warning 没有写入数据成功
                cell.dataDic = youhuiInfo;
            }
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = HEX(@"f7f9fa", 1.0f);
//            if (!_youhuijuan_Btn) {
                UILabel *lab = [[UILabel alloc]init];
                [cell addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset = 5;
                make.left.offset =10;
                make.bottom.offset = -5;
                make.width.offset = 60;
            }];
                lab.text = NSLocalizedString(@"优惠劵", @"");
                lab.font = FONT(14);
                lab.textColor = TEXT_COLOR;
                
                _youhuijuan_Btn  =[[UIButton alloc]init];
                [cell addSubview:_youhuijuan_Btn];
            [_youhuijuan_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset = 5;
                make.right.offset = -10;
                make.bottom.offset = -5;
                make.width.offset = 200;
            }];
                [_youhuijuan_Btn.titleLabel sizeToFit];
                [_youhuijuan_Btn setTitleColor:[UIColor redColor] forState:0];
                [_youhuijuan_Btn setTitle:NSLocalizedString(@"暂无可用优惠劵", nil) forState:0];
                [_youhuijuan_Btn addTarget:self action:@selector(selectYouhuijunClick:) forControlEvents:UIControlEventTouchUpInside];
            _youhuijuan_Btn.titleLabel.font = FONT(14);
            if (![_model.coupon isKindOfClass:[NSNull class]] && _model.coupon != nil) {
                [_youhuijuan_Btn setTitle:_model.coupon[@"deduct_lable"] forState:0];
            }
            _youhuijuan_Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            return cell;
            
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!_finalLabel) {
                _finalLabel = [[UILabel alloc]initWithFrame:FRAME(0, 10, WIDTH, 50)];
                _finalLabel.font = FONT(18);
                _finalLabel.textColor = SPECIAL_COLOR;
                _finalLabel.textAlignment = NSTextAlignmentCenter;
            }
            [cell addSubview:_finalLabel];
            //添加按钮
            UIButton *sureBtn = [[UIButton alloc]initWithFrame:FRAME(10, 60, WIDTH - 20, 40)];
            [sureBtn setBackgroundColor:THEME_COLOR forState:(UIControlStateNormal)];
            [sureBtn setBackgroundColor:HEX(@"499581", 1.0f) forState:(UIControlStateHighlighted)];
            [sureBtn setTitle:NSLocalizedString(@"确认买单", nil) forState:(UIControlStateNormal)];
            [sureBtn addTarget:self action:@selector(clickOrderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            sureBtn.layer.cornerRadius = 3;
            sureBtn.layer.masksToBounds = YES;
            
            [cell addSubview:sureBtn];
            return cell;
        }
            break;
            
        default:
            return [UITableViewCell new];
            break;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [_totalPriceField resignFirstResponder];
    }
}
#pragma mark - textField 内容改变
- (void)textFieldChanged:(NSNotification *)noti
{
    if (noti.object == _no_youhuiField) {
        return;
    }
    NSString *contentString = _totalPriceField.text;
    NSString *regex = @".*[0-9].*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([contentString containsString:@"¥"] && ![predicate evaluateWithObject:contentString]) {
        //去掉¥
        contentString = @"";
        _totalPriceField.text = contentString;
        //输入的金额
        self.inputAmount = 0.0;
        NSLog(@"%f",_inputAmount);
    }else if (![contentString containsString:@"¥"] && [predicate evaluateWithObject:contentString]){
        //加¥
        contentString = [@"¥" stringByAppendingString:contentString];
        _totalPriceField.text = contentString;
        
        self.inputAmount = [[contentString substringFromIndex:1] floatValue];
        NSLog(@"%f",_inputAmount);

    }else if ([contentString containsString:@"¥"] && [predicate evaluateWithObject:contentString]){
        self.inputAmount = [[contentString substringFromIndex:1] floatValue];
        NSLog(@"%f",_inputAmount);
        
    }
      _finalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"实际支付:¥ %@", nil),@"******"];
    jishu =0;
//    [self getYouHuiJuan];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//      [self getYouHuiJuan];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_totalPriceField resignFirstResponder];

}

#pragma mark - 创建蒙版
- (void)createMaskView
{
    [_totalPriceField resignFirstResponder];
    if (_inputAmount == 0) {
        [self showALertWithMsg:NSLocalizedString(@"请先进店消费", nil)];
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    _maskView = [[UIControl alloc]initWithFrame:window.frame];
    _maskView.backgroundColor = HEX(@"000000", 0.3);
    [_maskView addTarget:self action:@selector(tap_maskView) forControlEvents:(UIControlEventTouchUpInside)];
    //添加view
    UIView *centerView = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH - 60, 120)];
    centerView.layer.cornerRadius = 4;
    centerView.layer.masksToBounds = YES;
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.center = CGPointMake(_maskView.center.x, _maskView.center.y - 30);
    //添加title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:FRAME(0, 5, WIDTH - 60,25)];
    titleLabel.text = NSLocalizedString(@"请输入不享受金额", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT(18);
    titleLabel.textColor = HEX(@"666666", 1.0f);
    [centerView addSubview:titleLabel];
    //添加输入框
    _no_youhuiField = [[UITextField alloc]initWithFrame:FRAME(30, 45, WIDTH - 120, 25)];
    _no_youhuiField.placeholder = NSLocalizedString(@"请与服务员确认", nil);
    _no_youhuiField.textAlignment = NSTextAlignmentCenter;
    _no_youhuiField.textColor = RED_COLOR;
    _no_youhuiField.font = FONT(20);
    _no_youhuiField.keyboardType = UIKeyboardTypeNumberPad;
    //添加下划线
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.frame = FRAME(0, 24.3, WIDTH - 120, 0.7);
    lineLayer.backgroundColor = LINE_COLOR.CGColor;
    [_no_youhuiField.layer addSublayer:lineLayer];
    //添加按钮
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:FRAME(0, 0, 70, 30)];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = FONT(20);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [cancelBtn setBackgroundColor:HEX(@"dcdcdc", 1.0f) forState:(UIControlStateNormal)];
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    cancelBtn.center = CGPointMake(WIDTH/4 - 60/4, 95);
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:FRAME(0, 0, 70, 30)];
    [sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font = FONT(20);
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sureBtn setBackgroundColor:RED_COLOR forState:(UIControlStateNormal)];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(clickSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    sureBtn.center = CGPointMake(WIDTH * 3/4 - 60 * 3/4, 95);
    [centerView addSubview:titleLabel];
    [centerView addSubview:_no_youhuiField];
    [centerView addSubview:cancelBtn];
    [centerView addSubview:sureBtn];
    [_maskView addSubview:centerView];
    [window addSubview:_maskView];
}
#pragma mark - 点击优惠说明按钮
- (void)clickExplain:(UIButton *)sender
{
    NSLog(@"点击了优惠说明按钮");
}
-(void)keyboardMiss:(NSNotification *)noti{


}
#pragma mark - 点击了蒙版中得取消按钮
- (void)clickCancelBtn:(UIButton *)sender
{
    NSLog(@"点击了蒙版得取消按钮");
    [self tap_maskView];
    [self getYouHuiJuan];
}
#pragma mark - 点击选着优惠劵按钮
-(void)selectYouhuijunClick:(UIButton *)sender{
    [_totalPriceField resignFirstResponder];
    if (!(self.model.coupons.count > 0)) {
        return;
    }
    self.youHuiJuanSheet.dataSource = self.model.coupons;
    self.youHuiJuanSheet.coupon_id = self.coupon_id;
    [self.youHuiJuanSheet sheetShow];
    
}
#pragma mark - 点击了蒙版中的确定按钮
- (void)clickSureBtn:(UIButton *)sender
{
    NSLog(@"点击了蒙版的确定按钮");
    NSString *no_youhui = [_no_youhuiField.text isEqualToString:NSLocalizedString(@"请与服务员确认", nil)] ? @"" : _no_youhuiField.text;
    //不享受优惠的金额
    _no_youhui_amount = [no_youhui floatValue];
    [_mainTableView reloadData];
    [self tap_maskView];
    
    [self getYouHuiJuan];
}
#pragma mark - 点击了蒙版
- (void)tap_maskView
{
    [_maskView removeFromSuperview];
    _maskView = nil;
}
#pragma mark - 处理显示实际支付数目并展示
- (void)handleLastAmount
{

//    NSString *type = youhuiInfo[@"type"];
//    if ([type isEqualToString:@"0"]) {  //满减
//        NSArray *youhuiArray  = youhuiInfo[@"youhuis"];
//        if (youhuiArray.count == 0) {
//
//            _youhuiAmount = 0;
//            return;
//        }else{
//            CGFloat last_youhui = 0;
//            for (NSDictionary *dic in youhuiArray) {
//                CGFloat man = [dic[@"m"] floatValue];
//                CGFloat jian = [dic[@"d"] floatValue];
//                if ((_inputAmount - _no_youhui_amount) >= man) {
//
//                    NSInteger time = (_inputAmount - _no_youhui_amount) / man;
//
//                    last_youhui = MAX(last_youhui, time * jian);
//                }
//            }
//            if ( [youhuiInfo[@"max_youhui"] floatValue] > 0) {
//                _youhuiAmount = MIN(last_youhui, [youhuiInfo[@"max_youhui"] floatValue]);
//
//            }else{
//                _youhuiAmount = last_youhui;
//
//            }
//        }
//
//    }else if ([type isEqualToString:@"1"]){ //折扣
//
//        CGFloat  discount = (100 -[youhuiInfo[@"discount"] doubleValue])/100.0; //百进制
//        if ([youhuiInfo[@"max_youhui"] floatValue] >  0) {
//           _youhuiAmount = MIN((_inputAmount - _no_youhui_amount) * discount, [youhuiInfo[@"max_youhui"] floatValue]);
//        }else{
//            _youhuiAmount = (_inputAmount - _no_youhui_amount) * discount;
//        }
//    }
//    NSLog(@"_inputAmount:%f>>>>>>>>>>_youhuiAmount:%f",_inputAmount,_youhuiAmount);
//    if (_inputAmount <= _no_youhui_amount) {
//        _finalLabel.text = NSLocalizedString(@"消费金额小于不享受优惠金额!", nil);
//    }else{
//        _finalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"实际支付:¥ %@", nil),_model.need_pay];
//    }
    _finalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"实际支付:¥ %@", nil),_model.need_pay.length>0?_model.need_pay:@"0"];

}
#pragma mark - 点击了去下单按钮
- (void)clickOrderBtn:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    
    if (_inputAmount == 0.0) {
        [self showALertWithMsg:NSLocalizedString(@"请先进店消费", nil)];
        return;
    }
    if (_inputAmount <= _no_youhui_amount) {
        [self showALertWithMsg:NSLocalizedString(@"消费金额小于不享受优惠金额!", nil)];
        return;
    }
    
    SHOW_HUD
    //参数字典
    NSDictionary *paramsDic = @{@"shop_id":_shop_id,
                                @"amount":@(_inputAmount),
                                @"unyouhui":@(_no_youhui_amount),
                                @"coupon_id":_coupon_id,
                                };
    [HttpTool postWithAPI:@"client/shop/youhui/order"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/shop/youhui/order---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          //跳转到支付界面

                          JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
                          vc.order_id = json[@"data"][@"order_id"];
                          vc.amount = json[@"data"][@"money"];
                          vc.isHui = YES;
                          [self.navigationController pushViewController:vc animated:YES];
                      }else{
                          error_code = 101;
                          [self showALertWithMsg:json[@"message"]];
                      }
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
}
#pragma mark - 显示提醒内容
- (void)showALertWithMsg:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *clickAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (error_code == 101) { //没有登录,去登录
            JHLoginVC *vc = [JHLoginVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [alertController addAction:clickAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark ====== JHCreateOrderSheetViewDelegate =======
-(void)sheetView:(JHCreateOrderSheetView *)sheetView clickIndex:(NSInteger)index choosedValue:(NSString *)str{
   
    if (sheetView == _youHuiJuanSheet){

            NSMutableDictionary *dic = self.model.coupons[index];
            [self.youhuijuan_Btn setTitle:dic[@"deduct_lable"] forState:0];
            self.coupon_id = dic[@"coupon_id"];
        
            [self getYouHuiJuan];

    }
}
-(JHCreateOrderSheetView *)youHuiJuanSheet{
    if (_youHuiJuanSheet==nil) {
        _youHuiJuanSheet=[[JHCreateOrderSheetView alloc] initWithTitle:NSLocalizedString(@"选择优惠劵", @"JHWMCreateOrderVC") amount:@"" delegate:self sheetViewType:SheetViewChooseYouHui dataSource:self.model.coupons];
    }
    return _youHuiJuanSheet;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer =nil;
}
@end

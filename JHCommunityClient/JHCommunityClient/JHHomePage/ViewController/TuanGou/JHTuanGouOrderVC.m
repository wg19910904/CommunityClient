//
//  JHTuanGouOrderVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/4/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouOrderVC.h"
 
#import "JHWMPayOrderVC.h"
#import "JHShareModel.h"
#import "JHChangePhoneVC.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHCreateOrderSheetView.h"
@interface JHTuanGouOrderVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JHCreateOrderSheetViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UITextField *numField;
@property(nonatomic,strong)UILabel *totalPriceLabel;
@property(nonatomic,strong)UILabel *finalPriceLabel;
@property(nonatomic,strong)UILabel *hongbao_amountLabel;
@property(nonatomic,assign)CGFloat price;
@property(nonatomic,assign)CGFloat finalPrice;
@property(nonatomic,strong)JHCreateOrderSheetView *hongBaoSheet;
@property(nonatomic,strong)JHCreateOrderSheetView *couponSheet;
@property(nonatomic,strong)NSArray *hongbaoArr;
@property(nonatomic,copy)NSString *hongbao_id;
@property(nonatomic,copy)NSString *hongbao_amount;
@property(nonatomic,strong)NSArray *couponArr;
@property(nonatomic,copy)NSString *coupon_amount;
@property(nonatomic,copy)NSString *coupon_id;
@property(nonatomic,assign)int num;
@property(nonatomic,assign)BOOL is_first;
@end

@implementation JHTuanGouOrderVC
{
    UILabel * mobile_label;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"提交订单", nil);

    _is_first = YES;

    self.view.backgroundColor = BACKGROUND_COLOR;
    _price = [_cellModel.price floatValue];
    _finalPrice = _price;
//    self.hongbao_amount = @"0";
    self.hongbao_id = @"0";
    self.hongbaoArr = @[];
    
    [self createMainTableView];
    _num =[_cellModel.min_buy intValue];
    [self getHongBaoArr:_num];
    
}

#pragma mark - 初始化主表视图,刷新表视图
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, (NAVI_HEIGHT+10), WIDTH, HEIGHT -(NAVI_HEIGHT+10))
                                                      style:(UITableViewStyleGrouped)];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section==0) ? 0.01 : 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    (section == 0)?({}):({
    
        view = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 10)];
        view.backgroundColor = BACKGROUND_COLOR;
    });
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 1) {
        return 54;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(15, 0, WIDTH - 110, 44)];
                    titleLabel.text = _cellModel.title;
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"666666", 1.0f);
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 95, 0, 80, 44)];
                    priceLabel.textColor = HEX(@"666666", 1.0f);
                    priceLabel.text = [NSString stringWithFormat:@"¥%g",[_cellModel.price floatValue]];
                    priceLabel.font = FONT(15);
                    priceLabel.textAlignment = NSTextAlignmentRight;
                    [priceLabel adjustsFontSizeToFitWidth];
                    [cell addSubview:titleLabel];
                    [cell addSubview:priceLabel];
                    //添加上line
                    CALayer *linelayer1 = [[CALayer alloc] init];
                    linelayer1.frame = FRAME(0, 0, WIDTH, 0.5);
                    linelayer1.backgroundColor = LINE_COLOR.CGColor;
                    [cell.layer addSublayer:linelayer1];

                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(15, 0, 60, 44)];
                    titleLabel.text = NSLocalizedString(@"数量:", nil);
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"666666", 1.0f);
                    
                    if(!_numField){
                        _numField = [[UITextField alloc] initWithFrame:FRAME(WIDTH - 90,0,85, 44)];
                        //添加左按钮
                        UIButton *subtractBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 44)];
                        [subtractBtn setImage:IMAGE(@"jian") forState:(UIControlStateNormal)];
                        [subtractBtn  setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12, 5)];
                        [subtractBtn addTarget:self action:@selector(clickSubstractBtn:)
                              forControlEvents:(UIControlEventTouchUpInside)];
                        _numField.leftViewMode = UITextFieldViewModeAlways;
                        _numField.leftView = subtractBtn;
                        _numField.text = _cellModel.min_buy;
                        _numField.keyboardType = UIKeyboardTypeNumberPad;
                        //添加右侧按钮
                        UIButton *addBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 44)];
                        [addBtn setImage:IMAGE(@"jiahao") forState:(UIControlStateNormal)];
                        [addBtn  setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12, 5)];
                        [addBtn addTarget:self action:@selector(clickAddBtn:)
                              forControlEvents:(UIControlEventTouchUpInside)];
                        _numField.rightViewMode = UITextFieldViewModeAlways;
                        _numField.rightView = addBtn;
                        
                        _numField.font = FONT(14);
                        _numField.textAlignment = NSTextAlignmentCenter;
                        _numField.textColor = HEX(@"333333", 1.0f);
                        _numField.delegate = self;
                    }

                    [cell addSubview:titleLabel];
                    [cell addSubview:_numField];
                    CALayer *linelayer1 = [[CALayer alloc] init];
                    linelayer1.frame = FRAME(0, 0, WIDTH, 0.5);
                    linelayer1.backgroundColor = LINE_COLOR.CGColor;
                    [cell.layer addSublayer:linelayer1];
                    return cell;
 
                }
                    break;
 
                case 2:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 11.5, 15, 15)];
                    iconImg.image = IMAGE(@"name");
                    [cell.contentView addSubview:iconImg];
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 13, 80, 12)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"666666", 1.0f);
                    titleLabel.text = NSLocalizedString(@"优惠劵抵扣", nil);

                    [cell.contentView addSubview:titleLabel];
                    
                    UILabel *amountLab = [UILabel new];
                    [cell.contentView addSubview:amountLab];
                    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.offset=0;
                        make.centerY.offset=0;
                        make.height.offset=20;
                    }];
                    amountLab.font = FONT(14);
                    amountLab.textColor = HEX(@"f85357", 1.0f);
                    amountLab.textAlignment = NSTextAlignmentRight;
                     cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    if(self.couponArr.count == 0){
//                        amountLab.text =  NSLocalizedString(@"暂无可用优惠劵", NSStringFromClass([self class]));
//                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    }else{
//                        if([self.coupon_amount floatValue] == 0){
//                            amountLab.text =  NSLocalizedString(@"未选择优惠劵", NSStringFromClass([self class]));
//                        }else{
                            amountLab.text = [NSString stringWithFormat:@"%@",self.coupon_amount];
//                        }
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                    }
                    
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    CALayer *linelayer1 = [[CALayer alloc] init];
                    linelayer1.frame = FRAME(0, 0, WIDTH, 0.5);
                    linelayer1.backgroundColor = LINE_COLOR.CGColor;
                    CALayer *linelayer2 = [[CALayer alloc] init];
                    linelayer2.frame = FRAME(0, 43.5, WIDTH, 0.5);
                    linelayer2.backgroundColor = LINE_COLOR.CGColor;
                    [cell.layer addSublayer:linelayer1];
                    [cell.layer addSublayer:linelayer2];
                    return cell;
                }
                    break;
                case 3:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 11.5, 15, 15)];
                    iconImg.image = IMAGE(@"name");
                    [cell.contentView addSubview:iconImg];
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 13, 80, 12)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"666666", 1.0f);
                    titleLabel.text = NSLocalizedString(@"红包抵扣",nil);
                    [cell.contentView addSubview:titleLabel];
                    
                    UILabel *amountLab = [UILabel new];
                    [cell.contentView addSubview:amountLab];
                    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.offset=0;
                        make.centerY.offset=0;
                        make.height.offset=20;
                    }];
                    amountLab.font = FONT(14);
                    amountLab.textColor = HEX(@"f85357", 1.0f);
                    amountLab.textAlignment = NSTextAlignmentRight;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //                    if(self.hongbaoArr.count == 0){
                    //                        amountLab.text =  NSLocalizedString(@"暂无可用红包", NSStringFromClass([self class]));
                    //
                    //                    }else{
                    //                        if([self.hongbao_amount floatValue] == 0){
                    //                            amountLab.text =  NSLocalizedString(@"未选择红包", NSStringFromClass([self class]));
                    //                        }else{
                    amountLab.text = [NSString stringWithFormat:@"%@",self.hongbao_amount];
                    //                        }
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //                    }
                    
                    
                    
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    CALayer *linelayer1 = [[CALayer alloc] init];
                    linelayer1.frame = FRAME(0, 0, WIDTH, 0.5);
                    linelayer1.backgroundColor = LINE_COLOR.CGColor;
                    CALayer *linelayer2 = [[CALayer alloc] init];
                    linelayer2.frame = FRAME(0, 43.5, WIDTH, 0.5);
                    linelayer2.backgroundColor = LINE_COLOR.CGColor;
                    [cell.layer addSublayer:linelayer1];
                    [cell.layer addSublayer:linelayer2];
                    return cell;
                }
                    break;
                default:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(15, 0, 60, 44)];
                    titleLabel.text = NSLocalizedString(@"小计:", nil);
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"666666", 1.0f);
                    
                    if(!_totalPriceLabel){
                        
                        _totalPriceLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 200, 0, 185, 44)];
                        _totalPriceLabel.textColor = HEX(@"666666", 1.0f);
                        //                        _totalPriceLabel.text = [NSString stringWithFormat:@"¥%g",[_cellModel.price floatValue]*_cellModel.min_buy.integerValue];
//                        [self handleLabelStatuWithNum:_cellModel.min_buy.integerValue];
                        _totalPriceLabel.textColor = SPECIAL_COLOR;
                        _totalPriceLabel.font = FONT(15);
                        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
                        [_totalPriceLabel adjustsFontSizeToFitWidth];
                    }
                    [cell addSubview:titleLabel];
                    [cell addSubview:_totalPriceLabel];
                    CALayer *linelayer1 = [[CALayer alloc] init];
                    linelayer1.frame = FRAME(0, 0, WIDTH, 0.5);
                    linelayer1.backgroundColor = LINE_COLOR.CGColor;
                    CALayer *linelayer2 = [[CALayer alloc] init];
                    linelayer2.frame = FRAME(0, 43.5, WIDTH, 0.5);
                    linelayer2.backgroundColor = LINE_COLOR.CGColor;
                    [cell.layer addSublayer:linelayer1];
                    [cell.layer addSublayer:linelayer2];
                    return cell;
                }
                    break;
            }
        
        }
            break;
        case 1:
        {
            switch (row) {

                case 0:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(15, 0, 90, 44)];
                    titleLabel.text = NSLocalizedString(@"订单总价:", nil);
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"666666", 1.0f);
                    
                    if(!_finalPriceLabel){
                        
                        _finalPriceLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 200, 0, 185, 44)];
                        _finalPriceLabel.textColor = HEX(@"666666", 1.0f);
//                        _finalPriceLabel.text = [NSString stringWithFormat:@"¥%g",[_cellModel.price floatValue]*_cellModel.min_buy.integerValue];
//                        [self handleLabelStatuWithNum:_cellModel.min_buy.integerValue];
                        _finalPriceLabel.textColor = SPECIAL_COLOR;
                        _finalPriceLabel.font = FONT(15);
                        _finalPriceLabel.textAlignment = NSTextAlignmentRight;
                        [_finalPriceLabel adjustsFontSizeToFitWidth];
                    }
                    [cell addSubview:titleLabel];
                    [cell addSubview:_finalPriceLabel];
                    CALayer *linelayer1 = [[CALayer alloc] init];
                    linelayer1.frame = FRAME(0, 0, WIDTH, 0.5);
                    linelayer1.backgroundColor = LINE_COLOR.CGColor;
                    CALayer *linelayer2 = [[CALayer alloc] init];
                    linelayer2.frame = FRAME(0, 43.5, WIDTH, 0.5);
                    linelayer2.backgroundColor = LINE_COLOR.CGColor;
                    [cell.layer addSublayer:linelayer1];
                    [cell.layer addSublayer:linelayer2];
                    return cell;

                }
                    break;
                default:
                    return NULL;
                    break;
            }
            
        }
            break;
        case 2:
        {
            switch (row) {
                case 0:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(15, 0, 200, 44)];
                    titleLabel.text = NSLocalizedString(@"您绑定的手机号码", nil);
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"666666", 1.0f);
                
                    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 140, 0, 100, 44)];
                    phoneLabel.textColor = HEX(@"333333", 1.0f);
                    phoneLabel.font = FONT(14);
                    phoneLabel.text = [JHShareModel shareModel].phone;
                    phoneLabel.textAlignment = NSTextAlignmentRight;
                    mobile_label = phoneLabel;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell addSubview:titleLabel];
                    [cell addSubview:phoneLabel];
                    CALayer *linelayer1 = [[CALayer alloc] init];
                    linelayer1.frame = FRAME(0, 0, WIDTH, 0.5);
                    linelayer1.backgroundColor = LINE_COLOR.CGColor;
                    CALayer *linelayer2 = [[CALayer alloc] init];
                    linelayer2.frame = FRAME(0, 43.5, WIDTH, 0.5);
                    linelayer2.backgroundColor = LINE_COLOR.CGColor;
                    [cell.layer addSublayer:linelayer1];
                    [cell.layer addSublayer:linelayer2];
                    return cell;
                }
                    break;
                case 1:
                {
                 
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIButton *orderBtn = [[UIButton alloc] initWithFrame:FRAME(15, 10, WIDTH - 30, 44)];
                    [orderBtn setBackgroundColor:SPECIAL_COLOR forState:(UIControlStateNormal)];
                    [orderBtn setBackgroundColor:SPECIAL_COLOR_DOWN forState:(UIControlStateHighlighted)];
                    [orderBtn setTitle:NSLocalizedString(@"提交订单", nil) forState:(UIControlStateNormal)];
                    orderBtn.titleLabel.font = FONT(18);
                    [orderBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    [orderBtn addTarget:self action:@selector(clickOrderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    orderBtn.layer.cornerRadius = 4;
                    orderBtn.layer.masksToBounds = YES;
                    [cell addSubview:orderBtn];
                    cell.backgroundColor = BACKGROUND_COLOR;
                    return cell;
                }
                    break;
                default:
                    return NULL;
                    break;
            }
            
        }
            break;
            
        default:
            return NULL;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if(indexPath.section == 0 && indexPath.row == 3)
    {
        if (self.hongbaoArr.count == 0) {
            return;
        }
        self.hongBaoSheet.dataSource = self.hongbaoArr;
        self.hongBaoSheet.hongbao_id = self.hongbao_id;
        [self.hongBaoSheet sheetShow];
        
    }
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        if (self.couponArr.count == 0) {
            return;
        }
        self.couponSheet.dataSource = self.couponArr;
        self.couponSheet.hongbao_id = self.coupon_id;
        [self.couponSheet sheetShow];
        
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        JHChangePhoneVC * vc = [[JHChangePhoneVC alloc]init];
        vc.phone = [JHShareModel shareModel].phone;
        [vc setMyBlock:^(NSString * mobile) {
            mobile_label.text = mobile;
            [JHShareModel shareModel].phone = mobile;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 点击减号按钮
- (void)clickSubstractBtn:(UIButton *)sender
{
    NSLog(@"点击了减号按钮");
    if ([_numField.text integerValue] == _cellModel.min_buy.integerValue) {
        [self showAlertView:NSLocalizedString(@"不能低于最小购买数", nil)];
        return;
    }else{
        _numField.text = [NSString stringWithFormat:@"%ld",[_numField.text integerValue] - 1];
        _num = [_numField.text intValue];
        [self getHongBaoArr:_num];
    }
}
#pragma mark - 点击加号按钮
- (void)clickAddBtn:(UIButton *)sender
{
    NSLog(@"点击了加号按钮");
    if ([_numField.text integerValue] >= MIN([_cellModel.max_buy integerValue], [_cellModel.sale_sku integerValue])) {
        [self showAlertView:NSLocalizedString(@"已达到最大购买数", nil)];
        return;
    }else{
        _numField.text = [NSString stringWithFormat:@"%ld",[_numField.text integerValue] + 1];
         _num = [_numField.text intValue];
        [self getHongBaoArr:_num];
    }
}
#pragma mark - 点击提交订单按钮
- (void)clickOrderBtn:(UIButton *)sender
{
    SHOW_HUD
    NSLog(@"点击了提交订单按钮");
    NSDictionary *paramsDic = [self handleParamsDic];
    [HttpTool postWithAPI:@"client/tuan/order/create"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/tuan/order/create--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          //创建订单成功,跳转到支付界面
                          [self jumpToPayVC:json[@"data"]];
                          
                      }else{
                      
                          [self showAlertView:json[@"message"]];
                      }
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
    
}
#pragma mark - 处理label的状态(金额数量)
- (void)handleLabelStatuWithNum:(NSInteger )num
{
    
//    float amount = num*_price - [_hongbao_amount floatValue];
//    amount = MAX(amount, 0.01);
    _totalPriceLabel.text = [NSString stringWithFormat:@"¥%g", num*_price];
    _finalPriceLabel.text = [NSString stringWithFormat:@"¥%g", _finalPrice];
//    _finalPrice =amount;
}
#pragma mark - 文本框代理

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}
#pragma mark - 处理参数字典
- (NSDictionary *)handleParamsDic
{
    NSString *shop_id = _cellModel.shop_id;
    NSString *tuan_id = _cellModel.tuan_id;
    NSString *nums = _numField.text;
    NSString *price = _cellModel.price;
    double bd_lat;
    double bd_lon;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:[XHMapKitManager shareManager].lat
                                                 WithGD_lon:[XHMapKitManager shareManager].lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    return @{@"shop_id":shop_id,
             @"tuan_id":tuan_id,
             @"nums":nums,
             @"price":price,
             @"lng":@(bd_lon),
             @"lat":@(bd_lat),
             @"hongbao_id":_hongbao_id,
             @"coupon_id":_coupon_id,
             };
}
#pragma mark - 跳转到支付界面
- (void)jumpToPayVC:(NSDictionary *)dataDic
{

    JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
    vc.order_id = dataDic[@"order_id"];
    vc.amount = [NSString stringWithFormat:@"%g",_finalPrice];
    vc.isTuan = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showAlertView:(NSString *)title{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark ====== JHCreateOrderSheetViewDelegate =======
-(void)sheetView:(JHCreateOrderSheetView *)sheetView clickIndex:(NSInteger)index choosedValue:(NSString *)str{
    if (sheetView == _hongBaoSheet){// 选择红包的回调

            NSDictionary *dic = self.hongbaoArr[index];
            self.hongbao_id = dic[@"hongbao_id"];
            self.hongbao_amount = dic[@"deduct_lable"];

         [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    }
    if (sheetView == _couponSheet){// 选择优惠劵的回调
        
        NSDictionary *dic = self.couponArr[index];
        self.coupon_id = dic[@"coupon_id"];
        self.coupon_amount = dic[@"deduct_lable"];
        
        [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self getHongBaoArr:_num];
}

// 获取红包数组
-(void)getHongBaoArr:(int)num{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/tuan/order/preinfo" withParams:@{@"amount":@(num*_price),@"coupon_id":_coupon_id.length>0?_coupon_id:@"0",@"hongbao_id":_hongbao_id.length>0?_hongbao_id:@"0",@"shop_id":_cellModel.shop_id} success:^(NSDictionary* json) {
        NSLog(@"团购红包 =======  %@",json);
        HIDE_HUD
        if (ISPostSuccess) {
            NSDictionary *dic = json[@"data"][@"hongbao"];
            self.hongbaoArr = json[@"data"][@"hongbaos"];
            self.hongbao_id = dic[@"hongbao_id"];
            self.hongbao_amount = dic[@"deduct_lable"];
            
            NSDictionary *dic1 = json[@"data"][@"coupon"];
            self.couponArr = json[@"data"][@"coupons"];
            self.coupon_id = dic1[@"coupon_id"];
            self.coupon_amount = dic1[@"deduct_lable"];
            
            NSString *str =json[@"data"][@"need_pay"];
            _finalPrice =str.floatValue;
            [self handleLabelStatuWithNum:num];
            if (_is_first) {
                  [_mainTableView reloadData];
                _is_first = NO;
            }
          
        }else{
            [self showMsg:json[@"message"]];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error : %@",error.description);
        [self showMsg: NSLocalizedString(@"服务器繁忙,请稍后再试!", NSStringFromClass([self class]))];
    }];
}

-(JHCreateOrderSheetView *)hongBaoSheet{
    if (_hongBaoSheet==nil) {
        _hongBaoSheet=[[JHCreateOrderSheetView alloc] initWithTitle:NSLocalizedString(@"选择红包", @"JHWMCreateOrderVC") amount:@"" delegate:self sheetViewType:SheetViewChooseHongBao dataSource:self.hongbaoArr];
    }
    return _hongBaoSheet;
}
-(JHCreateOrderSheetView *)couponSheet{
    if (_couponSheet==nil) {
        _couponSheet=[[JHCreateOrderSheetView alloc] initWithTitle:NSLocalizedString(@"选择优惠劵", @"JHWMCreateOrderVC") amount:@"" delegate:self sheetViewType:SheetViewChooseYouHui dataSource:self.couponArr];
    }
    return _couponSheet;
}
@end

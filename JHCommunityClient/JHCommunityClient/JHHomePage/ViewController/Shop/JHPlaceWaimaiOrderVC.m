//
//  JHPlaceWaimaiOrderVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/4/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPlaceWaimaiOrderVC.h"
#import "JHOrderInfoModel.h"
 
#import "FirstOrderFirstCell.h"
#import "payCell.h"
#import "AddMessageVC.h"
#import "JHOrderInfoModel.h"
#import "JHWMPayOrderVC.h"
#import "DSToast.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "JHPathMapVC.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHOrderDetailViewController.h"
#import "UINavigationBar+Awesome.h"
#import "JHCreateOrderSheetView.h"
#import "WMCreateOrderModel.h"
#import "NSString+Tool.h"
#import "JHCreateOrderSheetView.h"
#import "JHWaiMaiAddressVC.h"
#import "JHWaiMaiOrderDetailVC.h"

@interface JHPlaceWaimaiOrderVC ()<UITableViewDelegate, UITableViewDataSource,JHCreateOrderSheetViewDelegate>
//按钮属性
@property(nonatomic,strong)JHCreateOrderSheetView *timeSheet;
@property(nonatomic,strong)JHCreateOrderSheetView *hongBaoSheet;
@property(nonatomic,strong)JHCreateOrderSheetView *couponSheet;
@property(nonatomic,strong)WMCreateOrderModel *shopModel;
@property(nonatomic,strong)UIButton *onlinePayBtn;
@property(nonatomic,strong)UIButton *arrivePayBtn;
@property(nonatomic,assign)NSInteger dateline;

@property(nonatomic,strong)NSString *titleString;
//店铺营业时间
@property(nonatomic,copy)NSString *yy_stime;
@property(nonatomic,copy)NSString *yy_ltime;
@property(nonatomic,copy)NSString *yy_status;
@end
@implementation JHPlaceWaimaiOrderVC
{
    //创建住主表视图
    UITableView *_mainTableView;
    
    //用于保存相应商铺的购物车数组
    NSArray *cartDataArray;
    //保存总价
    UILabel *_totalPriceLabel;
    UILabel *_youhuiLabel;
    //保存时间列表的数据
    NSMutableArray *_timeArray;
    //保存需要送的时间标签
    UILabel *_timeLabel;
    UILabel *_msgLabel;
    
    //背景蒙板
    UIControl *_backView;
    NSMutableDictionary *_tableViewData;
    //存储红包的id和地址的id  存储红包的抵扣金额 红包数目
    NSString *_hongbao_id;
    NSString *_addr_id;
    NSString *_hongbao_amount;
    NSString *_hongbao_count;
    
    NSString *_coupon_id;
    NSString *_coupon_amount;
    NSString *_coupon_count;
    
    //红包右侧信息
    UILabel *redPacketRightLabel;
    
    UILabel *couponRightLabel;
    
    //地址信息
    UILabel *contactTitleLabel;
    UILabel *addressLabel;
    
    //订单id
    NSString *_order_id;
    //计算总价时需计算的数值
    NSString *package;
    NSString *_first_amount;
    NSString *freight;
    NSString *order_youhui;
    FirstOrderFirstCell *firstCell;
    BOOL isOnlinepay;
    BOOL hideSection3;
    NSString * amountStr;
    
    //用于展示达到最大购买数量
    DSToast *toast;
    
    //自提开关
    UISwitch *ziTiS;
    //自提时间
    UILabel *zitiTime;
    //自提地址
    UILabel *zitiAddrL;
    
    //自提地点经纬度
    NSDictionary *pointDic;
    double lat;
    double lng;
    
    //是否支持自提
    BOOL have_ziti;
    
    BOOL have_online_pay;
    BOOL have_daofu;
    
    NSString *nead_pay;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACK_COLOR;
    self.fd_interactivePopDisabled = YES;
    //获取店铺的相应信息
    [self getShopInfo];
    _onlinePayBtn = [[UIButton alloc] init];
    [self getPreInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar yf_setBackgroundColor:NEW_THEME_COLOR];
}
- (void)clickBackBtn
{
    if (_isFromAgain) {
        JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
        [model removeShopCartInfoWithShop_id:_shop_id];
    }
    [super clickBackBtn];
}

#pragma mark - 获取系统保存的对应商铺的数据字典
- (void)getShopInfo
{
    //获取对应店铺的购物车数据
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    NSDictionary *shopcartDic = [model getCartInfoWithShop_id:_shop_id];
    cartDataArray = shopcartDic[@"products"];
    
}

#pragma mark - 获取订单前信息
- (void)getPreInfo
{
    SHOW_HUD
    //组建参数
    NSString *products = [self getProducts];
    NSDictionary *paramsDic = @{@"shop_id":_shop_id,
                                @"amount":@(_amount),
                                @"addr_id":_addr_id ? _addr_id : @"",
                                @"products":products
                                };
    [HttpTool postWithAPI:@"client/waimai/order/preinfo" withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/waimai/order/preinfo---%@",json);
                      _tableViewData = json[@"data"];
                      freight = _tableViewData[@"freight_stage"] ? _tableViewData[@"freight_stage"] : @"";
                      pointDic = _tableViewData[@"shopinfo"];
                      //判断是否有自提,在线支付,和到付
                      [self judgePayType:pointDic];
                      //获取总打包费
                      [self getAllPackage_price];
                      //获取红包金额
                      [self getHongBaoAmount];
                      //获取首单立减金额
                      _first_amount = _tableViewData[@"first_amount"];
                      //获取优惠金额
                      [self getYouhui:_tableViewData[@"youhui"]];
                      
                      //获取地址id
                      [self getAddressID];
                      //获取店铺信息
                      [self handleShopInfo:json[@"data"][@"shopinfo"]];
                      //创建表视图
                      [self createMainTableView];
                      [self createBottomView];
                      HIDE_HUD
                  } failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
}
#pragma mark - 刷新配送费
- (void)getFreight
{
    SHOW_HUD
    NSDictionary *paramsDic = @{@"shop_id":_shop_id,
                                @"amount":@(_amount),
                                @"addr_id":_addr_id ? _addr_id : @"",
                                @"products":[self getProducts],
                                @"hongbao_id":_hongbao_id,
                                @"coupon_id":_coupon_id
                                };
    [HttpTool postWithAPI:@"client/waimai/order/preinfo" withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/waimai/order/preinfo---%@",json);
                      _tableViewData = json[@"data"];
                      freight = _tableViewData[@"freight_stage"] ? _tableViewData[@"freight_stage"] : @"";
                      [self setTotalPrivce];
                      [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:5]]
                                            withRowAnimation:UITableViewRowAnimationNone];
                      HIDE_HUD
                  } failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
}
#pragma mark - 判断是否有自提,在线支付和到付
- (void)judgePayType:(NSDictionary *)typeDic
{
    if ([typeDic[@"is_ziti"] isEqualToString:@"1"]) {
        have_ziti = YES;
    }
    if ([typeDic[@"online_pay"] isEqualToString:@"1"]) {
        have_online_pay = YES;
        isOnlinepay = YES;
    }
    if ([typeDic[@"is_daofu"] isEqualToString:@"1"]) {
        have_daofu = YES;
    }
    if ([typeDic[@"is_daofu"] isEqualToString:@"1"] && ![typeDic[@"online_pay"] isEqualToString:@"1"]) {
        
        isOnlinepay = NO;
    }
}
#pragma mark - 获取总打包费
- (void)getAllPackage_price
{
    //获取对应店铺的购物车数据
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    package =[NSString stringWithFormat:@"%.2lf",[model getAllProductPackage_price:_shop_id]] ;//[@() stringValue];
}
#pragma 获取优惠总额
- (void)getYouhui:(NSString *)youhui
{
    double c_amount = _amount - [_first_amount doubleValue];
    NSArray *temArray = [youhui componentsSeparatedByString:@","];
    NSMutableArray *youhuiArray = [@[] mutableCopy];
    for (NSString *youhuiString in temArray) {
        NSArray *temArray1 = [youhuiString componentsSeparatedByString:@":"];
        NSDictionary *youhuiDic = @{@"man":temArray1.firstObject,
                                    @"jian":temArray1.lastObject};
        [youhuiArray addObject:youhuiDic];
    }
    CGFloat youhui_amount = 0.0;
    //循环找出对应的减免金额
    for (NSDictionary *temDic in youhuiArray) {
        NSString *man = temDic[@"man"];
        NSString *jian = temDic[@"jian"];
        if (([man floatValue] <= c_amount )&& ([jian floatValue] > youhui_amount)) {
            youhui_amount = [jian floatValue];
        }
    }
    order_youhui = [@(youhui_amount) stringValue];
    
}
#pragma mark - 获取红包金额
- (void)getHongBaoAmount
{
    //存在
    if ([[_tableViewData allKeys] containsObject:@"hongbao"] && [[_tableViewData[@"hongbao"] allKeys] containsObject:@"amount"]) {
        _hongbao_amount = _tableViewData[@"hongbao"][@"amount"];
    }else{
        _hongbao_amount = @"0.0";
    }
    _hongbao_id = _tableViewData[@"hongbao_id"] ? _tableViewData[@"hongbao_id"] : @"";
    _coupon_id = _tableViewData[@"coupon"][@"coupon_id"];
}

#pragma mark - 获取地址id
- (void)getAddressID
{
    _addr_id = _tableViewData[@"addr_id"];
}

#pragma mark - 创建表视图
- (void)createMainTableView
{
    if (!_mainTableView) {
        _mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH , HEIGHT - NAVI_HEIGHT - 49 - 10)
                         style:(UITableViewStyleGrouped)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.backgroundColor = BACK_COLOR;
        _mainTableView.separatorColor = LINE_COLOR;
        _mainTableView.separatorInset = UIEdgeInsetsZero;
        _mainTableView.layoutMargins = UIEdgeInsetsZero;
        [self.view addSubview:_mainTableView];
    }else{
    
        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:(UITableViewRowAnimationNone)];
        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:(UITableViewRowAnimationNone)];
    }
}
#pragma mark - 获取店铺信息
- (void)handleShopInfo:(NSDictionary *)shopInfo
{
   
   _shopModel = [WMCreateOrderModel shareAdvModelWithDic:shopInfo];
    
    _yy_ltime = shopInfo[@"yy_ltime"];
    _yy_stime = shopInfo[@"yy_stime"];
    _yy_status = shopInfo[@"yy_status"];
    _titleString = shopInfo[@"titleString"];
     self.navigationItem.title = _titleString;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //获取时间数组,可封装
//        _timeArray = [self handleServiceTime];
//    });
}
#pragma mark - 创建底部工具view
- (void)createBottomView
{
    //创建底部工具view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 49, WIDTH, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    //添加下单按钮
    UIButton *sureOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 110, 5, 100,39)];
    [sureOrderBtn setTitle:NSLocalizedString(@"确定下单", nil) forState:UIControlStateNormal];
    sureOrderBtn.backgroundColor = THEME_COLOR;
    sureOrderBtn.layer.cornerRadius = 4;
    sureOrderBtn.layer.masksToBounds = YES;
    [sureOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureOrderBtn addTarget:self action:@selector(clickSureOrder:) forControlEvents:UIControlEventTouchUpInside];
    sureOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    _totalPriceLabel = [UILabel new];
//    _youhuiLabel = [[UILabel alloc] initWithFrame:CGRectMake( 130, 5, 90, 39)];
    //设置总价和优惠价格
    [self setTotalPrivce];
    
    //添加竖分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(130, 4.5, 1, 40)];
    lineView.backgroundColor = LINE_COLOR;
    [bottomView addSubview:_totalPriceLabel];
    [bottomView addSubview:lineView];
    [bottomView addSubview:_youhuiLabel];
    [bottomView addSubview:sureOrderBtn];
    [self.view addSubview:bottomView];
}
#pragma mark - tableViewDelegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableView == _mainTableView ? 6 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _mainTableView) {
        switch (section) {
            case 0:
                return 2;
            case 1:
                return 1;
            case 2:
                return 2;
                break;
            case 3:
                return 2;
                break;
            case 4:
                return cartDataArray.count;
                break;
            case 5:
                return 6;
                break;
            default:
                return 0;
                break;
        }
    }else{
        
        return _timeArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        if (indexPath.section == 0 ) {
             return ziTiS.on ? 44 : 0;
        }
        if (indexPath.section == 1) {
            return !ziTiS.on ? 88 : 0;
        }
        if (indexPath.section == 2){
            if (indexPath.row == 0) {
                if (!have_online_pay) return 0;
                
                UITableViewCell *cell = [self tableView:_mainTableView cellForRowAtIndexPath:indexPath];
                CGFloat height = CGRectGetHeight(cell.frame);
                [cell removeFromSuperview];
                cell = nil;
                return height;
            }else if (!have_daofu) return 0;

        }
        if (indexPath.section == 3 && indexPath.row == 0) {
           return !ziTiS.on ? 44 : 0;
        }
        if (indexPath.section == 5) {
            UITableViewCell *cell = [self tableView:_mainTableView cellForRowAtIndexPath:indexPath];
            CGFloat height = CGRectGetHeight(cell.frame);
            [cell removeFromSuperview];
            cell = nil;
            return height;
        }
        return 44;
        
    }else{
        return 35;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _mainTableView) {
        if (section == 0)return have_ziti ? 44 : 0.01;
        if (section >1) return 10;
        return 0.01;
    }else{
        return 35;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (!have_ziti) {
            return [UIView new];
        }
        UIView *backV = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
        backV.backgroundColor = [UIColor whiteColor];
        UILabel *titleL = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
        titleL.text = NSLocalizedString(@"是否自提", nil);
        titleL.font = FONT(14);
        titleL.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        if (!ziTiS) {
            ziTiS = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 56, 5, 90,30)];
            ziTiS.transform = CGAffineTransformMakeScale( .9, .9);
            ziTiS.onTintColor = THEME_COLOR;
            [ziTiS addTarget:self action:@selector(zitiSChanged:) forControlEvents:(UIControlEventValueChanged)];
        }
        [backV addSubview:titleL];
        [backV addSubview:ziTiS];
        return backV;
    }else{
        UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 10)];
        backView.backgroundColor = BACK_COLOR;
        return backView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
 
    switch (section) {
        case 0:
        {
            if (row == 0) {
                if (!ziTiS.on) {
                    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
                }
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //添加label
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 42)];
                titleLabel.text = NSLocalizedString(@"自提时间", nil);
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.textColor = THEME_COLOR;
                NSString *time = [NSString formateDate:@"yy/MM/dd HH:mm" dateline:self.dateline];
                NSString *str1 = self.dateline  == 0 ? (ziTiS.on ? NSLocalizedString(@"立即自提", nil) : NSLocalizedString(@"立即送达", nil)) : time;
                //添加右侧label
                if (!zitiTime) {
                    zitiTime = [[UILabel alloc] initWithFrame:CGRectMake(100 , 0, WIDTH - 140, 42)];
                    zitiTime.text = NSLocalizedString(@"选择自提时间", nil);
                    zitiTime.textAlignment = NSTextAlignmentRight;
                    zitiTime.font = [UIFont systemFontOfSize:14];
                    zitiTime.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                    //添加手势
                    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(clickZiTiTime)];
                    zitiTime.userInteractionEnabled = YES;
                    [zitiTime addGestureRecognizer:gesture];
                }
                zitiTime.text = str1;
                [cell addSubview:titleLabel];
                [cell addSubview:zitiTime];
                return cell;
            }else{
                
                if (!ziTiS.on) {
                    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
                }
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //添加label
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 42)];
                titleLabel.text = NSLocalizedString(@"自提地点", nil);
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                //添加右侧label
                if (!zitiAddrL) {
                    zitiAddrL = [[UILabel alloc] initWithFrame:CGRectMake(140 , 0, WIDTH - 180, 42)];
                    zitiAddrL.text = [_tableViewData[@"shopinfo"][@"addr"] stringByAppendingString:_tableViewData[@"shopinfo"][@"house"]];
                    zitiAddrL.textAlignment = NSTextAlignmentRight;
                    zitiAddrL.font = [UIFont systemFontOfSize:14];
                    zitiAddrL.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                }
                
                [cell addSubview:titleLabel];
                [cell addSubview:zitiAddrL];
                return cell;
            }
        }
            break;
        
        case 1:
        {
            if (!ziTiS.on) {
                if (!firstCell) {
                    firstCell = [[FirstOrderFirstCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 88)];
                    
                    //获取要重设的控件
                    contactTitleLabel = (UILabel *)[firstCell viewWithTag:1];
                    NSString *nameString;
                    NSString *mobileString;
                    NSString *addrString;
                    if ([_tableViewData[@"addr"] count] > 0) {
                        nameString = _tableViewData[@"addr"][@"contact"] ?_tableViewData[@"addr"][@"contact"] : @"";
                        mobileString = _tableViewData[@"addr"][@"mobile"] ? _tableViewData[@"addr"][@"mobile"] : @"";
                        addrString = [_tableViewData[@"addr"][@"addr"] ? _tableViewData[@"addr"][@"addr"] : @""  stringByAppendingString:_tableViewData[@"addr"][@"house"] ? _tableViewData[@"addr"][@"house"] : @""];
                        
                    }else{
                        nameString =  @"";
                        mobileString = @"";
                        addrString = NSLocalizedString(@"请选择地址", nil);
                    }
                    contactTitleLabel.text = [NSString stringWithFormat:@"%@ %@",nameString,mobileString];
                    addressLabel = (UILabel *)[firstCell viewWithTag:2];
                    addressLabel.text =  addrString;
                    addressLabel.numberOfLines = 0;
                    
                    UIButton *rightBtn = (UIButton *)[firstCell viewWithTag:3];
                    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
                }
                return firstCell;
            }else{
                
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 88)];
                return cell;
            }
            
        }
            break;
        case 2:
        {
            if (row == 0) {
                if (!have_online_pay) {
                    return [UITableViewCell new];
                }
                payCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"payCell"];
                if (!cell) {
                    cell = [[payCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"payCell"];
                }
                cell.titleLabel.text = NSLocalizedString(@"在线支付", nil);
                if (isOnlinepay) {
                    cell.rightIV.image = [UIImage imageNamed:@"selectCurrent"];
                }else{
                    
                    cell.rightIV.image = [UIImage imageNamed:@"selectDefault"];
                }
                
                //获取首单立减金额
                NSString *first_amount = _tableViewData[@"first_amount"];
                //获取可用红包数目
                _hongbao_count = _tableViewData[@"hongbao_count"];
                
                if ([first_amount doubleValue] > 0 && _hongbao_count.integerValue == 0) {
                    //添加首单立减字样
                    UILabel *first_amount_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 80, 20)];
                    first_amount_label.textColor = [UIColor whiteColor];
                    first_amount_label.font = [UIFont systemFontOfSize:11];
                    first_amount_label.backgroundColor = [UIColor colorWithRed:126/255.0
                                                                         green:206/255.0
                                                                          blue:244/255.0 alpha:1.0];
                    first_amount_label.text = [NSString stringWithFormat:NSLocalizedString(@"首单立减%g元", nil),[first_amount doubleValue]];
                    first_amount_label.textAlignment = NSTextAlignmentCenter;
                    
                    cell.frame = CGRectMake(0, 0, WIDTH , 60);
                    [cell addSubview:first_amount_label];
                    
                }else{
                    
                    if ([first_amount doubleValue] > 0 && _hongbao_count.integerValue > 0) {
                        //添加首单立减字样
                        UILabel *first_amount_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 80, 20)];
                        first_amount_label.textColor = [UIColor whiteColor];
                        first_amount_label.font = [UIFont systemFontOfSize:11];
                        first_amount_label.backgroundColor = [UIColor colorWithRed:126/255.0
                                                                             green:206/255.0
                                                                              blue:244/255.0 alpha:1.0];
                        first_amount_label.text = [NSString stringWithFormat:NSLocalizedString(@"首单立减%g元", nil),[first_amount doubleValue]];
                        first_amount_label.textAlignment = NSTextAlignmentCenter;
                        [cell addSubview:first_amount_label];
                        
                        //添加可用红包字样
                        UILabel *hongbao_label = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 95, 20)];
                        hongbao_label.textColor = [UIColor whiteColor];
                        hongbao_label.font = [UIFont systemFontOfSize:11];
                        hongbao_label.backgroundColor = [UIColor colorWithRed:251/255.0
                                                                        green:0/255.0
                                                                         blue:26/255.0
                                                                        alpha:1.0];
                        hongbao_label.textAlignment = NSTextAlignmentCenter;
                        hongbao_label.text = [NSString stringWithFormat:NSLocalizedString(@"有%@个红包可用", nil),_hongbao_count];
                        
                        cell.frame = CGRectMake(0, 0, WIDTH , 60);
                        [cell addSubview:hongbao_label];
                        [cell addSubview:first_amount_label];
                        
                    }else{
                        
                        if ([first_amount doubleValue] == 0 && _hongbao_count.integerValue == 0) {
                            
                            cell.frame = CGRectMake(0, 0, WIDTH , 44);
                            cell.titleLabel.center = CGPointMake(cell.titleLabel.center.x, cell.center.y);
                            cell.rightIV.center = CGPointMake(cell.rightIV.center.x, cell.center.y);
                            
                        }else{
                            
                            //添加可用红包字样
                            UILabel *hongbao_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 95, 20)];
                            hongbao_label.textColor = [UIColor whiteColor];
                            hongbao_label.font = [UIFont systemFontOfSize:11];
                            hongbao_label.backgroundColor =  [UIColor colorWithRed:251/255.0
                                                                             green:0/255.0
                                                                              blue:26/255.0
                                                                             alpha:1.0];
                            hongbao_label.textAlignment = NSTextAlignmentCenter;
                            hongbao_label.text = [NSString stringWithFormat:NSLocalizedString(@"有%@个红包可用", nil),_hongbao_count];
                            
                            cell.frame = CGRectMake(0, 0, WIDTH , 60);
                            [cell addSubview:hongbao_label];
                        }
                    }
                }
                return cell;
            }else{
                if (!have_daofu) {
                    return [UITableViewCell new];
                }
                payCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"payCell"];
                if (!cell) {
                    cell = [[payCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"payCell"];
                }
                cell.frame = CGRectMake(0, 0, WIDTH, 44);
                cell.titleLabel.text = NSLocalizedString(@"货到付款", nil);
                cell.titleLabel.center = CGPointMake(cell.titleLabel.center.x, cell.center.y);
                
                if (isOnlinepay) {
                    cell.rightIV.image = [UIImage imageNamed:@"selectDefault"];
                }else{
                    cell.rightIV.image = [UIImage imageNamed:@"selectCurrent"];
                }
                cell.rightIV.center = CGPointMake(cell.rightIV.center.x, cell.center.y);
                return cell;
            }
            
        }
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                if (!ziTiS.on) {
                   
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //添加label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 44)];
                    titleLabel.text = NSLocalizedString(@"送达时间", nil);
                    titleLabel.font = [UIFont systemFontOfSize:14];
                    titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                    NSString *time = [NSString formateDate:@"yy/MM/dd HH:mm" dateline:self.dateline];
                    NSString *str1 = self.dateline  == 0? (ziTiS.on ? NSLocalizedString(@"立即自提", nil) : NSLocalizedString(@"立即送达", nil)) : time;
                    //添加右侧label
                    if (!_timeLabel) {
                        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake( WIDTH - 185, 0, 150, 44)];
                        _timeLabel.text = NSLocalizedString(@"选择时间", nil);
                        _timeLabel.textAlignment = NSTextAlignmentRight;
                        _timeLabel.font = [UIFont systemFontOfSize:14];
                        _timeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                        //添加手势
                        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                  action:@selector(clickChooseTimeLabel)];
                        _timeLabel.userInteractionEnabled = YES;
                        [_timeLabel addGestureRecognizer:gesture];
                    }
                    _timeLabel.text = str1;
                    [cell addSubview:titleLabel];
                    [cell addSubview:_timeLabel];
                    return cell;
                }else{
                
                    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
                }
                
            }else{
                UITableViewCell *cell = [UITableViewCell new];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //添加label
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 42)];
                titleLabel.text = NSLocalizedString(@"订单备注", nil);
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                
                //添加右侧label
                if (!_msgLabel) {
                    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 185, 0, 150, 42)];
                    _msgLabel.text = NSLocalizedString(@"添加备注", nil);
                    _msgLabel.textAlignment = NSTextAlignmentRight;
                    _msgLabel.font = [UIFont systemFontOfSize:14];
                    _msgLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                    //添加手势
                    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(clickAddMsg:)];
                    _msgLabel.userInteractionEnabled = YES;
                    [_msgLabel addGestureRecognizer:gesture];
                }
                
                [cell addSubview:titleLabel];
                [cell addSubview:_msgLabel];
                return cell;
            }

        }
            break;
        case 4:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加titleLabel
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            NSString *product_title = cartDataArray[indexPath.row][@"product_title"];
            NSString *spec_title = cartDataArray[indexPath.row][@"spec_title"];
            titleLabel.text = (spec_title.length > 0) ?  [NSString stringWithFormat:@"%@-%@",product_title,spec_title] :  product_title;
            
            //添加数量及价格标签
            UILabel *num_price_Label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 150, 0, 130, 44)];
            num_price_Label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            num_price_Label.font = [UIFont systemFontOfSize:14];
            num_price_Label.textAlignment = NSTextAlignmentRight;
            NSString *num = cartDataArray[indexPath.row][@"number"];
            NSString *price = cartDataArray[indexPath.row][@"price"];
            num_price_Label.text = [NSString stringWithFormat:NSLocalizedString(@"¥ %g   x %@", nil),[price floatValue],num];
            CGFloat width = getSize(num_price_Label.text, 44, 14).width + 20;
            titleLabel.frame = FRAME(10, 0, WIDTH - width - 20, 44);
            num_price_Label.frame = FRAME(WIDTH - width - 10 , 0, width, 44);
            [cell addSubview:titleLabel];
            [cell addSubview:num_price_Label];
            
            return cell;

        }
            break;
        default:
        {
            switch (row) {
                case 0:
                {
                    
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加titleLabel
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
                    titleLabel.font = [UIFont systemFontOfSize:14];
                    titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"打包费", nil);
                    
                    //添加右侧费用label
                    UILabel *packageLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 160, 0, 140, 44)];
                    packageLabel.font = [UIFont systemFontOfSize:14];
                    packageLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                    packageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"+ %@元", nil),package];
                    packageLabel.textAlignment = NSTextAlignmentRight;
                    
                    [cell addSubview:titleLabel];
                    [cell addSubview:packageLabel];
                    
                    if ([package doubleValue] == 0.00) {
                        cell = [UITableViewCell new];
                        cell.frame = CGRectZero;
                    }
                    
                    return cell;
                }
                    break;
                case 1:
                {
                    if (!ziTiS.on) {
                        UITableViewCell *cell = [UITableViewCell new];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //添加titleLabel
                        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
                        titleLabel.font = [UIFont systemFontOfSize:14];
                        titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                        titleLabel.text = NSLocalizedString(@"配送费", nil);
                        
                        //添加右侧费用label
                        UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 160, 0, 140, 44)];
                        freightLabel.font = [UIFont systemFontOfSize:14];
                        freightLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                        freightLabel.text = [NSString stringWithFormat:NSLocalizedString(@"+ %g元", nil),[freight floatValue]];
                        freightLabel.textAlignment = NSTextAlignmentRight;
                        
                        [cell addSubview:titleLabel];
                        [cell addSubview:freightLabel];
                        
                        if ([freight doubleValue] == 0.00) {
                            cell = [UITableViewCell new];
                            cell.frame = CGRectZero;
                        }
                        return cell;
                    }else{
                        UITableViewCell *cell = [UITableViewCell new];
                        cell.frame = CGRectZero;
                        return cell;
                        
                    }
                    
                }
                    break;
                case 2:
                {
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加titleLabel
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
                    titleLabel.font = [UIFont systemFontOfSize:14];
                    titleLabel.textColor = [UIColor colorWithRed:251/255.0 green:33/255.0 blue:46/255.0 alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"首单立减", nil);
                    
                    //添加右侧费用label
                    UILabel *first_amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 160, 0, 140, 44)];
                    first_amountLabel.font = [UIFont systemFontOfSize:14];
                    first_amountLabel.textColor = [UIColor colorWithRed:251/255.0 green:33/255.0 blue:46/255.0 alpha:1.0];
                    first_amountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"- %@元", nil),_first_amount];
                    first_amountLabel.textAlignment = NSTextAlignmentRight;
                    
                    [cell addSubview:titleLabel];
                    [cell addSubview:first_amountLabel];
                    
                    if ([_first_amount doubleValue] == 0.00 || hideSection3 == YES) {
                        cell = [UITableViewCell new];
                        cell.frame = CGRectZero;
                    }
                    
                    return cell;
                }
                    break;
                case 3:
                {
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加titleLabel
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
                    titleLabel.font = [UIFont systemFontOfSize:14];
                    titleLabel.textColor = [UIColor colorWithRed:251/255.0 green:33/255.0 blue:46/255.0 alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"满减优惠",nil);
                    //添加右侧费用label
                    UILabel *orderYouhuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 160, 0, 140, 44)];
                    orderYouhuiLabel.font = [UIFont systemFontOfSize:14];
                    orderYouhuiLabel.textColor = [UIColor colorWithRed:251/255.0 green:33/255.0 blue:46/255.0 alpha:1.0];
                    orderYouhuiLabel.text = [NSString stringWithFormat:NSLocalizedString(@"- %@元",nil),order_youhui];
                    orderYouhuiLabel.textAlignment = NSTextAlignmentRight;
                    
                    [cell addSubview:titleLabel];
                    [cell addSubview:orderYouhuiLabel];
                    
                    if ([order_youhui doubleValue] == 0.00 || hideSection3 == YES) {
                        cell = [UITableViewCell new];
                        cell.frame = CGRectZero;
                    }
                    return cell;
                }

                case 4:
                {
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 44)];
                    titleLabel.text = NSLocalizedString(@"优惠劵抵扣", nil);

                    titleLabel.font = [UIFont systemFontOfSize:14];
                    titleLabel.textColor = [UIColor colorWithRed:251/255.0 green:33/255.0 blue:46/255.0 alpha:1.0];
                    
                    //添加右侧label
                    couponRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 130 , 0, 110, 44)];
                    couponRightLabel.textAlignment = NSTextAlignmentRight;
                    couponRightLabel.font = [UIFont systemFontOfSize:14];
                    couponRightLabel.textColor = [UIColor colorWithRed:251/255.0 green:33/255.0 blue:46/255.0 alpha:1.0];
                    //处理默认红包可抵扣多少
                    [cell addSubview:titleLabel];
                    [cell addSubview:couponRightLabel];
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    if ([_tableViewData[@"coupons"] count] == 0) {
//                        couponRightLabel.text = GLOBAL(@"暂无优惠劵可用");
//                        couponRightLabel.frame = CGRectMake(WIDTH - 130 , 0, 110, 44);
//
//                    }else{
//                        if([_tableViewData[@"coupon"][@"coupon_amount"] floatValue] == 0 ){
//                            couponRightLabel.text =  NSLocalizedString(@"未使用优惠劵", NSStringFromClass([self class]));
//                        }else{
                            couponRightLabel.text = [NSString stringWithFormat:@"%@",_tableViewData[@"coupon"][@"deduct_lable"]];
//                        }
                    

                        couponRightLabel.frame = CGRectMake(WIDTH - 140 , 0, 110, 44);
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                    }
                    if (hideSection3 == YES) {
                        cell = [UITableViewCell new];
                        cell.frame = CGRectZero;
                    }
                    return cell;
                }
                    break;
                case 5:
                {
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 44)];
                    titleLabel.text = NSLocalizedString(@"红包抵扣",nil);
                    titleLabel.font = [UIFont systemFontOfSize:14];
                    titleLabel.textColor = [UIColor colorWithRed:251/255.0 green:33/255.0 blue:46/255.0 alpha:1.0];

                    
                    //添加右侧label
                    redPacketRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 130 , 0, 110, 44)];
                    redPacketRightLabel.textAlignment = NSTextAlignmentRight;
                    redPacketRightLabel.font = [UIFont systemFontOfSize:14];
                    redPacketRightLabel.textColor = [UIColor colorWithRed:251/255.0 green:33/255.0 blue:46/255.0 alpha:1.0];
                    //处理默认红包可抵扣多少
                    [cell addSubview:titleLabel];
                    [cell addSubview:redPacketRightLabel];
                    
                     cell.accessoryType = UITableViewCellAccessoryNone;
//                    if ([_tableViewData[@"hongbaos"] count] == 0) {
//                        redPacketRightLabel.text = GLOBAL(@"暂无红包可用");
//                        redPacketRightLabel.frame = CGRectMake(WIDTH - 130 , 0, 110, 44);
//
//                    }else{
//                        if([_tableViewData[@"hongbao"][@"amount"] floatValue] == 0 ){
//                            redPacketRightLabel.text =  NSLocalizedString(@"未使用红包", NSStringFromClass([self class]));
//                        }else{
                            redPacketRightLabel.text = [NSString stringWithFormat:@"%@",_tableViewData[@"hongbao"][@"deduct_lable"]];
//                        }
                    
                        redPacketRightLabel.frame = CGRectMake(WIDTH - 140 , 0, 110, 44);
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                    }
                    if (hideSection3 == YES) {
                        cell = [UITableViewCell new];
                        cell.frame = CGRectZero;
                    }
                    return cell;
                }
                    break;
                default:
                {
                    return [UITableViewCell new];
                    
                }
                    break;
            }
            break;
        }
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1 && indexPath.row == 0) {
        [self clickRightBtn];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //跳转到地图界面
        JHPathMapVC *vc = [[JHPathMapVC alloc] init];
        double bd_lat;
        double bd_lng;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[pointDic[@"lat"] doubleValue]
                                                     WithBD_lon:[pointDic[@"lng"] doubleValue]
                                                     WithGD_lat:&bd_lat
                                                     WithGD_lon:&bd_lng];
        vc.lat = @(bd_lat).description;
        vc.lng = @(bd_lng).description;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        NSLog(@"在线");
        payCell *cell = [_mainTableView cellForRowAtIndexPath:indexPath];
        cell.rightIV.image = [UIImage imageNamed:@"selectCurrent"];
        if (have_daofu) {
            payCell *cell2 = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
            cell2.rightIV.image = [UIImage imageNamed:@"selectDefault"];
        }
        isOnlinepay = YES;
        hideSection3 = NO;
        [self setTotalPrivce];
        //刷新分区
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:5];
        [_mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        NSLog(@"货到");
        payCell *cell = [_mainTableView cellForRowAtIndexPath:indexPath];
        cell.rightIV.image = [UIImage imageNamed:@"selectCurrent"];
        payCell *cell2 = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        if ([cell2 isKindOfClass:[payCell class]]) {
            cell2.rightIV.image = [UIImage imageNamed:@"selectDefault"];
        }
        
        isOnlinepay = NO;
        hideSection3 = YES;
        [self setTotalPrivce];
        //刷新分区
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:5];
        [_mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }
    if (indexPath.section == 5 && indexPath.row == 4) {
        NSLog(@"点击选择优惠劵cell");
        NSArray *arr = _tableViewData[@"coupons"];
        if (arr.count == 0) {
            return;
        }
        self.couponSheet.dataSource = arr;
        self.couponSheet.coupon_id = _coupon_id;
        [self.couponSheet sheetShow];
    }
    if (indexPath.section == 5 && indexPath.row == 5) {
        NSLog(@"点击选择红包cell");
        NSArray *arr = _tableViewData[@"hongbaos"];
        if (arr.count == 0) {
            return;
        }
        self.hongBaoSheet.dataSource = arr;
        self.hongBaoSheet.hongbao_id = _hongbao_id;
        [self.hongBaoSheet sheetShow];
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 改变自提状态
- (void)zitiSChanged:(UISwitch *)zitiS
{
    self.timeSheet.titleStr = ziTiS.on ? NSLocalizedString(@"选择自提时间" , @"JHWMCreateOrderVC") : NSLocalizedString(@"选择送达时间" , @"JHWMCreateOrderVC");


        [self changeOrderInfoWithChangeInfo:nil];

    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:5]
                  withRowAnimation:UITableViewRowAnimationNone];
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:3]
                  withRowAnimation:UITableViewRowAnimationNone];
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationFade];
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];

    [self setTotalPrivce];

}
#pragma mark - 设置总价
- (void)setTotalPrivce
{
    //设置总价
    double price;
    double youhuiprice;
    if (isOnlinepay) {
        
        price = _amount + [package doubleValue] + [freight doubleValue]
        -[_first_amount doubleValue] - [_hongbao_amount doubleValue] - [order_youhui doubleValue];
    }else{
        price = _amount + [package doubleValue] + [freight doubleValue];
    }
    if (ziTiS.on) {
        price -= [freight doubleValue];
    }
    price = [_tableViewData[@"total_price"] doubleValue];
    youhuiprice = [_tableViewData[@"total_youhui"] doubleValue];
    
    //添加字总价标签
    if (!_totalPriceLabel) {
        _totalPriceLabel = [UILabel new];
    }
    _totalPriceLabel.frame = CGRectMake(10 , 5, 120, 39);
    _totalPriceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"合计: ¥%g", nil),MAX(price,0.01)];

    amountStr = [NSString stringWithFormat:@"%g",MAX(price,0.01)];
    _totalPriceLabel.font = [UIFont systemFontOfSize:14];
    NSInteger temString1_len = _totalPriceLabel.text.length;
    //合计标签富文本
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_totalPriceLabel.text];
    
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15]
                          range:NSMakeRange(3, temString1_len - 3)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithRed:251/255.0 green:0/255.0 blue:26/255.0 alpha:1.0]
                          range:NSMakeRange(3, temString1_len - 3)];
    
    
    
    _totalPriceLabel.attributedText = AttributedStr;
    
}
#pragma mark - 获取格式化的商品字符串
- (NSString *)getProducts
{
    //获取对应店铺的购物车数据
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    return [model getProductsString:_shop_id];
}
#pragma mark - 点击确认下单按钮
- (void)clickSureOrder:(UIButton *)sender
{
    NSLog(@"点击确认下单按钮");
    if (ziTiS.on) {             //自提单
        //组建参数
        NSString *products = [self getProducts];
        //获取支付方式
        NSInteger pay = isOnlinepay ? 1 : 0;
        NSString *online_pay = @(pay).stringValue;
        //获取配送时间
        NSString *timeLabel_text = zitiTime.text;
        NSString *pei_time;
        if ([timeLabel_text isEqualToString:NSLocalizedString(@"选择自提时间", nil)] || [timeLabel_text  isEqualToString:NSLocalizedString(@"尽快上门", nil)]) {
            pei_time = @"0";
        }else{
            pei_time = timeLabel_text;
        }
        //备注要求
        NSString *message = _msgLabel.text;
        NSString *note;
        if ([message isEqualToString:NSLocalizedString(@"添加备注", nil)] || [message isEqualToString:NSLocalizedString(@"输入您想交代的话", nil)]) {
            note = @"";
        }else{
            note = message;
        }
        
        //获取当前的已选商品数组并转换为格式化字符串
        NSDictionary *params = @{@"shop_id":_shop_id,
                                 @"products":products,
                                 @"pei_time":@(_dateline),
                                 @"online_pay":online_pay,
                                 @"hongbao_id":_hongbao_id,
                                 @"note":note,
                                 @"pei_type":@"3",
                                 @"pei_time":[NSString stringWithFormat:@"%ld",self.dateline]};
        SHOW_HUD
        [HttpTool postWithAPI:@"client/waimai/order/create"
                   withParams:params
                      success:^(id json) {
                          NSLog(@"client/waimai/order/create---%@",json);
                          if ([json[@"error"] isEqualToString:@"0"]) {
                              
                              //清空对应购物车信息
                              JHOrderInfoModel *orderModel = [JHOrderInfoModel shareModel];
                              [orderModel removeShopCartInfoWithShop_id:_shop_id];
                              if (isOnlinepay) { //在线支付
                                  //跳转到支付界面
                                  NSLog(@"下单成功");;
                                  JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
                                  vc.order_id = json[@"data"][@"order_id"];
                                  vc.amount = amountStr;
                                  vc.isWM = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                              }else{
                                  
                                  JHOrderDetailViewController *vc = [JHOrderDetailViewController new];
                                  vc.order_id = json[@"data"][@"order_id"];
                                  vc.isPayCome = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                                  
                              }
                             

                          }else{
                              //展示信息
                              [self showAlertWithMsg:json[@"message"]];
                          }
                          HIDE_HUD
                      }
                      failure:^(NSError *error) {
                          NSLog(@"%@",error.localizedDescription);
                          HIDE_HUD
                      }];
        
        
    }else{         //非自提单
       
        //判断是否选择地址
        if (addressLabel.text.length == 0 || contactTitleLabel.text.length == 0 || _addr_id.length == 0) {
            [self showAlertWithMsg:NSLocalizedString(@"没有选择地址", nil)];
            return;
        }
        //组建参数
        NSString *products = [self getProducts];
        //获取支付方式
        NSInteger pay = isOnlinepay ? 1 : 0;
        NSString *online_pay = [NSString stringWithFormat:@"%ld",pay];
        
        //获取配送时间
        NSString *timeLabel_text = _timeLabel.text;
        NSString *pei_time;
        if ([timeLabel_text isEqualToString:NSLocalizedString(@"选择时间", nil)] || [timeLabel_text isEqualToString:NSLocalizedString(@"尽快送达", nil)]) {
            pei_time = @"0";
        }else{
            pei_time = timeLabel_text;
        }
        //备注要求
        NSString *message = _msgLabel.text;
        NSString *note;
        if ([message isEqualToString:NSLocalizedString(@"添加备注", nil)] || [message isEqualToString:NSLocalizedString(@"输入您想交代的话", nil)]) {
            note = @"";
        }else{
            note = message;
        }
        
        //获取当前的已选商品数组并转换为格式化字符串
        NSDictionary *params = @{@"shop_id":_shop_id,
                                 @"addr_id":_addr_id,
                                 @"products":products,
                                 @"pei_time":@(_dateline),
                                 @"online_pay":online_pay,
                                 @"hongbao_id":_hongbao_id,
                                 @"note":note,
                                 @"pei_amount":freight};
        SHOW_HUD
        [HttpTool postWithAPI:@"client/waimai/order/create"
                   withParams:params
                      success:^(id json) {
                          NSLog(@"client/waimai/order/create---%@",json);
                          if ([json[@"error"] isEqualToString:@"0"]) {
                              
                              //清空对应购物车信息
                              JHOrderInfoModel *orderModel = [JHOrderInfoModel shareModel];
                              [orderModel removeShopCartInfoWithShop_id:_shop_id];
                              if (isOnlinepay) {
                                
                                  //跳转到支付界面
                                  NSLog(@"下单成功");
                                  JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
                                  vc.order_id = json[@"data"][@"order_id"];
                                  vc.amount = amountStr;
                                  vc.isWM = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                                  
                                  
                              }else{
                              
                                  JHWaiMaiOrderDetailVC *wm = [[JHWaiMaiOrderDetailVC alloc] init];
                                  wm.order_id = json[@"data"][@"order_id"];
                                  wm.isPayCome = YES;
                                  [self.navigationController pushViewController:wm animated:YES];
                              }
                              
                              
                          }else{
                              //展示信息
                              [self showAlertWithMsg:json[@"message"]];
                          }
                          HIDE_HUD
                      }
                      failure:^(NSError *error) {
                          NSLog(@"%@",error.localizedDescription);
                          HIDE_HUD
                      }];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([_tableViewData[@"shopinfo"][@"is_daofu"] isEqualToString:@"1"] &&
        ![_tableViewData[@"shopinfo"][@"online_pay"] isEqualToString:@"1"]) {
        
        [self tableView:_mainTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    }
    
    [self.navigationController.navigationBar yf_setBackgroundColor:NEW_THEME_COLOR];
}

#pragma mark - 点击右侧箭头按钮
- (void)clickRightBtn
{
    //跳转界面到地址选择界面
    JHWaiMaiAddressVC *vc = [[JHWaiMaiAddressVC alloc] init];
    vc.shop_id = self.shop_id;
    vc.addr_id = _addr_id;   //不存在add_id时自动默认为空
    [self.navigationController pushViewController:vc animated:YES];
    //设置地址回调
    __weak typeof(self)weakSelf = self;
    [vc setSelectorBlock:^(JHWaimaiMineAddressListDetailModel *model) {
        _addr_id = model.addr_id;
        contactTitleLabel.text = [NSString stringWithFormat:@"%@ %@",model.contact,model.mobile];
        addressLabel.text = [model.addr stringByAppendingString:model.house];
        addressLabel.numberOfLines = 0;
        [weakSelf getFreight];
    }];
    
}
-(void)getNead_pay{
    
    
    [HttpTool postWithAPI:@"client/waimai/order/preinfo" withParams:@{} success:^(id json) {

    } failure:^(NSError *error) {

    }];
}
#pragma mark - 点击选择时间标签
- (void)clickChooseTimeLabel
{
    _timeSheet.dataSource = [self.shopModel getTimesArr:ziTiS.on];
    [self.timeSheet sheetShow];
}

#pragma mark - 点击添加备注标签
- (void)clickAddMsg:(UITapGestureRecognizer *)gesture
{
    NSLog(@"点击添加备注");
    AddMessageVC * vc = [[AddMessageVC alloc] init];
    vc.msgString = _msgLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    [vc setBlock:^(NSString *text) {
        _msgLabel.text = text;
    }];
}

#pragma mark - 点击了左侧按钮
- (void)clickBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击自提时间标签
- (void)clickZiTiTime
{
    _timeSheet.dataSource = [self.shopModel getTimesArr:have_ziti];
    [self.timeSheet sheetShow];
    
}
#pragma mark - show alert
- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
    [controller addAction:sureAction];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark ====== JHCreateOrderSheetViewDelegate =======
-(void)sheetView:(JHCreateOrderSheetView *)sheetView clickIndex:(NSInteger)index choosedValue:(NSString *)str{
    
    if (sheetView == _hongBaoSheet){// 选择红包的回调
        NSArray *arr = _tableViewData[@"hongbaos"];
            NSDictionary *dic = arr[index];
            [self changeOrderInfoWithChangeInfo:@{@"hongbao_id":dic[@"hongbao_id"]}];
        
    }else if (sheetView == _couponSheet){
        NSArray *arr = _tableViewData[@"coupons"];
        NSDictionary *dic = arr[index];
        [self changeOrderInfoWithChangeInfo:@{@"coupon_id":dic[@"coupon_id"]}];
        
    }else
    {
        // 选择时间的回调
        self.dateline = [str integerValue];
        
        [_mainTableView reloadData];
    }

}

-(JHCreateOrderSheetView *)timeSheet{
    if (_timeSheet==nil) {
        NSString *title = ziTiS.on ? NSLocalizedString(@"选择自提时间", @"JHWMCreateOrderVC") : NSLocalizedString(@"选择送达时间", @"JHWMCreateOrderVC");
        _timeSheet=[[JHCreateOrderSheetView alloc] initWithTitle:title amount:@"" delegate:self sheetViewType:SheetViewChooseTime dataSource:[self.shopModel getTimesArr:NO]];
        
    }
    return _timeSheet;
}

-(JHCreateOrderSheetView *)hongBaoSheet{
    if (_hongBaoSheet==nil) {
        _hongBaoSheet=[[JHCreateOrderSheetView alloc] initWithTitle:NSLocalizedString(@"选择红包", @"JHWMCreateOrderVC") amount:@"" delegate:self sheetViewType:SheetViewChooseHongBao dataSource:_tableViewData[@"hongbaos"]];
    }
    return _hongBaoSheet;
}

-(JHCreateOrderSheetView *)couponSheet{
    if (_couponSheet==nil) {
        _couponSheet=[[JHCreateOrderSheetView alloc] initWithTitle:NSLocalizedString(@"选择优惠劵", @"JHWMCreateOrderVC") amount:@"" delegate:self sheetViewType:SheetViewChooseYouHui dataSource:_tableViewData[@"coupons"]];
    }
    return _couponSheet;
}


-(void)changeOrderInfoWithChangeInfo:(NSDictionary *)change_dic{
    SHOW_HUD
    int is_ziti = ziTiS.on ? 1 : 0;
    int online_pay = isOnlinepay ? 1 : 0;
    NSString * notice =  _msgLabel.text ? _msgLabel.text : @"" ;
    NSString * addr_id = _addr_id ? _addr_id : @"";
    NSMutableDictionary *dic = @{@"shop_id":_shop_id,
                                 @"addr_id":addr_id,
                                 @"hongbao_id":_hongbao_id,
                                 @"coupon_id":_coupon_id,
                                 @"is_ziti":@(is_ziti),
                                 @"pei_time":@(_dateline),
                                 @"online_pay":@(online_pay),
                                 @"amount":@(_amount),
                                 @"products":[self getProducts],
                                 @"intro":notice}.mutableCopy;
    for (NSString *key in change_dic.allKeys) {
        dic[key] = change_dic[key];
    }

    [HttpTool postWithAPI:@"client/waimai/order/preinfo" withParams:dic.copy
                  success:^(id json) {
                      NSLog(@"client/waimai/order/preinfo---%@",json);
                      _tableViewData = json[@"data"];
                      freight = _tableViewData[@"freight_stage"] ? _tableViewData[@"freight_stage"] : @"";
                      [self getHongBaoAmount];
                      [self setTotalPrivce];
                      [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
                      HIDE_HUD
                  } failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
}

@end

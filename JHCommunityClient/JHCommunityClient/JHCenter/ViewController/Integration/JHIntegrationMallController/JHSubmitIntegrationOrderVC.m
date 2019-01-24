//
//  JHExchangeIntegrationVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//积分商城下单接口

#import "JHSubmitIntegrationOrderVC.h"
#import "JHWaiMaiAddressVC.h"

#import "NSObject+CGSize.h"
#import "UIImageView+NetStatus.h"
#import "MBProgressHUD.h"
 
#import "JHIntegrationCartModel.h"
#import "JHSubmitIntegrationOrderCell.h"
#import "JHWMPayOrderVC.h"
#import "DSToast.h"
#import "JudgeToken.h"
#import "JHIntegrationOrderListVC.h"
@interface JHSubmitIntegrationOrderVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_selectAddrBackView;//地址背景
    UILabel *_basicLabel;//姓名加电话号码
    UILabel *_addressLabel;//地址
    UIImageView *_coordinateImg;
    UILabel *_selectAddr;//请选择地址
    UILabel *_peiFee;//运费
    UITableView *_submitTableView;
    UIView *_bottomView;//底部视图
    UILabel *_badgeLabel;//购物数字
    UIButton *_submitBnt;//立即购买按钮
    UILabel *_totalPrice;//总价格和总积分
    DSToast *_badgeToast;
    DSToast *_maxToast;
    NSArray *_dataArray;
}
@end

@implementation JHSubmitIntegrationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"提交积分订单", nil);
    [self getDataSource];
    [self initSubViews];
    [self createSubmitTableView];
    [self createBottomView];
    
}
#pragma mark-====获取数据源
- (void)getDataSource{
    _dataArray =  [JHIntegrationCartModel shareIntegrationCartModel].integrationCartInfo;
    if(_dataArray.count == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark--====初始化子控件
- (void)initSubViews{
    _selectAddrBackView = [UIView new];
    _selectAddrBackView.frame = FRAME(0,0, WIDTH, 70);
    _selectAddrBackView.backgroundColor = [UIColor whiteColor];
    UIImageView *topLineImg = [UIImageView new];
    [_selectAddrBackView addSubview:topLineImg];
    [topLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 1;
        make.height.offset = 1;
    }];
    UIImageView *bottomLineImg = [UIImageView new];
    [_selectAddrBackView addSubview:bottomLineImg];
    [bottomLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 1;
    }];
    topLineImg.image = IMAGE(@"xiantiao");
    bottomLineImg.image = IMAGE(@"xiantiao");;
    _coordinateImg = [UIImageView new];
    [_selectAddrBackView addSubview:_coordinateImg];
    [_coordinateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.centerY.equalTo(_selectAddrBackView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    _coordinateImg.image = IMAGE(@"dizhi-1");
    
    UIImageView *directionImg = [UIImageView new];
    directionImg.image = IMAGE(@"jiantou_1");
    [_selectAddrBackView addSubview:directionImg];
    [directionImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.centerY.equalTo(_selectAddrBackView);
        make.size.mas_equalTo(CGSizeMake(9, 15));
    }];
    
    _basicLabel = [UILabel new];
    _basicLabel.font = FONT(14);
    _basicLabel.textColor = HEX(@"333333", 1.0f);
    [_selectAddrBackView addSubview:_basicLabel];
    [_basicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 35;
        make.top.offset = 15;
        make.height.offset = 14;
        make.right.offset = - 20;
    }];
    
    _selectAddr = [UILabel new];
    _selectAddr.text = NSLocalizedString(@"请选择地址", nil);
    _selectAddr.font = FONT(14);
    _selectAddr.textColor = HEX(@"333333", 1.0f);
    [_selectAddrBackView addSubview:_selectAddr];
    [_selectAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset= 35;
        make.top.offset = 30;
        make.height.offset = 14;
        make.right.offset = -20;
    }];
    
    _addressLabel = [UILabel new];
    _addressLabel.font = FONT(12);
    _addressLabel.textColor = [UIColor blackColor];
    _addressLabel.numberOfLines = 0;
    [_selectAddrBackView addSubview:_addressLabel];
    
    _peiFee = [UILabel new];
    _peiFee.font = FONT(14);
    _peiFee.textColor = HEX(@"ff6600", 1.0f);
    _peiFee.text = [NSString stringWithFormat:@"¥%@",[[JHIntegrationCartModel shareIntegrationCartModel] getIntegrationFreight]];
    _peiFee.frame = FRAME(WIDTH - 130, 0, 120, 40);
    _peiFee.textAlignment = NSTextAlignmentCenter;
    _peiFee.textAlignment = NSTextAlignmentRight;
    
}
#pragma mark--===创建表视图
- (void)createSubmitTableView{
    if(_submitTableView == nil){
        _submitTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50) style:UITableViewStyleGrouped];
        _submitTableView.delegate = self;
        _submitTableView.dataSource = self;
        _submitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [UIView new];
        view.backgroundColor = BACK_COLOR;
        _submitTableView.backgroundView = view;
        _submitTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_submitTableView];
    }else{
        [_submitTableView reloadData];
    }
}
#pragma mark-====创建底部视图
- (void)createBottomView{
    if(_bottomView == nil){
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.right.offset = 0;
            make.bottom.offset = 0;
            make.height.offset = 50;
        }];
        UIImageView *cartImg = [UIImageView new];
        [_bottomView addSubview:cartImg];
        cartImg.image = IMAGE(@"shop_vehicle");
        [cartImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.top.offset = 10;
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        _badgeLabel = [UILabel new];
        _badgeLabel.font = FONT(10);
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:_badgeLabel];
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 5;
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.offset = 32.5;
        }];
        _badgeLabel.layer.cornerRadius = 10.0f;
        _badgeLabel.clipsToBounds = YES;
        _totalPrice = [UILabel new];
        _totalPrice.font = FONT(16);
        _totalPrice.textColor = HEX(@"ff6600", 1.0f);
        [_bottomView addSubview:_totalPrice];
        [_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cartImg.mas_right).offset = 15;
            make.top.offset = 0;
            make.bottom.offset = 0;
            make.right.offset = -100;
        }];
        _submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBnt.titleLabel.font = FONT(16);
        _submitBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_submitBnt setTitle:NSLocalizedString(@"立即购买", nil) forState:UIControlStateNormal];
        [_submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateHighlighted];
        [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
        [_submitBnt addTarget:self action:@selector(clickSubmitIntegrationOrder) forControlEvents:UIControlEventTouchUpInside];
        _submitBnt.frame = FRAME(WIDTH - 100, 0, 100, 50);
        [_bottomView addSubview:_submitBnt];
        UIView *line = [UIView new];
        line.backgroundColor = LINE_COLOR;
        line.frame = FRAME(0, 0, WIDTH, 0.5);
        [_bottomView addSubview:line];
        [self refreshBottomView];
    }else{
        [self refreshBottomView];
    }
}
#pragma mark--===立即提交积分订单按钮点击事件
- (void)clickSubmitIntegrationOrder{
    
    __unsafe_unretained typeof(self)weakSelf = self;
    [JudgeToken judgeTokenWithVC:self withBlock:^{
        [weakSelf submitNetRequest];
    }];
}
#pragma mark--===提交网络请求
- (void)submitNetRequest{
    if(_addr_id.length == 0 || _addr_id == nil){
        [self showAlertView:NSLocalizedString(@"请选择地址", nil)];
    }else{
        SHOW_HUD
        NSString *mcart = [[JHIntegrationCartModel shareIntegrationCartModel] getMcart];
        NSDictionary *dic = @{@"addr_id":_addr_id,@"mcart":mcart};
        [HttpTool postWithAPI:@"client/mall/order/create" withParams:dic success:^(id json) {
            NSLog(@"%@",json);
            HIDE_HUD
            if([json[@"error"] isEqualToString:@"0"]){
                NSString * totalMoney = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalPayMoney];
                if (totalMoney.doubleValue == 0.0) {
                    JHIntegrationOrderListVC *listVC = [JHIntegrationOrderListVC new];
                    [self.navigationController pushViewController:listVC animated:YES];
                    [JHIntegrationCartModel shareIntegrationCartModel].integrationCartInfo = @[].mutableCopy;

                }else{

                    JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
                    vc.order_id = json[@"data"][@"order_id"];
                    vc.amount = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalPayMoney];
                    vc.isIntegration = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
               
            }else{
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"提交失败,原因:%@", nil),json[@"message"]]];
            }
            
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"%@",error.localizedDescription);
        }];
    }
    
}
#pragma mark--===刷新底部视图
- (void)refreshBottomView{
    _badgeLabel.text = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalNumer];
    if([_badgeLabel.text integerValue] <= 0){
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.hidden = NO;
    }
    NSString *totalMoney = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalPayMoney];
    NSString *totalJifen = [[JHIntegrationCartModel shareIntegrationCartModel] getTotalJifen];
    _totalPrice.text = [NSString stringWithFormat:@"¥%@ %@积分",totalMoney,totalJifen];
    NSMutableAttributedString *totalPriceAttributed = [[NSMutableAttributedString alloc] initWithString:_totalPrice.text];
    NSRange totalPriceRange1 = [_totalPrice.text rangeOfString:[NSString stringWithFormat:@"%@积分",totalJifen]];
    NSRange totalPriceRange2 = [_totalPrice.text rangeOfString:totalJifen];
    NSRange totalPriceRange3 = [_totalPrice.text rangeOfString:NSLocalizedString(@"积分", nil)];
    [totalPriceAttributed addAttributes:@{NSFontAttributeName:FONT(14)} range:totalPriceRange1];
    [totalPriceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:totalPriceRange2];
    [totalPriceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:totalPriceRange3];
    _totalPrice.attributedText = totalPriceAttributed;
    //运费
    _peiFee.text = [NSString stringWithFormat:@"¥%@",[[JHIntegrationCartModel shareIntegrationCartModel] getIntegrationFreight]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1)
        return _dataArray.count;
    else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2)
        return CGFLOAT_MIN;
    else
        return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 70 + _addressLabel.frame.size.height;
    else if(indexPath.section == 1)
        return 80;
    else
        return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACK_COLOR;
        [cell.contentView addSubview:_selectAddrBackView];
        return cell;
    }else if(indexPath.section == 1){
        static NSString *identifier = @"submitIntegrationCell";
        JHSubmitIntegrationOrderCell *cell = [_submitTableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[JHSubmitIntegrationOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        
        UIView *topLine = [UIView new];
        topLine.frame = FRAME(0, 0, WIDTH, 0.5);
        topLine.backgroundColor = LINE_COLOR;
        if(indexPath.row == 0)
            [cell.contentView addSubview:topLine];
        cell.addBnt.tag = indexPath.row + 1;
        cell.subBnt.tag = indexPath.row + 1;
        [cell.addBnt addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.subBnt addTarget:self action:@selector(clickSubButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell setDataDic:_dataArray[indexPath.row]];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 40)];
        title.font = FONT(14);
        title.textColor = HEX(@"333333", 1.0f);
        title.text = NSLocalizedString(@"总运费", nil);
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:_peiFee];
        for(int i = 0 ; i < 2; i++){
            UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 39.5 * i, WIDTH, 0.5)];
            line.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:line];
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        [JudgeToken judgeTokenWithVC:self withBlock:^{
            [self selectAddr];
        }];
        
    }
    
}
#pragma mark--====加号按钮点击事件
- (void)clickAddButton:(UIButton *)sender{
    NSDictionary *dataDic = [JHIntegrationCartModel shareIntegrationCartModel].integrationCartInfo[sender.tag - 1];
    JHSubmitIntegrationOrderCell *cell = [_submitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 1 inSection:1]];
    NSString *num = dataDic[@"product_number"];
    NSString *sku = dataDic[@"sku"];
    if([num integerValue] >= [sku integerValue]){
        [self showMaxNum];
        return;
    }
    cell.buyNumber.text = [NSString stringWithFormat:@"%ld",([num integerValue] + 1)];
    
    [[JHIntegrationCartModel shareIntegrationCartModel] addIntegrationCartInfoWithProduct_id:dataDic[@"product_id"]
                                                                           withProduct_title:dataDic[@"title"]
                                                                               withImage_url:dataDic[@"photo"]
                                                                                   withPrice:dataDic[@"price"]
                                                                                   withJifen:dataDic[@"jifen"]
                                                                                 withFreight:dataDic[@"freight"]
                                                                                     withSku:dataDic[@"sku"]];
    [self refreshBottomView];
    
}
#pragma mark--==减号点击事件
- (void)clickSubButton:(UIButton *)sender{
    JHSubmitIntegrationOrderCell *cell = [_submitTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 1 inSection:1]];
    if([cell.buyNumber.text integerValue] <= 0){
        return;
    }
    NSDictionary *dataDic = [JHIntegrationCartModel shareIntegrationCartModel].integrationCartInfo[sender.tag - 1];
    NSString *num = dataDic[@"product_number"];
    if([num integerValue] - 1 >= 0){
        cell.buyNumber.text = [NSString stringWithFormat:@"%ld",[num integerValue] - 1];
    }else{
        cell.buyNumber.text = @"0";
    }
    [[JHIntegrationCartModel shareIntegrationCartModel] removeIntegrationCartInfoWithProduct_id:dataDic[@"product_id"]];
    [self refreshBottomView];
    [_submitTableView reloadData];
    [self getDataSource];
    
}

#pragma mark==========地址点击事件============
- (void)selectAddr{
    NSLog(@"对地址进行操作");
    JHWaiMaiAddressVC *list = [[JHWaiMaiAddressVC alloc] init];

    list.selectorBlock = ^(JHWaimaiMineAddressListDetailModel *model) {
        if( model.contact.length == 0 || model.addr.length == 0){//img== nil
            _selectAddr.hidden = NO;
        }else{
            _selectAddr.hidden = YES;
//            _coordinateImg.image = img;
            _addressLabel.text = [NSString stringWithFormat:@"%@%@",model.addr,model.house];
            _basicLabel.text = [NSString stringWithFormat:@"%@ %@",model.contact,model.mobile];
            CGSize addressSize = [self currentSizeWithString:_addressLabel.text font:FONT(12) withWidth:70];
            _addressLabel.frame = FRAME(35, 60, WIDTH - 70, addressSize.height);
            _selectAddrBackView.frame = FRAME(0, 0, WIDTH, 70 + addressSize.height);
            self.addr_id = model.addr_id;
        }
        [_submitTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } ;
    [self.navigationController pushViewController:list animated:YES];
}
#pragma mark--===购物车无数据
- (void)showNoGood{
    if (_badgeToast == nil) {
        _badgeToast = [[DSToast alloc] initWithText:NSLocalizedString(@"您还没有选择商品", nil)];
        [_badgeToast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            _badgeToast = nil;
        }];
    }
}
#pragma mark--===购物车无数据
- (void)showMaxNum{
    if (_maxToast == nil) {
        _maxToast = [[DSToast alloc] initWithText:NSLocalizedString(@"库存不足!", nil)];
        [_maxToast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            _maxToast = nil;
        }];
    }
    
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

@end

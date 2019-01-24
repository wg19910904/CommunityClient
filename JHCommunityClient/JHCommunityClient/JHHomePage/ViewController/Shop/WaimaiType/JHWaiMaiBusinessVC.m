//
//  JHWaiMaiBusinessVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiBusinessVC.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "StarView.h"
 
#import "ShowAddressVC.h"
@interface JHWaiMaiBusinessVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, copy)NSDictionary *dataDic;
@property(nonatomic, copy)NSArray *imageArray;
@property(nonatomic,copy)NSDictionary *infoDic;
@end
#define DETAIL_TEXTCOLOR [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0]
@implementation JHWaiMaiBusinessVC
{
    NSString *phone_num;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = @[@"labelShou",@"labeJian",@"labelFu"];
    
    //请求数据
    [self loadNewData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark -请求数据
- (void)loadNewData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/waimai/shop/detail" withParams:@{@"shop_id":_shop_id}
                  success:^(id json) {
                      NSLog(@"client/shop/detail---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          _dataDic = json[@"data"][@"waimai_detail"];
                          phone_num = _dataDic[@"phone"];
                          [self createMainTableView];
                      }else{
                          [self showALertWithMsg:json[@"message"]];
                      }
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}
#pragma mark - 初始化表视图
- (void)createMainTableView
{
    if (!_mainTableView) {
        //初始化表视图
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 100) style:UITableViewStyleGrouped];
        _mainTableView.separatorStyle = 1;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_mainTableView];
    }else{
        [_mainTableView reloadData];
    }
    
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 2;
            break;
        case 2:
        {
            return 4;
        }
            break;
        case 3:
            num = 4;
            break;
            
        default:
            break;
    }
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0  ? 0.01 : 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat height = CGRectGetHeight(cell.frame);
    [cell removeFromSuperview];
    cell = nil;
    if (indexPath.section == 2) {
        return height;
    }else{
        return height > 40 ? height : 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    //------------- section 0 --------------------
    if (indexPath.section == 0) {
        //创建section 0 的cell
        UIView *firstCell = [self createSection_0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bounds = firstCell.frame;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:229/ 255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [cell addSubview:lineView];
        [cell.contentView addSubview:firstCell];
    }
    //------------ section1----------------------
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH- 20, 20)];
            titleLabel.text = NSLocalizedString(@"商家公告", nil);
            titleLabel.textColor = [UIColor colorWithRed:250/255.0 green:68/255.0 blue:39/255.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:12];
            
            cell.bounds = CGRectMake(0, 0, WIDTH, CGRectGetHeight(titleLabel.frame));
            
            [cell addSubview:titleLabel];
        }
        if (indexPath.row == 1) {
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH-20, 50)];
            contentLabel.text = _dataDic[@"delcare"];
            contentLabel.textColor = HEX(@"666666", 1.0);
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.numberOfLines = 0;
            [contentLabel sizeToFit];
            cell.bounds = CGRectMake(0, 0, WIDTH, CGRectGetHeight(contentLabel.frame) + 10);
            [cell addSubview:contentLabel];
        }
    }
    //------------section 2-----------------------
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH- 20, 40)];
            titleLabel.text = NSLocalizedString(@"商家活动", nil);
            titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:12];
            
            cell.bounds = CGRectMake(0, 0, WIDTH, CGRectGetHeight(titleLabel.frame));
            
            [cell addSubview:titleLabel];
            
        }
        if (indexPath.row == 1) {
            
            NSInteger rowNum = indexPath.row - 1;
            //为cell添加iv及Label
            UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14.5, 14, 14)];
            [cell.contentView addSubview:leftIV];
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.textColor = DETAIL_TEXTCOLOR;
            contentLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftIV.mas_right).mas_offset(@10);
                make.right.equalTo(cell.contentView).mas_offset(@(-10));
                make.top.equalTo(contentLabel.superview);
                make.bottom.equalTo(contentLabel.superview);
            }];
            leftIV.image = [UIImage imageNamed:_imageArray[rowNum]];
            contentLabel.numberOfLines = 0;contentLabel.text= [NSString stringWithFormat:NSLocalizedString(@"新用户下单立减%@元", nil),_dataDic[@"first_amount"]];
            [contentLabel sizeToFit];
            if ([_dataDic[@"first_amount"] integerValue] == 0) {
                cell.frame = CGRectMake(0, 0, WIDTH, 0);
                [leftIV removeFromSuperview];
                [contentLabel removeFromSuperview];
                leftIV = nil;
                contentLabel = nil;
            }
            
        }
        if (indexPath.row == 2) {
            
            NSInteger rowNum = indexPath.row - 1;
            //为cell添加iv及Label
            UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14.5, 14, 14)];
            [cell.contentView addSubview:leftIV];
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.textColor = DETAIL_TEXTCOLOR;
            contentLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftIV.mas_right).mas_offset(@10);
                make.right.equalTo(cell.contentView).mas_offset(@(-10));
                make.top.equalTo(contentLabel.superview);
                make.bottom.equalTo(contentLabel.superview);
            }];
            leftIV.image = [UIImage imageNamed:_imageArray[rowNum]];
            contentLabel.numberOfLines = 0;
            contentLabel.text= _dataDic[@"youhui_title"];
            [contentLabel sizeToFit];
            if ([_dataDic[@"youhui_title"] length] == 0) {
                cell.frame = CGRectMake(0, 0, WIDTH, 0);
                [leftIV removeFromSuperview];
                [contentLabel removeFromSuperview];
                leftIV = nil;
                contentLabel = nil;
            }
        }
        if (indexPath.row == 3) {
            
            NSInteger rowNum = indexPath.row - 1;
            //为cell添加iv及Label
            UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14.5, 14, 14)];
            [cell.contentView addSubview:leftIV];
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.textColor = DETAIL_TEXTCOLOR;
            contentLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftIV.mas_right).mas_offset(@10);
                make.right.equalTo(cell.contentView).mas_offset(@(-10));
                make.top.equalTo(contentLabel.superview);
                make.bottom.equalTo(contentLabel.superview);
            }];
            leftIV.image = [UIImage imageNamed:_imageArray[rowNum]];
            contentLabel.numberOfLines = 0;
            contentLabel.text= NSLocalizedString(@"商家支持在线支付", nil);
            [contentLabel sizeToFit];
            if ([_dataDic[@"online_pay"] integerValue] == 0) {
                cell.frame = CGRectMake(0, 0, WIDTH, 0);
                [leftIV removeFromSuperview];
                [contentLabel removeFromSuperview];
                leftIV = nil;
                contentLabel = nil;
            }
        }
        
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH- 20, 30)];
            titleLabel.text = NSLocalizedString(@"商家信息", nil);
            titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:12];
            
            cell.bounds = CGRectMake(0, 0, WIDTH, CGRectGetHeight(titleLabel.frame));
            
            [cell addSubview:titleLabel];
        }else if (indexPath.row == 1){
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH- 60, 30)];
            titleLabel.text = _dataDic[@"addr"];
            titleLabel.textColor = DETAIL_TEXTCOLOR;
            titleLabel.font = [UIFont systemFontOfSize:13];
            cell.bounds = CGRectMake(0, 0, WIDTH, CGRectGetHeight(titleLabel.frame));
            [cell addSubview:titleLabel];
            //添加右侧地理位置按钮
            UIButton *addressBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 40, 0, 40, 40)];
            [addressBtn setImage:IMAGE(@"order_postion") forState:(UIControlStateNormal)];
            [addressBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 11.5, 10, 11.5)];
            [addressBtn addTarget:self action:@selector(clickAddressBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell addSubview:addressBtn];
            
        }else if(indexPath.row == 2){
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH- 60, 30)];
            titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"营业时间:%@", nil),_dataDic[@"yy_time"]];
            titleLabel.textColor = DETAIL_TEXTCOLOR;
            titleLabel.font = [UIFont systemFontOfSize:13];
            cell.bounds = CGRectMake(0, 0, WIDTH, CGRectGetHeight(titleLabel.frame));
            [cell addSubview:titleLabel];
            
        }else{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH- 60, 30)];
            titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"联系商家: %@", nil),[phone_num stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
            titleLabel.textColor = DETAIL_TEXTCOLOR;
            titleLabel.font = [UIFont systemFontOfSize:13];
            cell.bounds = CGRectMake(0, 0, WIDTH, CGRectGetHeight(titleLabel.frame));
            [cell addSubview:titleLabel];
            //右侧添加电话按钮
            UIButton *phoneBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 40, 0, 40, 40)];
            [phoneBtn setImage:IMAGE(@"tg_phone") forState:(UIControlStateNormal)];
            [phoneBtn setImageEdgeInsets:UIEdgeInsetsMake(8.5, 8.5, 8.5, 8.5)];
            [phoneBtn addTarget:self action:@selector(clickPhoneBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell addSubview:phoneBtn];
        }
    }
    return cell;
}
#pragma mark - 点击地址按钮
- (void)clickAddressBtn:(UIButton *)addressBtn
{
    ShowAddressVC *addressVC = [[ShowAddressVC alloc]init];
    addressVC.titleString = _dataDic[@"title"];
    addressVC.lat = [_dataDic[@"lat"] doubleValue];
    addressVC.lng = [_dataDic[@"lng"] doubleValue];
    
    [self.navigationController pushViewController:addressVC animated:YES];
}
#pragma mark - 点击电话按钮
- (void)clickPhoneBtn:(UIButton *)phoneBtn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"联系商家", nil)
                                                                   message:[phone_num stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"TEL://%@",phone_num]]];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 创建section 0
- (UIView *)createSection_0
{
    UIView *firstCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    
    //创建左侧iv
    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_dataDic[@"logo"]]];
    [leftIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"shangping"]];
    
    //创建店名标签及星级标签
    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 150, 25)];
    shopNameLabel.text = _dataDic[@"title"];
    shopNameLabel.numberOfLines = 0;
    [shopNameLabel sizeToFit];
    shopNameLabel.font = [UIFont systemFontOfSize:13];
    shopNameLabel.textColor = DETAIL_TEXTCOLOR;
    
    //创建星级视图
    float starNO = [_dataDic[@"score"] integerValue] / [_dataDic[@"comments"] floatValue];
    UIView *starView = [StarView addEvaluateViewWithStarNO:(float)starNO
                                              withStarSize:11
                                         withBackViewFrame:CGRectMake(70,shopNameLabel.frame.size.height+10, 100, 25)];
    UILabel *numlabel = [[UILabel alloc] initWithFrame:FRAME(150, shopNameLabel.frame.size.height+7.5, 70, 25)];
    numlabel.text = [NSLocalizedString(@"月售 ", nil)  stringByAppendingString:_dataDic[@"orders"]?_dataDic[@"orders"]:@""];
    numlabel.font = FONT(11);
    numlabel.textColor = HEX(@"999999", 1.0);
    //添加第一个横分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 70, WIDTH, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:229/ 255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    //添加剩余的两个竖分割线
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 3, 75, 0.5, 40)];
    lineView3.backgroundColor = [UIColor colorWithRed:229/ 255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 3 * 2, 75, 0.5, 40)];
    lineView4.backgroundColor = [UIColor colorWithRed:229/ 255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    //添加起送价 , 平均送达时间 , 配送费 标签
    //-----起送价
    UILabel *deliverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, WIDTH / 3, 20)];
    deliverLabel.text = [NSString stringWithFormat:NSLocalizedString(@"¥ %@", nil),_dataDic[@"min_amount"]];
    deliverLabel.textColor = THEME_COLOR;
    deliverLabel.textAlignment = NSTextAlignmentCenter;
    deliverLabel.font = [UIFont systemFontOfSize:11];
    
    UILabel *deliverTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, WIDTH / 3, 20)];
    deliverTitleLabel.text =NSLocalizedString(@"起送金额", nil) ;
    deliverTitleLabel.textColor = DETAIL_TEXTCOLOR;
    deliverTitleLabel.textAlignment = NSTextAlignmentCenter;
    deliverTitleLabel.font = [UIFont systemFontOfSize:11];
    
    //-----平均送达时间
    UILabel *sendTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 3, 75, WIDTH / 3, 20)];
    sendTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@分钟", nil) ,_dataDic[@"pei_time"]];
    sendTimeLabel.textColor = THEME_COLOR;
    sendTimeLabel.textAlignment = NSTextAlignmentCenter;
    sendTimeLabel.font = [UIFont systemFontOfSize:11];
    
    UILabel *sendTimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 3, 90, WIDTH / 3, 20)];
    sendTimeTitleLabel.text = NSLocalizedString(@"平均送达时间", nil);
    sendTimeTitleLabel.textColor = DETAIL_TEXTCOLOR;
    sendTimeTitleLabel.textAlignment = NSTextAlignmentCenter;
    sendTimeTitleLabel.font = [UIFont systemFontOfSize:11];
    
    //-----配送费
    UILabel *packingFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 3 * 2, 75, WIDTH / 3, 20)];
    packingFeeLabel.textColor = THEME_COLOR;
    packingFeeLabel.textAlignment = NSTextAlignmentCenter;
    packingFeeLabel.font = [UIFont systemFontOfSize:11];
    if ([_dataDic[@"freight_price"] floatValue] <= 0) {
        packingFeeLabel.text = NSLocalizedString(@"免", nil) ;
    }else{
        packingFeeLabel.text = [NSLocalizedString(@"¥ ", nil) stringByAppendingString:_dataDic[@"freight_price"]?_dataDic[@"freight_price"]:@""];
    }
    UILabel *packingFeeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 3 * 2, 90, WIDTH / 3, 20)];
    packingFeeTitleLabel.text = NSLocalizedString(@"配送费", nil) ;
    packingFeeTitleLabel.textColor = DETAIL_TEXTCOLOR;
    packingFeeTitleLabel.textAlignment = NSTextAlignmentCenter;
    packingFeeTitleLabel.font = [UIFont systemFontOfSize:11];
    
    //添加第一个横分割线
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 119, WIDTH, 0.5)];
    lineView5.backgroundColor = [UIColor colorWithRed:229/ 255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    //添加到父视图
    [firstCell addSubview:leftIV];
    [firstCell addSubview:shopNameLabel];
    [firstCell addSubview:starView];
    [firstCell addSubview:numlabel];
    [firstCell addSubview:lineView2];
    [firstCell addSubview:lineView3];
    [firstCell addSubview:lineView4];
    [firstCell addSubview:lineView5];
    [firstCell addSubview:deliverLabel];
    [firstCell addSubview:deliverTitleLabel];
    [firstCell addSubview:sendTimeLabel];
    [firstCell addSubview:sendTimeTitleLabel];
    [firstCell addSubview:packingFeeLabel];
    [firstCell addSubview:packingFeeTitleLabel];
    
    return firstCell;
    
}
- (void)showALertWithMsg:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)  message:msg preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *clickAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:clickAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

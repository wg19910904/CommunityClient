//
//  JHShopHomepageVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHShopHomepageVC.h"
#import "StarView.h"
#import "JHSupermarketEvaluateCell.h"
#import "JHPhotoMainVC.h"
#import "StarView.h"
#import "JHShopEvaluateVC.h"
#import "JHTuanGouProductListVC.h"
#import "JHXianJinListVC.h"
#import "JHSupermarketMainVC.h"
#import "JHWaiMaiMainVC.h"
 
#import <UIImageView+WebCache.h>
#import "JHEvaluateCellModel.h"
#import "JHYouHuiOrderMainVC.h"

#import "JHShopHomePageWaiCell.h"
#import "JHShopHomePageQuanCell.h"
#import "JHShopHomePageTuanCell.h"
#import "JHPathMapVC.h"
#import "GaoDe_Convert_BaiDu.h"
#import "TitleBtnLeft.h"
#import "JHAddSeatVC.h"
#import "JHGetNumberVC.h"
#import "SeatModel.h"
#import "GetNumberModel.h"
#import "JHDetailOfSeatAndNumberVC.h"
#import "JHTempWebViewVC.h"
#import "ZQShareView.h"

@interface JHShopHomepageVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)ZQShareView *shareView;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIButton *youhui_btn;
@end

@implementation JHShopHomepageVC
{
    UIImageView *topIV;
    UIView *grayView;
    UIView *customNav;
    UIButton *backBtn_custom;
    NSMutableDictionary *height_dic;
    UIButton *morePicBtn;
    UILabel *title_;
    //保存页面的数据data
    NSDictionary *dataDic;
    //存储评价的model
    NSMutableArray *evaluateModelArray;
    //分享数据字典
    NSDictionary *shareDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    shareDic = @{};
    //初步请求数据
    [self loadNewData];
    height_dic = [@{} mutableCopy];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (shareDic.count > 0) {
        [self.shareView getCollectButtonSelected];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
#pragma mark - 请求新数据
- (void)loadNewData
{
    SHOW_HUD
    //请求商户详情数据
    [HttpTool postWithAPI:@"client/shop/detail"
               withParams:@{@"shop_id":_shop_id}
                  success:^(id json) {
                      NSLog(@"client/shop/detail---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          dataDic = json[@"data"][@"detail"];
                          evaluateModelArray = [@[] mutableCopy];
                          if ([dataDic[@"comment_detail"] count]>0) {
                              for (NSDictionary *dic in dataDic[@"comment_detail"]) {
                                  JHEvaluateCellModel *model = [[JHEvaluateCellModel alloc] init];
                                  [model setValuesForKeysWithDictionary:dic];
                                  [evaluateModelArray addObject:model];
                              }
                          }
                          shareDic = json[@"data"][@"share"];
                          [self createMaintableview];
                      }
                      
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
}
#pragma mark - 创建主表视图
- (void)createMaintableview
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.separatorColor = LINE_COLOR;
        _mainTableView.contentInset = UIEdgeInsetsMake(WIDTH/3*1.8, 0, 0, 0);
        _mainTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_mainTableView];
        [self createSubview];
    }else{
        [_mainTableView reloadData];
    }
}
- (void)createSubview
{
    topIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, WIDTH, WIDTH/3*1.8)];
    NSURL *imgURL = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:dataDic[@"banner"]]];
    grayView = [[UIView alloc] initWithFrame:topIV.bounds];
    grayView.backgroundColor = HEX(@"000000", .2);
    [topIV addSubview:grayView];
    [topIV sd_setImageWithURL:imgURL placeholderImage:IMAGE(@"5")];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(clickMorePicBtn)];
    topIV.userInteractionEnabled = YES;
    [topIV addGestureRecognizer:gesture];
    topIV.contentMode = UIViewContentModeScaleAspectFill;
    topIV.clipsToBounds = YES;
    //top添加更多图片按钮
    morePicBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 60, WIDTH/3*1.8-40, 50, 30)];
    morePicBtn.backgroundColor = HEX(@"000000", 0.5);
    [morePicBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@张", nil),dataDic[@"photo_count"]] forState:UIControlStateNormal];
    [morePicBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    morePicBtn.titleLabel.font = FONT(12);
    [morePicBtn addTarget:self action:@selector(clickMorePicBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [topIV addSubview:morePicBtn];
    [self.view addSubview:topIV];
    //创建自定义导航栏
    customNav = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, NAVI_HEIGHT)];
    customNav.backgroundColor = HEX(@"f96720", 0.0);
    [self.view addSubview:customNav];
    //添加返回按钮
    [self createBackBtn_cus];
}
#pragma mark - 创建左边按钮及文字及右边按钮
- (void)createBackBtn_cus
{
    backBtn_custom = [[UIButton alloc] initWithFrame:CGRectMake(5, STATUS_HEIGHT,40,40)];
    [backBtn_custom addTarget:self action:@selector(clickBackBtn)
             forControlEvents:UIControlEventTouchUpInside];
    backBtn_custom.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [backBtn_custom setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [customNav addSubview:backBtn_custom];
    title_ = [[UILabel alloc] initWithFrame:FRAME(0, 0, 150, 44)];
    title_.text = dataDic[@"title"];
    title_.font = FONT(18);
    title_.textColor = HEX(@"333333", 1);
    title_.textAlignment = NSTextAlignmentCenter;
    title_.alpha = 0.0f;
    [customNav addSubview:title_];
    title_.center = CGPointMake(customNav.center.x, customNav.center.y + 10);
    //右
    [self.shareView addShareBntAndCollectionBntWithVC:self withView:customNav withId:_shop_id type:@"1"];
    self.shareView.shareDic = shareDic;

}
#pragma mark - 点击导航栏左按钮
- (void)clickBackBtn
{
    
//    if ([[UserDefaults objectForKey:@"is_center"] boolValue]) {
//        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
//    }else
        [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - topIv点击手势
- (void)tapTopIV:(UITapGestureRecognizer *)gesture
{
    NSLog(@"点击了topIV");
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
            return 3;
            break;
        case 1:
            return 4;
            break;
        default:
            return MIN([evaluateModelArray count], 5);
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 2:
            return 40;
            break;
        default:
            return 0.01;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        //为第二个分区添加分区头
        UIView *headerView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
        headerView.backgroundColor = [UIColor clearColor];
        //添加子视图
        UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 10, WIDTH, 30)];
        backView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 150, 30)];
        
        titleLabel.text =
        [NSString stringWithFormat:NSLocalizedString(@"商家评价(%@)", nil),dataDic[@"comment_counts"]];
        titleLabel.font = FONT(11);
        titleLabel.textColor = HEX(@"333333", 1.0f);
        
        UILabel *allLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 150, 0, 140, 30)];
        allLabel.textColor = HEX(@"999999", 1.0f);
        allLabel.font = FONT(13);
        allLabel.text = NSLocalizedString(@"全部 >>", nil);
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(tapMoreEvaluate:)];
        allLabel.userInteractionEnabled = YES;
        [allLabel addGestureRecognizer:gesture];
        allLabel.textAlignment = NSTextAlignmentRight;
        //        CGFloat starNum;
        //        if ([dataDic[@"orders"] doubleValue] == 0) {
        //            starNum = 0.0;
        //        }else{
        //            starNum = [dataDic[@"score"] doubleValue]/[dataDic[@"comment_counts"] doubleValue];
        //            if (isnan(starNum) || isinf(starNum)) {
        //                starNum = 0.0;
        //            }
        //        }
        //
        //        UIView *starView = [StarView addEvaluateViewWithStarNO:MIN(starNum, 5.0) withStarSize:11 withBackViewFrame:FRAME(10, 30, 80, 13)];
        //
        //        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:FRAME(90, 33, 50, 13)];
        //        scoreLabel.font = FONT(12);
        //        scoreLabel.textColor = HEX(@"999999", 1.0f);
        //        scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%3.1f分", nil),MIN(starNum, 5.0)];
        //
        //        UILabel *statusLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 120, 33, 110, 13)];
        //        statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"高于%@的同行", nil),dataDic[@"percent"]];
        //        statusLabel.font = FONT(12);
        //        statusLabel.textColor = HEX(@"333333", 1.0f);
        //        statusLabel.textAlignment = NSTextAlignmentRight;
        //
        [backView addSubview:titleLabel];
        [backView addSubview:allLabel];
        //        [backView addSubview:starView];
        //        [backView addSubview:scoreLabel];
        //        [backView addSubview:statusLabel];
        //
        [headerView addSubview:backView];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            if (row == 0) {
                return 55;
            }else{
                return 40;
            }
            
        }
            break;
        case 1:
        {
            if (row == 0) {//---waimai---
                
                return [JHShopHomePageWaiCell getHeight:dataDic[@"have_waimai"]];
                
            }else if (row == 1){//----hui---
                if ([dataDic[@"have_maidan"] integerValue] == 0) return 0;
                return 40;
                
            }else if (row == 2){//----quan----
                
                return [JHShopHomePageQuanCell getHeightWithHaveQuan:dataDic[@"have_quan"]
                                                             withDic:dataDic[@"quan_detail"]];
                
            }else{//----tuan----
                
                return [JHShopHomePageTuanCell getHeightWith:dataDic[@"have_tuan"] withDic:dataDic[@"tuan_detail"]];
                
            }
        }
            break;
        default:
        {
            NSString *key = [NSString stringWithFormat:@"%ld-%ld",section,row];
            CGFloat height;
            if (height_dic[key]) {
                height = [height_dic[key] floatValue];
            }else{
                UITableViewCell *cell = (UITableViewCell *)[self tableView:_mainTableView cellForRowAtIndexPath:indexPath];
                height = CGRectGetHeight(cell.frame);
                [cell removeFromSuperview];
                cell = nil;
                [height_dic addEntriesFromDictionary:@{key:@(height)}];
            }
            return height;
        }
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            if (row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //添加title
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 150, 35)];
                titleLabel.text = dataDic[@"title"];
                titleLabel.adjustsFontSizeToFitWidth = YES;
                titleLabel.font = FONT(16);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                //添加星级视图
                CGFloat starNum;
                starNum = [dataDic[@"score"] doubleValue]/[dataDic[@"comment_counts"] doubleValue];
                if (isnan(starNum) || isinf(starNum)) {
                    starNum = 0.0;
                }
                
                UIView *starView = [StarView addEvaluateViewWithStarNO:MIN(starNum,5.0)  withStarSize:12 withBackViewFrame:FRAME(10, 30, 100, 15)];
                UILabel *scoreLabel = [[UILabel alloc] initWithFrame:FRAME(100,33,200, 15)];
                scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%3.1f分  人均: ¥%g", nil),MIN(starNum,5.0),[dataDic[@"avg_amount"] doubleValue]];
                scoreLabel.font = FONT(12);
                scoreLabel.textColor = HEX(@"999999", 1.0f);
                [cell addSubview:titleLabel];
                [cell addSubview:starView];
                [cell addSubview:scoreLabel];
                cell.frame = FRAME(0, 0, WIDTH, 55);
                //添加优惠买单按钮
                _youhui_btn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 95, 10, 85, 35)];
                [_youhui_btn setBackgroundColor:SPECIAL_COLOR
                                       forState:(UIControlStateNormal)];
                [_youhui_btn setBackgroundColor:SPECIAL_COLOR_DOWN
                                       forState:(UIControlStateHighlighted)];
                [_youhui_btn setTitle:NSLocalizedString(@"优惠买单", nil) forState:(UIControlStateNormal)];
                _youhui_btn.titleLabel.font = FONT(16);
                _youhui_btn.layer.cornerRadius = 4;
                _youhui_btn.layer.masksToBounds = YES;
                [_youhui_btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                [_youhui_btn addTarget:self action:@selector(clickYouHuiBtn:)
                      forControlEvents:(UIControlEventTouchUpInside)];
                [cell addSubview:_youhui_btn];
                //添加上边线
                UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
                lineView.backgroundColor = LINE_COLOR;
                [cell addSubview:lineView];
                return cell;
            }else if(row == 1){
                
                
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                //添加子视图
                UIImageView * iv = [[UIImageView alloc] initWithFrame:FRAME(10, 14.5, 10, 14)];
                iv.image = IMAGE(@"zuobaio2");
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 0, WIDTH - 90, 40)];
                titleLabel.text = dataDic[@"addr"];
                titleLabel.font = FONT(13);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                [cell addSubview:iv];
                [cell addSubview:titleLabel];
                
                //添加电话按钮
                UIButton *phoneBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 60, 0, 60, 40)];
                [phoneBtn setImage:IMAGE(@"call-1") forState:(UIControlStateNormal)];
                phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
                [phoneBtn addTarget:self action:@selector(phoneCall) forControlEvents:(UIControlEventTouchUpInside)];
                [cell addSubview:phoneBtn];
                cell.frame = FRAME(0, 0, WIDTH, 40);
                return cell;
                
            }else{
                
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                CGFloat btnW=WIDTH/2.0;
                CGFloat btnH=40;
                CGFloat btnCenterX=-btnW;
                NSArray *imgArr=@[@"iocn-paihao",@"icon-din"];
                NSArray *titleArr=@[NSLocalizedString(@"  排号", nil) ,NSLocalizedString(@"  订座", nil)];
                for (NSInteger i=0; i<2; i++) {
                    UIButton *btn=[UIButton new];
                    [cell.contentView addSubview:btn];
                    if (i==0) btnCenterX= -WIDTH/4;
                    if (i==1) btnCenterX= WIDTH/4;
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.offset=btnCenterX;
                        make.top.offset=0;
                        make.width.offset=btnW;
                        make.height.offset=btnH;
                    }];
                    btn.titleLabel.font=FONT(14);
                    btn.imageView.contentMode=UIViewContentModeCenter;
                    btn.tag=500+i;
                    
                    [btn setImage:IMAGE(imgArr[i]) forState:UIControlStateNormal];
                    [btn setTitle:titleArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(onClickSeat:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i!=0) {
                        UIView *lineView=[UIView new];
                        [cell.contentView addSubview:lineView];
                        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.offset=btnW*i;
                            make.top.offset=0;
                            make.width.offset=0.5;
                            make.height.offset=btnH;
                        }];
                        lineView.backgroundColor=LINE_COLOR;
                    }
                    
                }
                
                return cell;
            }
        }
            break;
        case 1:
        {
            switch (row) {
                case 0:  //------waimai----
                {
                    JHShopHomePageWaiCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHShopHomePageWaiCellID"];
                    if (!cell) {
                        cell = [[JHShopHomePageWaiCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                            reuseIdentifier:@"JHShopHomePageWaiCellID"];
                    }
                    [JHShopHomePageWaiCell getHeight:dataDic[@"have_waimai"]];
                    cell.dataDic = dataDic[@"waimai_detail"];
                    return cell;
                }
                    break;
                case 1:  //------hui----
                {
                    if ([dataDic[@"have_maidan"] integerValue] == 0 ||
                        ![dataDic[@"maidan_detail"] isKindOfClass:[NSDictionary class]]) {
                        UITableViewCell *cell = [[UITableViewCell alloc] init];
                        cell.frame = FRAME(0, 0, WIDTH, 0);
                        _youhui_btn.hidden = YES;
                        return cell;
                    }
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    //添加左侧图片
                    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 12, 16, 16)];
                    leftIV.image = IMAGE(@"hui");
                    cell.frame = FRAME(0, 0, WIDTH, 40);
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:FRAME(30,0, 200, 40)];
                    contentLabel.text = dataDic[@"maidan_detail"][@"title"];
                    contentLabel.font = FONT(13);
                    contentLabel.textColor = HEX(@"333333", 1.0f);
                    //添加已售数量按钮
                    UILabel *rightLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 130, 20, 100, 30)];
                    UIImageView *rightIV = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 19, 12.5, 9, 15)];
                    rightIV.image = IMAGE(@"jiantou_1");
                    NSInteger num = [dataDic[@"maidan_detail"][@"orders"] integerValue];
                    rightLabel.text = [NSString stringWithFormat:NSLocalizedString(@"已售%ld", nil),num];
                    rightLabel.font = FONT(12);
                    rightLabel.textColor = HEX(@"999999", 1.0f);
                    rightLabel.textAlignment = NSTextAlignmentRight;
                    [cell addSubview:rightIV];
                    rightLabel.center = CGPointMake(rightLabel.center.x, cell.center.y);
                    [cell addSubview:rightLabel];
                    [cell addSubview:leftIV];
                    [cell addSubview:contentLabel];
                    return cell;
                }
                    break;
                case 2:  //------quan----
                {
                    JHShopHomePageQuanCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHShopHomePageQuanCell"];
                    if (!cell) {
                        cell = [[JHShopHomePageQuanCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                             reuseIdentifier:@"JHShopHomePageQuanCell"];
                    }
                    [JHShopHomePageQuanCell getHeightWithHaveQuan:dataDic[@"have_quan"]
                                                          withDic:dataDic[@"quan_detail"]];
                    cell.dataDic = dataDic[@"quan_detail"];
                    cell.navVC = self.navigationController;
                    [cell setClickMoreBtnBlock:^{
                        JHXianJinListVC *vc = [[JHXianJinListVC alloc] init];
                        vc.shop_id = _shop_id;
                        vc.titleString = [title_.text stringByAppendingString:NSLocalizedString(@"-现金券", nil)];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    return cell;
                }
                    break;
                    
                default:
                {
                    
                    JHShopHomePageTuanCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHShopHomePageTuanCell"];
                    if (!cell) {
                        cell = [[JHShopHomePageTuanCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                             reuseIdentifier:@"JHShopHomePageTuanCell"];
                    }
                    [JHShopHomePageTuanCell getHeightWith:dataDic[@"have_tuan"] withDic:dataDic[@"tuan_detail"]];
                    cell.dataDic = dataDic[@"tuan_detail"];
                    cell.navVC = self.navigationController;
                    [cell setClickMoreBtnBlock:^{
                        JHTuanGouProductListVC *vc = [[JHTuanGouProductListVC alloc] init];
                        vc.shop_id = _shop_id;
                        vc.titleString = [title_.text stringByAppendingString:NSLocalizedString(@"-团购", nil)];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }];
                    return cell;
                }
                    break;
            }
            
        }
        default:
        {
            JHSupermarketEvaluateCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHShopHomePageCellID"];
            if (!cell) {
                cell = [[JHSupermarketEvaluateCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHShopHomePageCellID"];
            }
            cell.dataModel = (JHEvaluateCellModel *)evaluateModelArray[row];
            return cell;
        }
            break;
    }
}

#pragma mark ======排队的按钮=======
-(void)onClickSeat:(UIButton *)btn{
    
    switch (btn.tag-500) {
        case 0://排号
        {
            if([dataDic[@"have_paidui"] isEqualToString:@"0"]){
                [self showMsg:NSLocalizedString(@"该商家还未开通排队功能!", nil)];
                return;
            }
            
            [GetNumberModel checkOutHaveOrder:self.shop_id block:^(NSString *order_id, NSString *msg) {
                if (!msg) {
                    if(order_id){
                        JHDetailOfSeatAndNumberVC * vc = [JHDetailOfSeatAndNumberVC new];
                        vc.order_id = order_id;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        JHGetNumberVC * vc = [JHGetNumberVC new];
                        vc.shop_id = self.shop_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }else{
                    
                    [self showMsg:msg];
                }
            }];
            
        }
            break;
        case 1://订座
        {
            if([dataDic[@"have_dingzuo"] isEqualToString:@"0"]){
                [self showMsg:NSLocalizedString(@"该商家还未开通订座功能!", nil)];
                return;
            }
            [SeatModel checkOutHaveOrder:self.shop_id block:^(NSString *order_id, NSString *msg) {
                if (!msg) {
                    if(order_id){
                        JHDetailOfSeatAndNumberVC * vc = [JHDetailOfSeatAndNumberVC new];
                        vc.order_id = order_id;
                        vc.is_seat = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        JHAddSeatVC * vc = [JHAddSeatVC new];
                        vc.shop_id = self.shop_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }else{
                    
                    [self showMsg:msg];
                }
            }];
            
        }
            break;
        case 2://点餐
        {
            if([dataDic[@"have_weidian"] isEqualToString:@"0"]){
                [self showMsg:NSLocalizedString(@"该商家还未开通微店功能!", nil)];
                return;
            }else{
                JHTempWebViewVC *web = [[JHTempWebViewVC alloc] init];
                web.isWeidian = YES;
                web.url = dataDic[@"weidian_link"];
                [self.navigationController pushViewController:web animated:YES];
            }
        }
            break;
        default:
            break;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (section) {
        case 0:
        {
            if (row == 1) {
                //跳转到地图界面
                JHPathMapVC *vc = [[JHPathMapVC alloc] init];
                double latG;
                double lngG;
                [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[dataDic[@"lat"] doubleValue]
                                                             WithBD_lon:[dataDic[@"lng"] doubleValue]
                                                             WithGD_lat:&latG
                                                             WithGD_lon:&lngG];
                vc.lat = @(latG).description;
                vc.lng = @(lngG).description;
                vc.shopName = dataDic[@"title"];
                vc.shopAddr = dataDic[@"addr"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case 1:
        {
            if (row == 0) {
                NSString *type = dataDic[@"waimai_detail"][@"tmpl_type"];
                if ([type isEqualToString:@"waimai"]) {
                    JHWaiMaiMainVC *vc = [[JHWaiMaiMainVC alloc] init];
                    vc.shop_id = _shop_id;
//                    vc.restStatus = dataDic[@"waimai_detail"][@"yysj_status"];
//                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    JHSupermarketMainVC *vc = [JHSupermarketMainVC new];
                    vc.shop_id = _shop_id;
                    vc.restStatus = dataDic[@"waimai_detail"][@"yysj_status"];
//                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            if (row == 1) {
                
                [self clickYouHuiBtn:_youhui_btn];
            }
            if (row == 2) {
                
                JHXianJinListVC *vc = [[JHXianJinListVC alloc] init];
                vc.shop_id = _shop_id;
                vc.titleString = [title_.text stringByAppendingString:NSLocalizedString(@"-现金券", nil) ];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (row == 3) {
                JHTuanGouProductListVC *vc = [[JHTuanGouProductListVC alloc] init];
                vc.shop_id = _shop_id;
                vc.titleString = [title_.text stringByAppendingString:NSLocalizedString(@"-团购", nil) ];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_y = scrollView.contentOffset.y;
    topIV.frame = FRAME(0, 0, WIDTH, -offset_y);
    grayView.frame = topIV.bounds;
    morePicBtn.center = CGPointMake(morePicBtn.center.x, -offset_y - 20);
    CGFloat alpha = (offset_y+(WIDTH/3*1.8))/(WIDTH/3*1.8);
    customNav.backgroundColor = HEX(@"f8f8f8", alpha);
    title_.alpha = alpha;
}
#pragma mark - 点击更多评价
- (void)tapMoreEvaluate:(UITapGestureRecognizer *)gesture
{
    NSLog(@"点击了更多评价");
    JHShopEvaluateVC *vc = [[JHShopEvaluateVC alloc] init];
    vc.API = @"client/shop/comment/items";
    vc.paramsDic = [self handleDataDic];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 点击顶部图片上的更多按钮
- (void)clickMorePicBtn
{
    NSLog(@"点击了更多图片按钮");
    JHPhotoMainVC *vc = [[JHPhotoMainVC alloc] init];
    vc.shop_id = _shop_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击优惠买单按钮
- (void)clickYouHuiBtn:(UIButton *)sender
{
    NSLog(@"点击优惠买单按钮");
    JHYouHuiOrderMainVC *vc = [[JHYouHuiOrderMainVC alloc]init];
    vc.shop_id = _shop_id;
    vc.titleString = dataDic[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击电话按钮
- (void)phoneCall
{
    NSString *phone_num = dataDic[@"phone"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"联系商家", nil)
                                                                   message:phone_num
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"TEL://%@",phone_num]]];
                                                    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 处理下个界面所需参数
- (NSDictionary *)handleDataDic
{
    NSDictionary *paramsDic = @{@"shop_id":_shop_id};
    return paramsDic;
}

-(ZQShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ZQShareView alloc]init];
        _shareView.isUrlImg = YES;
        _shareView.superVC = self;
    }
    return _shareView;
}

@end

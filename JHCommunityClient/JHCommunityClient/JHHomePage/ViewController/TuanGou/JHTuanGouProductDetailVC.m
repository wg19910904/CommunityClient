//
//  JHTuanGouDetailVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouProductDetailVC.h"
#import "JHTuanGouDetailCellOne.h"
#import "JHTuanGouProductListCell.h"
#import "JHSupermarketEvaluateCell.h"
#import "JHShopEvaluateVC.h"
#import "JHTuanGouListVC.h"
#import "JHTuanGouDetailCellTwo.h"
#import "JHTuanGouProductDetailVC.h"
 
#import "JHTuanGouDetialCellOneModel.h"
#import "JHTuanGouProductListCellModel.h"
#import "JHEvaluateCellModel.h"
#import "JHShareModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHTuanGouProductListVC.h"
#import "JHTuanGouProductPhotoDetailVC.h"
#import "JHTuanGouOrderVC.h"
#import "ZQShareView.h"

@interface JHTuanGouProductDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *mainTableView;
@property(nonatomic,strong)ZQShareView *shareView;
@end
@implementation JHTuanGouProductDetailVC
{
    CGFloat height_iv;
    NSMutableDictionary *height_dic;
   
    //评价页数
    NSInteger page;
    JHTuanGouDetialCellOneModel *cellModel;
    //存储其他团购和评价的模型数组
    NSMutableArray *otherModelArray;
    NSMutableArray *commentsModelArray;
    //存储参数字典
    NSMutableDictionary *paramsDic;
    //存储当前团购商品的shop_id
    NSString *_shop_id;
    
    //分享的字典
    NSDictionary *shareDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self neededInfo];
    //处理网络请求
    [self loadNewData];
}
#pragma mark - 设置基本信息
- (void)neededInfo
{
    self.navigationItem.title = NSLocalizedString(@"团购详情", nil);
    height_iv = 160*WIDTH/320;
    height_dic = [@{} mutableCopy];
    shareDic = @{};
}

#pragma mark - 处理参数
- (void)handleParams
{
   
    double bd_lat;
    double bd_lon;
    //获取当前位置
    JHShareModel *shareModel = [JHShareModel shareModel];
    //在请求前将高德坐标转换为百度坐标
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:shareModel.lat
                                                 WithGD_lon:shareModel.lng
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    paramsDic = [@{@"lat":@(bd_lat),
                   @"lng":@(bd_lon),
                   @"tuan_id":_tuan_id} mutableCopy];
    
}
#pragma mark - 处理第一次数据请求
- (void)loadNewData
{
    SHOW_HUD
    [self handleParams];
    [HttpTool postWithAPI:@"client/tuan/detail"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/tuan/detail---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          cellModel = [[JHTuanGouDetialCellOneModel alloc]init];
                          [cellModel setValuesForKeysWithDictionary:json[@"data"][@"detail"]];
                          _shop_id = json[@"data"][@"detail"][@"shop_id"];
                          self.shareView.can_id = _shop_id;

                          //创建其他团购模型数组
                          if (cellModel.other.count > 0) {
                              otherModelArray = [@[] mutableCopy];
                              for (NSDictionary *dic in cellModel.other) {
                                  JHTuanGouProductListCellModel *model = [JHTuanGouProductListCellModel new];
                                  [model setValuesForKeysWithDictionary:dic];
                                  [otherModelArray addObject:model];
                              }
                          }
                          //创建评价模型数组
                          if (cellModel.comment_list.count > 0) {
                              commentsModelArray = [@[] mutableCopy];
                              for (NSDictionary *dic in cellModel.comment_list) {
                                  JHEvaluateCellModel *model = [JHEvaluateCellModel new];
                                  [model setValuesForKeysWithDictionary:dic];
                                  [commentsModelArray addObject:model];
                              }
                              
                          }
                          [self createMainTableView];
                          shareDic = json[@"data"][@"share"];
                          self.shareView.shareDic = shareDic;
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
#pragma mark - 初始化主表视图
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
-  (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.rightBarButtonItems = nil;
    [self addShareBtn];
    
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else if (section == 2){
        return [cellModel.other count];
    }else{
        return [cellModel.comment_list count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 30;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = @[NSLocalizedString(@"购买须知", nil),NSLocalizedString(@"其他", nil),NSLocalizedString(@"全部评价", nil)];
    UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 30)];
    backView.backgroundColor = BACK_COLOR;
    if (section > 0) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 30)];
        titleLabel.text = titleArray[section - 1];
        titleLabel.textColor = HEX(@"333333", 1.0f);
        titleLabel.font = FONT(13);
        [backView addSubview:titleLabel];
        //添加全部label
        if (section == 2 || section == 3) {
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 30)];
            rightLabel.text = NSLocalizedString(@"全部 >>", nil);
            rightLabel.textColor = HEX(@"999999", 1.0f);
            rightLabel.font = FONT(11);
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAllBtn:)];
            rightLabel.tag = section;
            [rightLabel addGestureRecognizer:gesture];
            [backView addSubview:rightLabel];
        }
        return backView;
    }else{
        return backView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
    if (!height_dic[key]) {
        UITableViewCell *cell = (UITableViewCell *)[self tableView:_mainTableView cellForRowAtIndexPath:indexPath];
        CGFloat height = CGRectGetHeight(cell.frame);
        [height_dic addEntriesFromDictionary:@{key:@(height)}];
        [cell removeFromSuperview];
        cell = nil;
        return height;
    }else{
        return [height_dic[key] floatValue];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            JHTuanGouDetailCellOne *cell = [[JHTuanGouDetailCellOne alloc] initWithFrame:FRAME(0, 0, WIDTH,height_iv+60+75)];
            cell.dataModel = cellModel;
            [cell.orderBtn addTarget:self action:@selector(clickOrderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
        }
            break;
        case 1:
        {
            JHTuanGouDetailCellTwo *detailCell =[_mainTableView dequeueReusableCellWithIdentifier:@"JHTuanGouDetailCellTwo"];
            if (!detailCell) {
                detailCell = [[JHTuanGouDetailCellTwo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHTuanGouDetailCellTwo"];
            }
            detailCell.dataModel = cellModel;
            [detailCell.detailBtn addTarget:self action:@selector(tapDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
                return detailCell;
    
        }
            break;
        case 2:
        {
            JHTuanGouProductListCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHTuanGouDetailCellID1"];
            if (!cell) {
                cell = [[JHTuanGouProductListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHTuanGouDetailCellID1"];
            }
            cell.dataModel = (JHTuanGouProductListCellModel *)otherModelArray[indexPath.row];
            return cell;
        }
            break;
        case 3:
        {
            JHSupermarketEvaluateCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHTuanGouDetailCellID2"];
            if (!cell) {
                cell = [[JHSupermarketEvaluateCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHTuanGouDetailCellID2"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataModel = (JHEvaluateCellModel *)commentsModelArray[indexPath.row];
            return cell;
        }
            break;
            
        default:
        {
            UITableViewCell *cell = [UITableViewCell new];
            return cell;
        }
    } 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 2) {
        //重新创建一个团购详情界面
        JHTuanGouProductListCellModel *model = (JHTuanGouProductListCellModel *)otherModelArray[row];
        JHTuanGouProductDetailVC *vc = [[JHTuanGouProductDetailVC alloc] init];
        vc.tuan_id = model.tuan_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 点击图文详情标签
- (void)tapDetailBtn:(UIButton *)sender
{
    NSLog(@"点击了图文详情标签");
    JHTuanGouProductPhotoDetailVC *vc = [[JHTuanGouProductPhotoDetailVC alloc] init];
    vc.dataModel = cellModel;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 点击全部按钮
- (void)clickAllBtn:(UITapGestureRecognizer *)gesture
{
    UIView *currentView = gesture.view;
    if (currentView.tag == 2) {
        NSLog(@"跳转到其他团购列表");
        JHTuanGouProductListVC *vc = [[JHTuanGouProductListVC alloc] init];
        vc.titleString = NSLocalizedString(@"其他", nil);
        vc.shop_id = _shop_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"跳转到全部评价界面");
        JHShopEvaluateVC *vc = [[JHShopEvaluateVC alloc] init];
        //处理参数
        vc.API = @"client/shop/comment/items";
        vc.paramsDic = [self handleDataDic];
        vc.hidesBottomBarWhenPushed = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark - 处理下个界面所需参数
- (NSDictionary *)handleDataDic
{
    NSDictionary *dataDic = @{@"shop_id":_shop_id};
    return dataDic;
}
#pragma mark - 点击下单按钮
- (void)clickOrderBtn:(UIButton *)sender
{
    JHTuanGouOrderVC *vc = [[JHTuanGouOrderVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.cellModel = cellModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 增加分享按钮和收藏按钮
- (void)addShareBtn
{
    [self.shareView addShareBntAndCollectionBntWithVC:self withId:_shop_id ? _shop_id : @"" type:@"1"];
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end

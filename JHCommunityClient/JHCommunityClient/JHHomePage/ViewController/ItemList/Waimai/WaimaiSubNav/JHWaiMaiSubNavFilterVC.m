//
//  JHWaiMaiSubNavClassifyVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiSubNavFilterVC.h"

@interface JHWaiMaiSubNavFilterVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,assign)NSInteger selectRow;
@end

@implementation JHWaiMaiSubNavFilterVC
{
    NSArray *titleArray;
    NSArray *typeArray;
    NSArray *iconImgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT - (NAVI_HEIGHT+40));
    self.view.backgroundColor = HEX(@"000000", 0.3);
    //处理数据源
    [self handleData];
    //创建左右表视图
    [self createTables];
    
}
#pragma mark - 处理数据
- (void)handleData
{
    titleArray = @[NSLocalizedString(@"新店开业", nil),NSLocalizedString(@"在线支付", nil),NSLocalizedString(@"首单优惠", nil),NSLocalizedString(@"下单立减", nil)];
    typeArray = @[@"is_new",@"online_pay",@"youhui_first",@"youhui_order"];
    iconImgArray = @[@"xindain",@"zaixianzhifu",@"shoudanyouhui",@"xaidanlijian"];
}
#pragma mark - 创建表视图
- (void)createTables
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 160)
                                                      style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = YES;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(45, 0, WIDTH - 45, 40)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    titleLabel.text = titleArray[indexPath.row];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = FONT(12);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    titleLabel.tag = 100;
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.image = IMAGE(iconImgArray[indexPath.row]);
    [cell.contentView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(cell.contentView);
        make.left.offset = 15;
    }];
    UIImageView *dirImg = [UIImageView new];
    [cell.contentView addSubview:dirImg];
    dirImg.tag = 200;
    dirImg.image = IMAGE(@"selected-0");
    dirImg.hidden = YES;
    [dirImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -20;
        make.size.mas_equalTo(CGSizeMake(15,10));
        make.centerY.equalTo(cell.contentView);
    }];

    if (_selectRow && (indexPath.row == _selectRow)) {
        
        titleLabel.textColor = THEME_COLOR;
        
    }
    //添加下划线
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.backgroundColor = LINE_COLOR.CGColor;
    lineLayer.frame = FRAME(0, 0, WIDTH, 0.5);
    if(indexPath.row != 0){
        [cell.layer addSublayer:lineLayer];
    }
    [cell addSubview:titleLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = THEME_COLOR;
    UIImageView *dirImg = [cell.contentView viewWithTag:200];
    dirImg.hidden = NO;
    //记录当前的点击的行数
    _selectRow = indexPath.row;
    //构建参数
    NSDictionary *paramDic = @{@"filter":typeArray[indexPath.row]};
    _refreshBlock(paramDic);
    _refreshBtnTitleBlock(titleArray[indexPath.row]);
    [self touch_BackView];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = HEX(@"333333", 1.0f);
    UIImageView *dirImg = [cell.contentView viewWithTag:200];
    dirImg.hidden = YES;
}
- (void)touch_BackView
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"JHDeleteNavVCNotificationName" object:self userInfo:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end

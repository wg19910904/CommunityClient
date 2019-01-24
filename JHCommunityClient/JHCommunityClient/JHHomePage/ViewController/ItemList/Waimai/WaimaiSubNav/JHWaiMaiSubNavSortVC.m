//
//  JHWaiMaiSubNavClassifyVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiSubNavSortVC.h"

@interface JHWaiMaiSubNavSortVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,copy)NSArray *titleArray;
@property (nonatomic,copy)NSArray *iconArray;
@property(nonatomic,assign)NSInteger selectRow;
@end

@implementation JHWaiMaiSubNavSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT - (NAVI_HEIGHT+40));
    self.view.backgroundColor = HEX(@"000000", 0.3);
    //创建数据源
    //创建左右表视图
    [self createTables];
    
}
#pragma mark - 处理数据源
- (NSArray *)titleArray
{
    return @[NSLocalizedString(@"智能排序", nil),NSLocalizedString(@"配送最快", nil),NSLocalizedString(@"距离最近", nil),
             NSLocalizedString(@"销量最好", nil),NSLocalizedString(@"好评优先", nil),NSLocalizedString(@"起送价最低", nil)];
    
}
- (NSArray *)iconArray{
    return @[@"shop_sort01",@"shop_sort02",@"shop_sort03",@"shop_sort04",@"shop_sort06",@"shop_sort05"];
}
#pragma mark - 创建表视图
- (void)createTables
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 240.5)
                                                      style:(UITableViewStyleGrouped)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = YES;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        _mainTableView.backgroundView = view;
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(45, 13, WIDTH - 45, 14)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    titleLabel.text = self.titleArray[indexPath.row];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = FONT(12);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    titleLabel.tag = 100;
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.image = IMAGE(self.iconArray[indexPath.row]);
    [cell.contentView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(cell.contentView);
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
    NSArray *paramArray = @[@"",@"time",@"juli",@"sales",@"score",@"price"];
    //构建参数
    NSDictionary *paramDic = @{@"order":paramArray[indexPath.row]};
    _refreshBlock(paramDic);
    _refreshBtnTitleBlock(self.titleArray[indexPath.row]);
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

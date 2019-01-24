//
//  JHNavSortVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouSubNavSortVC.h"

@interface JHTuanGouSubNavSortVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSArray *dataArray;
@property(nonatomic,assign)NSInteger selectRow;
@end

@implementation JHTuanGouSubNavSortVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, NAVI_HEIGHT+40, WIDTH, HEIGHT - NAVI_HEIGHT-40);
    self.view.backgroundColor = HEX(@"000000", 0.3);
    //创建右表视图
    [self createTable];
    
}
//构建数据源
- (NSArray *)dataArray
{
    NSArray *temArray = @[@{@"title":NSLocalizedString(@"智能排序", nil),@"type":@"",@"img":@"shop_sort01"},
                          @{@"title":NSLocalizedString(@"离我最近", nil),@"type":@"juli",@"img":@"shop_sort03"},
                          @{@"title":NSLocalizedString(@"好评优先", nil),@"type":@"score",@"img":@"shop_sort06"},
                          @{@"title":NSLocalizedString(@"人均最低", nil),@"type":@"avg_amount",@"img":@"shop_sort05"}];
    _dataArray = temArray;
    return _dataArray;
}
#pragma mark - 创建表视图
- (void)createTable
{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 160)
                                                  style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = HEX(@"f5f5f5", 1.0f);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = YES;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(45, 13, WIDTH - 45, 14)];
    titleLabel.font = FONT(12);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    titleLabel.tag = 100;
    titleLabel.text = self.dataArray[indexPath.row][@"title"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.contentMode = UIViewContentModeScaleAspectFit;
    iconImg.image = IMAGE(self.dataArray[indexPath.row][@"img"]);
    [cell.contentView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
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
    
    //添加下边线
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.frame = FRAME(0, 0, WIDTH, 0.7);
    lineLayer.backgroundColor = LINE_COLOR.CGColor;
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
    _selectRow = indexPath.row;
    //构建参数
    NSDictionary *paramDic = @{@"order":self.dataArray[indexPath.row][@"type"]};
    _refreshBlock(paramDic);
    _refreshBtnTitleBlock(self.dataArray[indexPath.row][@"title"]);
    [self touch_BackView];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = HEX(@"666666", 1.0f);
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

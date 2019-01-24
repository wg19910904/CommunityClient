//
//  JHHouseKeepingSubDistantVc.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//距离视图

#import "JHHouseKeepingSubSortVc.h"

@interface JHHouseKeepingSubSortVc ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_imgArray;
    
}
@end

@implementation JHHouseKeepingSubSortVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT - (NAVI_HEIGHT+40));
    self.view.backgroundColor = HEX(@"000000", 0.3);
    [self cretaeDataSource];
    [self createTableView];
}
#pragma mark-===创建数据源
- (void)cretaeDataSource{
    _titleArray = @[NSLocalizedString(@"智能排序", nil),NSLocalizedString(@"好评优先", nil),NSLocalizedString(@"距离最近", nil),NSLocalizedString(@"销量最好", nil)];
    _imgArray = @[@"shop_sort01",@"shop_sort06",@"shop_sort03",@"shop_sort04"];
}
#pragma mark======创建距离表视图========
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 160)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [_tableView addSubview:thread];

}
#pragma mark=======UITableViewDelegate===========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel *titleLabel = [UILabel new];
    [cell.contentView addSubview:titleLabel];
    titleLabel.font = FONT(12);
    titleLabel.textColor = HEX(@"333333", 1.0);
    titleLabel.tag = 100;
    titleLabel.text = _titleArray[indexPath.row];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 45;
        make.top.offset = 0;
        make.right.offset = -50;
        make.centerY.equalTo(cell.contentView);
    }];
    
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.image = IMAGE(_imgArray[indexPath.row]);
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
    //添加底部线条
    UILabel *bottomLine = [UILabel new];
    [cell.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = LINE_COLOR;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UILabel *title = [cell.contentView viewWithTag:100];
    title.textColor = THEME_COLOR;
    UIImageView *dirImg = [cell.contentView viewWithTag:200];
    dirImg.hidden = NO;
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    NSDictionary *dic = @{@"name":@"sort",@"title":[NSString stringWithFormat:@"%@",_titleArray[indexPath.row]]};
    NSLog(@"%@",dic);
   [[NSNotificationCenter  defaultCenter] postNotificationName:@"updateHouseKeepingList" object:nil userInfo:dic];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UILabel *title = [cell.contentView viewWithTag:100];
    title.textColor = HEX(@"333333", 1.0f);
    UIImageView *dirImg = [cell.contentView viewWithTag:200];
    dirImg.hidden = YES;
}
- (void)touch_BackView{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"updateHouseKeepingList" object:nil userInfo:@{}];
    
}
@end

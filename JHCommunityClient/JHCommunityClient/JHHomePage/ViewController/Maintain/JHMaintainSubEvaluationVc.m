//
//  JHHouseKeepingSubEvaluationVc.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//评价视图

#import "JHMaintainSubEvaluationVc.h"

@interface JHMaintainSubEvaluationVc ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation JHMaintainSubEvaluationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, 99, WIDTH, HEIGHT - 99);
    self.view.backgroundColor = HEX(@"000000", 0.3);
    [self createTableView];
}
#pragma mark====创建评价表视图=============
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 220)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}
#pragma mark=======UITableViewDelegate===========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 12.5, WIDTH - 10, 10)];
    titleLabel.font = FONT(14);
    titleLabel.textColor = [UIColor blackColor];
    if(indexPath.row == 0){
        titleLabel.text = NSLocalizedString(@"从高到低", nil);
    }
    else{
        titleLabel.text = NSLocalizedString(@"从低到高", nil);
    }
    [cell.contentView addSubview:titleLabel];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 34.5, WIDTH, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [cell.contentView addSubview:thread];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"updateMaintainList" object:nil userInfo:@{}];
    
}
- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateMaintainList" object:nil];
}
- (void)touch_BackView
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"updateMaintainList" object:nil userInfo:@{}];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

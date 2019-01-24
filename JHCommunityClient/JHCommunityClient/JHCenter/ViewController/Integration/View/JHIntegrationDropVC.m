//
//  JHIntegrationDropVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/9/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHIntegrationDropVC.h"
#import "JHIntegrationDropListCell.h"
 
#import "IntegrationMallCateBntModel.h"
@interface JHIntegrationDropVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *_indexPath;
    NSMutableArray *_dataArray;
    JHIntegrationDropListCell *_lastCell;
}
@end

@implementation JHIntegrationDropVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT);
    _dataArray = @[].mutableCopy;
    [self reuestDropData];
}
#pragma mark--==获取下拉列表的数据
- (void)reuestDropData{
    [HttpTool postWithAPI:@"client/mall/product/cate" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            NSArray *items = json[@"data"][@"items"];
            IntegrationMallCateBntModel *model = [[IntegrationMallCateBntModel alloc] init];
            model.cate_id = @"0";
            model.title = NSLocalizedString(@"全部", nil);
            [_dataArray addObject:model];
            for(NSDictionary *dic in items){
                IntegrationMallCateBntModel *cateModel = [[IntegrationMallCateBntModel alloc] init];
                [cateModel setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:cateModel];
            }
            [self cretaeTableView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark-====创建表视图
- (void)cretaeTableView{
    if(_listTableView == nil){
        _listTableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0) style:UITableViewStylePlain];
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = BACK_COLOR;
        [self.view addSubview:_listTableView];
    }else{
        [_listTableView reloadData];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _listTableView.frame = FRAME(0, 0, WIDTH, _dataArray.count * 40);
        [_listTableView reloadData];
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.36f];
    }];
}
#pragma  mark-====UITableViewDelagete Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"dropListCell";
    JHIntegrationDropListCell  *cell = [_listTableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[JHIntegrationDropListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = _dataArray[indexPath.row];
    if([self.cate_id isEqualToString:cell.model.cate_id]){
            cell.selectImg.hidden = NO;
            cell.title.textColor = THEME_COLOR;
            _lastCell = cell;
    }else{
            cell.selectImg.hidden = YES;
            cell.title.textColor = HEX(@"333333", 1.0f);
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_lastCell != nil){
        _lastCell.selectImg.hidden = YES;
        _lastCell.title.textColor = HEX(@"333333", 1.0f);
    }
    [self touch_BackView];
    JHIntegrationDropListCell *cell = [_listTableView cellForRowAtIndexPath: indexPath];
    cell.title.textColor = THEME_COLOR;
    cell.selectImg.hidden = NO;
    self.cate_id = [_dataArray[indexPath.row] cate_id];
    if(self.selectBlock){
        self.selectBlock(_dataArray[indexPath.row]);
    }
    _lastCell = cell;
}

- (void)touch_BackView{
    [UIView animateWithDuration:0.3 animations:^{
        _listTableView.frame = FRAME(0, 0, WIDTH,0);
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view removeFromSuperview];
    });

}
- (void)showDropVC{
    [UIView animateWithDuration:0.3 animations:^{
        _listTableView.frame = FRAME(0, 0, WIDTH, _dataArray.count * 40);
        [_listTableView reloadData];
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.36f];
    }];
}
- (void)hideDropVC{
    [self touch_BackView];
}
@end

//
//  JHHouseKeepingEvaluationSubVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHMaintainEvaluationSubVC.h"
#import "JHMaintainEvalutionCell.h"
#import "MaintainCommentFrameModel.h"
#import "MaintainCommentModel.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
 
#import "DSToast.h"
@interface JHMaintainEvaluationSubVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSInteger _page;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    NSMutableArray *_dataArray;
    NSMutableDictionary  *_dic;
    UIImageView *_backImg;
    DSToast *toast;
}
@end

@implementation JHMaintainEvaluationSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    self.view.frame = FRAME(0, 189 + 30,WIDTH, HEIGHT - 189 - 30);
    _dataArray = [NSMutableArray array];
    _dic = [NSMutableDictionary dictionary];
    _backImg = [[UIImageView alloc] init];
    _page = 1;
    [self createTableView];
}
#pragma mark=====创建表视图=========
- (void)createTableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = BACK_COLOR;
        [self.view addSubview:_tableView];
        __unsafe_unretained typeof (self)weakSelf = self;
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您刷新中", nil) forState:MJRefreshStateRefreshing];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header beginRefreshing];
        _tableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = _footer;
        _backImg.frame = FRAME(WIDTH/2-75, 75, 150, 104);
        _backImg.image = IMAGE(@"noMessage");
    }
    else
    {
        [_tableView reloadData];
    }
    
}
#pragma mark=====加载第一页数据========
- (void)loadNewData
{
    if(self.index == 0)
    {
        if([_dic objectForKey:@"type"])
        {
            [_dic removeObjectForKey:@"type"];
        }
    }
    else if(self.index == 1)
    {
        [_dic setObject:@(1) forKey:@"type"];
    }
    else if (self.index == 2)
    {
        [_dic setObject:@(2) forKey:@"type"];
    }
    else
    {
        [_dic setObject:@(3) forKey:@"type"];
    }
    _page = 1;
    [_dic setValue:self.staff_id forKey:@"staff_id"];
    [_dic setValue:@(_page) forKey:@"page"];
    [HttpTool postWithAPI:@"client/weixiu/staffcomment" withParams:_dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            [_dataArray removeAllObjects];
            NSArray *itemsArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemsArray)
            {
                MaintainCommentFrameModel *frameModel = [[MaintainCommentFrameModel alloc] init];
                MaintainCommentModel *commentModel = [[MaintainCommentModel alloc] init];
                [commentModel setValuesForKeysWithDictionary:dic];
                frameModel.commentModel = commentModel;
                [_dataArray addObject:frameModel];
            }
            if(_dataArray.count == 0)
            {
                [_tableView addSubview:_backImg];
            }
            else
            {
                [_backImg removeFromSuperview];
            }
            
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self createTableView];
        }
        else
        {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self showAlertView:NSLocalizedString(@"数据请求失败", nil)];
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}
#pragma mark=======加载更多数据=========
- (void)loadMoreData
{
    if(self.index == 0)
    {
        if([_dic objectForKey:@"type"])
        {
            [_dic removeObjectForKey:@"type"];
        }
    }
    else if(self.index == 1)
    {
        [_dic setObject:@(1) forKey:@"type"];
    }
    else if (self.index == 2)
    {
        [_dic setObject:@(2) forKey:@"type"];
    }
    else
    {
        [_dic setObject:@(3) forKey:@"type"];
    }
    _page ++;
    [_dic setValue:self.staff_id forKey:@"staff_id"];
    [_dic setValue:@(_page) forKey:@"page"];
    [HttpTool postWithAPI:@"client/weixiu/staffcomment" withParams:_dic success:^(id json) {
        NSLog(@"json%@",json);
       
        if([json[@"error"] isEqualToString:@"0"])
        {
             NSArray *itemsArray = json[@"data"][@"items"];
            if (itemsArray.count == 0) {
                [self showHaveNoMoreData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                return ;
            }
            for(NSDictionary *dic in itemsArray)
            {
                MaintainCommentFrameModel *frameModel = [[MaintainCommentFrameModel alloc] init];
                MaintainCommentModel *commentModel = [[MaintainCommentModel alloc] init];
                [commentModel setValuesForKeysWithDictionary:dic];
                frameModel.commentModel = commentModel;
                [_dataArray addObject:frameModel];
            }
            if(_dataArray.count == 0)
            {
                [_tableView addSubview:_backImg];
            }
            else
            {
                [_backImg removeFromSuperview];
            }
            
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self createTableView];
        }
        else
        {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self showAlertView:NSLocalizedString(@"数据请求失败", nil)];
        }
        
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
    
}

#pragma mark========UITableViewDelaget=========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    JHMaintainEvalutionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[JHMaintainEvalutionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.frameModel = _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_dataArray[indexPath.row] rowHeight];
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark - 没有数据时展示
- (void)showHaveNoMoreData{
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
        [toast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            toast = nil;

        }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

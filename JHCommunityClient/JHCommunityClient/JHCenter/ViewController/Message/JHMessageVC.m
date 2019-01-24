//
//  JHMessageVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/3.
//  Copyright © 2016年 JiangHu. All rights reserved.
//消息中心noticenone

#import "JHMessageVC.h"
#import "MessageCell.h"
#import "MJRefresh.h"
 
#import "MessageModel.h"
#import "DSToast.h"
@interface JHMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIImageView *_backgroundImg;//背景图片
    BOOL _isEditing;
    NSMutableArray *_dataArray;
    MJRefreshAutoNormalFooter *_footer;
    NSInteger _page;
    UIImageView *_backImg;
    DSToast *toast;
    MJRefreshNormalHeader *_header;
    UIButton *_editBnt;//清空按钮
}
@end

@implementation JHMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"消息中心", nil);
    _dataArray = [[NSMutableArray alloc] init];
    _backImg = [[UIImageView alloc] init];
    _page = 1;
    self.view.backgroundColor = BACK_COLOR;
    _editBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBnt.frame = FRAME(0, 0, 15, 15);
    [_editBnt setBackgroundImage:IMAGE(@"laji") forState:UIControlStateNormal];
    [_editBnt addTarget:self action:@selector(editBnt:) forControlEvents:UIControlEventTouchUpInside];
    _editBnt.titleLabel.font = FONT(14);
    [_editBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_editBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)clickBackBtn{
    if (_dataArray.count == 0 && self.myBlock) {
        self.myBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark==========编辑按钮点击事件==========
- (void)editBnt:(UIButton *)sender
{
        NSLog(@"清空");
    if (_dataArray.count == 0) {
        return;
    }
        UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"确定清空吗", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *dic = @{@"message_id":@"-1"};
            [HttpTool postWithAPI:@"client/member/delmsg" withParams:dic success:^(id json) {
                NSLog(@"json%@",json[@"message"]);
                //[self loadNewData];
                [_dataArray removeAllObjects];
                [_tableView reloadData];
            } failure:^(NSError *error) {
                NSLog(@"error%@",error.localizedDescription);
            }];
        }];
        [alertViewController addAction:cancelAction];
        [alertViewController addAction:certainAction];
        [self presentViewController:alertViewController animated:YES completion:nil];
   
}
#pragma mark=======创建表视图=============
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:FRAME(0,(NAVI_HEIGHT), WIDTH, HEIGHT - (NAVI_HEIGHT)) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BACK_COLOR;
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [_tableView addSubview:thread];
    [self.view addSubview:_tableView];
    __unsafe_unretained typeof (self)weakSelf = self;
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
    [_header beginRefreshing];
    _tableView.mj_header = _header;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    _tableView.mj_footer = _footer;
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
    _backImg.frame = FRAME(100, NAVI_HEIGHT, WIDTH - 200, (WIDTH - 200) / 1.4);
    _backImg.image = IMAGE(@"noMessage");
};
#pragma mark=====加载第一页数据========
- (void)loadNewData
{
    _page = 1;
    [self postTogetData];
}
#pragma mark=======加载更多数据=========
- (void)loadMoreData
{
    _page ++;
    [self postTogetData];
}
//请求接口的方法
-(void)postTogetData{
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"client/member/msg" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        NSArray *itemsArray = json[@"data"][@"items"];
        if (itemsArray.count == 0) {
            [self showHaveNoMoreData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            return ;
        }
        for(NSDictionary *dic in itemsArray)
        {
            MessageModel *model = [[MessageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        if(_dataArray.count == 0)
        {
            [_tableView addSubview:_backImg];
            _editBnt.hidden = YES;
        }
        else
        {
            [_backImg removeFromSuperview];
            _editBnt.hidden = NO;
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];

}
#pragma mark============添加删除按钮===========
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除的一些处理");
        NSDictionary *dic = @{@"message_id":[_dataArray[indexPath.row] message_id]};
        [HttpTool postWithAPI:@"client/member/delmsg" withParams:dic success:^(id json) {
            NSLog(@"json%@",json[@"message"]);
            [self loadNewData];
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
        }];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return @[deleteAction];
}
#pragma mark===========UITableViewDelegate===============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.messageModel = _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    MessageModel *model = _dataArray[indexPath.row];
    if([model.is_read isEqualToString:@"0"])
    {
        cell.titleLabel.textColor = HEX(@"999999", 1.0f);
        if([model.type isEqualToString:@"1"])
        {
            cell.iconImg.image = IMAGE(@"bao_2");
        }
        else
        {
            cell.iconImg.image = IMAGE(@"dingdan_2");
            
        }
        NSDictionary *dic = @{@"message_id":model.message_id};
        [HttpTool postWithAPI:@"client/member/readmsg" withParams:dic success:^(id json) {
            NSLog(@"json%@",json[@"message"]);
              model.is_read = @"1";
              [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
        }];
        
    }
    else
    {
        
        
    }
    
    
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark - 没有数据时展示
- (void)showHaveNoMoreData
{
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
        [toast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            toast = nil;
        }];
    }
    
}
@end

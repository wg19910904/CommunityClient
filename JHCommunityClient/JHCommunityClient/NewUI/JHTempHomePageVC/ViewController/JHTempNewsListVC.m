//
//  JHTempNewsListVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTempNewsListVC.h"
#import "BottomCell.h"
#import "JHTempClientNewsModel.h"
#import <MJRefresh.h>
#import "JHTempHomePageViewModel.h"
#import "JHAllCell.h"
#import "JHTempWebViewVC.h"
@interface JHTempNewsListVC ()<UITableViewDelegate,UITableViewDataSource>{
   NSMutableArray *infoArr_new;//存储第二个分区的新闻的数据
    MJRefreshNormalHeader *_header;
    MJRefreshAutoNormalFooter *_footer;
    NSInteger page;
}
@property(nonatomic,strong)UITableView *myTableView;//创建tableView
@end

@implementation JHTempNewsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加表
    [self.view addSubview:self.myTableView];
    //获取数据
    [self postToGetData];
}
//初始化一些数据的方法
-(void)initData{
    infoArr_new = @[].mutableCopy;
    page = 1;
    self.view.backgroundColor = BACK_COLOR;
}
#pragma mark - 请求数据
-(void)postToGetData{
    HIDE_HUD
    SHOW_HUD
    NSMutableDictionary *dic = @{@"page":@(page)}.mutableCopy;
    if (self.isCenter) {
        [dic addEntriesFromDictionary:@{@"type":@"5"}];
    }else{
        [dic addEntriesFromDictionary:@{@"cat_id":self.cat_id}];
    }
    [JHTempHomePageViewModel postToGetNewsListWithDic:dic block:^(NSString *error, NSArray *modelArr) {
        HIDE_HUD
        if (error) {
            [self showMsg:error];
        }else{
            if (page == 1) {
                infoArr_new = modelArr.mutableCopy;
            }else{
                //新闻推荐
                for (JHTempClientNewsModel *toutiaoModel in modelArr) {
                    [infoArr_new addObject:toutiaoModel];
                }
            }
            [self.myTableView reloadData];
        }
        [_header endRefreshing];
        [_footer endRefreshing];
    }];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-114) style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = BACK_COLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
            _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
            _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            _header.lastUpdatedTimeLabel.hidden = YES;
            [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
            [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
            [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
            table.mj_header = _header;
            _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
            [_footer setTitle:@"" forState:MJRefreshStateIdle];
            [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
            table.mj_footer = _footer;
            table;
        });
    }
    return _myTableView;
}
#pragma mark - 这是下拉刷新
-(void)downRefresh{
    page = 1;
    [self postToGetData];
}
#pragma mark - 上拉加载
-(void)upLoadData{
    page++;
    [self postToGetData];
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoArr_new.count == 0? 1:infoArr_new.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (infoArr_new.count == 0) {
         return HEIGHT -114;
     }else{
         JHTempClientNewsModel *model = infoArr_new[indexPath.row];
         if (model.status == 0) {//只有文字
             CGSize size = [model.title boundingRectWithSize:CGSizeMake(WIDTH-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(16)} context:nil].size;
             return 27+size.height+23 + 23;
         }else if(model.status == 1){//1张图片和文字
             CGSize size = [model.title boundingRectWithSize:CGSizeMake(WIDTH-12-155, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(16)} context:nil].size;
             CGFloat h = size.height > 70? size.height:70;
             return 27+h+10+23;
         }else{//多张图片和文字
             CGSize size = [model.title boundingRectWithSize:CGSizeMake(WIDTH-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(16)} context:nil].size;
             return 27+size.height+70+23+10+23;
         }
 
     }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (infoArr_new.count == 0) {
        JHAllCell * cell = [[JHAllCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *str = @"cell";
        BottomCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[BottomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        JHTempClientNewsModel *model = infoArr_new[indexPath.row];
        cell.model = model;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (infoArr_new.count > 0) {
        JHTempClientNewsModel *model = infoArr_new[indexPath.row];
        JHTempWebViewVC *vc = [JHTempWebViewVC new];
        vc.url = model.link;
        if (self.superVC) {
             [self.superVC.navigationController pushViewController:vc animated:YES];
        }else{
             [self.navigationController pushViewController:vc animated:YES];
        }
       
    }
}
@end

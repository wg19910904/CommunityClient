//
//  JHPropertyNotifyVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPropertyNotifyVC.h"
#import "PropertyNotifyCell.h"
#import "JHTempWebViewVC.h"
#import <MJRefresh.h>
#import "NSString+Tool.h"

@interface JHPropertyNotifyVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@end

@implementation JHPropertyNotifyVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setUpView];
    self.page=1;
    self.navigationItem.title=@"物业通知";
    self.view.backgroundColor=BACK_COLOR;
    [self getNotifyList];

}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=1;
        [weakSelf getNotifyList];
    }];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getNotifyList];
    }];
    self.tableView.mj_footer.automaticallyHidden=YES;
}

#pragma mark ======获取物业通知列表=======
-(void)getNotifyList{
    SHOW_HUD
    [PropertyNotifyModel getNotifyListWithPage:self.page block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        if (arr) {
            if (self.page==1) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
            }else{
                if (arr.count==0)  [self.tableView.mj_footer endRefreshingWithNoMoreData];
                else{
                    [self.dataSource addObjectsFromArray:arr];
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self showMsg:msg];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHPropertyNofityCell";
    PropertyNotifyCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[PropertyNotifyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=BACK_COLOR;
    }
    
    PropertyNotifyModel *model=self.dataSource[indexPath.section];
    [cell reloadCellWithModel:model];
    
    return cell;
}

#pragma mark ======阅读全文=======
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PropertyNotifyModel *model=self.dataSource[indexPath.section];
    JHTempWebViewVC *vc=[[JHTempWebViewVC alloc] init];
    vc.navigationItem.title=model.title;
    vc.url=model.link;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    view.backgroundColor=BACK_COLOR;
    PropertyNotifyModel *model=self.dataSource[section];
    
    UILabel *lab=[UILabel new];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=0;
//        make.width.offset=80;
        make.height.offset=25;
    }];
    lab.backgroundColor=HEX(@"666666", 1.0);
    lab.text=[NSString stringWithFormat:@" %@  ",model.dateline_label];
    lab.textColor=[UIColor whiteColor];
    lab.font=FONT(14);
    lab.textAlignment=NSTextAlignmentCenter;
    lab.layer.cornerRadius=4;
    lab.clipsToBounds=YES;
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.dataSource.count-1) return 10;
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PropertyNotifyModel *model=self.dataSource[indexPath.section];
    if (model.photo.length>0) return 240+getStrHeight(model.intro, WIDTH-40, 15);
    else return 120+getStrHeight(model.intro, WIDTH-40, 15);
}

-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end

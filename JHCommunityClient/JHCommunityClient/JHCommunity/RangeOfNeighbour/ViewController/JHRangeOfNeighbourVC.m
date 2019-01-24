//
//  JHRangeOfNeighbourVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRangeOfNeighbourVC.h"
#import "UITableView+XHShowEmpty.h"
#import "JHNeighbourCell.h"
#import <MJRefresh.h>
#import "JHPubilshNeighbourVC.h"
#import "JHPublishUsedVC.h"
#import "YFSheetView.h"
#import "JHNeighbourDetailVC.h"

@interface JHRangeOfNeighbourVC ()<UITableViewDataSource,UITableViewDelegate,YFSheetViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,weak)UIButton *talkBtn;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)YFSheetView *sheetView;
@end

@implementation JHRangeOfNeighbourVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    self.view.backgroundColor=BACK_COLOR;
    self.navigationItem.title=@"社区邻里";
    [self setUpNavi];
    self.page=1;
    [self getList];
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=1;
        [weakSelf getList];
    }];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getList];
    }];
    self.tableView.mj_footer.automaticallyHidden=YES;
    
}

#pragma mark ======获取邻里圈列表=======
-(void)getList{
    SHOW_HUD
    [NeighbourModel getNeighbourModelListWithPage:self.page block:^(NSArray *arr, NSString *msg) {
       HIDE_HUD
        if (arr) {
            if (self.page==1) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                if (arr.count==0) [self.tableView.mj_footer endRefreshingWithNoMoreData];
                else{
                    [self.dataSource addObjectsFromArray:arr];
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            if (self.dataSource.count > 0) {
                [self.tableView configBlankPageWithType:XHBlankpageHaveData
                                              withBlock:nil];
            }else{
                [self.tableView configBlankPageWithType:XHBlankPageHaveNoData
                                              withBlock:^{
                                                  [self getList];
                                              }];
            }
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self showMsg:msg];
        }
    }];
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)setUpNavi{
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setFrame:CGRectMake(20, 0,30, 40)];
//    rightBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
//    rightBtn.imageView.contentMode=UIViewContentModeCenter;
//    [rightBtn addTarget:self action:@selector(clickTalk)
//       forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setImage:IMAGE(@"neighbourhood_news") forState:UIControlStateNormal];
//    self.talkBtn=rightBtn;
    
    UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn2 setFrame:CGRectMake(0, 0,36, 40)];
    [rightBtn2 addTarget:self action:@selector(clickIssue)
        forControlEvents:UIControlEventTouchUpInside];
    rightBtn2.imageView.contentMode=UIViewContentModeCenter;
    [rightBtn2 setImage:IMAGE(@"neighbourhood_issue") forState:UIControlStateNormal];
    rightBtn2.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
//    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *rightBtnItem2= [[UIBarButtonItem alloc] initWithCustomView:rightBtn2];
//    self.navigationItem.rightBarButtonItems =@[rightBtnItem,rightBtnItem2];
    self.navigationItem.rightBarButtonItem=rightBtnItem2;
    
}

#pragma mark ======点击信息和发布=======
-(void)clickTalk{

}

-(void)clickIssue{
    [self.sheetView sheetShow];
}

#pragma mark ======YFSheetViewDelegate=======
-(void)sheetClickButtonIndex:(NSInteger)index{
    
    if (index==0) {
        JHPubilshNeighbourVC *publish = [[JHPubilshNeighbourVC alloc] init];
        publish.success=^(){
            [self getList];
        };
        [self.navigationController pushViewController:publish animated:YES];        
    }else{
        JHPublishUsedVC *used = [[JHPublishUsedVC alloc] init];
        used.success=^(){
            [self getList];
        };
        [self.navigationController pushViewController:used animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHRangeOfNeighbourCell";
    JHNeighbourCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[JHNeighbourCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    NeighbourModel *model=self.dataSource[indexPath.section];
    [cell reloadCellWithModel:model is_showDes:NO];
    
    cell.clickComment=^(){//点击评论数
        [self goDetailWithModel:model indexPath:indexPath];
    };
    
    cell.clickSupport=^(){//点赞
        [self likeTiebaWith:model andIndexPath:indexPath];
    };
    
    return cell;
}

#pragma mark ======点赞=======
-(void)likeTiebaWith:(NeighbourModel *)model andIndexPath:(NSIndexPath *)indexPath{
    SHOW_HUD
    [NeighbourModel likeTiebaWithId:model.tieba_id block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        [self showMsg:msg];
        if (arr) {
            model.likes=[NSString stringWithFormat:@"%d",[model.likes intValue]+1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NeighbourModel *model=self.dataSource[indexPath.section];
    [self goDetailWithModel:model indexPath:indexPath];
}

#pragma mark ======查看详情=======
-(void)goDetailWithModel:(NeighbourModel *)model indexPath:(NSIndexPath *)indexPath{
    JHNeighbourDetailVC *detail=[[JHNeighbourDetailVC alloc] init];
    detail.tieba_id=model.tieba_id;
    detail.success=^(){
        model.replys=[NSString stringWithFormat:@"%d",[model.replys intValue]+1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NeighbourModel *model=self.dataSource[indexPath.section];
    NSString *str=[NSString stringWithFormat:@"             %@", model.content];
    float height=getStrHeight(str, WIDTH-30, 14);
    float imgH=0;
    if (model.photos.count==0)   imgH=0;
    else{
        int count=(int)model.photos.count/4+1;
        imgH += (WIDTH-15*4)/3.0 * count+15*count;
    }
    return 145+height+imgH;
}

-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(YFSheetView *)sheetView{
    if (_sheetView==nil) {
        _sheetView=[[YFSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:@[NSLocalizedString(@"发布邻里圈", nil),NSLocalizedString(@"发布二手", nil)]];
    }
    return _sheetView;
}

@end

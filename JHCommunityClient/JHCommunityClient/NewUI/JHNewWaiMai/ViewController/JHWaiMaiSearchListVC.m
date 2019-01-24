//
//  JHWaiMaiFilterListVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/28.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHWaiMaiSearchListVC.h"
#import "YFFilterView.h"
#import "WaiMaiShopperCell.h"
#import <MJRefresh.h>
#import "YFTextField.h"
#import "HistorySearchView.h"
#import "JHWaiMaiMainVC.h"
#import "JHShareModel.h"
#import "JHSupermarketMainVC.h"
@interface JHWaiMaiSearchListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)YFFilterView *filterView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *area_id;
@property(nonatomic,copy)NSString *paixu_id;
@property(nonatomic,copy)NSString *business_id;

@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,weak)YFTextField *searchField;
@property(nonatomic,strong)HistorySearchView *historyView;

@end

@implementation JHWaiMaiSearchListVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchField endEditing:YES];
    [self.searchField resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [JHShareModel shareModel].isShop = NO;
    [self setUpView];
    
    self.cate_id = @"";
    self.area_id = @"";
    self.paixu_id = @"";
    self.business_id = @"";
    self.keyword = @"";
    
    self.page = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldChamge) name: UITextFieldTextDidChangeNotification object:nil];
    
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+44, WIDTH, HEIGHT-NAVI_HEIGHT-44) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=1;
        [weakSelf getData];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getData];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    self.tableView.mj_footer=footer;
    self.tableView.mj_footer.automaticallyHidden=YES;
    
    YFFilterView *filterView = [[YFFilterView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 44) titleArr:@[NSLocalizedString(@"分类", nil),NSLocalizedString(@"区域", nil),NSLocalizedString(@"排序", nil)]];
    [filterView getData];
    filterView.firstArr = @[];
    filterView.secondArr = @[];
    filterView.thirdArr = @[];
    filterView.firstSelectedType = @"";
    [self.view addSubview:filterView];
    
    filterView.chooseFilter = ^(NSString *filter,NSString *filter1,int index){
        if (index == 1) {
            weakSelf.cate_id = filter;
        }else if(index == 2){
            weakSelf.area_id = filter;
            weakSelf.business_id = filter1;
        }else{
            weakSelf.paixu_id = filter;
        }
        [weakSelf getData];
    };
    self.filterView = filterView;
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_search"]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame=CGRectMake(0, 0, 30, 15);
    
    YFTextField *searchField=[[YFTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 28) leftView:imageView];
    searchField.margin=5;
    searchField.font=[UIFont systemFontOfSize:14];
    searchField.placeholdeColor = HEX(@"999999", 1.0);
    searchField.placeholder= NSLocalizedString(@"请输入商家名", nil);
    searchField.layer.cornerRadius= 14.0;
    searchField.clipsToBounds=YES;
    [searchField becomeFirstResponder];
    searchField.tintColor = THEME_COLOR;
    searchField.backgroundColor=HEX(@"ffffff", 0.7);
    searchField.leftViewMode=UITextFieldViewModeAlways;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.textColor = HEX(@"666666", 1.0);
    searchField.delegate = self;
    self.searchField = searchField;
    self.navigationItem.titleView = searchField;
    
    [self creatRightBtnWith:@"" sel:nil edgeInsets:UIEdgeInsetsZero];
    
    [self.view addSubview:self.historyView];
    self.historyView.backgroundColor = [UIColor whiteColor];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataSource.count == 0) {
        [self showEmptyViewWithImgName:@"noMessage" desStr:@"" btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"WaiMaiShopperCell";
    WaiMaiShopperCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[WaiMaiShopperCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    WaiMaiShopperModel *model = self.dataSource[indexPath.row];
    
    [cell reloadCellWithModel:model isFliterList:NO];
    cell.reloadYouhuiCell = ^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WaiMaiShopperModel *model = self.dataSource[indexPath.row];
    CGFloat height = 3 * 30;
    if (model.showYouHui || model.activity_list.count <= 3) {
        height = model.activity_list.count * 30 ;
    }
    return 100 + height ;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WaiMaiShopperModel *model = self.dataSource[indexPath.row];
    if ([model.tmpl_type isEqualToString:@"market"]) {
        JHSupermarketMainVC *vc = [[JHSupermarketMainVC alloc]init];
        vc.shop_id = model.shop_id;
        vc.restStatus = model.yysj_status;
//        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JHWaiMaiMainVC *vc = [[JHWaiMaiMainVC alloc] init];
        vc.shop_id = model.shop_id;
//        vc.restStatus = model.yysj_status;
//        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark ======Functions=======
#pragma mark ======获取数据=======
-(void)getData{
    [self.searchField endEditing:YES];
    [self.searchField resignFirstResponder];
    
    [self.view sendSubviewToBack:self.historyView];
    SHOW_HUD
    [WaiMaiShopperModel getShopFilterListWith:self.page cate_id:self.cate_id title:self.keyword area_id:self.area_id paixu_id:self.paixu_id buiness:self.business_id block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (arr) {
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
                if (arr.count != 0) {
                    [self.historyView searchHistoryAddStr:self.keyword];
                }
            }else{
                if (arr.count == 0)  [self showHaveNoMoreData];
                else [self.dataSource addObjectsFromArray:arr];
            }
            [self.tableView reloadData];
        }else [self showToastAlertMessageWithTitle:msg];
        
    }];
    
}

#pragma mark ======TextFieldChange=======
-(void)fieldChamge{
    
    if (self.searchField.text.length == 0) {//搜索的内容被清空了
        [self.view bringSubviewToFront:self.historyView];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length != 0) {
        [textField endEditing:YES];
        [textField resignFirstResponder];
        self.keyword = textField.text;
        self.page = 1;
        [self getData];
    }
    return YES;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.searchField resignFirstResponder];
    [self.searchField endEditing:YES];
    
}

-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(HistorySearchView *)historyView{
    if (_historyView==nil) {
         __weak typeof(self) weakSelf=self;
        _historyView=[[HistorySearchView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT)];
        _historyView.clickTitle = ^(NSString *title){
            weakSelf.keyword = title;
            weakSelf.searchField.text = title;
            weakSelf.page = 1;
            [weakSelf getData];
        };
    }
    return _historyView;
}

@end

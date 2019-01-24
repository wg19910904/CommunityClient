//
//  JHSearchShopVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/28.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSearchShopVC.h"
#import "JHHomePageCell.h"
#import "JHHistoryCell.h"
 
#import "JHShareModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHHomePageShopItemModel.h"
#import <MJRefresh.h>
#import "JHShopHomepageVC.h"
#import <IQKeyboardManager.h>
#import "UINavigationBar+Awesome.h"
#import "WaiMaiShopperCell.h"
#import "WaiMaiShopperModel.h"
#import "JHTempShopSearchMainModel.h"
#import "WaiMaiShopperModel.h"
@interface JHSearchShopVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *historyTableView;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UITextField *searchField;
@property(nonatomic,copy)NSMutableArray *historyArray;
@property(nonatomic,copy)NSMutableArray *searchDataModelArray;
@end

@implementation JHSearchShopVC
{
    NSString *key; //保存当前需要搜索的key
    UIButton *rightBtn;
    //用来存储转换生成的百度坐标
    double bd_lat;
    double bd_lon;
    //当前页数
    NSInteger page;
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
     UIView *backView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    //self.backBtn.hidden = YES;
    key = @"";
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
   
    //创建搜索历史表视图
    [self handleHistoryTableView];
    [_searchField becomeFirstResponder];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [backView removeFromSuperview];
    backView = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //创建搜索文本框
    [self createSearchfield];
}
-(void)clickBackBtn{
    [_searchField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 创建搜索文本框
- (void)createSearchfield
{
    if (!backView) {
        backView = [[UIView alloc] initWithFrame:FRAME(50, 0, WIDTH-50, 44)];
        //初始化搜索框
        _searchField = [[UITextField alloc] initWithFrame:FRAME(0,4.5 , WIDTH - 60, 35)];
        _searchField.placeholder = NSLocalizedString(@"请输入关键字", nil);
        _searchField.layer.borderWidth = 0.7;
        _searchField.layer.borderColor = LINE_COLOR.CGColor;
        _searchField.backgroundColor = HEX(@"ffffff", 1.0f);
        _searchField.layer.cornerRadius = 5;
        _searchField.layer.masksToBounds = YES;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.tintColor = THEME_COLOR;
        _searchField.textColor = HEX(@"333333", 1.0);
        _searchField.font = FONT(16);
        _searchField.delegate = self;
        //添加左侧view
        UIView *leftIV = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 35)];
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.leftView = leftIV;
        //添加右侧按钮
        rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 60, 35)];
        [rightBtn setTitle:NSLocalizedString(@"搜索", nil) forState:(UIControlStateNormal)];
        [rightBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:HEX(@"7d7d7d", 1.0f) forState:(UIControlStateNormal)];
        rightBtn.titleLabel.font = FONT(15);
        rightBtn.layer.borderColor = LINE_COLOR.CGColor;
        rightBtn.layer.borderWidth = 0.7;
        _searchField.rightViewMode = UITextFieldViewModeAlways;
        _searchField.rightView = rightBtn;
        [backView addSubview:_searchField];
        [self.navigationController.navigationBar addSubview:backView];
    }
}
#pragma mark - 处理搜索历史表视图
- (void)handleHistoryTableView
{
    _historyArray = [JHShareModel shareModel].historyArray;
    //当历史数据数组为真且count > 0 时创建
    if ( _historyArray || _historyArray.count > 0) {
        if (!_historyTableView) {
            _historyTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)
                                                             style:(UITableViewStylePlain)];
            _historyTableView.delegate = self;
            _historyTableView.dataSource = self;
            _historyTableView.layoutMargins = UIEdgeInsetsZero;
            _historyTableView.separatorInset = UIEdgeInsetsZero;
            [self.view addSubview:_historyTableView];
        }
    }
    
}
#pragma mark - 搜索框内容发生改变时
- (void)searchFieldTextChanged:(NSNotification *)noti
{
    NSLog(@"文本框内容发生改变了");
    if (_searchField.text.length > 0) {
        key = _searchField.text;
//        rightBtn.backgroundColor = THEME_COLOR;
        [rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [rightBtn addTarget:self action:@selector(clickSearchBtn:)
           forControlEvents:UIControlEventTouchUpInside];
    }else{
        [rightBtn removeTarget:self action:@selector(clickSearchBtn:)
              forControlEvents:UIControlEventTouchUpInside];
        rightBtn.backgroundColor = HEX(@"f7f7f7", 1.0f);
        [rightBtn setTitleColor:HEX(@"7d7d7d", 1.0f) forState:(UIControlStateNormal)];
        
        //将搜索表视图置为nil
        [_mainTableView removeFromSuperview];
        _mainTableView = nil;
        _historyArray = [JHShareModel shareModel].historyArray;
        [_historyTableView reloadData];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    [_mainTableView removeFromSuperview];
    _mainTableView = nil;
    return YES;
}
#pragma mark - 点击搜索按钮
- (void)clickSearchBtn:(UIButton *)sender
{
    NSLog(@"点击了搜索按钮");
    [self search];
}
-(void)search{
     [_searchField resignFirstResponder];
    if (_searchField.text.length == 0 || _searchField.text == nil) {
        return;
    }
    //请求数据
    [self loadNewData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //将搜索历史存入单例数组
        __block JHShareModel *model = [JHShareModel shareModel];
        NSMutableArray *historyArray = model.historyArray;
        [historyArray containsObject:_searchField.text] ?
        ({ [historyArray removeObject:_searchField.text];
            [historyArray insertObject:_searchField.text atIndex:0];})
        : ({[historyArray insertObject:_searchField.text atIndex:0];});
        
        model.historyArray = NULL;
        model.historyArray = (historyArray.count <= 10)? historyArray : [[historyArray subarrayWithRange:NSMakeRange(0, 10)] mutableCopy];
    });

}
#pragma mark - 请求新数据
- (void)loadNewData
{
    [self.view endEditing:YES];
    SHOW_HUD
    //处理参数
    page = 1;
    NSMutableDictionary *paramsDic = [self handleParams];
    [paramsDic addEntriesFromDictionary:@{@"page":@(page)}];
    [HttpTool postWithAPI:@"client/v2/shop/discover"
               withParams:paramsDic
                  success:^(id json) {
                     NSLog(@"client/data/searchshop---%@",json);
                      //创建表视图
                      [self handleMainTableView];
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          
                          if ([json[@"data"][@"shop_items"] count] == 0) {
                              [_mainTableView configBlankPageWithType:XHBlankPageHaveNoData
                                                            withBlock:^{
                                                                [self loadNewData];
                                                            }];
                              _mainTableView.mj_footer.userInteractionEnabled = NO;

                          }else{
                              
                              _searchDataModelArray = [@[] mutableCopy];
                              //处理数据
                              [self handleModelData:json[@"data"][@"shop_items"]];
                              //创建表视图
                              [self handleMainTableView];
                              _mainTableView.mj_footer.userInteractionEnabled = YES;
                              [_mainTableView configBlankPageWithType:XHBlankpageHaveData
                                                            withBlock:nil];
                          }
                          
                      }else{
                          
                          [_headerRefresh endRefreshing];
                          _searchDataModelArray = [@[] mutableCopy];
                          [_mainTableView reloadData];
                          [_mainTableView configBlankPageWithType:XHBlankPageNetError
                                                        withBlock:^{
                                                            [self loadNewData];
                                                        }];
                          _mainTableView.mj_footer.userInteractionEnabled = NO;
                      
                      }
                      HIDE_HUD
                      [_headerRefresh endRefreshing];
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                      [_headerRefresh endRefreshing];
                      _searchDataModelArray = [@[] mutableCopy];
                      [_mainTableView reloadData];
                      [_mainTableView configBlankPageWithType:XHBlankPageNetError
                                                    withBlock:^{
                                                        [self loadNewData];
                                                    }];
                      _mainTableView.mj_footer.userInteractionEnabled = NO;

                  }];
}
#pragma mark - 请求更多数据
- (void)loadMoreData
{
    SHOW_HUD
    //处理参数
    page++;
    NSMutableDictionary *paramsDic = [self handleParams];
    [paramsDic addEntriesFromDictionary:@{@"page":@(page)}];
    [HttpTool postWithAPI:@"client/v2/shop/discover"
               withParams:paramsDic
                  success:^(id json) {
                      NSLog(@"client/data/searchshop---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          //创建主表视图
                          [self handleModelData:json[@"data"][@"shop_items"]];
                          //创建表视图
                          [self handleMainTableView];
                      }
                      HIDE_HUD
                      [_footerRefresh endRefreshing];
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                      _searchDataModelArray = [@[] mutableCopy];
                      [_mainTableView reloadData];
                      [_mainTableView configBlankPageWithType:XHBlankPageNetError
                                                    withBlock:^{
                                                        [self loadNewData];
                                                    }];
                      _mainTableView.mj_footer.userInteractionEnabled = NO;
                  }];
}
#pragma mark - 处理参数
- (NSMutableDictionary *)handleParams
{
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"app.lat"];
    lat = lat ? lat : @"";
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"app.lng"];
    lng = lng ? lng : @"";
    NSMutableDictionary *paramsDic = [@{@"lat":lat,
                                        @"lng":lng,
                                        @"title":(key.length > 0) ? key : _searchField.text} mutableCopy];
    return [paramsDic mutableCopy];
}
#pragma mark - 处理数据
- (void)handleModelData:(NSDictionary *)dic
{
    if (page == 1) {
        _searchDataModelArray = [[WaiMaiShopperModel mj_objectArrayWithKeyValuesArray:dic]mutableCopy];
        

    }else{
        NSArray *arr = [WaiMaiShopperModel mj_objectArrayWithKeyValuesArray:dic];
        [_searchDataModelArray addObjectsFromArray:arr];
    }
    
}
#pragma mark - 处理表视图
- (void)handleMainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)
                                                        style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = BACK_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        //-----------------刷新和加载更多添加--------------------
        //创建刷新表头
        _headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _headerRefresh.lastUpdatedTimeLabel.hidden = YES;
        [_headerRefresh setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_headerRefresh setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _headerRefresh.stateLabel.textColor = [UIColor colorWithRed:129/255.0
                                                              green:129/255.0
                                                               blue:129/255.0
                                                              alpha:1.0];
        _mainTableView.mj_header = _headerRefresh;
        //创建加载表尾
        _footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadMoreData)];
        [_footerRefresh setTitle:@"" forState:MJRefreshStateIdle];//普通闲置状态
        _mainTableView.mj_footer = _footerRefresh;
        //----------------------------------------------------
        _mainTableView.layoutMargins = UIEdgeInsetsZero;
        _mainTableView.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:_mainTableView];
    }else{
        
        [_mainTableView reloadData];
    }
}
#pragma mark - UITableViewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == _historyTableView)?
                       _historyArray.count :
                _searchDataModelArray.count;
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
    if (tableView == _mainTableView) {
        WaiMaiShopperModel *model = self.searchDataModelArray[indexPath.row];
        CGFloat height = 3 * 30;
        if (model.showYouHui || model.activity_list.count <= 3) {
            height = model.activity_list.count * 30 ;
        }
        return 100 + height;

    }
    return 45;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (tableView == _historyTableView) {
        static NSString *JHHistoryCellID = @"JHHistoryCellID";
        JHHistoryCell *cell = [_historyTableView dequeueReusableCellWithIdentifier:JHHistoryCellID];
        if (!cell) {
            cell = [[JHHistoryCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                        reuseIdentifier:JHHistoryCellID];
        }
        //获取系统保存的历史
        cell.titleLabel.text = _historyArray[row];
        [cell.rightBtn addTarget:self action:@selector(tapHistoryBtn:)
                            forControlEvents:(UIControlEventTouchUpInside)];
        cell.rightBtn.highlighted = YES;
        return cell;
    }else{
        static NSString *ID=@"WaiMaiShopperCell";
        WaiMaiShopperCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WaiMaiShopperCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isHomePage = YES;
        WaiMaiShopperModel *model = _searchDataModelArray[indexPath.row];
        [cell reloadCellWithModel:model isFliterList:YES];
        cell.reloadYouhuiCell = ^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        NSInteger row = indexPath.row;
        //获取点击的店铺的id
        WaiMaiShopperModel *shopItemModel = (WaiMaiShopperModel*)_searchDataModelArray[row];
        NSString *shop_id = shopItemModel.shop_id;
        JHShopHomepageVC *vc = [[JHShopHomepageVC alloc] init];
        vc.shop_id = shop_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //获取搜索历史的对应条目
         key = _historyArray[indexPath.row];
        _searchField.text = key;
        //搜索
        [self loadNewData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - 点击历史表视图的右侧按钮
- (void)tapHistoryBtn:(UIButton *)sender
{
    JHHistoryCell *cell = (JHHistoryCell *)sender.superview;
    NSIndexPath *indexPath = [_historyTableView indexPathForCell:cell];
    [_historyArray removeObjectAtIndex:indexPath.row];
    [JHShareModel shareModel].historyArray = _historyArray;
    [_historyTableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [backView endEditing:YES];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
@end

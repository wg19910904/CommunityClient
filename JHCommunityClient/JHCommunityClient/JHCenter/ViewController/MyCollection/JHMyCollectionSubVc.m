//
//  JHMyCollectionSubVc.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//我的收藏内部子页

#import "JHMyCollectionSubVc.h"
#import "MyCollectionPersonCell.h"
#import "MJRefresh.h"
 
#import "DSToast.h"
#import "MyCollectionPersonModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import "MyCollectionShopCell.h"
#import "MyCollectionShopModel.h"
#import "JHHouseKeepingDetailVC.h"
#import "JHMaintainDetailVC.h"
#import "JHHouseKeepingVC.h"
@interface JHMyCollectionSubVc ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    MJRefreshAutoNormalFooter *_footer;
    NSMutableArray *_dataArray;
    DSToast *toast;
    NSInteger _page;
    NSMutableDictionary *_dic;
    UIImageView *_backImg;
    MJRefreshNormalHeader *_header;
}
@end

@implementation JHMyCollectionSubVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _dic = [NSMutableDictionary dictionary];
    self.view.frame = FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT - (NAVI_HEIGHT+40));
    self.view.backgroundColor = BACK_COLOR;
    _dataArray = [NSMutableArray array];
    [self createTbaleView];
}

#pragma mark========创建表视图===============
- (void)createTbaleView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0,0, WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACK_COLOR;
        _tableView.tableFooterView = [[UIView alloc] init];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [_tableView addSubview:thread];
        [self.view addSubview:_tableView];
        __unsafe_unretained typeof(self)weakSelf = self;
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
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = _footer;
        _backImg = [[UIImageView alloc] init];
        _backImg.frame = FRAME(100, 104, WIDTH - 200, (WIDTH - 200) / 1.4);
        _backImg.image = IMAGE(@"noMessage");
    }
    else
    {
        [_tableView reloadData];
    }
   
}
#pragma mark=======加载第一页数据========
- (void)loadNewData
{
    _page = 1;
    NSString *lat = nil;
    NSString *lng = nil;
    float lat_gaode = [XHMapKitManager shareManager].lat;
    float lng_gaode = [XHMapKitManager shareManager].lng;
    double baiduLat = 0.0;
    double baiduLng = 0.0;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:lat_gaode
                                                 WithGD_lon:lng_gaode
                                                 WithBD_lat:&baiduLat
                                                 WithBD_lon:&baiduLng];
    lat = [NSString stringWithFormat:@"%f",baiduLat];
    lng = [NSString stringWithFormat:@"%f",baiduLng];
    [_dic setObject:lat forKey:@"lat"];
    [_dic setObject:lng forKey:@"lng"];
    [_dic setObject:@(_page) forKey:@"page"];
    [_dic setObject:@(self.index) forKey:@"type"];
   [HttpTool postWithAPI:@"client/member/collect/items" withParams:_dic success:^(id json) {
       NSLog(@"json%@",json);
       if([json[@"error"] isEqualToString:@"0"])
       {
           [_dataArray removeAllObjects];
           NSArray *items = [json[@"data"][@"items"] isKindOfClass:[NSArray class]] ? json[@"data"][@"items"]:@[];
           for(NSDictionary *dic in items)
           {
               if(self.index == 1)
               {
                   MyCollectionShopModel *shop = [[MyCollectionShopModel alloc] init];
                   [shop setValuesForKeysWithDictionary:dic];
                   [_dataArray addObject:shop];
               }
               else
               {
                   MyCollectionPersonModel *person = [[MyCollectionPersonModel alloc] init];
                   [person setValuesForKeysWithDictionary:dic];
                   [_dataArray addObject:person];
               }
               
           }
           if(_dataArray.count == 0)
           {
               [_tableView addSubview:_backImg];
           }
           else
           {
               [_backImg removeFromSuperview];
           }
           [self createTbaleView];
       }
       else
       {
           [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据加载失败,原因:%@", nil),json[@"message"]]];
       }
       [_tableView.mj_header endRefreshing];
       [_tableView.mj_footer endRefreshing];
   } failure:^(NSError *error) {
       NSLog(@"error%@",error.localizedDescription);
       [_tableView.mj_header endRefreshing];
       [_tableView.mj_footer endRefreshing];
       [self showAlertView:error.localizedDescription];
       
   }];
}
#pragma mark========获取更多数据========
- (void)loadMoreData
{
    _page ++;
    NSString *lat = nil;
    NSString *lng = nil;
    float lat_gaode = [[NSUserDefaults standardUserDefaults] floatForKey:@"lat"];
    float lng_gaode = [[NSUserDefaults standardUserDefaults] floatForKey:@"lng"];
    double baiduLat = 0.0;
    double baiduLng = 0.0;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:lat_gaode
                                                 WithGD_lon:lng_gaode
                                                 WithBD_lat:&baiduLat
                                                 WithBD_lon:&baiduLng];
    lat = [NSString stringWithFormat:@"%f",baiduLat];
    lng = [NSString stringWithFormat:@"%f",baiduLng];
    [_dic setObject:lat forKey:@"lat"];
    [_dic setObject:lng forKey:@"lng"];
    [_dic setObject:@(_page) forKey:@"page"];
    [_dic setObject:@(self.index) forKey:@"type"];
    [HttpTool postWithAPI:@"client/member/collect/items" withParams:_dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            NSArray *items = json[@"data"][@"items"];
            if(items.count == 0)
            {
                [self showHaveNoMoreData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                return ;
            }
            for(NSDictionary *dic in items)
            {
                if(self.index == 1)
                {
                    MyCollectionShopModel *shop = [[MyCollectionShopModel alloc] init];
                    [shop setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:shop];
                }
                else
                {
                    MyCollectionPersonModel *person = [[MyCollectionPersonModel alloc] init];
                    [person setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:person];
                }
                

                
            }
            if(_dataArray.count == 0)
            {
                [_tableView addSubview:_backImg];
            }
            else
            {
                [_backImg removeFromSuperview];
            }
            [self createTbaleView];
        }
        else
        {
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据加载失败,原因:%@", nil),json[@"message"]]];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.localizedDescription);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self showAlertView:error.localizedDescription];
    }];

}
#pragma mark===========UITableViewDelegate==============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.index == 1)
    {
        static NSString *identifier = @"shop";
        MyCollectionShopCell *shop = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(shop == nil)
        {
            shop = [[MyCollectionShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        shop.myCollectionShopModel = _dataArray[indexPath.row];
        return shop;
    }
    else
    {
        static NSString *identifier = @"preson";
        MyCollectionPersonCell *person = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(person == nil)
        {
            person = [[MyCollectionPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        person.myCollectionPersonModel = _dataArray[indexPath.row];
        return person;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.index == 2)
        return 95;
    else
        return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 1)
    {
        NSLog(@"进入商品详情");
        MyCollectionShopModel *model = _dataArray[indexPath.row];
        //跳转到店铺详情
        if(self.myBlock1)
        {
            self.myBlock1(model);
        }
        
    }
    else
    {
        MyCollectionPersonModel *model = _dataArray[indexPath.row];
        if(self.myBlock2)
        {
            self.myBlock2(model);
        }
    }
}
#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        if(self.index == 1)
        {
            MyCollectionShopModel*model = _dataArray[indexPath.row];
            NSDictionary *dic = @{@"can_id":model.shop_id,@"type":@(1)};
            [HttpTool postWithAPI:@"client/member/collect/cancel" withParams:dic success:^(id json) {
                NSLog(@"json%@",json[@"message"]);
                if([json[@"error"] isEqualToString:@"0"])
                {
                    [self showAlertView:NSLocalizedString(@"取消收藏成功", nil)];
                    [self loadNewData];
                }
                else
                {
                    [self showAlertView:NSLocalizedString(@"取消收藏失败", nil)];
                }
            } failure:^(NSError *error) {
                NSLog(@"error%@",error.localizedDescription);
                [self showAlertView:NSLocalizedString(@"取消收藏失败", nil)];
            }];

        }
        else
        {
            MyCollectionPersonModel *model = _dataArray[indexPath.row];
            NSDictionary *dic = @{@"can_id":model.staff_id,@"type":@(2)};
            [HttpTool postWithAPI:@"client/member/collect/cancel" withParams:dic success:^(id json) {
                NSLog(@"json%@",json[@"message"]);
                if([json[@"error"] isEqualToString:@"0"])
                {
                    [self showAlertView:NSLocalizedString(@"取消收藏成功", nil)];
                    [self loadNewData];
                    
                }
                else
                {
                    [self showAlertView:NSLocalizedString(@"取消收藏失败", nil)];
                }
            } failure:^(NSError *error) {
                NSLog(@"error%@",error.localizedDescription);
                [self showAlertView:NSLocalizedString(@"取消收藏失败", nil)];
            }];

        }
        
       
    }];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
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
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
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

//
//  JHHouseKeepingVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//频道页家政

#import "JHHouseKeepingVC.h"
 
#import "MBProgressHUD.h"
#import "JHHouseKeepingListVc.h"
#import "JHHouseKeepingMapVC.h"
#import "HouseKeepingHomeCateModel.h"
#import "HouseKeppeingHomeCateCell.h"
#import "CustomView.h"
#import "MJRefresh.h"
#import "JHHouseKeepingMapVC.h"
#import "HouseKeepingHomeCateProductModel.h"
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
#import "JHLoginVC.h"
@interface JHHouseKeepingVC ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSMutableArray *_dataArray;
    UICollectionView *_collectionView;
}

@end

@implementation JHHouseKeepingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"全部服务", nil);
    self.view.backgroundColor = BACK_COLOR;
    _dataArray = [NSMutableArray array];
    [self createUI];
    [self createRightItem];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
#pragma mark==============搭建首页界面=====
- (void)createUI
{
    if(_collectionView == nil)
    {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.scrollDirection =  UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) collectionViewLayout:flow];

        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HouseKeppeingHomeCateCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[CustomView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
    }else{
        [_collectionView reloadData];
    }
}
#pragma mark=====右侧转换按钮===========
- (void)createRightItem
{
    UIButton *switchBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBnt.frame = FRAME(0, 0, 15, 15);
    [switchBnt setBackgroundImage:IMAGE(@"people_list") forState:UIControlStateNormal];
    [switchBnt addTarget:self action:@selector(switchBnt) forControlEvents:UIControlEventTouchUpInside];
    switchBnt.titleLabel.font = FONT(14);
    [switchBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:switchBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)switchBnt
{
    //转换到列表模式
    JHHouseKeepingListVc *list = [[JHHouseKeepingListVc alloc] init];
    list.cate_id = @"";
    list.cateTitle = NSLocalizedString(@"全部分类", nil);
    [self.navigationController pushViewController:list animated:YES];
}
#pragma mark=====加载网络数据=========
- (void)requestData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/house/cate" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            HIDE_HUD
            NSArray *items = json[@"data"][@"items"];
            NSLog(@"%@",items);
            for(NSDictionary *dic in items)
            {
                HouseKeepingHomeCateModel *cateModel = [[HouseKeepingHomeCateModel alloc] init];
                [cateModel setValuesForKeysWithDictionary:dic];
                for(NSDictionary *dicc in cateModel.products)
                {
                    HouseKeepingHomeCateProductModel *productModel = [[HouseKeepingHomeCateProductModel alloc] init];
                    [productModel setValuesForKeysWithDictionary:dicc];
                    [cateModel.productArray addObject:productModel];
                    NSLog(@"%@",cateModel.productArray);
                }
                [_dataArray addObject:cateModel];
    
            }
            [self createUI];
        }else if([json[@"error"] isEqualToString:@"101"]){
            //跳转到登录界面
            JHLoginVC *login = [JHLoginVC new];
            login.fromYunBuy = YES;
            [self.navigationController pushViewController:login animated:YES];
        }else{
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:@"%@",json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}
#pragma mark========UICollectionViewDelegate===========
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray[section] productArray].count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HouseKeppeingHomeCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.productModel = [_dataArray[indexPath.section] productArray][indexPath.item];
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-20)/4, (WIDTH-20)/4 + 20);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0,10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    JHHouseKeepingMapVC *map = [[JHHouseKeepingMapVC alloc] init];
    HouseKeepingHomeCateProductModel *model = [_dataArray[indexPath.section] productArray][indexPath.item];
    map.cate_id = model.cate_id;
    map.imgUrl = model.icon;
    map.name = model.title;
    map.price = model.price;
    map.unit = model.unit;
    map.start = model.start;
    [self.navigationController pushViewController:map animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CustomView *view;
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        view = [_collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    }
    view.backgroundColor = BACK_COLOR;
    //UIView *backView = nil;
//    if(backView == nil)
//    {
//        backView = [[UIView alloc] init];
//    }
//    backView.frame = FRAME(0, 0, WIDTH, 30);
//    backView.backgroundColor = BACK_COLOR;
//    [view addSubview:backView];
    UIImageView *img = nil;
    if(img == nil)
    {
        img = [[UIImageView alloc] init];
    }
    img.frame = FRAME(10, 5, 20, 20);
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:[NSString stringWithFormat:@"%@",[_dataArray[indexPath.section] icon]]]];
    [img sd_image:url plimage:IMAGE(@"house&maintainonecategory")];
    [view addSubview:img];
    if(view.title == nil)
    {
        view.title = [[UILabel alloc] init];
    }
    view.title.frame =  FRAME(40, 0, WIDTH - 40, 30);
    view.title.font = FONT(14);
    view.title.textColor = HEX(@"666666", 1.0f);
    view.title.text = [_dataArray[indexPath.section] title];
    view.title.backgroundColor = BACK_COLOR;
    [view addSubview:view.title];
    UIView *thread1 = nil;
    if(thread1 == nil)
    {
        thread1 = [[UIView alloc] init];
    }
    thread1.frame = FRAME(0, 0, WIDTH, 0.5);
    thread1.backgroundColor = LINE_COLOR;
    if(indexPath.section != 0)
    {
        [view addSubview:thread1];
    }
    UIView *thread2 = nil;
    if(thread2 == nil)
    {
        thread2 = [[UIView alloc] init];
    }
    thread2.frame = FRAME(0, 29.5, WIDTH, 0.5);
    thread2.backgroundColor = LINE_COLOR;
    [view addSubview:thread2];
    return view;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, 30);
}

//#pragma mark=======UITableVioewDelegate===========
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 4;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"cell";
//    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
//    if(cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    if(indexPath.section == 0 || indexPath.section == 1)
//    {
//        for(int i = 0; i < 3; i++)
//        {
//            HouseKeepingCateBnt *bnt = [[HouseKeepingCateBnt alloc] initWithFrame:FRAME(10 + i%4*((WIDTH - 20)/4) , i / 4 * ((WIDTH - 20) / 4 + 30),(WIDTH - 20)/4, (WIDTH - 20) / 4 + 20)];
//            bnt.tag = i + 1 + indexPath.section;
//            [bnt setTitle:NSLocalizedString(@"家庭保洁", nil) forState:UIControlStateNormal];
//            [bnt addTarget:self action:@selector(cateBnt:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:bnt];
//        }
//    }
//    else
//    {
//        for(int i = 0; i < 8; i++)
//        {
//            HouseKeepingCateBnt *bnt = [[HouseKeepingCateBnt alloc] initWithFrame:FRAME(10 + i % 4 * ((WIDTH - 20)/4), i / 4 * ((WIDTH - 20) / 4 + 30), WIDTH/4, WIDTH /4 + 20)];
//            bnt.tag = i + 1 + indexPath.section;
//            [bnt setTitle:NSLocalizedString(@"皮质沙发保养", nil) forState:UIControlStateNormal];
//            [bnt addTarget:self action:@selector(cateBnt:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:bnt];
//        }
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == 0 || indexPath.section == 1)
//    {
//        return WIDTH/4 + 30;
//    }
//    else
//    {
//        return WIDTH/2 + 60;
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return CGFLOAT_MIN;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(10, 12.5, 15, 15)];
//    img.image = IMAGE(@"xiyi");
//    [view addSubview:img];
//    UILabel *title = [[UILabel alloc] initWithFrame:FRAME(35, 15, 150, 10)];
//    title.font = FONT(14);
//    title.textColor = [UIColor blackColor];
//    title.textAlignment = NSTextAlignmentLeft;
//    title.text = NSLocalizedString(@"保洁服务", nil);
//    [view addSubview:title];
//    return view;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
//#pragma mark========分类按钮点击事件==========
//- (void)cateBnt:(UIButton *)sender
//{
//    NSLog(@"%ld",(long)sender.tag);
//    JHHouseKeepingMapVC *map = [[JHHouseKeepingMapVC alloc] init];
//    [self.navigationController pushViewController:map animated:YES];
//}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
@end

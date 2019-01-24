//
//  JHMyCollectVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/3.
//  Copyright © 2016年 JiangHu. All rights reserved.
//我的收藏

#import "JHMyCollectVC.h"
#import "JHMyCollectionSubVc.h"
#import "MyCollectionPersonModel.h"
#import "MyCollectionShopModel.h"
#import "JHHouseKeepingDetailVC.h"
#import "JHMaintainDetailVC.h"
#import "JHShopHomepageVC.h"
#import "JHMyCollecBook.h"
#import "JHTempNewsListVC.h"
@interface JHMyCollectVC ()<UIPageViewControllerDelegate>
{
    UIView *_backView;//按钮背景图片
    UIPageViewController *_pvc;
    NSMutableArray *_vcArray;
    NSInteger _curPage;
    UIView *_coverView;
    UIButton *_lastBnt;
    
}
@end

@implementation JHMyCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的收藏", nil);
    self.view.backgroundColor = BACK_COLOR;
    [self createBnt];
    [self initVCArray];
    [self initPageVc];
    
}
#pragma mark========创建UIPageViewController========
- (void)initPageVc
{
    _pvc = [[UIPageViewController alloc] initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pvc.delegate = self;
    _pvc.view.frame = FRAME(0, (NAVI_HEIGHT+40), WIDTH , HEIGHT - (NAVI_HEIGHT+40));
    _pvc.view.backgroundColor = BACK_COLOR;
    [_pvc setViewControllers:@[_vcArray[0]] direction:1 animated:YES completion:nil];
    [self.view addSubview:_pvc.view];
    [_pvc.view.subviews[0] setDelegate:self];
    
}
#pragma mark=========创建子视图控制器数组==============
- (void)initVCArray
{
    _vcArray = [NSMutableArray array];
    for(int i = 0 ; i < 3; i ++)
    {
        JHMyCollectionSubVc *sub = [[JHMyCollectionSubVc alloc] init];
        sub.index = i + 1;
        if(i == 0)
        {
            sub.myBlock1 = ^(MyCollectionShopModel *model)
            {
                JHShopHomepageVC *homePage = [[JHShopHomepageVC alloc] init];
                homePage.shop_id = model.shop_id;
                [self.navigationController pushViewController:homePage animated:YES];
            };
        }
        else if(i == 1)
        {
            
            sub.myBlock2 = ^(MyCollectionPersonModel *model)
            {
                if([model.from_title isEqualToString:NSLocalizedString(@"家政", nil)])
                {
                    JHHouseKeepingDetailVC *house = [[JHHouseKeepingDetailVC alloc] init];
                    house.staff_id = model.staff_id;
                    house.name = model.name;
                    [self.navigationController pushViewController:house animated:YES];
                }
                else if([model.from_title isEqualToString:NSLocalizedString(@"维修", nil)])
                {
                    JHMaintainDetailVC *maintain = [[JHMaintainDetailVC alloc] init];
                    maintain.staff_id = model.staff_id;
                    maintain.name = model.name;
                    [self.navigationController pushViewController:maintain animated:YES];
                }
            };
        }
        if (i < 2) {
            [_vcArray addObject:sub];
        }else{
            JHTempNewsListVC *bookVC = [JHTempNewsListVC new];
            bookVC.isCenter = YES;
            bookVC.superVC = self;
            [_vcArray addObject:bookVC];
        }
    }
}
#pragma mark=======搭建UI界面==========
- (void)createBnt
{
   
    _backView = [[UIView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 40)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    _coverView = [[UIView alloc] initWithFrame:FRAME(15, 39, WIDTH / 3 - 30, 1)];
    _coverView.backgroundColor = THEME_COLOR;
    [_backView addSubview:_coverView];
    for(int i = 0 ; i < 3; i ++)
    {
        UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        bnt.frame = FRAME(i * (WIDTH / 3), 0, WIDTH / 3, 40);
        bnt.titleLabel.font = FONT(14);
        bnt.tag = i + 1;
        [bnt addTarget:self action:@selector(clickBnt:) forControlEvents:UIControlEventTouchUpInside];
         if(i == 0)
        {
            [bnt setTitle:NSLocalizedString(@"店铺", nil) forState:UIControlStateNormal];
            [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        }
        else if(i == 1)
        {
            [bnt setTitle:NSLocalizedString(@"人员", nil) forState:UIControlStateNormal];
            [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];

        }else{
            [bnt setTitle:NSLocalizedString(@"文章", nil) forState:UIControlStateNormal];
            [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        }
        if(i == 0)
        {
            bnt.selected = YES;
            _lastBnt = bnt;
        }
        [_backView addSubview:bnt];
    }
    
}
#pragma mark=======详单,商家,人员按钮的点击事件============
- (void)clickBnt:(UIButton *)sender
{
    if(_lastBnt != nil)
    {
        _lastBnt.selected = NO;
    }
    sender.selected = YES;
    _lastBnt = sender;
    _coverView.center = CGPointMake(sender.center.x, 39);
        [_pvc setViewControllers:@[_vcArray[sender.tag - 1]] direction:(sender.tag -1)< _curPage animated:YES completion:^(BOOL finished) {
        _curPage = sender.tag - 1;
    }];
}
//#pragma mark========UIPageViewControllerDelegate=========================
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
//{
//    NSInteger index = [_vcArray indexOfObject:viewController];
//    if (index == 2) {
//        return nil;
//    }
//    return _vcArray[++index];
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
//{
//    NSInteger index = [_vcArray indexOfObject:viewController];
//    if (index == 0) {
//        return nil;
//    }
//    return _vcArray[--index];
//}
//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
//{
//    _curPage = [_vcArray indexOfObject:pageViewController.viewControllers[0]];
//    UIButton *selectBnt = (UIButton *)[self.view viewWithTag:_curPage + 1];
//    for(int i = 0 ; i < 3; i ++)
//    {
//        UIButton *bnt = (UIButton *)[self.view viewWithTag:i + 1];
//        if(bnt == selectBnt)
//        {
//            bnt.selected = YES;
//        }
//        else
//        {
//            bnt.selected = NO;
//        }
//    }
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%f",scrollView.contentOffset.x);
//    CGFloat ratio = (WIDTH/3- 30)/WIDTH;
//    CGRect rect = _coverView.frame;
//    rect.origin.x = 15 + (scrollView.contentOffset.x - WIDTH) * ratio + _curPage * WIDTH / 3;
//    _coverView.frame = rect;
//    NSLog(@"%f %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

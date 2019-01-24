//
//  JHTabBarVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTabBarVC.h"
#import "JHBaseNavVC.h"
#import "JHShopListVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "JHRunVC.h"
#import "JHCommunityHomeVC.h"
#import "JHWaiMaiFilterListVC.h"
#import "JHTempWebViewVC.h"
#import "JHNewTempHomePageVC.h"
#import "JHHeadLinesVC.h"
#import "JHNewMyCenter.h"
#import "JHTempWebViewVC.h"
@interface JHTabBarVC ()
@end
@implementation JHTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建子items
    [self createSubViewControl];
}
#pragma mark - 创建子item
- (void)createSubViewControl
{

    JHNewTempHomePageVC *vc1 = [JHNewTempHomePageVC new];
    vc1.title = NSLocalizedString(@"首页", nil);

    JHBaseNavVC *nav1 = [[JHBaseNavVC alloc] initWithRootViewController:vc1];
    nav1.navigationBarHidden  = YES;
    
    JHBaseVC *vc2 = [JHShopListVC new];
    vc2.title  = NSLocalizedString(@"附近",nil);
    [vc2.tabBarItem setImage:[UIImage imageNamed:@"nearby"]];
    JHBaseNavVC *nav2 = [[JHBaseNavVC alloc] initWithRootViewController:vc2];
    nav2.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
    JHHeadLinesVC *vc3 = [JHHeadLinesVC new];
    JHBaseNavVC *nav3 = [[JHBaseNavVC alloc] initWithRootViewController:vc3];
    vc3.title = NSLocalizedString(@"头条",nil);
    nav3.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
    
    JHTempWebViewVC *vc4 = [JHTempWebViewVC new];
    JHBaseNavVC *nav4 = [[JHBaseNavVC alloc] initWithRootViewController:vc4];
    vc4.title = NSLocalizedString(@"商圈",nil);
    vc4.url = SHANGQUAN_LINK;
    vc4.isShangQuan = YES;
    nav4.fd_fullscreenPopGestureRecognizer.enabled = NO;

    JHNewMyCenter *vc5 = [JHNewMyCenter new];
    vc5.title  = NSLocalizedString(@"我的", nil);
    JHBaseNavVC *nav5 = [[JHBaseNavVC alloc] initWithRootViewController:vc5];
    
    NSArray *arr = @[vc1,vc2,vc3,vc4,vc5];
    for (int i = 1; i < arr.count + 1; i ++) {
        UIImage *mySelectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"newYear_tabbar0%d",i]];
        mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *defalutImage = [UIImage imageNamed:[NSString stringWithFormat:@"newYear_tabbar0%d_pre",i]];
        defalutImage = [defalutImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        JHBaseVC *Vc = arr[i-1];
        Vc.tabBarItem.selectedImage = defalutImage;
        Vc.tabBarItem.image = mySelectedImage;
    }
    self.tabBar.tintColor = RGBA(255, 162, 0, 1);
    self.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
}
@end

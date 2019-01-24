//
//  JHSeatAndNumberListVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSeatAndNumberListVC.h"
#import "JHSeatListVC.h"
#import "JHNumberListVC.h"
#import <YFIndexIndicatorView.h>
#import <YFPageViewController.h>



@interface JHSeatAndNumberListVC ()<YFIndexIndicatorViewDelegate,YFPageViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *subVCArr;
@property(nonatomic,weak)YFIndexIndicatorView *indicatorView;
@property(nonatomic,weak)YFPageViewController *pageViewController;

@end

@implementation JHSeatAndNumberListVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    self.navigationItem.title =  NSLocalizedString(@"我的预约", NSStringFromClass([self class]));
    
}

-(void)setUpView{
    
    NSArray *arr = @[@{@"title": NSLocalizedString(@"我的号单", NSStringFromClass([self class])),@"badge":@"0"},
                     @{@"title": NSLocalizedString(@"我的订座", NSStringFromClass([self class])),@"badge":@"0"},
               ];
    
    YFIndexIndicatorView *indicatorView = [YFIndexIndicatorView new];
    [self.view addSubview:indicatorView];
    [indicatorView mas_constraint:^(UIView *make) {
        make.yf_mas_top = NAVI_HEIGHT;
        make.yf_mas_left = 0;
        make.yf_mas_right = 0;
        make.yf_mas_height = 44;
    }];
    indicatorView.index_arr = arr;
    indicatorView.delegate = self;
    indicatorView.scrollEnabled = NO;
    indicatorView.showAnmation = NO;
    indicatorView.showIndicatorLineView = YES;
    indicatorView.indicatorLineWidth = 50;
    indicatorView.indicatorLineColor = Orange_COLOR;
    indicatorView.indicatorLineAutoWidth = NO;
    self.indicatorView = indicatorView;
    
    self.subVCArr = [NSMutableArray array];

    JHNumberListVC *vc = [JHNumberListVC new];
    vc.yf_base_index = 0;
    vc.superVC = self;
    JHSeatListVC *vc1 = [JHSeatListVC new];
    vc1.yf_base_index = 1;
    vc1.superVC = self;
    [self.subVCArr addObject:vc];
    [self.subVCArr addObject:vc1];
    
    YFPageViewController *pageViewController = [[YFPageViewController alloc] initWithTransformType:VCTransformType_Scroll vcArr:self.subVCArr.copy];
    pageViewController.view.frame = CGRectMake(0, NAVI_HEIGHT + 44, WIDTH, HEIGHT - NAVI_HEIGHT);
    pageViewController.delegate = self;
    pageViewController.superVC = self;
    [self addChildViewController:pageViewController];
    self.pageViewController = pageViewController;
    [self.view addSubview:pageViewController.view];
    
//    UIView *top_lineView=[UIView new];
//    [indicatorView addSubview:top_lineView];
//    [top_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset=0;
//        make.top.offset=0;
//        make.right.offset=0;
//        make.height.offset=1;
//    }];
//    top_lineView.backgroundColor=LINE_COLOR;
    
    UIView *bottom_lineView=[UIView new];
    [indicatorView addSubview:bottom_lineView];
    [bottom_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset=0;
        make.height.offset=1;
    }];
    bottom_lineView.backgroundColor=LINE_COLOR;
    
}

#pragma mark ====== YFIndexIndicatorViewDelegate =======
- (void)indexIndicatorView :(YFIndexIndicatorView *)indexIndicatorView didSelectItemAtIndex:(NSInteger)index{    
    self.pageViewController.current_index = index;
    
    
}

#pragma mark ====== YFPageViewControllerDelegate =======
-(void)pageViewController:(YFPageViewController *)pageViewController
   showNextViewController:(YFBasePageVC *)subVC
               showNextVC:(NSUInteger)index{
    self.indicatorView.scrollToIndex = index;
}
@end


//
//  JHGroupOrderVC.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHGroupOrderVC.h"
#import "JHGroupOrderListVC.h"
#import <YFIndexIndicatorView.h>
#import <YFPageViewController.h>



@interface JHGroupOrderVC ()<YFIndexIndicatorViewDelegate,YFPageViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *subVCArr;
@property(nonatomic,weak)YFIndexIndicatorView *indicatorView;
@property(nonatomic,weak)YFPageViewController *pageViewController;

@end

@implementation JHGroupOrderVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    self.navigationItem.title =  NSLocalizedString(@"团购单", NSStringFromClass([self class]));
    
}

-(void)setUpView{
    
    NSArray *arr = @[@{@"title": NSLocalizedString(@"全部", NSStringFromClass([self class])),@"badge":@"0"},
                     @{@"title": NSLocalizedString(@"待付款", NSStringFromClass([self class])),@"badge":@"0"},
                     @{@"title": NSLocalizedString(@"待使用", NSStringFromClass([self class])),@"badge":@"0"},
                     @{@"title": NSLocalizedString(@"待评价", NSStringFromClass([self class])),@"badge":@"0"},
                     @{@"title": NSLocalizedString(@"退款", NSStringFromClass([self class])),@"badge":@"0"}];
    
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
//    indicatorView.scrollToIndex = 0;
    self.indicatorView = indicatorView;

    self.subVCArr = [NSMutableArray array];
    for (int i=0; i<arr.count; i++) {
        JHGroupOrderListVC *vc = [JHGroupOrderListVC new];
        vc.yf_base_index = i;
        vc.superVC = self;
        [self.subVCArr addObject:vc];
    }
    
    YFPageViewController *pageViewController = [[YFPageViewController alloc] initWithTransformType:VCTransformType_Scroll vcArr:self.subVCArr.copy];
    pageViewController.view.frame = CGRectMake(0, NAVI_HEIGHT + 44, WIDTH, HEIGHT - NAVI_HEIGHT);
    pageViewController.delegate = self;
    pageViewController.superVC = self;
    [self addChildViewController:pageViewController];
    self.pageViewController = pageViewController;
    [self.view addSubview:pageViewController.view];
    
    UIView *top_lineView=[UIView new];
    [indicatorView addSubview:top_lineView];
    [top_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=1;
    }];
    top_lineView.backgroundColor=LINE_COLOR;
    
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

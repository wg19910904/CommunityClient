//
//  JHHouseKeepingEvaluationVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseKeepingEvaluationVC.h"
#import "JHHouseKeepingEvaluationSubVC.h"
@interface JHHouseKeepingEvaluationVC ()<UIPageViewControllerDelegate>
{
    UIView *_backView;//按钮背景图片
    UIPageViewController *_pvc;
    NSMutableArray *_vcArray;
    NSInteger _curPage;
    UIView *_coverView;
    UIButton *_lastBnt;
    
}
@end

@implementation JHHouseKeepingEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    self.view.frame = FRAME(0, 189, WIDTH, HEIGHT - 189);
    [self createBnt];
    [self initVCArray];
    [self initPageVc];
    
}
#pragma mark========创建UIPageViewController========
- (void)initPageVc
{
    _pvc = [[UIPageViewController alloc] initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pvc.delegate = self;
    _pvc.view.frame = FRAME(0, 30, WIDTH , HEIGHT - 189 - 30);
    _pvc.view.backgroundColor = BACK_COLOR;
    [_pvc setViewControllers:@[_vcArray[0]] direction:1 animated:YES completion:nil];
    [self.view addSubview:_pvc.view];
    [_pvc.view.subviews[0] setDelegate:self];
    
}
#pragma mark=========创建子视图控制器数组==============
- (void)initVCArray
{
    _vcArray = [NSMutableArray array];
    for(int i = 0 ; i < 4; i ++)
    {
        JHHouseKeepingEvaluationSubVC *sub = [[JHHouseKeepingEvaluationSubVC alloc] init];
        sub.staff_id = self.staff_id;
        sub.index = i;
       [_vcArray addObject:sub];
    }
}
#pragma mark=======搭建UI界面==========
- (void)createBnt
{
    
    _backView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 30)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = THEME_COLOR;
    [_backView addSubview:_coverView];
    for(int i = 0 ; i < 4; i ++)
    {
        UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        bnt.frame = FRAME(i * (WIDTH / 4), 0, WIDTH / 4, 30);
        bnt.titleLabel.font = FONT(14);
        bnt.tag = i + 1;
        [bnt addTarget:self action:@selector(clickBnt:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0)
        {
            _coverView.frame = FRAME(bnt.center.x - 25, 29, 50, 1);
            if(self.countDic[@"i"] == nil)
            {
               [bnt setTitle:[NSString stringWithFormat:NSLocalizedString(@"全部(%@)", nil),@"0"] forState:UIControlStateNormal];
            }
            else
            {
                [bnt setTitle:[NSString stringWithFormat:NSLocalizedString(@"全部(%@)", nil),self.countDic[@"i"]] forState:UIControlStateNormal];
            }
            [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        }
        else if(i == 1)
        {
            if(self.countDic[@"a"] == nil)
            {
                 [bnt setTitle:[NSString stringWithFormat:NSLocalizedString(@"好评(%@)", nil),@"0"] forState:UIControlStateNormal];
            }
            else
            {
                 [bnt setTitle:[NSString stringWithFormat:NSLocalizedString(@"好评(%@)", nil),self.countDic[@"a"]] forState:UIControlStateNormal];
            }
           
            [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        }
        else if(i== 2)
        {
            if(self.countDic[@"b"] == nil)
            {
                 [bnt setTitle:[NSString stringWithFormat:NSLocalizedString(@"中评(%@)", nil),@"0"] forState:UIControlStateNormal];
            }
            else
            {
                 [bnt setTitle:[NSString stringWithFormat:NSLocalizedString(@"中评(%@)", nil),self.countDic[@"b"]] forState:UIControlStateNormal];
            }
           
            [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
            
        }
        else
        {
            if(self.countDic[@"c"] == nil)
            {
                [bnt setTitle:[NSString stringWithFormat:NSLocalizedString(@"差评(%@)", nil),@"0"] forState:UIControlStateNormal];
            }
            else
            {
                [bnt setTitle:[NSString stringWithFormat:NSLocalizedString(@"差评(%@)", nil),self.countDic[@"c"]] forState:UIControlStateNormal];
            }
            [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        }
        bnt.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    _coverView.center = CGPointMake(sender.center.x, 29);
    [_pvc setViewControllers:@[_vcArray[sender.tag - 1]] direction:(sender.tag -1)< _curPage animated:YES completion:^(BOOL finished) {
        _curPage = sender.tag - 1;
    }];
}

@end

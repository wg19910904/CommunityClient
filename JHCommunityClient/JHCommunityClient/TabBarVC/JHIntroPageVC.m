

//
//  JHIntroPageVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//引导页

#import "JHIntroPageVC.h"

@interface JHIntroPageVC ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIButton *_btn;
    NSArray *_imgArray;
}
@end

@implementation JHIntroPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self createBtn];
}
#pragma mark======创建滚动视图======
- (void)createScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _imgArray = @[@"intro1",@"intro2",@"intro3",@"intro4"];
    for(int i = 0; i < _imgArray.count; i ++){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(i * WIDTH, 0, WIDTH, HEIGHT)];
        imgView.image = IMAGE(_imgArray[i]);
        [_scrollView addSubview:imgView];
        imgView.tag = i + 1;
        if(i == _imgArray.count - 1){
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
            [imgView addGestureRecognizer:tap];
        }
    }
    _scrollView.contentSize = CGSizeMake(_imgArray.count * WIDTH, 0);
}
#pragma  mark======创建立即体验按钮=====
- (void)createBtn{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = FRAME((WIDTH - 150)/ 2, HEIGHT - 60, 150, 40);
    [_btn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [_btn setBackgroundColor:THEME_COLOR forState:UIControlStateHighlighted];
    _btn.layer.cornerRadius = 20.0f;
    _btn.clipsToBounds = YES;
    _btn.titleLabel.font = FONT(23);
    [_btn setTitle:NSLocalizedString(@"立即体验", nil) forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.hidden = YES;
    [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:_imgArray.count];
    [imgView addSubview:_btn];
}
#pragma mark=====立即体验按钮点击事件==========
- (void)btnClick{
    NSLog(@"==========点我了========");
    __unsafe_unretained typeof (self)weakSelf = self;
    if(weakSelf.bntBlock){
        weakSelf.bntBlock();
    }
}
@end

//
//  ZQSegementViewController.m
//  ZQSegementViewController
//
//  Created by ijiaghu on 17/3/20.
//  Copyright © 2017年 zq. All rights reserved.
//

#import "ZQSegementViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth 70
#define titleHeight 40

@interface ZQSegementViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    UIButton *selectButton;
    UIView *_sliderView;
    UIViewController *_viewController;
}
@property(nonatomic,retain)UICollectionView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end


@implementation ZQSegementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    _buttonArray = [[NSMutableArray alloc] init];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = [[NSArray alloc] initWithArray:titleArray];
    [self initWithTitleButton];
}

- (void)setControllerArray:(NSMutableArray *)controllerArray {
    _controllerArray = controllerArray;
    [self myCollectionView];
}
- (void)initWithTitleButton
{
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, 40)];
    if (titleWidth*_titleArray.count > WIDTH) {
         scroll.contentSize = CGSizeMake(titleWidth*_titleArray.count, 40);
    }else{
         scroll.contentSize = CGSizeMake(WIDTH, 40);
    }
    scroll.bounces = YES;
    scroll.scrollEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    [scroll flashScrollIndicators];
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    _scroll = scroll;
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (titleWidth*_titleArray.count > WIDTH) {
           titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        }else{
            CGFloat w = WIDTH/_titleArray.count;
            titleButton.frame = CGRectMake(w*i, 0, w, titleHeight);
        }
        [titleButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        titleButton.backgroundColor = [UIColor whiteColor];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [scroll addSubview:titleButton];
        if (i == self.index) {
            titleButton.selected = YES;
            selectButton = titleButton;
        }
        [_buttonArray addObject:titleButton];
    }
}
- (void)scrollViewSelectToIndex:(UIButton *)button
{
    selectButton.selected = NO;
    button.selected = !button.selected;
    selectButton = button;
    if (titleWidth*_titleArray.count > WIDTH) {
         [self selectButton:button.tag-100];
    }
    [_scrollView setContentOffset:CGPointMake(WIDTH*(button.tag-100), 0) animated:YES];
}

//选择某个标题
- (void)selectButton:(NSInteger)index
{
    CGRect rect = [selectButton.superview convertRect:selectButton.frame toView:self.view];
    CGPoint contentOffset = _scroll.contentOffset;
    [UIView animateWithDuration:0.25 animations:^{
        if (contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2)<=0) {
            [_scroll setContentOffset:CGPointMake(0, contentOffset.y) animated:NO];
        } else if (contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2)+SCREEN_WIDTH>=_titleArray.count*titleWidth) {
            [_scroll setContentOffset:CGPointMake(_titleArray.count*titleWidth-SCREEN_WIDTH, contentOffset.y) animated:NO];
        } else {
            [_scroll setContentOffset:CGPointMake(contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2),contentOffset.y) animated:NO];
        }

    }];
}
#pragma mark - collectionView
-(UICollectionView *)myCollectionView{
    if (!_scrollView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _scrollView = [[UICollectionView alloc]initWithFrame:FRAME(0, 114, WIDTH, HEIGHT - 114) collectionViewLayout:layout];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        [_scrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _scrollView.delegate = self;
        _scrollView.dataSource = self;
        [self.view addSubview:_scrollView];
        [_scrollView setContentOffset:CGPointMake(WIDTH*self.index, 0) animated:NO];
    }
    return _scrollView;
}
//collectionview的代理和数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.controllerArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH, HEIGHT - 114);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JHBaseVC *vc = self.controllerArray[indexPath.row];
    [self addChildViewController:vc];
    [cell addSubview:vc.view];
    return cell;
}
@end

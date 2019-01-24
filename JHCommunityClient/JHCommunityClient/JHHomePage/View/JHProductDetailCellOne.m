//
//  JHProductDetailCellOne.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHProductDetailCellOne.h"
#import "UIImageView+WebCache.h"
@implementation JHProductDetailCellOne
{
    UIScrollView *_top_scrollView;
    UIImageView *iv1;
    UIImageView *iv2;
    UIImageView *iv3;
    UIPageControl *pageControl;
    UILabel *titleLabel;
    UILabel *infoLabel;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        //添加子控件
//        [self createSubViews];
//    }
//    return self;
//}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加子控件
        [self createSubViews];
    }
    return self;
}
#pragma mark - 添加子控件
- (void)createSubViews
{
    CGFloat height = 0;
//    _top_scrollView = [[UIScrollView alloc] initWithFrame:FRAME(0, 0, WIDTH, height)];
//    _top_scrollView.delegate = self;
//    _top_scrollView.pagingEnabled = YES;
//    _top_scrollView.showsHorizontalScrollIndicator = NO;
//    pageControl = [[UIPageControl alloc]initWithFrame:FRAME(0, height-20,80, 20)];
//    pageControl.currentPageIndicatorTintColor = THEME_COLOR;
//    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.currentPage = 0;
//    pageControl.center = CGPointMake(self.center.x, pageControl.center.y);
    titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, height, WIDTH - 20, 30)];
    titleLabel.font = FONT(16);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    infoLabel = [[UILabel alloc] initWithFrame:FRAME(10, height+25, WIDTH - 29, 30)];
    infoLabel.font = FONT(14);
    infoLabel.textColor = HEX(@"999999", 1.0f);
    //添加下划线
    UIView *line = [[UIView alloc] initWithFrame:FRAME(0, height+59.5, WIDTH, 0.5)];
    line.backgroundColor = LINE_COLOR;
    
//    [self addSubview:_top_scrollView];
//    [self addSubview:pageControl];
    [self addSubview:titleLabel];
    [self addSubview:infoLabel];
    [self addSubview:line];
}
#pragma mark - 外部数据传入时,刷新内容
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
//    //定义高度
//    CGFloat height = WIDTH;
//    NSArray *photos = dataDic[@"photos"];
//    NSInteger count = photos.count;
//    _top_scrollView.contentSize = CGSizeMake(WIDTH * count, 0);
//    pageControl.numberOfPages = count;
//    for (int i = 0; i < count; i++) {
//        UIImageView *iv = [[UIImageView alloc] initWithFrame:FRAME(WIDTH * i, 0, WIDTH, height)];
//        NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:photos[i]]];
//        [iv sd_setImageWithURL:url placeholderImage:IMAGE(@"commondefault")];
//        [_top_scrollView addSubview:iv];
//        
//    }
    titleLabel.text = dataDic[@"title"];
    NSString *content;
    if ([dataDic[@"sale_type"] integerValue] == 0) {
        content = [NSString stringWithFormat:NSLocalizedString(@"月售:%@", nil),dataDic[@"sale_count"]];
    }else{
        content = [NSString stringWithFormat:NSLocalizedString(@"月售:%@  库存:%@", nil),dataDic[@"sales"],dataDic[@"sale_sku"]];
    }
    infoLabel.text = content;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_x = scrollView.contentOffset.x;
    NSInteger index =  offset_x/WIDTH;
    pageControl.currentPage = index;
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_clickBtnBlock) {
        _clickBtnBlock();
    }
}
@end

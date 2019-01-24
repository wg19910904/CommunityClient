//
//  TempHomeTopCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "TempHomeTopCell.h"
#import "ZZCarouselControl.h"
#import <UIImageView+WebCache.h>
#import "JHTempAdvModel.h"
@interface TempHomeTopCell()<ZZCarouselDataSource,ZZCarouselDelegate>
@property(nonatomic,strong)ZZCarouselControl * carouselView;//滚动视图的控制器

@end
@implementation TempHomeTopCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setArray:(NSMutableArray *)array{
    _array = array;
    [_carouselView removeFromSuperview];
    _carouselView = nil;
    if (_array.count > 0) {
        [self carouselView];
    }
}
//初始化轮播视图
-(ZZCarouselControl *)carouselView{
    if (!_carouselView) {
        _carouselView = [[ZZCarouselControl alloc]initWithFrame:FRAME(0, 0, WIDTH, WIDTH/2)];
        _carouselView.carouseScrollTimeInterval = 2.0f;
        _carouselView.dataSource = self;
        _carouselView.delegate = self;
         [_carouselView reloadData];
        [self addSubview:_carouselView];
    }
    return  _carouselView;
}
#pragma mark --- dataSource
-(NSArray *) zzcarousel:(ZZCarouselControl *)carouselView
{
    return self.array;
}

-(UIView *) zzcarousel:(ZZCarouselControl *)carouselView carouselFrame:(CGRect)frame data:(NSArray *)data viewForItemAtIndex:(NSInteger)index
{
    /*
     *   此方法中必须返回UIView
     *   注意在此方法中创建 UI 控件时，必须使用此方法冲的frame参数来设定位置。
     *   注意在此方法中的数据源必须从data参数中获取。
     */
    UIView *view = [[UIView alloc]initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    JHTempAdvModel *model = data[index];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.thumb]];
    [imageView sd_setImageWithURL:url placeholderImage:IMAGE(@"tgtopdeafault")];
    [view addSubview:imageView];
    return view;
}

#pragma mark --- delegate

-(void)zzcarouselView:(ZZCarouselControl *)zzcarouselView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了 %lu",index);
    if (self.clickBlock) {
        self.clickBlock(index);
    }
}

@end

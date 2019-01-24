//
//  DisplayImageInView.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/28.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "DisplayImageInView.h"
#import "UIImageView+NetStatus.h"
@implementation DisplayImageInView
{
    UIScrollView * scrollV;
    UILabel * label_image;
    
}
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//直接传图片数组(@[@"1.png",@"2.png"])
-(void)showInViewWithImageArray:(NSArray *)imageArray withIndex:(NSInteger )index withBlock:(void(^)(void))click{
    self.backgroundColor = [UIColor blackColor];
    self.frame = FRAME(0, 0, WIDTH, HEIGHT);
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    //创建点击view移除图片展示的view
    UITapGestureRecognizer * tap_remove = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove_image:)];
    [self addGestureRecognizer:tap_remove];
    //创建显示图片的个数和当前第几张的label
    if (label_image == nil) {
        label_image = [[UILabel alloc]init];
        label_image.backgroundColor = [UIColor blackColor];
        label_image.bounds = CGRectMake(0, 0, 50, 30);
        label_image.center = CGPointMake(self.center.x,self.center.y - WIDTH / 2 - 20);
        label_image.text = [NSString stringWithFormat:@"%ld/%ld",index,imageArray.count];
        label_image.textAlignment = NSTextAlignmentCenter;
        label_image.textColor  = [UIColor whiteColor];
        [self addSubview:label_image];
    }
    //创建中间的scrollView
    if (scrollV == nil) {
        scrollV = [[UIScrollView alloc]init];
        scrollV.bounds = CGRectMake(0, 0,WIDTH, WIDTH);
        scrollV.center = self.center;
        scrollV.contentSize = CGSizeMake(WIDTH*imageArray.count,WIDTH);
        [scrollV setContentOffset:CGPointMake((index - 1)*WIDTH, 0)];
        scrollV.tag = imageArray.count;
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollV];
    }
    //设置滑动视图整页滑动
    scrollV.pagingEnabled = YES;
    //滑动到头／尾的时候，不能滑动
    scrollV.bounces = NO;
    scrollV.delegate = self;
    scrollV.backgroundColor = [UIColor clearColor];
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.showsVerticalScrollIndicator = NO;
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH, WIDTH)];
        imageView.image = imageArray[i];
        [scrollV addSubview:imageView];
   }
    [self setBlock:^(){
        click();
    }];
}
#pragma mark - 这是移除蒙版的手势
-(void)remove_image:(UITapGestureRecognizer *)sender{
    [scrollV removeFromSuperview];
    scrollV = nil;
    [label_image removeFromSuperview];
    label_image = nil;
    self.block();
}
#pragma mark - 这是滑动视图的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int  a = scrollView.contentOffset.x/WIDTH + 1;
    label_image.text = [NSString stringWithFormat:@"%d/%ld",a,scrollView.tag];
}

//传图片的url
-(void)showInViewWithImageUrlArray:(NSArray *)imageArray withIndex:(NSInteger )index withBlock:(void(^)(void))click{
    self.backgroundColor = [UIColor blackColor];
    self.frame = FRAME(0, 0, WIDTH, HEIGHT);
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    //创建点击view移除图片展示的view
    UITapGestureRecognizer * tap_remove = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove_image:)];
    [self addGestureRecognizer:tap_remove];
    //创建显示图片的个数和当前第几张的label
    if (label_image == nil) {
        label_image = [[UILabel alloc]init];
        label_image.backgroundColor = [UIColor blackColor];
        label_image.bounds = CGRectMake(0, 0, 50, 30);
        label_image.center = CGPointMake(self.center.x,self.center.y - WIDTH / 2 - 20);
        label_image.text = [NSString stringWithFormat:@"%ld/%ld",index,imageArray.count];
        label_image.textAlignment = NSTextAlignmentCenter;
        label_image.textColor  = [UIColor whiteColor];
        [self addSubview:label_image];
    }
    //创建中间的scrollView
    if (scrollV == nil) {
        scrollV = [[UIScrollView alloc]init];
        scrollV.bounds = CGRectMake(0, 0,WIDTH, WIDTH);
        scrollV.center = self.center;
        scrollV.contentSize = CGSizeMake(WIDTH*imageArray.count,WIDTH);
        [scrollV setContentOffset:CGPointMake((index - 1)*WIDTH, 0)];
        scrollV.tag = imageArray.count;
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollV];
    }
    //设置滑动视图整页滑动
    scrollV.pagingEnabled = YES;
    //滑动到头／尾的时候，不能滑动
    scrollV.bounces = NO;
    scrollV.delegate = self;
    scrollV.backgroundColor = [UIColor clearColor];
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.showsVerticalScrollIndicator = NO;
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH,WIDTH)];
        [imageView sd_image:[NSURL URLWithString:imageArray[i]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
        [scrollV addSubview:imageView];
    }
    [self setBlock:^(){
        click();
    }];
}
@end

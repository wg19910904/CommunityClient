//
//  MJBannnerPlayer.m
//  MJBannerPlayer
//
//  Created by WuXushun on 16/1/21.
//  Copyright © 2016年 wuxushun. All rights reserved.
//

#import "MJBannnerPlayer.h"
#import <UIImageView+WebCache.h>

@interface MJBannnerPlayer ()<UIScrollViewDelegate>
@property (nonatomic) CGFloat timeInterval;
@property(nonatomic,weak)UIPageControl *pageControl;
@property (nonatomic) CGRect currentRect;
@property (nonatomic, strong)  UIScrollView *mainSv;
@property (nonatomic) NSUInteger index;


@end

@implementation MJBannnerPlayer

//便利构造器
+ (void)initWithSourceArray:(NSArray *)picArray
                  addTarget:(id)controller
                   withSize:(CGRect)frame
           withTimeInterval:(CGFloat)interval{
    
    MJBannnerPlayer *new = [[MJBannnerPlayer alloc]initWithFrame:frame];
    new.currentRect = frame;
    new.timeInterval = interval;
    if ([controller isKindOfClass:[UIView class]]) {
        
        [controller addSubview:new];
        
    }else if ([controller isKindOfClass:[UIViewController class]]){
        
        UIViewController *view = controller;
        
        [view.view addSubview:new];
        
    }
    [new setImage:picArray is_url:NO];
    [new initTimer];
    
}

+ (void)initWithUrlArray:(NSArray *)urlArray
               addTarget:(UIViewController *)controller
                withSize:(CGRect)frame
        withTimeInterval:(CGFloat)interval{

    MJBannnerPlayer *new = [[MJBannnerPlayer alloc]initWithFrame:frame];
    new.currentRect = frame;
    new.timeInterval = interval;
    [controller.view addSubview:new];
    [new initTimer];
    [new setImage:urlArray is_url:YES];

}


//便利构造器
- (MJBannnerPlayer *)initWithSourceArray:(NSArray *)picArray
                   withSize:(CGRect)frame
           withTimeInterval:(CGFloat)interval{
    
    MJBannnerPlayer *new = [[MJBannnerPlayer alloc]initWithFrame:frame];
    new.currentRect = frame;
    new.timeInterval = interval;
    [new setImage:picArray is_url:NO];
    [new initTimer];
    return new;
    
}

- (MJBannnerPlayer *)initWithUrlArray:(NSArray *)urlArray
                withSize:(CGRect)frame
        withTimeInterval:(CGFloat)interval{
    
    MJBannnerPlayer *new = [[MJBannnerPlayer alloc]initWithFrame:frame];
    new.currentRect = frame;
    new.timeInterval = interval;
    [new initTimer];
    [new setImage:urlArray is_url:YES];
     return new;
}

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.currentRect = frame;
        [self initScrollView];
        [self initImageView];
    }

    return self;
    
}

//初始化主滑动视图
-(void)initScrollView{
  

    self.mainSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.currentRect.size.width, self.currentRect.size.height)];
    self.mainSv.bounces = NO;
    self.mainSv.showsHorizontalScrollIndicator = NO;
    self.mainSv.showsVerticalScrollIndicator = NO;
    self.mainSv.pagingEnabled = YES;
    self.mainSv.contentSize = CGSizeMake(self.currentRect.size.width * 3, self.currentRect.size.height);
    self.mainSv.delegate = self;
    [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
    [self addSubview:self.mainSv];

}

//初始化imageview
-(void)initImageView{

    CGFloat width = 0;
    
    for (int a = 0; a < 3; a++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width, 0, self.currentRect.size.width, self.currentRect.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = a + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgActive:)];
        [imageView addGestureRecognizer:tap];
        [self.mainSv addSubview:imageView];
        width += self.currentRect.size.width;
        
    }

}

//自动布局创建自定义的pageController
-(void)initMXPageController:(NSUInteger)totalPageNumber{
    self.index=0;
    if (self.pageControl) {
        self.pageControl.numberOfPages=totalPageNumber;
        self.pageControl.currentPage=0;
    }else{
        UIPageControl *page=[[UIPageControl alloc] initWithFrame:CGRectMake((self.currentRect.size.width-100)/2.0, self.currentRect.size.height-10, 100, 0)];
        page.numberOfPages=totalPageNumber;
        page.currentPage=0;
        page.transform=CGAffineTransformMakeScale(1.2, 1.2);
        page.currentPageIndicatorTintColor=THEME_COLOR;
        page.pageIndicatorTintColor=[UIColor whiteColor];
    
        [self addSubview:page];
        self.pageControl=page;
    }
}

//初始化一个定时器
-(void)initTimer{

    if (self.timer == nil) {
        
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]
                                             interval:self.timeInterval
                                               target:self
                                             selector:@selector(timerActive:)
                                             userInfo:nil
                                              repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }

}

//点击图片的回调
-(void)imgActive:(id)sender{

    if (self.clickAD) {
        self.clickAD(self.index);
    }
    
}

//定时器事件
-(void)timerActive:(id)sender{
    
    [self.mainSv scrollRectToVisible:CGRectMake(self.currentRect.size.width * 2, 0, self.currentRect.size.width, self.currentRect.size.height) animated:YES];

}


//首次初始化图片
-(void)setImage:(NSArray *)sourceList is_url:(BOOL)is_url{
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    UIImageView *indexViewOne = (UIImageView *)[self.mainSv viewWithTag:1];
    UIImageView *indexViewTwo = (UIImageView *)[self.mainSv viewWithTag:2];
    UIImageView *indexViewThree = (UIImageView *)[self.mainSv viewWithTag:3];
    
    self.index = 0;

    if (is_url) {
        [tempArray addObjectsFromArray:sourceList];
        if (tempArray.count > 0) {
            
            if (sourceList.count == 1){
                [indexViewOne sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
                [indexViewTwo sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
                [indexViewThree sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
            }else if (sourceList.count == 2){
                
                [indexViewOne sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
                [indexViewTwo sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
                [indexViewThree sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];

            }else{
                
                [indexViewOne sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:tempArray.count - 1]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
                [indexViewTwo sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
                [indexViewThree sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
            }
            
            self.sourceArray = tempArray;
            [self initMXPageController:self.sourceArray.count];
            
        }
        
    }else{
        for (NSString * obj in sourceList) {
            UIImage *image=[UIImage imageNamed:obj];
            [tempArray addObject:image];
        }
        
        if (tempArray.count > 0) {
            
            if (sourceList.count == 1){
                
                [tempArray addObject:[tempArray objectAtIndex:0]];
                [tempArray addObject:[tempArray objectAtIndex:0]];
                indexViewOne.image = [tempArray objectAtIndex:0];
                indexViewTwo.image = [tempArray objectAtIndex:0];
                indexViewThree.image = [tempArray objectAtIndex:0];
                
            }else if (sourceList.count == 2){
                
                [tempArray addObject:[tempArray objectAtIndex:0]];
                indexViewOne.image = [tempArray objectAtIndex:1];
                indexViewTwo.image = [tempArray objectAtIndex:0];
                indexViewThree.image = [tempArray objectAtIndex:1];
                
            }else{
                
                indexViewOne.image = [tempArray objectAtIndex:tempArray.count - 1];
                indexViewTwo.image = [tempArray objectAtIndex:0];
                indexViewThree.image = [tempArray objectAtIndex:1];
                
            }
            
            self.sourceArray = tempArray;
            [self initMXPageController:self.sourceArray.count];
        }

    }
    
}

//设置图片
-(void)setPicWithIndex:(NSUInteger)index withImage:(UIImage *)img{

    UIImageView *indexView = (UIImageView *)[self.mainSv viewWithTag:index];
    if ([img isKindOfClass:[NSString class]]) {
        [indexView sd_setImageWithURL:[NSURL URLWithString:(NSString *)img] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
    }else  indexView.image = img;

}

//触摸后停止定时器
- (void)scrollViewWillBeginDragging:( UIScrollView *)scrollView{

    if (self.timer != nil) {
        
        [self.timer invalidate];
        self.timer = nil;
        
    }

}

//触摸停止后再次启动定时器
- (void)scrollViewDidEndDragging:( UIScrollView *)scrollView willDecelerate:( BOOL )decelerate{
    
    [self initTimer];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == self.mainSv) {
        //三个图uiimageview交替部分
        if (self.mainSv.contentOffset.x == 0) {
            
            if (self.index == 0) {
                [self setPageCurrentNum:self.index+1];
                self.index = self.sourceArray.count - 1;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                if (self.sourceArray.count>1) {
                   [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                }else{
                    [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:0]];
                }
                
                [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:0]];
                
            }else{
               [self setPageCurrentNum:self.index+1];
                self.index --;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                
                if (self.index == 0) {
                    
                    [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.sourceArray.count - 1]];
                    
                }else{
                
                   [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                
                }
                
                [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
                
            }
            
        }else if (self.mainSv.contentOffset.x == self.currentRect.size.width * 2){
            
            if (self.index == self.sourceArray.count - 1) {
                [self setPageCurrentNum:self.index+1];
                self.index = 0;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.sourceArray.count - 1]];
                if (self.sourceArray.count>1) {
                    [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
                }else{
                    [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index]];
                }
                
            }else{
                [self setPageCurrentNum:self.index+1];
                self.index ++;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                
                if (self.index == self.sourceArray.count - 1) {
                    
                    [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:0]];
                    
                }else{
                
                    [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
                
                }
                
            }
        
        }
        
    }

}

-(void)setPageCurrentNum:(NSInteger)index{
    
    if (index==self.urlArray.count || index==self.sourceArray.count)  self.pageControl.currentPage=0;
    else self.pageControl.currentPage=index;
    
}

-(void)setUrlArray:(NSArray *)urlArray{
    _urlArray=urlArray;
    if (urlArray.count>1) {
        self.pageControl.hidden = NO;
    }else{
        self.pageControl.hidden = YES;
    }
    [self setImage:urlArray is_url:YES];
}


-(void)dealloc{
    [self.timer invalidate];
    _timer = nil;
}

-(NSString *)placeHolderImage{
    if (_placeHolderImage.length == 0 || _placeHolderImage == nil) {
        return @"tgtopdeafault";
    }
    return _placeHolderImage;
}

@end

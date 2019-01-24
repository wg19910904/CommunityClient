//
//  NewUpwardLunV.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/13.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "NewUpwardLunV.h"

#import "UIImageView+WebCache.h"
#import "JHTempAdvModel.h"

@interface NewUpwardLunV()
{
    NewUpwardLunV *banner;
}

//容器
@property(nonatomic,strong)UIScrollView     *scrollView;

/* 定时器 **/
@property(nonatomic,strong)NSTimer          *animationTimer;
/* 当前index **/
@property(nonatomic,assign)NSInteger        currentPageIndex;
/* 所有的图片数组 **/
@property(nonatomic,strong)NSMutableArray   *imageArray;
/* 当前图片数组，永远只存储三张图 **/
@property(nonatomic,strong)NSMutableArray   *currentArray;


@property(nonatomic,strong)NSMutableArray   *titleArr;
@property(nonatomic,strong)NSMutableArray   *titlecurrentArray;

@property(nonatomic,strong)NSMutableArray   *descArr;
@property(nonatomic,strong)NSMutableArray   *desccurrentArray;

/* block方式接收回调 */
@property(nonatomic,copy)tapActionBlock block;


@end



@implementation NewUpwardLunV

+ (instancetype)adsPlayViewWithFrame:(CGRect)rect imageGroup:(NSArray *)imageGroup{
    NewUpwardLunV *banner = [[self alloc]initWithFrame:rect];
    banner.imageGroup = [NSArray arrayWithArray:imageGroup];
    return banner;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self render];
    }
    return self;
}

//- (instancetype)init
//{
//    return [self initWithFrame:[UIScreen mainScreen].bounds];
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)render{
    self.autoresizesSubviews = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height*3);
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(0, self.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    [self addSubview:self.scrollView];
    
 
    
    //点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tapGesture];
    
    //默认五秒钟循环播放
    self.animationDuration = 2.;
   
    //默认第一张
    self.currentPageIndex = 0;
}
-(void)setAnimationDuration:(NSTimeInterval)animationDuration{
    _animationDuration = animationDuration;
    
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    
    if (animationDuration <= 0) {
        return;
    }
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:_animationDuration
                                                           target:self
                                                    selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
    
    [self.animationTimer setFireDate:[NSDate distantFuture]];
}
-(void)downLoadImage{
    if (self.imageGroup && self.imageGroup.count > 0) {
        self.imageArray = [NSMutableArray array];
        self.titleArr  = [NSMutableArray array];
        self.descArr = [NSMutableArray array];
        __weak typeof(self) weak = self;
        [self.imageGroup enumerateObjectsUsingBlock:^(JHTempAdvModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj.thumb] placeholderImage:self.placeHoldImage];
            [weak.imageArray addObject:imageView];
            
            UILabel *lab = [[UILabel alloc]init];
            lab.numberOfLines = 0;
            lab.font = FONT(14);
            lab.textColor = TEXT_COLOR;

            lab.text = obj.title;
            [weak.titleArr addObject:lab];
            
            UILabel *lab1 = [[UILabel alloc]init];
            lab1.numberOfLines = 0;
            lab1.font = FONT(11);
         
     
            lab1.text = obj.desc;
            [weak.descArr addObject:lab1];
        
        }];
        
        [self configContentViews];
    }
}
- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
    
    self.currentArray = (_currentArray?:[NSMutableArray new]);
    self.titlecurrentArray = (_titlecurrentArray?:[NSMutableArray new]);
    self.desccurrentArray = (_desccurrentArray?:[NSMutableArray new]);
    _currentArray.count == 0 ?:[_currentArray removeAllObjects];
    _titlecurrentArray.count == 0 ?:[_titlecurrentArray removeAllObjects];
    _desccurrentArray.count == 0 ?:[_desccurrentArray removeAllObjects];
    
    if (_imageArray) {
        if (_imageArray.count >= 3) {
            [_currentArray addObject:_imageArray[previousPageIndex]];
            [_currentArray addObject:_imageArray[_currentPageIndex]];
            [_currentArray addObject:_imageArray[rearPageIndex]];
            [_titlecurrentArray addObject:_titleArr[previousPageIndex]];
            [_titlecurrentArray addObject:_titleArr[_currentPageIndex]];
            [_titlecurrentArray addObject:_titleArr[rearPageIndex]];
            [_desccurrentArray addObject:_descArr[previousPageIndex]];
            [_desccurrentArray addObject:_descArr[_currentPageIndex]];
            [_desccurrentArray addObject:_descArr[rearPageIndex]];
        }
        else{
            [self getImageFromArray:_imageArray[previousPageIndex] withLab:_titleArr[previousPageIndex]  withDesc:_descArr[previousPageIndex]];
            [self getImageFromArray:_imageArray[_currentPageIndex] withLab:_titleArr[_currentPageIndex] withDesc:_descArr[_currentPageIndex]];
            [self getImageFromArray:_imageArray[rearPageIndex] withLab:_titleArr[rearPageIndex] withDesc:_descArr[rearPageIndex]];
            
            
        }
    }
    
    [_currentArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = YES;

        CGRect rightRect = CGRectMake(self.scrollView.bounds.size.width - 80, 5, 80 , 60);
        
        rightRect.origin = CGPointMake(self.scrollView.bounds.size.width - 90, CGRectGetHeight(self.scrollView.frame) * idx);
        obj.frame = rightRect;
        
       
//        UILabel *titleL =[[UILabel alloc]initWithFrame:FRAME(10, CGRectGetHeight(self.scrollView.frame) * idx,self.scrollView.bounds.size.width - 110, 60)];
    
//        [self.scrollView addSubview:titleL];
//        titleL.numberOfLines = 0;
//        titleL.textColor = TEXT_COLOR;
//        titleL.textAlignment = NSTextAlignmentCenter;
//        titleL.text = _titlecurrentArray[idx];
        
        [self.scrollView addSubview:obj];
    }];
    [_titlecurrentArray enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = YES;
        
        CGRect rightRect = CGRectMake(self.scrollView.bounds.size.width - 80, 5, self.scrollView.bounds.size.width - 110, 30);
        
        rightRect.origin = CGPointMake(10, CGRectGetHeight(self.scrollView.frame) * idx);
        obj.frame = rightRect;
        obj.font = FONT(14);
             
        [self.scrollView addSubview:obj];

    }];
    
    [_desccurrentArray enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = YES;
        
        CGRect rightRect = CGRectMake(self.scrollView.bounds.size.width - 80, 5+30, self.scrollView.bounds.size.width - 110, 30);
        
        rightRect.origin = CGPointMake(10, CGRectGetHeight(self.scrollView.frame) * idx +30);
        obj.frame = rightRect;
        obj.font = FONT(12);
        obj.textColor = HEX(@"999999", 1);
        
        [self.scrollView addSubview:obj];
        
    }];
    
    [self.scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.scrollView.frame))];
}
- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1){
        return self.imageGroup.count - 1;
    }
    else if (currentPageIndex == self.imageGroup.count){
        return 0;
    }
    else
        return currentPageIndex;
}
-(void)getImageFromArray:(UIImageView *)imageView withLab:(UILabel * )label withDesc:(UILabel *)label1{
    //开辟自动释放池
    @autoreleasepool {
        UIImageView *tempImage = [[UIImageView alloc]initWithFrame:imageView.frame];
        tempImage.image = imageView.image;
        [_currentArray addObject:tempImage];
        
        UILabel *templab = [[UILabel alloc]initWithFrame:label.frame];
        templab.text = label.text;
        [_titlecurrentArray addObject:templab];
        
        
        UILabel *templab1 = [[UILabel alloc]initWithFrame:label1.frame];
        templab1.text = label1.text;
        [_desccurrentArray addObject:templab1];
        
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.animationDuration]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetY = scrollView.contentOffset.y;
    if(contentOffsetY >= (2 * CGRectGetHeight(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    if(contentOffsetY <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
       
        [self configContentViews];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(scrollView.frame)) animated:YES];
}


#pragma mark - 循环事件
- (void)animationTimerDidFired:(NSTimer *)timer
{

    CGPoint newOffset = CGPointMake(0, 2* CGRectGetHeight(self.scrollView.frame));

    [self.scrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - 响应事件
- (void)tap
{
    if (self.block) {
        self.block(self.currentPageIndex);
    }
}


#pragma mark - 外部API

-(void)startWithTapActionBlock:(tapActionBlock)block{
    [self.animationTimer setFireDate:[NSDate date]];
    
    [self downLoadImage];
    
    self.block = block;
}

-(void)stop{
    [self.animationTimer invalidate];
}
-(void)setArray:(NSArray *)array{
    _array = array;
    self.imageGroup = @[].copy;
    self.imageGroup = [NSArray arrayWithArray:array];
}
@end

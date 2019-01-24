//
//  YFProgressHUD.m
//  LoadingViewAnimation
//
//  Created by ios_yangfei on 2017/11/13.
//  Copyright © 2017年 tracy wang. All rights reserved.
//

#import "YFProgressHUD.h"

#import "YLImageView.h"
#import "YLGIFImage.h"



#define ANIMATION_DURATION_SECS 0.5f

#define KW  100
#define KH  120

typedef NS_ENUM(NSUInteger, YFProgressHUDType) {
    YFProgressHUDTypeGif,   // gifHUD
    YFProgressHUDTypeRotAni,// 旋转下落HUD
    YFProgressHUDTypeNormal,// 普通的HUD
};

@interface YFProgressHUD ()
// 动画处理的定时器
@property (nonatomic, strong) NSTimer *timer;
// 动画的view
@property(nonatomic,strong)UIImageView * shapView;
// 阴影view
@property(nonatomic,strong)UIImageView * shadowView;
// gif
@property (nonatomic, copy) NSString *gifName;
// 加载的文字
@property (nonatomic, copy) NSString *titleString;
// 加载的图片数组
@property(nonatomic,strong)NSArray *imagesArr;
// 切换不同的图片
@property (nonatomic, assign) int stepNumber;
// 是否正在动画中
@property (nonatomic, assign) BOOL isAnimating;
// 记录下降动画开始的位置
@property(nonatomic,assign)float fromValue;
// 记录下降动画结束的位置
@property(nonatomic,assign)float toValue;
// 记录阴影缩放开始的值
@property(nonatomic,assign)float scalefromValue;
// 记录阴影缩放结束的值
@property(nonatomic,assign)float scaletoValue;
// HUD动画类型
@property(nonatomic,assign)YFProgressHUDType hudType;
@end

@implementation YFProgressHUD

#pragma mark ====== 添加在window上 =======
/**
 显示UIActivityIndicatorView 和 title
 
 @param titleString 加载时展示的文字(可选)
 */
+(YFProgressHUD *) showProgressHUDWithTitle:(NSString *)titleString{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    return [YFProgressHUD showProgressHUDinView:window title:titleString];
}

/**
 带有下落动画HUD
 
 @param titleString 加载时展示的文字(可选)
 @param arr         动画的图片
 */
+(YFProgressHUD *) showProgressHUDWithTitle:(NSString *)titleString imagesArr:(NSArray *)arr{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    return [YFProgressHUD showProgressHUDinView:window title:titleString imagesArr:arr];
}

/**
 gif动画HUD
 
 @param titleString 加载时展示的文字(可选)
 @param gifName     gif动画的图片
 */
+(YFProgressHUD *) showProgressHUDWithTitle:(NSString *)titleString gifImg:(NSString *)gifName{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    return [YFProgressHUD showProgressHUDinView:window withTitle:titleString gifImg:gifName];
}

/**
 移除HUD
 */
+(void) hiddenProgressHUD{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [YFProgressHUD hiddenProgressHUDforView:window];
}

#pragma mark ====== 添加在View上 =======
/**
 显示UIActivityIndicatorView 和 title
 
 @param titleString 加载时展示的文字(可选)
 */
+(YFProgressHUD *) showProgressHUDinView:(UIView *)view title:(NSString *)titleString{
   
    [YFProgressHUD hiddenProgressHUDforView:view];
    
    YFProgressHUD *hud = [[YFProgressHUD alloc] initWithFrame:view.bounds];
    hud.hudType = YFProgressHUDTypeNormal;
    hud.titleString = titleString;
    [hud setupView];
    [view addSubview:hud];
    [hud startAnimating];
    return hud;
}

/**
 带有下落动画HUD
 
 @param view        需要展示HUD的view
 @param titleString 加载时展示的文字(可选)
 @param arr         动画的图片
 */
+(YFProgressHUD *) showProgressHUDinView:(UIView *)view title:(NSString *)titleString imagesArr:(NSArray *)arr{
    
    [YFProgressHUD hiddenProgressHUDforView:view];
    
    YFProgressHUD *hud = [[YFProgressHUD alloc] initWithFrame:view.bounds];
    hud.hudType = YFProgressHUDTypeRotAni;
    hud.titleString = titleString;
    hud.imagesArr = arr;
    [hud setupView];
    [view addSubview:hud];
    [hud startAnimating];
    return hud;
}

/**
 gif动画HUD
 @param view        需要展示HUD的view
 @param titleString 加载时展示的文字(可选)
 @param gifName     gif动画的图片
 */
+(YFProgressHUD *) showProgressHUDinView:(UIView *)view  withTitle:(NSString *)titleString gifImg:(NSString *)gifName{
    
    [YFProgressHUD hiddenProgressHUDforView:view];
    
    YFProgressHUD *hud = [[YFProgressHUD alloc] initWithFrame:view.bounds];
    hud.hudType = YFProgressHUDTypeGif;
    hud.titleString = titleString;
    hud.gifName = gifName;
    [hud setupView];
    [view addSubview:hud];
    [hud startAnimating];
    return hud;
}

/**
 移除HUD
 */
+(void) hiddenProgressHUDforView:(UIView *)view{
    if (!view) {
        view = [[UIApplication sharedApplication].delegate window];
    }
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[YFProgressHUD class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
}

#pragma mark ====== 初始化=======
-(void)setupView
{
    
    self.userInteractionEnabled = YES;
    
    switch (self.hudType) {
        case YFProgressHUDTypeNormal:
            [self setupNormal];
            break;
        case YFProgressHUDTypeGif:
            [self setupGif];
            break;
        case YFProgressHUDTypeRotAni:
            [self setupRotAni];
            break;
    }
    
}

-(void)setupNormal{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = width/375;
    CGFloat w = 80 * scale;
    UIView *centerView = [UIView new];
    centerView.bounds = CGRectMake(0, 0, w, w);
    centerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 20);
    centerView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    centerView.layer.cornerRadius = 4;
    centerView.layer.masksToBounds = YES;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]init];
    indicatorView.frame = CGRectMake(0, 0, w, w);
    indicatorView.center = CGPointMake(w/2, w/2);
    indicatorView.transform = CGAffineTransformMakeScale(1.6 * scale, 1.6 * scale);
    indicatorView.hidesWhenStopped = NO;
    [centerView addSubview:indicatorView];
    [indicatorView startAnimating];
    [self addSubview:centerView];
    
    if (_titleString.length != 0) {
        UILabel *label=[[UILabel alloc] init];
        label.frame=CGRectMake(0, 0 , KW , 20);
        label.textColor=[UIColor grayColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + w/2);
        label.text=_titleString;
        label.font=[UIFont systemFontOfSize:14.0f];
        [self addSubview:label];
    }
}

-(void)setupRotAni{
    
    _shapView=[[UIImageView alloc] init];
    _shapView.frame = CGRectMake(KW/2-31/2, 0, 31, 31);
    _shapView.image = [UIImage imageNamed:self.imagesArr[0]];
    _shapView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-100);
    _shapView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_shapView];
    
    //阴影
    _shadowView = [[UIImageView alloc] init];
    _shadowView.frame = CGRectMake(KW/2-37/2, KH-2.5-30, 37, 2.5);
    _shadowView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _shadowView.image = [UIImage imageNamed:@"loading_shadow"];
    [self addSubview:_shadowView];
    
    if (_titleString.length != 0) {
        UILabel *_label=[[UILabel alloc] init];
        _label.frame=CGRectMake(0, 0 , KW , 20);
        _label.textColor=[UIColor grayColor];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2+20);
        _label.text=_titleString;
        _label.font=[UIFont systemFontOfSize:14.0f];
        [self addSubview:_label];
    }
    
    _fromValue=self.frame.size.height/2-100;
    _toValue=self.frame.size.height/2.0-37/2.0;
    _scalefromValue=0.1f;
    _scaletoValue=1.0f;
}

-(void)setupGif{
    
//    NSString *url = [[NSBundle mainBundle] pathForResource:self.gifName ofType:@""];
    UIImage *gifImg = [YLGIFImage imageNamed:self.gifName];//[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:url]];
    
    CGSize size = gifImg.size;
    YLImageView *gifView=[[YLImageView alloc] init];
    gifView.frame = CGRectMake(0, 0, size.width, size.height);
    gifView.image = [YLGIFImage imageNamed:self.gifName];
    gifView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 30);
    gifView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:gifView];
    
    if (_titleString.length != 0) {
        UILabel *label=[[UILabel alloc] init];
        label.frame=CGRectMake(0, gifView.bounds.size.height , KW , 20);
        label.textColor=[UIColor grayColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.center = CGPointMake(gifView.center.x, gifView.center.y + size.height/2 + 20);
        label.text=_titleString;
        label.font=[UIFont systemFontOfSize:14.0f];
        [self addSubview:label];
    }
}

#pragma mark ====== 动画处理 =======
// 开始动画
-(void) startAnimating
{
    if (!_isAnimating)
    {
        _isAnimating = YES;
        if (self.hudType == YFProgressHUDTypeRotAni) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION_SECS target:self selector:@selector(animateNextStep) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            [self animateNextStep];
        }
        
    }
    
}

// 结束动画
-(void) stopAnimating
{
    _isAnimating = NO;
    if (self.hudType == YFProgressHUDTypeRotAni) {
        [_timer invalidate];
        _timer=nil;
        _stepNumber = 0;
        [_shapView.layer removeAllAnimations];
        [_shadowView.layer removeAllAnimations];
    }
}

// 动画方法
-(void)animateNextStep
{
    
    if (_stepNumber%2==0) {
        [self loadingAnimation:_toValue toValue:_fromValue timingFunction:kCAMediaTimingFunctionEaseOut];
        [self scaleAnimation:_scaletoValue toValue:_scalefromValue timingFunction:kCAMediaTimingFunctionEaseIn];
        _shapView.image=[UIImage imageNamed:self.imagesArr[_stepNumber]];
    }else {
        [self loadingAnimation:_fromValue toValue:_toValue timingFunction:kCAMediaTimingFunctionEaseIn];
        [self scaleAnimation:_scalefromValue toValue:_scaletoValue timingFunction:kCAMediaTimingFunctionEaseOut];
    }
    
    if (_stepNumber==self.imagesArr.count-1) {
        _stepNumber = -1;
    }
    _stepNumber++;
}

// 下落动画
-(void) loadingAnimation:(float)fromValue toValue:(float)toValue timingFunction:(NSString * const)tf
{
    //位置
    CABasicAnimation *panimation = [CABasicAnimation animation];
    panimation.keyPath = @"position.y";
    panimation.fromValue =@(fromValue);
    panimation.toValue = @(toValue);
    panimation.duration = ANIMATION_DURATION_SECS;
    panimation.timingFunction = [CAMediaTimingFunction functionWithName:tf];
    
    //旋转
    CABasicAnimation *ranimation = [CABasicAnimation animation];
    ranimation.keyPath = @"transform.rotation";
    ranimation.fromValue =@(0);
    ranimation.toValue = @(M_PI_2);
    ranimation.duration = ANIMATION_DURATION_SECS;
    
    ranimation.timingFunction = [CAMediaTimingFunction functionWithName:tf];
    
    //组合
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[panimation,ranimation];
    group.duration = ANIMATION_DURATION_SECS;
    group.beginTime = 0;
    group.fillMode=kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [_shapView.layer addAnimation:group forKey:@"basic"];
    
}

// 缩放动画
-(void) scaleAnimation:(float) fromeValue toValue:(float)toValue timingFunction:(NSString * const)tf
{
    
    CABasicAnimation *sanimation = [CABasicAnimation animation];
    sanimation.keyPath = @"transform.scale";
    sanimation.fromValue =@(fromeValue);
    sanimation.toValue = @(toValue);
    sanimation.duration = ANIMATION_DURATION_SECS;
    sanimation.fillMode = kCAFillModeForwards;
    sanimation.timingFunction = [CAMediaTimingFunction functionWithName:tf];
    sanimation.removedOnCompletion = NO;
    [_shadowView.layer addAnimation:sanimation forKey:@"shadow"];
    
}

#pragma mark ====== setter =======
-(void)setImagesArr:(NSArray *)imagesArr{
    NSMutableArray *arr=[NSMutableArray array];
    for (int i=0; i<imagesArr.count; i++) {
        if (i==0) [arr addObject:imagesArr[i]];
        else {
            for (int j=0; j<2; j++) {// 除了第一个其他都需要两次动画
                [arr addObject:imagesArr[i]];
            }
        }
        if (i==imagesArr.count-1) [arr addObject:imagesArr[0]];
    }
    _imagesArr = arr.copy;
}

#pragma mark ====== 销毁 =======
- (void)dealloc
{
    [_timer invalidate];
    _timer=nil;
}

@end

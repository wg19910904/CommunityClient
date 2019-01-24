//
//  JHTempRedBagView.m
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/17.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTempRedBagView.h"
#import "JHTempJumpWithRouteModel.h"
#define scale_screen (WIDTH/375)
static const JHTempRedBagView *currentView;
@interface JHTempRedBagView()
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)UIView *bg_view;
@end
@implementation JHTempRedBagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void)showRedGagViewWithUrl:(NSString *)link{
    if (currentView) {
       [currentView remove];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentView = [[JHTempRedBagView alloc]init];
    });
    currentView.link = link;
    [currentView creatSubView];
}
-(void)creatSubView{
    self.frame =  FRAME(0, 0, WIDTH, HEIGHT);
    self.backgroundColor = HEX(@"000000", 0.5);
   
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:self];
    
    self.bg_view = [[UIView alloc]init];
    self.bg_view.frame = FRAME(60*scale_screen, -300*scale_screen, WIDTH - 120*scale_screen, 310*scale_screen);
    self.bg_view.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bg_view];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.frame = FRAME(2, 0, WIDTH - 124*scale_screen, 260*scale_screen);
    imageV.image = IMAGE(@"111");
    [self.bg_view addSubview:imageV];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = FRAME((110+40)*i*scale_screen, 270*scale_screen, 110*scale_screen, 40*scale_screen);
        if (i == 1) {
            [btn setBackgroundImage:IMAGE(@"btn_ling") forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:IMAGE(@"btn_ok") forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.bg_view addSubview:btn];
    }
    [self springAnimation];

}
-(void)click:(UIButton *)sender{
   
    if (sender.tag == 1) {
        [self jumpWithUrl:self.link];
         [self removeFromSuperview];
    }else{
        [self remove];
    }
}
-(void)remove{
    for (UIView *view in currentView.subviews) {
        [view removeFromSuperview];
    }
     [currentView removeFromSuperview];
}
-(void)jumpWithUrl:(NSString *)url{
    UIViewController *vc = [JHTempJumpWithRouteModel jumpWithLink:url];
    UITabBarController *tab = (UITabBarController*)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)tab.viewControllers[tab.selectedIndex];
    [nav pushViewController:vc animated:YES];
}
//spring动画
-(void)springAnimation{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.bg_view.frame = FRAME(60*scale_screen, 250*(WIDTH/667), WIDTH - 120*scale_screen, 310*scale_screen);
    } completion:nil];
}
@end

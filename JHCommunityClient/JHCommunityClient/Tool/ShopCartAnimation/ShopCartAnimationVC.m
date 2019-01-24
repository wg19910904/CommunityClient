//
//  ShopCarAnimationVC.m
//
//  Created by xixixi
//  Copyright © 2016年 xixixi. All rights reserved.
//

#import "ShopCartAnimationVC.h"

@interface ShopCartAnimationVC ()<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *animationLayers;
@property (nonatomic, assign) BOOL isNeedNotification;

@end

@implementation ShopCartAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addProductsAnimation:(UIView *)out_view dropToPoint:(CGPoint)dropToPoint isNeedNotification:(BOOL)isNeedNotification {
    
    self.isNeedNotification = isNeedNotification;
    if (self.animationLayers == nil) {
        self.animationLayers = [[NSMutableArray alloc] init];
    }
    
    CGRect frame = [out_view convertRect:out_view.bounds toView:self.view];
    CALayer *transitionLayer = [[CALayer alloc] init];
    transitionLayer.frame = frame;
    transitionLayer.contents = out_view.layer.contents;
    [self.view.layer addSublayer:transitionLayer];
    [self.animationLayers addObject:transitionLayer];
    
    CGPoint point1 = transitionLayer.position;
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, point1.x, point1.y);
    CGPathAddCurveToPoint(path, nil, point1.x, point1.y - 30, dropToPoint.x, point1.y - 30, dropToPoint.x, dropToPoint.y);
    positionAnimation.path = path;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @1;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.6, 0.6, 1)];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[positionAnimation, transformAnimation, opacityAnimation];
    groupAnimation.duration = 0.5;
    groupAnimation.delegate = self;
    
    [transitionLayer addAnimation:groupAnimation forKey:@"cartParabola"];
    
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationLayers.count > 0) {
        CALayer *layer = self.animationLayers[0];
        layer.hidden = YES;
        [layer removeFromSuperlayer];
        [self.animationLayers removeObjectAtIndex:0];
        [self.view.layer removeAnimationForKey:@"cartParabola"];
        if (self.isNeedNotification) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShopCartAnimationEnd object:nil];
        }
    }
}
@end

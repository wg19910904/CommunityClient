//
//  AnimationVC.m
//  JHCash
//
//  Created by ijianghu on 16/12/7.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "AnimationVC.h"
#import "JHTabBarVC.h"
#import "JHIntroPageVC.h"
#import "JHTempWebViewVC.h"
#import "JHTempWebViewVC.h"
#import "AdvModel.h"
#import "AdvCell.h"
@interface AnimationVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CAAnimationDelegate>{
    UIView *btnView;
    CAShapeLayer *shapLayer;
    BOOL isYes;
}

@property(nonatomic,strong)UICollectionView *myCollectionView;//展示广告位的
@property(nonatomic,strong)UIButton *btn;//倒计时跳转或点击跳转
@property(nonatomic,strong)NSMutableArray *advArr;//广告页数组

@end
@implementation AnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取广告
    _advArr = @[].mutableCopy;
    NSArray *tempArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"adv"];
    for (NSDictionary *dic in tempArr) {
        AdvModel *model = [AdvModel shareAdvModelWithDic:dic];
        [_advArr addObject:model];
    }
    //添加广告
    [self.view addSubview:self.myCollectionView];
    //添加点击跳过的按钮(倒计时)
    [self btn];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (isYes) {
        [self judgeToTabbar];
    }
}
//展示广告的
-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT) collectionViewLayout:layout];
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.bounces = NO;
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        [_myCollectionView registerClass:[AdvCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _myCollectionView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _advArr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH, HEIGHT);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AdvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    AdvModel *model = _advArr[indexPath.row];
    cell.imageStr = [IMAGEADDRESS stringByAppendingString:model.thumb];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AdvModel  *model = _advArr[indexPath.row];
    if ([model.link hasPrefix:@"http"] == NO) {
        return;
    }
    isYes = YES;
    JHTempWebViewVC *vc = [[JHTempWebViewVC alloc]init];
    vc.url = model.link;
    vc.isAdv = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//倒计时跳转或点击跳转的按钮
-(UIButton *)btn{
    if(!_btn){
        btnView = [UIView new];
        btnView.frame = FRAME(WIDTH - 50, 30, 40, 40);
        [self.view addSubview:btnView];
        [self ceatShapLayer];
        _btn =[[UIButton alloc]init];
        _btn.frame = FRAME(1, 1, 38, 38);
        _btn.layer.cornerRadius = 19;
        _btn.layer.masksToBounds = YES;
        _btn.titleLabel.font = FONT(11);
        _btn.backgroundColor = [UIColor whiteColor];
        [_btn setTitleColor:HEX(@"333333", 1) forState:UIControlStateNormal];
        _btn.titleLabel.numberOfLines = 0;
        [_btn setTitle:NSLocalizedString(@"点击\n跳过", nil) forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickToHome) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_btn];
    }
    return _btn;
}
-(void)ceatShapLayer{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:20 startAngle:3*M_PI/2 endAngle:7*M_PI/2 clockwise:YES];
    shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.path = path.CGPath;
    shapLayer.fillColor = [UIColor whiteColor].CGColor;
    shapLayer.lineWidth = 2;
    shapLayer.strokeColor = THEME_COLOR.CGColor;
    shapLayer.lineCap = kCALineCapButt;
    [btnView.layer addSublayer:shapLayer];
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.duration = 5;
    baseAnimation.fromValue = @(1);
    baseAnimation.toValue = @(0);
    baseAnimation.delegate = self;
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    [shapLayer addAnimation:baseAnimation forKey:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (isYes == NO) {
        [self judgeToTabbar];
    }
}
//点击跳过
-(void)clickToHome{
    //将状态栏字体该为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self judgeToTabbar];
}
#pragma mark - 跳转到根式图
-(void)judgeToTabbar{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    JHTabBarVC *rootVC = [[JHTabBarVC alloc] init];
    window.rootViewController = rootVC;
}
@end

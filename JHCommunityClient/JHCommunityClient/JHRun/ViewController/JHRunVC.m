//
//  JHRunVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/25.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRunVC.h"
#import <Masonry.h>
#import "MyTapGesture.h"
#import "JHSendingVC.h"
#import "JHBuyingVC.h"
#import "JHQueueVC.h"
#import "JHPetVC.h"
#import "JHSeatVC.h"
#import "JHOther.h"
 
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface JHRunVC ()<XHMapViewDelegate>{
    XHMapView * _mapView;//地图
    UIImageView * imageV_bubble;//显示在大头针上方的气泡
    UILabel * label_num;//显示有多少跑腿员的
    NSMutableArray * array_annotion;//存放附近跑腿员经纬度的数组
    BOOL isFirst;//是否是第一次启动
}
@end
@implementation JHRunVC
//这是高德转化为百度的函数
const double MAP_x_pi_pp = M_PI * 3000.0 / 180.0;
void transform_mars_gaode_to_baidu(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon)
{
//    double x = gg_lon, y = gg_lat;
//    double z = sqrt(x * x + y * y) + 0.00002 * sin(y *  MAP_x_pi_pp);
//    double theta = atan2(y, x) + 0.000003 * cos(x *  MAP_x_pi_pp);
//    *bd_lon = z * cos(theta) + 0.0065;
//    *bd_lat = z * sin(theta) + 0.006;
    *bd_lon = gg_lon;
    *bd_lat = gg_lat;
}

//界面消失的时候让地图不再定位
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
-(void)clickBackBtn{
    if (self.navigationController.viewControllers[0] == self) {
        self.tabBarController.selectedIndex = 0;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = NO;
    self.navigationItem.title = NSLocalizedString(@"跑腿", nil);
    array_annotion = [NSMutableArray array];
    //创建地图
    [self creatMapView];
    //创建下面的六个按钮
    [self creatUIView];
    //点击返回当前定位的位置
    [self creatReturnToCurrentLocation];
    if ([XHMapKitManager shareManager].is_International) {
        //创建气泡
        [self creatBubble];
    }
}
#pragma mark - 创建显示在大头针的上方的气泡
-(void)creatBubble{
    if (imageV_bubble == nil) {
        imageV_bubble = [[UIImageView alloc]init];
        imageV_bubble.image = [UIImage imageNamed:@"bubble"];
        imageV_bubble.bounds = FRAME(0, 0, 100, 48);
        imageV_bubble.center = CGPointMake(_mapView.center.x, _mapView.center.y - 55);
        [self.view addSubview:imageV_bubble];
        label_num = [[UILabel alloc]init];
        label_num.frame = FRAME(0, 0, 100, 45);
        label_num.backgroundColor = [UIColor clearColor];
        label_num.numberOfLines = 1;
        label_num.adjustsFontSizeToFitWidth = YES;
        label_num.textAlignment = NSTextAlignmentCenter;
        label_num.textColor = [UIColor whiteColor];
        label_num.text = NSLocalizedString(@"正在搜索...", nil);
        [imageV_bubble addSubview:label_num];
    }
}
#pragma mark - 创建点击返回当前的位置的方法
-(void)creatReturnToCurrentLocation{
    UIButton * btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:@"zhinan"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(ClickToOrigin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-151);
        make.height.offset(40);
        make.width.offset(40);
    }];
}
#pragma mark - 这是点击后地图回到当前位置的方法
-(void)ClickToOrigin{
    NSLog(@"你点击了返回地图定位的方法");
    [_mapView setCenterWithCurrentLocation];
}
#pragma mark - 这是创建地图的方法
-(void)creatMapView{
    _mapView = [[XHMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH,HEIGHT)];
    _mapView.XHDelegate = self;
    [_mapView setCenterWithCurrentLocation];
    [self.view addSubview:_mapView];
    //创建屏幕中间的大头针
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"datouzhen"];
    imageView.bounds = CGRectMake(0, 0, 25, 30);
    imageView.center = CGPointMake(_mapView.center.x, _mapView.center.y-15);
    [self.view addSubview:imageView];
    
}
#pragma mark - 这是创建底部的六个按钮的方法
-(void)creatUIView{
    NSArray * array = @[NSLocalizedString(@"宠物照顾", nil),NSLocalizedString(@"餐馆占座", nil),NSLocalizedString(@"其他", nil),NSLocalizedString(@"帮我送", nil),NSLocalizedString(@"帮我买", nil),NSLocalizedString(@"代排队", nil)];
    NSArray * imageArray = @[@"pet",@"seat",@"other",@"send",@"buy",@"queue"];

   // NSArray * arrayImage = @[@"give@2x",@"buy@2x",@"goods@2x",@"",@"",@""];
    for (int i = 0; i < 6; i ++) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.offset(-(+(i/3)*70));
            make.left.offset((i%3)*WIDTH/3.0);
            make.width.offset(WIDTH/3.0);
            make.height.offset(70);
        }];
        MyTapGesture * tap = [[MyTapGesture alloc]initWithTarget:self action:@selector(clickToViewController:)];
        tap.tag = i;
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tap];
        UILabel * label = [[UILabel alloc]init];
        label.text = array[i];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, 45, WIDTH/3.0, 20);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        [view addSubview:label];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake((WIDTH/3.0-35)/2.0, 10, 35, 35);
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:imageView];
    }
}
#pragma mark - 这是点击下面的六个按钮的方法
-(void)clickToViewController:(MyTapGesture *)tapGesture{
        JHBaseVC * vc = nil;
    switch (tapGesture.tag) {
        case 0:
            //跳转到宠物照顾界面
            vc = [[JHPetVC alloc]init];
            break;
        case 1:
            //跳转到餐馆占座界面
            vc = [[JHSeatVC alloc]init];
            break;
        case 2:
            //跳转到其他界面
            vc = [[JHOther alloc]init];
            break;
        case 3:
            //跳转到帮我送界面
            vc = [[JHSendingVC alloc]init];
            break;
        case 4:
            //跳转到帮我买界面
            vc = [[JHBuyingVC alloc]init];
            break;
        case 5:
            //跳转到代排队界面
            vc = [[JHQueueVC alloc]init];
            break;
        default:
            break;
    }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
   
}
-(void)xhMapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        //创建气泡
        [self creatBubble];
        
        if (!isFirst) {
            //第一次启动的时候调接口
            [self postHttp];
            isFirst = YES;
        }
    }
}
-(void)xhMapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    if (isFirst&&wasUserAction) {
        [self postHttp];
    }
    
}
-(void)xhMapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    if ((isFirst&&wasUserAction) || mapView == nil) {
        [self postHttp];
    }
}


#pragma mark - 这是标注大头针回调的方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:@"ren"];
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
#pragma mark - 这是跑腿地图请求附近有多少配送员的接口
-(void)postHttp{
    //左下经纬度
    CLLocationCoordinate2D collection1 = [_mapView coordinateForPoint:CGPointMake(0, HEIGHT)];
    //右上经纬度cd
    CLLocationCoordinate2D collection2 = [_mapView coordinateForPoint:CGPointMake(WIDTH, 0)];
    double baiduLat = 0.0;
    double baiduLng = 0.0;
    transform_mars_gaode_to_baidu(collection1.latitude, collection1.longitude, &baiduLat, &baiduLng);
    double baiduLat1 = 0.0;
    double baiduLng1 = 0.0;
    transform_mars_gaode_to_baidu(collection2.latitude, collection2.longitude, &baiduLat1, &baiduLng1);

    NSDictionary * dic = @{@"SouthWlat":[NSString stringWithFormat:@"%f",baiduLat],
                           @"SouthWlng":[NSString stringWithFormat:@"%f",baiduLng],
                           @"NorthElat":[NSString stringWithFormat:@"%f",baiduLat1],
                           @"NorthElng":[NSString stringWithFormat:@"%f",baiduLng1]};
   [HttpTool postWithAPI:@"client/paotui/map" withParams:dic success:^(id json) {
       NSLog(@"%@",json);
       if ([json[@"error"] isEqualToString:@"0"]) {
           //移除旧的大头针
           [_mapView removeAllAnnotations];
           [array_annotion removeAllObjects];
          //请求成功
           NSArray * tempArray = json[@"data"][@"items"];
           for (NSDictionary * dic in tempArray) {
               //将百度的坐标转化为高德的坐标
               CLLocationCoordinate2D amapcoord = CLLocationCoordinate2DMake([dic[@"lat"] floatValue],[dic[@"lng"] floatValue]);
               [_mapView addAnnotation:amapcoord title:@"" imgStr:@"ren" selected:NO];
           }
           if (tempArray.count == 0) {
               label_num.text = NSLocalizedString(@"附近无跑腿员", nil);
           }else{
           label_num.text = [NSString stringWithFormat:NSLocalizedString(@"附近有%ld个跑腿员", nil),tempArray.count];
           
         }
       }else{
          //请求错误
           label_num.text = NSLocalizedString(@"附近无跑腿员", nil);
       }
   } failure:^(NSError *error) {
       NSLog(@"%@",error.localizedDescription);
   }];
}
@end

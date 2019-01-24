//
//  JHBigMapViewController.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/8/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBigMapViewController.h"
#import <MAMapKit/MAMapKit.h>
@interface JHBigMapViewController ()<MAMapViewDelegate>
{
    MAMapView * _mapView;//地图
    UILabel * label_state;//显示骑手状态的label
    UIButton * btn_phone;//显示骑手号码的按钮
    MAPointAnnotation * pointAnnotation;//大头针
    MAPointAnnotation * pointAnnotation_shop;//标注商家的地方
    float user_lat;
    float user_lng;
    BOOL isFirstMap;//判断是不是第一次加载地图
    float last_distance;
}
@property(nonatomic,retain)MAMapView * getMapView;
@end

@implementation JHBigMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     last_distance = MAXFLOAT;
    self.title = @"配送跟踪";
    //创建底部的Subview
    [self creatSubview];
    //创建地图
    [self.view addSubview:self.getMapView];
    pointAnnotation_shop = [[MAPointAnnotation alloc]init];
    pointAnnotation_shop.coordinate = CLLocationCoordinate2DMake(self.shop_lat.floatValue, self.shop_lng.floatValue);
    [_mapView addAnnotation:pointAnnotation_shop];
}
-(void)clickBackBtn{
    if (self.refreshBlock) {
        self.refreshBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 这是创建地图的方法
-(MAMapView *)getMapView{
    if (_mapView) {
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.staff_lat.floatValue, self.staff_lng.floatValue) animated:YES];
        return _mapView;
    }else{
        [MAMapServices sharedServices].apiKey = GAODE_KEY;
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50)];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.showsScale = NO;
        _mapView.showsCompass = NO;
        [_mapView setZoomLevel:16.1 animated:YES];
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.staff_lat.floatValue, self.staff_lng.floatValue) animated:YES];
        return _mapView;
    }
}
#pragma mrak - 创建底部的Subview
-(void)creatSubview{
    UIView * view_buttom = [[UIView alloc]init];
    view_buttom.frame = FRAME(0, HEIGHT - 50, WIDTH, 50);
    view_buttom.backgroundColor = [UIColor whiteColor];
    view_buttom.layer.borderColor = [UIColor colorWithWhite:0.98 alpha:1].CGColor;
    view_buttom.layer.borderWidth = 1;
    [self.view addSubview:view_buttom];
    //添加label
    label_state = [[UILabel alloc]init];
    label_state.frame = FRAME(10, 10, WIDTH/2 - 10, 30);
    label_state.text = @"骑手正在配送中";
    label_state.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    label_state.textAlignment = NSTextAlignmentLeft;
    label_state.font = [UIFont systemFontOfSize:13];
    [view_buttom addSubview:label_state];
    //添加中间的竖线
    CALayer * layer_xian = [[CALayer alloc]init];
    layer_xian.backgroundColor = [UIColor grayColor].CGColor;
    layer_xian.frame = FRAME(WIDTH/2+ 1,10,1,30);
    [view_buttom.layer addSublayer:layer_xian];
    //创建打电话的按钮
    btn_phone = [[UIButton alloc]init];
    btn_phone.frame = FRAME(WIDTH/2 + 2, 0, WIDTH/2 - 2, 50);
    [view_buttom addSubview:btn_phone];
    [btn_phone setTitle:self.mobile forState:UIControlStateNormal];
    [btn_phone setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [btn_phone setImage:[UIImage imageNamed:@"tg_phone"] forState:UIControlStateNormal];
    ;
    [btn_phone addTarget:self action:@selector(clickToCall:) forControlEvents:UIControlEventTouchUpInside];
}
//当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        user_lat = userLocation.coordinate.latitude;
        user_lng = userLocation.coordinate.longitude;
        NSLog(@"%f",user_lat);
            //1.将两个经纬度点转成投影点
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.staff_lat floatValue], [self.staff_lng floatValue]));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.lat.doubleValue,self.lng.doubleValue));
            //2.计算距离
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            if (pointAnnotation == nil) {
                pointAnnotation = [[MAPointAnnotation alloc]init];
                [_mapView addAnnotation:pointAnnotation];

            }
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.staff_lat floatValue], [self.staff_lng floatValue]);
            NSString * title = [NSString stringWithFormat:@"%f",distance];
            title = [[title componentsSeparatedByString:@"."] firstObject];
//            if ([title floatValue] > last_distance) {
//                title = [NSString stringWithFormat:@"%f",last_distance];
//            }
        if (title.floatValue == 0) {
            pointAnnotation.title = @"配送员已到达";
            last_distance = 0;
            [_mapView selectAnnotation:pointAnnotation animated:YES];
            isFirstMap = YES;
            return;
        }

            last_distance = [title floatValue];
            if (last_distance < 1000) {
                pointAnnotation.title = [NSString stringWithFormat:GLOBAL(@"距终点还有%dm"),[title intValue]];
            }else{
                pointAnnotation.title = [NSString stringWithFormat:GLOBAL(@"距终点还有%.2fkm"),[title floatValue]/1000];
            }
            
            [_mapView selectAnnotation:pointAnnotation animated:YES];
            isFirstMap = YES;
        
    }
}
//标注大头针会回调的方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        if (annotation == pointAnnotation) {
            static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
            MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            }
            annotationView.image = [UIImage imageNamed:@"paotuiR"];
            annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
            return annotationView;

        }else{
            static NSString *pointReuseIndentifier = @"pointReuse";
            MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            }
            annotationView.image = [UIImage imageNamed:@"order_sj"];
            return annotationView;

        }
}
    return nil;
}
#pragma mark - 点击打电话
-(void)clickToCall:(UIButton *)sender{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:self.mobile preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:GLOBAL(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:GLOBAL(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.mobile]]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

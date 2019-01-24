//
//  ShowAddressVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/5/7.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ShowAddressVC.h"
#import <MAMapKit/MAMapKit.h>
#import "GaoDe_Convert_BaiDu.h"
@interface ShowAddressVC ()<MAMapViewDelegate>

@end

@implementation ShowAddressVC
{
    XHMapView *_mapView;
    double gd_lat;
    double gd_lng;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _titleString;
    //转换坐标
    [self convertPoint];
    //创建高德地图
    [self makeGapDeMap];
}
#pragma marl - 转换坐标
- (void)convertPoint
{
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:_lat
                                                 WithBD_lon:_lng
                                                 WithGD_lat:&gd_lat
                                                 WithGD_lon:&gd_lng];
}
#pragma makk - makeGaoDeMap
- (void)makeGapDeMap
{
    _mapView = [[XHMapView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)];
   
    [self.view addSubview:_mapView];
    //添加标注
    [_mapView addAnnotation:CLLocationCoordinate2DMake(gd_lat, gd_lng) title:NSLocalizedString(@"商家", nil) imgStr:@"shopPoint" selected:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

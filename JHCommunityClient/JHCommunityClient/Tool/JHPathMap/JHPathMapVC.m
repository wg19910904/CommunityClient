//
//  JHPaiotuiOtherMapVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/31.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHPathMapVC.h"
#import "JHShowAlert.h"
#import "GaoDe_Convert_BaiDu.h"
@interface JHPathMapVC ()
{
    XHMapView *_mapView;
    NSMutableArray *maps;
}
@property(nonatomic,strong)UIView *mapBottomView;
@property(nonatomic,strong)UILabel *houseLab;//当前的建筑
@property(nonatomic,strong)UILabel *roadLad;//当前的路
@end

@implementation JHPathMapVC
- (void)viewDidLoad {
    [super viewDidLoad];
    maps = @[].mutableCopy;
    [self initMap];
//    if(!self.is_hiddenPath)
    [self.view addSubview:self.mapBottomView];
    
    [self creatReturnBtn];
  
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)creatReturnBtn{
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundImage:IMAGE(@"btn_back") forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickReturn) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 25;
        make.height.width.offset = 30;
    }];
}
-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark=====初始化地图======
- (void)initMap{
    _mapView = [[XHMapView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];

    [self.view addSubview:_mapView];

    [_mapView addAnnotation:CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue])
                      title:@"" imgStr:@"shopPoint" selected:NO];
    [self createRouteSearch];
}

#pragma mark=======创建路径搜素========
- (void)createRouteSearch{
    
    [_mapView createRouteSearchWithDestination_lat:[self.lat floatValue] destination_lng:[self.lng floatValue]];
}
-(UIView *)mapBottomView{
    if (!_mapBottomView) {
        _mapBottomView = [UIView new];
        _mapBottomView.backgroundColor = [UIColor whiteColor];
        _mapBottomView.frame = FRAME(0, HEIGHT-60, WIDTH, 60);
        UIButton *imgV = [UIButton new];
        [imgV setBackgroundImage:IMAGE(@"btn_go") forState:UIControlStateNormal];
        [_mapBottomView addSubview:imgV];
        [imgV addTarget:self action:@selector(clickShowChoseMap) forControlEvents:UIControlEventTouchUpInside];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.top.offset = 10;
            make.width.height.offset = 40;
        }];
        _houseLab = [[UILabel alloc]init];
        _houseLab.textColor = HEX(@"333333", 1);
        _houseLab.font = FONT(16);
        [_mapBottomView addSubview:_houseLab];
        [_houseLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.offset = 11;
            make.height.offset = 16;
        }];
        _houseLab.text = self.shopName;
        _roadLad = [[UILabel alloc]init];
        _roadLad.textColor = HEX(@"999999", 1);
        _roadLad.font = FONT(12);
        [_mapBottomView addSubview:_roadLad];
        [_roadLad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.mas_equalTo(_houseLab.mas_bottom).offset = 10;
            make.height.offset = 12;
        }];
        _roadLad.text = self.shopAddr;
    }
    return _mapBottomView;
}
-(void)clickShowChoseMap{
    NSLog(@"这是点击展示选择地图的方法");
//    NSString *need_lat = self.lat;
//    NSString *need_lng = self.lng;
//    if (_order_status.integerValue == 3) {
//        need_lat = self.lat;
//        need_lng = self.lng;
//    }
    NSArray *arr = [self getInstalledMapAppWithEndLocation:CLLocationCoordinate2DMake(self.lat.floatValue, self.lng.floatValue)];
    NSLog(@"%@",arr);
    NSMutableArray *titleArr = @[].mutableCopy;
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dic = arr[i];
        [titleArr addObject:dic[@"title"]];
    }
    [JHShowAlert showSheetAlertWithTextArr:titleArr withController:self withClickBlock:^(NSInteger tag) {
        NSLog(@"%ld",tag);
        if (tag ==  maps.count -1) {
//            //苹果地图

            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue]);
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            
        
            
            
        }else{
            NSDictionary *dic = arr[tag];
            NSString *urlString = dic[@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }];
}

- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = NSLocalizedString(@"高德地图", nil);
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&backScheme=%@&dev=0&m=0&t=0&sid=BGVIS1&did=BGVIS2&dlat=%f&dlon=%f",NSLocalizedString(@"导航功能",nil),@"nav123456",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
        
        
    }
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        double lat = 0.00;
        double lng = 0.00;
        [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:endLocation.latitude WithGD_lon:endLocation.longitude WithBD_lat:&lat WithBD_lon:&lng];
        
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = NSLocalizedString(@"百度地图", nil);
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }

    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = NSLocalizedString(@"腾讯地图", nil);
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    // 谷歌地图导航
    // 集成文档地址：https://developers.google.com/maps/documentation/ios-sdk/urlscheme
    /*
     * saddr：设置路线搜索的起点。 它可以是一个纬度、经度或查询格式的地址。 如果它是返回多个结果的查询字符串， 将选择第一个结果。 如果该值留空，那么将使用该用户的当前位置。
     * daddr：设置路线搜索的终点。 具有与 saddr 相同的格式和行为。
     * directionsmode：交通方式。 可以设置为：driving、transit、bicycling 或 walking。
     */
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = NSLocalizedString(@"谷歌地图", nil);
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f&directionsmode=driving",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    iosMapDic[@"title"] = NSLocalizedString(@"本机地图", nil);
    [maps addObject:iosMapDic];
    
    return maps;
}
@end

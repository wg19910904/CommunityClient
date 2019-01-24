//
//  JHHouseKeepingMapVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅地图模式

#import "JHMaintainMapVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "JHMaintainListVc.h"
#import "MaintainListBnt.h"
#import "JHMaintainSubCateVc.h"
#import "JHMaintainSubEvaluationVc.h"
#import "JHMaintainSubSortVc.h"
#import "JHMaintainOrderVC.h"
 
#import "MaintainMapPersonModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface JHMaintainMapVC ()<MAMapViewDelegate,AMapSearchDelegate,XHMapViewDelegate>
{
    XHMapView *_map;
    AMapSearchAPI *_search;
    //MAPointAnnotation *_myPoint;//定位的大头针
    BOOL _isFirst;
    UIButton *_locationBnt;//返回定位的位置
    MAUserLocation  *_userLocation;//定位的坐标
    MAUserLocation *_ayiLocation;
    CLLocationCoordinate2D _leftLocation;
    CLLocationCoordinate2D _rightLocation;
    NSMutableArray *_dataArray;//存放维修师傅人员的信息
    NSMutableArray *_personAnnotionArray;
    UIImageView * _imageV_bubble;//显示在大头针上方的气泡
    UILabel * _label_num;//显示有多少跑腿员的
}



@end

@implementation JHMaintainMapVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"附近服务人员", nil);
    _isFirst = NO;
    self.view.backgroundColor = BACK_COLOR;
    _dataArray = [NSMutableArray array];
    _personAnnotionArray = [NSMutableArray array];
    [self createRightItem];
    [self createMap];
}
#pragma mark =========== 创建显示在大头针的上方的气泡
-(void)creatBubble{
    if (_imageV_bubble == nil) {
        _imageV_bubble = [[UIImageView alloc]init];
        _imageV_bubble.image = [UIImage imageNamed:@"bubble"];
        _imageV_bubble.bounds = FRAME(0, 0, 110, 48);
        _imageV_bubble.hidden = YES;
        _imageV_bubble.center = CGPointMake(_map.center.x, _map.center.y - 55);
        [self.view addSubview:_imageV_bubble];
        _label_num = [[UILabel alloc]init];
        _label_num.frame = FRAME(1, 0, 100, 45);
        _label_num.backgroundColor = [UIColor clearColor];
        _label_num.numberOfLines = 0;
        _label_num.font = FONT(14);
        _label_num.textAlignment = NSTextAlignmentCenter;
        _label_num.textColor = [UIColor whiteColor];
        [_imageV_bubble addSubview:_label_num];
    }
}
#pragma mark====创建地图========
- (void)createMap
{
    _map = [[XHMapView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 45)];
    _map.XHDelegate = self;
    [_map setCenterWithPoint:CLLocationCoordinate2DMake([XHMapKitManager shareManager].lat,
                                                        [XHMapKitManager shareManager].lng)];
    [self.view addSubview:_map];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"datouzhen"];
    imageView.bounds = CGRectMake(0, 0, 25, 30);
    imageView.center = CGPointMake(_map.center.x, _map.center.y-15);
    [self.view addSubview:imageView];
    [self creatBubble];
    _locationBnt = [[UIButton alloc] initWithFrame:FRAME(10, _map.frame.size.height - 45, 40, 40)];
    [_locationBnt setBackgroundImage:IMAGE(@"locationBnt") forState:UIControlStateNormal];
    [_locationBnt addTarget:self action:@selector(locationBnt) forControlEvents:UIControlEventTouchUpInside];
    [_map addSubview:_locationBnt];
    [self createOrderBnt];
}
#pragma mark=====创建下单按钮========
- (void)createOrderBnt
{
    UIButton *orderBnt =[UIButton buttonWithType:UIButtonTypeCustom];
    orderBnt.frame = FRAME(30, HEIGHT - 40, WIDTH - 60,35);
    [orderBnt setTitle:NSLocalizedString(@"立即下单", nil) forState:UIControlStateNormal];
    [orderBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    orderBnt.layer.cornerRadius = 4.0f;
    orderBnt.clipsToBounds = YES;
    orderBnt.titleLabel.font = FONT(14);
    [orderBnt setBackgroundColor:HEX(@"fc7400", 1.0f) forState:UIControlStateNormal];
    [orderBnt setBackgroundColor:HEX(@"ff5500", 1.0f) forState:UIControlStateHighlighted];
    [orderBnt addTarget:self action:@selector(orderBnt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBnt];
}
#pragma mark=======下单按钮点击事件========
- (void)orderBnt
{
    //下单了
    JHMaintainOrderVC *order = [[JHMaintainOrderVC alloc] init];
    order.cate_id = self.cate_id;
    order.name = self.name;
    order.price = self.price;
    order.unit = self.unit;
    order.start = self.start;
    order.imgUrl = self.imgUrl;
    order.index = 1;
    order.cate_id = self.cate_id;
    [self.navigationController pushViewController:order animated:YES];
}
#pragma mark=====返回当前坐标按钮的点击事件=========
- (void)locationBnt
{

     [_map setCenterWithCurrentLocation];
    _leftLocation = [_map coordinateForPoint:CGPointMake(0, HEIGHT - 45)];
    _rightLocation = [_map coordinateForPoint:CGPointMake(WIDTH, 64)];
    [self postWithleftLat:_leftLocation.latitude leftLng:_leftLocation.longitude rightLat:_rightLocation.latitude rightLng:_rightLocation.longitude];
}
#pragma mark=======地图定位回调方法========
-(void)xhMapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation){
        _userLocation = userLocation;
        _leftLocation = [_map coordinateForPoint:CGPointMake(0, HEIGHT - 45)];
        _rightLocation = [_map coordinateForPoint:CGPointMake(WIDTH, 64)];
        [[NSUserDefaults standardUserDefaults] setFloat:userLocation.coordinate.latitude forKey:@"lat"];
        [[NSUserDefaults standardUserDefaults] setFloat:userLocation.coordinate.longitude forKey:@"lng"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%f==%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        if(!_isFirst){
            _imageV_bubble.center = CGPointMake(_map.center.x, _map.center.y - 55);
            [self postWithleftLat:_leftLocation.latitude leftLng:_leftLocation.longitude rightLat:_rightLocation.latitude rightLng:_rightLocation.longitude];
            _isFirst = YES;
        }
        
    }
}
-(void)xhMapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    if (_isFirst&&wasUserAction) {
        _leftLocation = [_map coordinateForPoint:CGPointMake(0, HEIGHT - 45)];
        _rightLocation = [_map coordinateForPoint:CGPointMake(WIDTH, 64)];
         [self postWithleftLat:_leftLocation.latitude leftLng:_leftLocation.longitude rightLat:_rightLocation.latitude rightLng:_rightLocation.longitude];
    }
    
}
-(void)xhMapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    if ((_isFirst&&wasUserAction) || mapView == nil) {
        _leftLocation = [_map coordinateForPoint:CGPointMake(0, HEIGHT - 45)];
        _rightLocation = [_map coordinateForPoint:CGPointMake(WIDTH, 64)];
        [self postWithleftLat:_leftLocation.latitude leftLng:_leftLocation.longitude rightLat:_rightLocation.latitude rightLng:_rightLocation.longitude];
    }
}
#pragma mark=====请求网络数据======
- (void)postWithleftLat:(float)leftLat leftLng:(float)leftLng rightLat:(float)rightLat rightLng:(float)rightLng
{
    NSString *leftbottomlat = [NSString stringWithFormat:@"%f",leftLat];
    NSString *leftbottomlng = [NSString stringWithFormat:@"%f",leftLng];
    NSString *righttoplat = [NSString stringWithFormat:@"%f",rightLat];
    NSString *righttoplng = [NSString stringWithFormat:@"%f",rightLng];
    NSDictionary *dic = @{@"leftbottomlat":leftbottomlat,@"leftbottomlng":leftbottomlng,@"righttoplat":righttoplat,@"righttoplng":righttoplng};
    [HttpTool postWithAPI:@"client/weixiu/map" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            [_dataArray removeAllObjects];
            NSArray *items = json[@"data"][@"items"];
            NSString *count = json[@"data"][@"count"];
             _imageV_bubble.hidden = NO;
            if(count.length == 0){
                 _label_num.text = NSLocalizedString(@"附近无维修师傅", nil);
            }
            else{
                _label_num.text = [NSString stringWithFormat:NSLocalizedString(@"附近有%@名维修师傅", nil),count];
            }
            for(NSDictionary *dic in items)
            {
                MaintainMapPersonModel *personModel = [[MaintainMapPersonModel alloc] init];
                [personModel setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:personModel];
            }
            [_map removeAllAnnotations];
            [self addAnnotion];
        }
        else
        {
            [self showAlertView:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"数据加载失败,原因:", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}
- (void)addAnnotion
{
    
    if(_dataArray.count != 0)
    {
        [_personAnnotionArray removeAllObjects];
        
        for(int i = 0 ; i <_dataArray.count; i ++)
        {
            MAPointAnnotation * personPoint = [[MAPointAnnotation alloc] init];
            MaintainMapPersonModel * model = _dataArray[i];
            float lat = model.lat ;
            float lng = model.lng ;
            personPoint.coordinate =  CLLocationCoordinate2DMake(lat,lng);
            NSLog(@"%f=======%f",personPoint.coordinate.latitude,personPoint.coordinate.longitude);
            [_personAnnotionArray addObject:personPoint];
            [_map addAnnotation:personPoint.coordinate title:@"'" imgStr:@"shifu" selected:NO];
        }
        
        NSLog(@"%@===%@",_dataArray,_personAnnotionArray);
    }
    else
    {
        
    }
}
#pragma mark=====右侧转换按钮===========
- (void)createRightItem
{
    UIButton * switchBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBnt.frame = FRAME(0, 0, 15, 15);
    [switchBnt setBackgroundImage:IMAGE(@"people_list") forState:UIControlStateNormal];
    [switchBnt addTarget:self action:@selector(switchBnt) forControlEvents:UIControlEventTouchUpInside];
    switchBnt.titleLabel.font = FONT(14);
    [switchBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:switchBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)switchBnt
{
    //转换到列表模式
    JHMaintainListVc * list = [[JHMaintainListVc alloc] init];
    list.cate_id = self.cate_id;
    list.cateTitle = self.name;
    [self.navigationController pushViewController:list animated:YES];
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController * alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//界面消失的时候让地图不再定位
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}
@end

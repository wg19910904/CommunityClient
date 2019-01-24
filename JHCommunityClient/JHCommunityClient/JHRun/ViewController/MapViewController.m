//
//  MapViewController.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry.h>
#import "JHShareModel.h"
@interface MapViewController ()<MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AMapSearchDelegate>
{
    MAMapView * _mapView;//创建地图
    AMapSearchAPI * _search;//周边搜索需要的
    BOOL isYes;//判断是关键字搜索还是周边搜索
    UITableView * tableView_Location;//这是展示周边搜索的数据的表
    //周边搜索
    NSMutableArray * buildArray;
    NSMutableArray * roadArray;
    NSMutableArray * latArray;
    NSMutableArray * logArray;
    NSMutableArray * sendArray;
    BOOL first;//判断是否是第一次
    UITableView * tableView_LocationOther;//这是展示关键字搜索的数据的表
    UIView * _view;//放关键字搜索的表
    //关键字搜索
   UITextField * textFiel;//关键字搜索的搜索框
    NSMutableArray * buildArray1;
    NSMutableArray * roadArray1;
    NSMutableArray * latArray1;
    NSMutableArray * logArray1;
    NSMutableArray * sendArray1;
}
@end

@implementation MapViewController
//这是高德转化为百度的函数
const double MAP_x_pi = M_PI * 3000.0 / 180.0;
void transform_mars_to_baidu(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon)
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y *  MAP_x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x *  MAP_x_pi);
    *bd_lon = z * cos(theta) + 0.0065;
    *bd_lat = z * sin(theta) + 0.006;
}
- (void)viewDidLoad {
    //初始化数组
    buildArray = [NSMutableArray array];
    roadArray = [NSMutableArray array];
    latArray = [NSMutableArray array];
    logArray = [NSMutableArray array];
    sendArray = [NSMutableArray array];
    buildArray1 = [NSMutableArray array];
    roadArray1 = [NSMutableArray array];
    latArray1 = [NSMutableArray array];
    logArray1 = [NSMutableArray array];
    sendArray1 = [NSMutableArray array];
    [super viewDidLoad];
    //创建地图
    [self creatMapView];
    //创建地图下方的表
    [self creatTableView];
    [self creatSearchBar];
    //检测文本框发生文本发生改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:textFiel];
    SHOW_HUD
}
#pragma mark - 创建地图
-(void)creatMapView{
    [MAMapServices sharedServices].apiKey = GAODE_KEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, (HEIGHT-64)/2)];
    _mapView.delegate = self;
    [_mapView setZoomEnabled:YES];
    [_mapView setZoomLevel:16.1 animated:YES];//显示地图的缩放级别
    [self.view addSubview:_mapView];
    _mapView.showsCompass = NO;//不显示指南针
    _mapView.showsScale = NO;//不显示比例尺
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.bounds = CGRectMake(0, 0, 25, 30);
    imageView.center = CGPointMake(_mapView.center.x, _mapView.center.y-15);
    imageView.image = [UIImage imageNamed:@"datouzhen"];
    [self.view addSubview:imageView];
}
#pragma mark - 这是当前位置改变的时候会调用的方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (userLocation) {
        NSLog(@"当前位置的坐标%f===%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
    if (!first) {
        first = YES;
        [self creatSearchWithlatiude:userLocation.coordinate.latitude withLongitude:userLocation.coordinate.longitude];
    }
}
#pragma mark-拖动地图时一直打印中间位置的坐标
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"拖动地图后坐标===%f,%f===",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
     [self creatSearchWithlatiude:mapView.centerCoordinate.latitude withLongitude:mapView.centerCoordinate.longitude];
}
#pragma mark - 添加周边搜索服务
-(void)creatSearchWithlatiude:(float)lat withLongitude:(float)log{
    isYes = NO;
    NSLog(@"<<<%f========%f>>>>",lat,log);
    [AMapSearchServices sharedServices].apiKey = GAODE_KEY;
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest * request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:lat longitude:log];
    request.types = @"餐饮服务|购物服务|生活服务|住宿服务|商务住宅|公司企业";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 50000;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {    NSLog(@"没有搜到结果哦亲");
        //return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    //NSLog(@"我找到le%ld",response.pois.count);
    if (!isYes) {
        [roadArray removeAllObjects];
        [buildArray removeAllObjects];
        [latArray removeAllObjects];
        [logArray removeAllObjects];
        [sendArray removeAllObjects];
    }else{
        [roadArray1 removeAllObjects];
        [buildArray1 removeAllObjects];
        [latArray1 removeAllObjects];
        [logArray1 removeAllObjects];
        [sendArray1 removeAllObjects];
    }
    for (AMapPOI * p in response.pois) {
        
        NSString * lat = [NSString stringWithFormat:@"%f",p.location.latitude];
        NSString * log = [NSString stringWithFormat:@"%f",p.location.longitude];
        NSLog(@"%@%@%@%@----->%@",p.province,p.city,p.district,p.address,p.name);
        NSString * road = [NSString stringWithFormat:@"%@%@%@%@",p.province,p.city,p.district,p.address];
        NSString * str_send = [NSString stringWithFormat:@"%@%@%@",p.city,p.district,p.name];
        if (!isYes) {
            [roadArray addObject:road];
            [buildArray addObject:p.name];
            [latArray addObject:lat];
            [logArray addObject:log];
            [sendArray addObject:str_send];
        }else{
            [roadArray1 addObject:road];
            [buildArray1 addObject:p.name];
            [latArray1 addObject:lat];
            [logArray1 addObject:log];
            [sendArray1 addObject:str_send];
        }
        NSLog(@"%@ <======> %@",lat,log);
    }
    if (!isYes) {
        HIDE_HUD
        //[tableView_Location reloadData];
        [tableView_Location reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        //[tableView_LocationOther reloadData];
        [tableView_LocationOther reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
# pragma mark - 创建地图下方的表
-(void)creatTableView{
    tableView_Location = [[UITableView alloc]initWithFrame:CGRectMake(0, 32+HEIGHT/2, WIDTH, (HEIGHT - 64)/2) style:UITableViewStylePlain];
    tableView_Location.delegate = self;
    tableView_Location.dataSource = self;
    tableView_Location.tag = 10;
    [self.view addSubview:tableView_Location];
    tableView_Location.tableFooterView = [[UIView alloc]init];
}
#pragma mark - 这是表的数据源方法和代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        return roadArray.count;
    }else{
        return roadArray1.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        static NSString * identifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.imageView.image = [UIImage imageNamed:@"address"];
        cell.textLabel.text = buildArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.text = roadArray[indexPath.row];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString * iden = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden ];
        if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        }
        cell.imageView.image = [UIImage imageNamed:@"address"];
        cell.textLabel.text = buildArray1[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.text = roadArray1[indexPath.row];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str1 = nil;
    NSString * str2 = nil;
    NSString * lat = nil;
    NSString * log = nil;
    NSString * str3 = nil;
    if (tableView.tag == 10) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //NSLog(@"%@<====%@=====>%ld",cell.textLabel.text,cell.detailTextLabel.text,indexPath.row);
        str1 = cell.textLabel.text;
        str2 = cell.detailTextLabel.text;
        lat = latArray[indexPath.row];
        log = logArray[indexPath.row];
        str3 = sendArray[indexPath.row];
    }else{
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        str1 = cell.textLabel.text;
        str2 = cell.detailTextLabel.text;
        lat = latArray1[indexPath.row];
        log = logArray1[indexPath.row];
        str3 = sendArray1[indexPath.row];
    }
    double baiduLat = 0.0;
    double baiduLng = 0.0;
    transform_mars_to_baidu([lat doubleValue], [log doubleValue], &baiduLat, &baiduLng);
    //NSLog(@"%f---%f----%@---%@",baiduLat,baiduLng,lat,log);
    lat = [NSString stringWithFormat:@"%f",baiduLat];
    log = [NSString stringWithFormat:@"%f",baiduLng];
    NSLog(@"%f---%f",baiduLat,baiduLng);
    [textFiel removeFromSuperview];
    //[label removeFromSuperview];
    self.Block(str2,str1,lat,log,str3);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 添加关键字搜索服务搜索服务
-(void)creatMainSearch{
    isYes = YES;
    [AMapSearchServices sharedServices].apiKey = GAODE_KEY;
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    NSLog(@"%@",textFiel.text);
    request.keywords = textFiel.text;
    request.city = [JHShareModel shareModel].cityName;
    request.sortrule = 0;
    request.requireExtension = YES;
    //发起关键字搜索
    [_search AMapPOIKeywordsSearch: request];
}
#pragma mark - 这是创建关键字搜索后的背景view
-(void)creatView{
    if (_view == nil) {
        _view = [[UIView alloc]init];
        _view.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        _view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        [self.view addSubview:_view];
    }
}
#pragma mark - 这是关键字搜索的表
-(void)creatOtherTableView{
    tableView_LocationOther = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    tableView_LocationOther.delegate = self;
    tableView_LocationOther.dataSource = self;
    tableView_LocationOther.tag = 20;
    tableView_LocationOther.tableFooterView = [UIView new];
    [_view addSubview:tableView_LocationOther];
}
#pragma mark - 创建导航上的搜索框
-(void)creatSearchBar{
    CGRect mainViewBounds = self.navigationController.view.bounds;
    textFiel = [[UITextField alloc]initWithFrame:CGRectMake(40, 27, mainViewBounds.size.width- 90, 30)];
    //设置提示字样
    textFiel.placeholder = GLOBAL(@"请输入搜索的地点");
    [textFiel setValue:[UIColor colorWithWhite:1.0 alpha:0.9] forKeyPath:@"_placeholderLabel.textColor"];
    [textFiel setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    textFiel.textColor = [UIColor whiteColor];
    textFiel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    textFiel.layer.cornerRadius = 4;
    textFiel.layer.masksToBounds = YES;
    textFiel.font = [UIFont systemFontOfSize:14];
    textFiel.clearButtonMode = UITextFieldViewModeAlways;
    textFiel.delegate = self;
    //添加左view
    UIView *leftVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textFiel.leftViewMode = UITextFieldViewModeAlways;
    textFiel.leftView = leftVeiw;
    [self.navigationController.view addSubview:textFiel];
}
#pragma mark-文本框的代理和数据源方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textFiel.text = nil;
    [self.navigationController.view endEditing:YES];
    [_view removeFromSuperview];
    _view = nil;
    [tableView_LocationOther removeFromSuperview];
    tableView_LocationOther = nil;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:GLOBAL(@"取消") style:UIBarButtonItemStylePlain target:self action:@selector(quxiaoClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self creatView];
    if (tableView_LocationOther == nil) {
        [self creatOtherTableView];
    }
}
#pragma mark 取消搜索框的搜索
-(void)quxiaoClick{
    [self.navigationController.view endEditing:YES];
    [_view removeFromSuperview];
    _view = nil;
    [tableView_LocationOther removeFromSuperview];
    tableView_LocationOther = nil;
    textFiel.text = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
-(void)textFieldTextDidChangeOneCI:(NSNotification *)not{
    [self creatMainSearch];
}
//滚动视图的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == 20){
        
        CGFloat offset_y = scrollView.contentOffset.y;
        if (offset_y > 0) {
            //搜索文本框放弃第一响应
            [textFiel resignFirstResponder];
        }
    }
}
//文本框隐藏的通知
-(void)keyBoardDidHide:(NSNotification *)note{
    [self.navigationController.view endEditing:YES];
    [_view removeFromSuperview];
    _view = nil;
    [tableView_LocationOther removeFromSuperview];
    tableView_LocationOther = nil;
    textFiel.text = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
//界面消失的时候移除通知
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [textFiel removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:textFiel];
}
@end

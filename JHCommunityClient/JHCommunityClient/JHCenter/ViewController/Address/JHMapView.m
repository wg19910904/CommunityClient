//
//  JHMapView.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHMapView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "JHShareModel.h"
@interface JHMapView ()<UITextFieldDelegate,MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_searchTextField;
    UIButton *_cancelBnt;//搜索栏取消按钮
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    BOOL _isFirst;//是否为第一次
    NSMutableArray *_nameArray;//店名
    NSMutableArray *_allAddressArray;//地址详细全称
    NSMutableArray *_partAddressArray;//部分信息
    NSMutableArray *_latArray;
    NSMutableArray *_lngArray;
    UITableView *_tableViewMap;//地图表视图
    NSMutableArray *_nameSearchArray;//搜索店名
    NSMutableArray *_allAddressSearchArray;//搜索地址详细全称
    NSMutableArray *_partAddressSearchArray;//搜索部分信息
    NSMutableArray *_latSearchArray;
    NSMutableArray *_lngSearchArray;
    UITableView *_tableViewSearch;//搜索表视图
    BOOL _isMap;//判断是地图页面,还是搜索页面
    
}
@end

@implementation JHMapView

//这是高德转化为百度的函数
const double map = M_PI * 3000.0 / 180.0;
void baidu_transFromGaode(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon)
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y *  map);
    double theta = atan2(y, x) + 0.000003 * cos(x *  map);
    *bd_lon = z * cos(theta) + 0.0065;
    *bd_lat = z * sin(theta) + 0.006;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMap];
    [self createSearchTextField];
    [self addCancelBnt];
    _cancelBnt.hidden = YES;
    _nameArray = [NSMutableArray array];
    _allAddressArray = [NSMutableArray array];
    _partAddressArray = [NSMutableArray array];
    _latArray = [NSMutableArray array];
    _lngArray = [NSMutableArray array];
    _nameSearchArray = [NSMutableArray array];
    _allAddressSearchArray = [NSMutableArray array];
    _partAddressSearchArray = [NSMutableArray array];
    _latSearchArray = [NSMutableArray array];
    _lngSearchArray = [NSMutableArray array];
    [self createTableViewMap];
    [self createSearchTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:_searchTextField];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isFirst = YES;
}
#pragma mark========创建地图===========
- (void)createMap
{
    [MAMapServices sharedServices].apiKey = GAODE_KEY;
    _mapView = [[MAMapView alloc] initWithFrame:FRAME(0, 64, WIDTH, (HEIGHT-64)/2)];
    _mapView.delegate = self;
    [_mapView setZoomEnabled:YES];
    [_mapView setZoomLevel:16.1 animated:YES];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self.view addSubview:_mapView];
    UIImageView *img = [[UIImageView alloc] init];
    img.bounds = FRAME(0, 0, 25, 30);
    img.center = CGPointMake(_mapView.center.x, _mapView.center.y - 15);
    img.image = IMAGE(@"datouzhen");
    [self.view addSubview:img];
    
}

#pragma mark========定位回调方法============
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(userLocation)
    {
        NSLog(@"lat%f=======lng%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
    if(_isFirst)
    {
        _isFirst = NO;
        [self createSearchWithLat:userLocation.location.coordinate.latitude lng:userLocation.location.coordinate.longitude];
    }
    
}
#pragma mark===========拖动地图上的大头针图片的执行方法========
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self createSearchWithLat:_mapView.centerCoordinate.latitude lng:_mapView.centerCoordinate.longitude];
}
#pragma mark==========实现POI搜索对应的回调函数===================
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if(response.pois.count == 0)
    {
        NSLog(@"很抱歉没有搜到!!");
        
    }
    if(_isMap)
    {
        [_nameArray removeAllObjects];
        [_allAddressArray removeAllObjects];
        [_partAddressArray removeAllObjects];
        [_latArray removeAllObjects];
        [_lngArray removeAllObjects];
    }
    else
    {
        [_nameSearchArray removeAllObjects];
        [_allAddressSearchArray removeAllObjects];
        [_partAddressSearchArray removeAllObjects];
        [_latSearchArray removeAllObjects];
        [_lngSearchArray removeAllObjects];
    }
    for(AMapPOI *p in response.pois){
        NSString *lat = [NSString stringWithFormat:@"%f",p.location.latitude];
        NSString *lng = [NSString stringWithFormat:@"%f",p.location.longitude];
        NSString *name = [NSString stringWithFormat:@"%@",p.name];
        NSString *allAddress = [NSString stringWithFormat:@"%@%@%@%@",p.province,p.city,p.district,p.address];
        NSString *partAddress = [NSString stringWithFormat:@"%@%@%@",p.city,p.district,p.name];
        if(_isMap){
            [_nameArray addObject:name];
            [_allAddressArray addObject:allAddress];
            [_partAddressArray addObject:partAddress];
            [_latArray addObject:lat];
            [_lngArray addObject:lng];
        }
        else{
            [_nameSearchArray addObject:name];
            [_allAddressSearchArray addObject:allAddress];
            [_partAddressSearchArray addObject:partAddress];
            [_latSearchArray addObject:lat];
            [_lngSearchArray addObject:lng];
        }
    }
   if(_isMap){
       [_tableViewMap reloadData];
   }
  else{
        [_tableViewSearch reloadData];
   }

}
#pragma Mark=========创建周边搜索============
- (void)createSearchWithLat:(float)lat lng:(float)lng{
    _isMap = YES;
    [AMapSearchServices sharedServices].apiKey = GAODE_KEY;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:lat longitude:lng];
    request.types =GLOBAL(@"餐饮服务|购物服务|生活服务|住宿服务|商务住宅|公司企业");
    request.sortrule = 0;
    request.requireExtension = YES;
    [_search AMapPOIAroundSearch:request];
}
#pragma mark========创建关键字搜索=========
- (void)createWordsSearch{
    _isMap = NO;
    [AMapSearchServices sharedServices].apiKey = GAODE_KEY;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = _searchTextField.text;
    request.city = [JHShareModel shareModel].cityName;
    request.sortrule = 0;
    request.requireExtension = YES;
    [_search AMapPOIKeywordsSearch:request];
    
}
#pragma mark==========创建搜索框==========
- (void)createSearchTextField{
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 27, WIDTH- 90, 30)];
    _searchTextField.layer.cornerRadius = 4.0f;
    _searchTextField.delegate = self;
    _searchTextField.font = FONT(14);
     _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    _searchTextField.placeholder = GLOBAL(@"请输入搜索的地点");
    _searchTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    _searchTextField.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 20)];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _searchTextField;
}
#pragma mark=========创建地图表视图===========
- (void)createTableViewMap{
    _tableViewMap = [[UITableView alloc] initWithFrame:FRAME(0, 64 +(HEIGHT-64)/2 , WIDTH, HEIGHT - (64 +(HEIGHT-64)/2)) style:UITableViewStylePlain];
    _tableViewMap.delegate = self;
    _tableViewMap.dataSource = self;
    _tableViewMap.tag = 100;
    _tableViewMap.showsVerticalScrollIndicator = NO;
    _tableViewMap.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewMap.backgroundColor = BACK_COLOR;
    UILabel *thread = [[UILabel alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 0.5)];
    thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [_tableViewMap addSubview:thread];
    [self.view addSubview:_tableViewMap];
}
#pragma mark========创建搜索框表视图===============
- (void)createSearchTableView{
    _tableViewSearch = [[UITableView alloc] initWithFrame:FRAME(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    _tableViewSearch.delegate = self;
    _tableViewSearch.dataSource = self;
    _tableViewSearch.tag = 200;
    _tableViewSearch.showsVerticalScrollIndicator = NO;
    _tableViewSearch.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewSearch.backgroundColor = BACK_COLOR;
    UILabel *thread = [[UILabel alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 0.5)];
    thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [_tableViewSearch addSubview:thread];
    [self.view addSubview:_tableViewSearch];
    _tableViewSearch.hidden = YES;
    _tableViewSearch.backgroundColor = BACK_COLOR;

}
#pragma mark============UITableViewDelegate==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 100)
       return _nameArray.count;
    else
       return _nameSearchArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 100)
    {
        static NSString *identifier = @"map";
        UITableViewCell *cellMap = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cellMap == nil)
        {
            cellMap = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cellMap.imageView.image = IMAGE(@"address");
        cellMap.textLabel.font = FONT(13);
        cellMap.textLabel.text = _nameArray[indexPath.row];
        cellMap.detailTextLabel.text = _allAddressArray[indexPath.row];
        cellMap.detailTextLabel.textColor = HEX(@"999999", 1.0f);
        cellMap.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *thread = [[UILabel alloc] initWithFrame:FRAME(50, 43.5, WIDTH - 50, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [cellMap addSubview:thread];
        return cellMap;
    }
    else
    {
        static NSString *identifier = @"search";
        UITableViewCell *cellSearch = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cellSearch == nil)
        {
            cellSearch = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cellSearch.imageView.image = IMAGE(@"address");
        cellSearch.textLabel.font = FONT(13);
        cellSearch.textLabel.text = _nameSearchArray[indexPath.row];
        cellSearch.detailTextLabel.text = _allAddressSearchArray[indexPath.row];
        cellSearch.detailTextLabel.textColor = HEX(@"999999", 1.0f);
        cellSearch.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *thread = [[UILabel alloc] initWithFrame:FRAME(50, 43.5, WIDTH - 50, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [cellSearch addSubview:thread];
        return cellSearch;
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *lat = nil;
    NSString *lng = nil;
    if(tableView.tag == 100)
    {
        double baiduLat = 0.0;
        double baiduLng = 0.0;
        baidu_transFromGaode([_latArray[indexPath.row] doubleValue], [_lngArray[indexPath.row] doubleValue], &baiduLat, &baiduLng);
        //NSLog(@"%f---%f----%@---%@",baiduLat,baiduLng,lat,log);
        lat = [NSString stringWithFormat:@"%f",baiduLat];
        lng = [NSString stringWithFormat:@"%f",baiduLng];
        if(self.myBlock)
        {
            self.myBlock(lat,lng,_partAddressArray[indexPath.row]);
        }
    }
    else
    {
        double baiduLat = 0.0;
        double baiduLng = 0.0;
        baidu_transFromGaode([_latSearchArray[indexPath.row] doubleValue], [_lngSearchArray[indexPath.row] doubleValue], &baiduLat, &baiduLng);
        lat = [NSString stringWithFormat:@"%f",baiduLat];
        lng = [NSString stringWithFormat:@"%f",baiduLng];
        if(self.myBlock)
        {
            self.myBlock(lat,lng,_partAddressSearchArray[indexPath.row]);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark=========添加取消按钮===========
- (void)addCancelBnt{
    _cancelBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBnt.frame = FRAME(0, 0, 30, 15);
    [_cancelBnt setTitle:GLOBAL(@"取消") forState:UIControlStateNormal];
    [_cancelBnt addTarget:self action:@selector(cancelBnt) forControlEvents:UIControlEventTouchUpInside];
    _cancelBnt.titleLabel.font = FONT(14);
    [_cancelBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_cancelBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark=======取消按钮点击事件=============
- (void)cancelBnt
{
    NSLog(@"取消检索");
    _isMap = YES;
    _cancelBnt.hidden = YES;
    _tableViewSearch.hidden = YES;
    _searchTextField.text = nil;
    [_searchTextField resignFirstResponder];
}
#pragma mark======UITextFieldDelegate==============
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touch_BackView
{
    [self.view endEditing:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _cancelBnt.hidden = NO;
    _tableViewSearch.hidden = NO;
    _searchTextField.text = nil;
}
- (void)textFieldChange:(NSNotification *)noti
{
    [self createWordsSearch];
}
//界面消失的时候移除通知
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
     _searchTextField.text = nil;
    //[_searchTextField removeFromSuperview];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UITextFieldTextDidChangeNotification object:_searchTextField];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchTextField resignFirstResponder];
}
- (void)dealloc{
     [[NSNotificationCenter defaultCenter]  removeObserver:self name:UITextFieldTextDidChangeNotification object:_searchTextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

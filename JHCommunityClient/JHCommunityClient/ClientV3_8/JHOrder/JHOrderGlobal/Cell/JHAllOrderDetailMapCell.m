//
//  JHOrderDetailMapCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHAllOrderDetailMapCell.h"
#import "XHMapView.h"

@interface JHAllOrderDetailMapCell()
@property(nonatomic,strong)XHMapView *mapView;//地图

@end

@implementation JHAllOrderDetailMapCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    XHMapView *mapView = [[XHMapView alloc]initWithFrame:FRAME(0, 0, WIDTH, 135)];
    [self addSubview:mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
        make.height.offset = 135;
    }];
    self.mapView = mapView;
}

/*
 staff_id    int    配送员ID
 name    string    配送员姓名
 mobile    string    配送员手机
 face    string    配送员头像
 lng    int    配送员经度
 lat    int    配送员纬度
 */
-(void)reloadCellWithModel:(JHWaiMaiModel *)model{
    
    if(model.order_status  == 2 && [model.staff[@"staff_id"] integerValue] > 0){//骑手正在取餐
        float shop_lat = [model.staff[@"lat"] floatValue];
        float shop_lng = [model.staff[@"lng"] floatValue];
        CLLocationCoordinate2D shop = CLLocationCoordinate2DMake(shop_lat, shop_lng);
        float pei_lat = [model.staff[@"lat"] floatValue];
        float pei_lng = [model.staff[@"lng"] floatValue];
        CLLocationCoordinate2D pei = CLLocationCoordinate2DMake(pei_lat, pei_lng);

        [_mapView changeDistanceWithShopCoordinate:shop peiCoordinate:pei];
    }
    if (model.order_status == 3) {//配送员正在送餐
        float pei_lat = [model.staff[@"lat"] floatValue];
        float pei_lng = [model.staff[@"lng"] floatValue];
        CLLocationCoordinate2D pei = CLLocationCoordinate2DMake(pei_lat, pei_lng);
        float custom_lat = model.lat;
        float custom_lng = model.lng ;
        CLLocationCoordinate2D custom = CLLocationCoordinate2DMake(custom_lat, custom_lng);
        [_mapView changeDistanceWithCustomCoordinate:custom peiCoordinate:pei];

    }
    
}

@end

//
//  JHGroupTableViewCellThree.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGroupTableViewCellThree.h"
#import "JHShareModel.h"
@implementation JHGroupTableViewCellThree
{
    UIView * label_line;//创建分割线
    UILabel * label_title;//商家信息
    UILabel * label_name;//显示饭馆的名字的
    UILabel * label_address;//显示地点的
    UILabel * label_distance;//距离
    UIImageView  * imageV;//显示距离之前的图片
    AMapLocationManager * locationManager;
    float lat;
    float lng;
}

-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    //创建分割线
    if(label_line == nil){
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
        UIView * label = [[UIView alloc]init];
        label.frame = FRAME(0, 119.5, WIDTH, 0.5);
        label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label];
    }
    //商家信息
    if(label_title == nil){
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(10, 10, WIDTH/2, 20);
        label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_title.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_title];
    }
    label_title.text = NSLocalizedString(@"商家信息", nil);
    //显示饭馆的名字的
    if(label_name == nil){
        UIImageView * image = [[UIImageView alloc]init];
        image.frame =FRAME(10, 50, 15, 15);
        image.image = [UIImage imageNamed:@"icon_tab02"];
        [self addSubview:image];
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(30, 50, WIDTH/2, 20);
        label_name.font = [UIFont systemFontOfSize:15];
        label_name.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_name];
    }
    label_name.text = model.title;
    //显示地点的
    if(label_address == nil){
        label_address = [[UILabel alloc]init];
        label_address.frame = FRAME(10, 70, WIDTH - 80, 40);
        //label_address.adjustsFontSizeToFitWidth = YES;
        label_address.font = [UIFont systemFontOfSize:13];
        label_address.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_address.numberOfLines = 0;
        [self addSubview:label_address];
    }
    label_address.text = model.addr;
    //显示距离的
    if (label_distance == nil) {
        label_distance = [[UILabel alloc]init];
        label_distance.frame =FRAME(30, 93, WIDTH/2, 20);
        label_distance.font = [UIFont systemFontOfSize:15];
        label_distance.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_distance];
    }
    [self initLocation];
     if(imageV == nil){
        imageV = [[UIImageView alloc]init];
        imageV.frame =FRAME(10, 93, 20, 20);
        [self addSubview:imageV];
        //imageV.image =[UIImage imageNamed:@"address"];
    }
    //打电话的按钮
    if (self.btnCall == nil) {
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"callNEW"];
        image.frame = FRAME(10, 9, 15, 20);
        self.btnCall = [[UIButton alloc]init];
        self.btnCall.frame = FRAME(WIDTH - 40, 0, 40, 40);
        [self addSubview:self.btnCall];
        [self.btnCall addSubview:image];
        UIImageView * imageV_address = [[UIImageView alloc]init];
        imageV_address.image = [UIImage imageNamed:@"arrowR"];
        imageV_address.frame = FRAME(WIDTH - 28, 72, 10, 15);
        [self addSubview:imageV_address];
    }
}
-(void)initLocation{
//    [AMapLocationServices sharedServices].apiKey = GAODE_KEY;
//    locationManager = [[AMapLocationManager alloc]init];
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//    [locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        if (error)
//        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//            
//            if (error.code == AMapLocationErrorLocateFailed)
//            {
//                return;
//            }
//        }
//        NSLog(@"%f==%f",location.coordinate.latitude,location.coordinate.longitude);
//        lat = [JHShareModel shareModel].lat;
//        lng = [JHShareModel shareModel].lng;
//        //1.将两个经纬度点转成投影点
//        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lng));
//        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_model.lat floatValue],[_model.lng floatValue]));
//        //2.计算距离
//        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
//        if(distance <= 1500){
//            label_distance.text = [NSString stringWithFormat:@"%.2f m",distance];
//        }else{
//            label_distance.text = [NSString stringWithFormat:@"%.2f km",distance/1000];
//        }
//    //}];
}
@end

//
//  JHPrivilegeDetailCellTwo.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegeDetailCellTwo.h"
#import "UIImageView+NetStatus.h"
#import "JHShareModel.h"
@implementation JHPrivilegeDetailCellTwo
{
    UILabel * label;//显示商家信息四个字的
    UIImageView * imageView;//显示图标的
    UILabel * label_title;//显示订单名的
    UILabel * label_address;//显示地址的
    UILabel * label_distance;//显示距离的
    UIImageView * imageV;//显示小图标的
    AMapLocationManager * locationManager;
    float lat;
    float lng;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(void)setModel:(JHPrivilegeDetailModel *)model{
     _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.frame = FRAME(10, 5, 60, 20);
        label.text = NSLocalizedString(@"商家信息", nil);
        label.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        //创建第一根分割线
        UIView * label_one = [[UIView alloc]init];
        label_one.frame = FRAME(0,0, WIDTH, 0.5);
        label_one.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_one];
        //创建第二根分割线
        UIView * label_two = [[UIView alloc]init];
        label_two.frame = FRAME(0, 29.5, WIDTH, 0.5);
        label_two.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_two];
        //创建第三根分割线
        UIView * label_three = [[UIView alloc]init];
        label_three.frame = FRAME(0, 109.5, WIDTH, 0.5);
        label_three.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_three];
        self.btn_call = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_call.frame = FRAME(WIDTH - 60, 50, 40, 40);
        [self.btn_call setImage:[UIImage imageNamed:@"phone00"] forState:UIControlStateNormal];
        [self addSubview:self.btn_call];
        //创建竖着的分割线
        UIView * label_four = [[UIView alloc]init];
        label_four.frame = FRAME(WIDTH - 81, 40, 1, 60);
        label_four.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_four];
    }
    if (imageView == nil) {
        imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME(10, 45, 50, 50);
        [self addSubview:imageView];
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME(70, 85, 15, 15);
        imageV.image = [UIImage imageNamed:@"address"];
        [self addSubview:imageV];
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(70, 40, WIDTH - 160, 20);
        label_title.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        label_title.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_title];
        label_address = [[UILabel alloc]init];
        label_address.frame = FRAME(70, 62, WIDTH - 160, 20);
        label_address.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_address.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_address];
        label_distance = [[UILabel alloc]init];
        label_distance.frame = FRAME(90, 83, 100, 20);
        label_distance.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_distance.adjustsFontSizeToFitWidth = YES;
        label_distance.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_distance];
    }
     [imageView sd_image:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.photo]] plimage:[UIImage imageNamed:@"commondefault"]];
    [self initLocation];
    label_title.text = model.title;
    label_address.text = model.addr;
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
//        
//        NSLog(@"%f<==>%f",location.coordinate.latitude,location.coordinate.longitude);
        lat = [JHShareModel shareModel].lat;
        lng = [JHShareModel shareModel].lng;
         NSLog(@"%f%f%@%@",lat,lng,_model.lat,_model.lng);
        //1.将两个经纬度点转成投影点
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lng));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_model.lat floatValue],[_model.lng floatValue]));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        if (distance <= 1500) {
         label_distance.text = [NSString stringWithFormat:@"%.1f m",distance];
        }else{
        label_distance.text = [NSString stringWithFormat:@"%.1f km",distance/1000];
        }

//    }];
}

@end

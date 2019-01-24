//
//  JHChooseCityVC.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^ChooseCity)(NSString *cityName,NSString *city_id);

@interface ChooseCityVC : JHBaseVC
@property(nonatomic,copy)ChooseCity chooseCity;
@end

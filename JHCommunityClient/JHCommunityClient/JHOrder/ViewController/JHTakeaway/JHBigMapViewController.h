//
//  JHBigMapViewController.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/8/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void (^(refreshBlock))(void);
@interface JHBigMapViewController : JHBaseVC
@property(nonatomic,copy)refreshBlock refreshBlock;
@property(nonatomic,copy)NSString * staff_lat;
@property(nonatomic,copy)NSString * staff_lng;
@property(nonatomic,copy)NSString * lat;//订单地址lat
@property(nonatomic,copy)NSString * lng;//订单地址lng
@property(nonatomic,copy)NSString * shop_lat;
@property(nonatomic,copy)NSString * shop_lng;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * labelState;
@end

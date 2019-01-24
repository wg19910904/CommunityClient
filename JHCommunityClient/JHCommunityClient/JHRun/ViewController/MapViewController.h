//
//  MapViewController.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
@interface MapViewController : JHBaseVC
@property(nonatomic,copy)void(^Block)(NSString * house,NSString * detailHouse,NSString * lat,NSString * log,NSString * sendAddress);

@end

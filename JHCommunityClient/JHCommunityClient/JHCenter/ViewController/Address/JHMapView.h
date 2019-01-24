//
//  JHMapView.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHMapView : JHBaseVC
@property (nonatomic,copy)void(^myBlock)(NSString *lat,NSString *lng,NSString*partAddress);
@end

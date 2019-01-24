//
//  JHPaiotuiOtherMapVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/31.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
@interface JHPathMapVC : JHBaseVC
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *lng;
@property(nonatomic,copy)NSString *shopName;
@property(nonatomic,copy)NSString *shopAddr;
@property(nonatomic,assign)BOOL is_hiddenPath;//不进行路径规划
@end

//
//  JHCountryVC.h
//  Lunch
//
//  Created by ios_yangfei on 17/8/1.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHCountryCodeVC : JHBaseVC
@property(nonatomic,copy) void(^chooseCountryCode)(BOOL success,NSString *code);
@end

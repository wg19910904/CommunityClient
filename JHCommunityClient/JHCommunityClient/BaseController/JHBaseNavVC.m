//
//  JHBaseNaviVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseNavVC.h"

@interface JHBaseNavVC ()

@end

@implementation JHBaseNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:IMAGE(@"barBackImage") forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar yf_setBackgroundColor:THEME_COLOR_WHITE_Alpha(1)];
    self.navigationBar.translucent = YES;
    self.navigationBar.shadowImage = [UIImage new];
    
}


@end

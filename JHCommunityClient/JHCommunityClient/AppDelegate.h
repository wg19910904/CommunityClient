//
//  AppDelegate.h
//  JHCommunityClient
//
//  Created by xixixi on 16/2/20.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSwitchModel.h"
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) Reachability *hostReach;
@property (nonatomic,copy)NSString *access_token;
@property (nonatomic,copy)NSString *openid;
@property (nonatomic,strong)JHSwitchModel *switchModel;

- (void)setPaypalClientID:(NSString *)clientID model:(NSString *)model;

@end

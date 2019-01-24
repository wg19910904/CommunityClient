//
//  JHSwitchModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSwitchModel.h"

@implementation JHSwitchModel
{
    NSString *_netWorkOn;
    BOOL _netWorkStatus;
}
static JHSwitchModel *model = nil;

+ (JHSwitchModel *)shareModel
{
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
        model = [[JHSwitchModel alloc] init];
    });
    return model;
}
#pragma mark=======get方法======
- (NSString *)netWorkOn
{
    _netWorkOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetWorkOn"];
    return _netWorkOn;
}

- (BOOL)netWorkStatus
{
    _netWorkStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"NetWorkStatus"];
    return  _netWorkStatus;
}

- (void)setNetWorkOn:(NSString *)netWorkOn
{
    _netWorkOn = netWorkOn;
    [[NSUserDefaults standardUserDefaults] setObject:netWorkOn forKey:@"NetWorkOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setNetWorkStatus:(BOOL)netWorkStatus{
    _netWorkStatus = netWorkStatus;
    [[NSUserDefaults standardUserDefaults] setBool:netWorkStatus forKey:@"NetWorkStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

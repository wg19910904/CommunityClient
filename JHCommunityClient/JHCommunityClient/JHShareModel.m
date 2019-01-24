//
//  JHShareModel.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHShareModel.h"
 
#import "AppDelegate.h"
@implementation JHShareModel
{
    NSString *_cityCode;
    double _lat;
    double _lng;
    NSString *_lastCommunity;
    NSString *_cityName;
    NSString *_phone;
    NSMutableArray *_historyArray;
    NSString *_shareLink;
     NSString *_chooseCityName;
}

+(instancetype)shareModel
{
    static JHShareModel *model = nil;
    if (!model) {
        model = [[JHShareModel alloc] init];
        if (SHOW_COUNTRY_CODE) {
            [model get_def_code];
        }
    }
    return model;
}
- (NSString *)token{
    if (_token.length) {
        return _token;
    }
    return @"";
}
//获取默认的区号
- (void)get_def_code{
    [HttpTool postWithAPI:@"magic/get_default_code"
               withParams:@{}
                  success:^(id json) {
                      NSLog(@"magic/get_default_code------------%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          self.def_code = json[@"data"][@"code_code"];
                      }
                  } failure:^(NSError *error) {
                      
                  }];
}

-(NSString *)version{
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    NSString *vers = dic[@"CFBundleShortVersionString"];
    return  vers;
}
#pragma mark - citycode
- (void)setCityCode:(NSString *)cityCode
{
    _cityCode = cityCode;
    [UserDefaults setObject:_cityCode forKey:@"lastCity_code"];
    if (cityCode.length>0) {
        [HttpTool postWithAPI:@"magic/citycode" withParams:@{@"code":cityCode} success:^(id json) {
            NSLog(@"city_id   %@",json[@"data"][@"city_id"]);
            if ([json[@"error"] intValue]==0)  self.city_id=json[@"data"][@"city_id"];
            //else [JHShareModel shareModel].cityCode=cityCode;
        } failure:^(NSError *error) {
            //[JHShareModel shareModel].cityCode=cityCode;
        }];
    }
}

- (NSString *)cityCode
{
    _cityCode = [UserDefaults stringForKey:@"lastCity_code"] ?
    [UserDefaults stringForKey:@"lastCity_code"] : @"";
//    return _cityCode;
    return @"0551";
}
#pragma mark - lat
- (void)setLat:(double)lat
{
    _lat = lat;
    [UserDefaults setDouble:_lat forKey:@"last_lat"];
}
- (double)lat
{
    _lat = [UserDefaults doubleForKey:@"last_lat"] ?
    [UserDefaults doubleForKey:@"last_lat"] : 0.0;
    return _lat;
}
#pragma mark - lng
- (void)setLng:(double)lng
{
    _lng = lng;
    [UserDefaults setDouble:_lng forKey:@"last_lng"];
}
- (double)lng
{
    _lng = [UserDefaults doubleForKey:@"last_lng"] ?
    [UserDefaults doubleForKey:@"last_lng"] : 0.0;
    return _lng;
}

#pragma mark - lastCommunity
- (void)setLastCommunity:(NSString *)lastCommunity
{
    _lastCommunity = lastCommunity;
//    [UserDefaults  setObject:_lastCommunity forKey:@"last_community"];
}
- (NSString *)lastCommunity
{
//    _lastCommunity = [UserDefaults stringForKey:@"last_community"];
    return _lastCommunity ? _lastCommunity : @"";
    //    return NSLocalizedString(@"金环花园南村", nil);
}
#pragma mark - cityName
- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    [UserDefaults  setObject:_cityName forKey:@"last_city"];
}
- (NSString *)cityName
{
    _cityName = [UserDefaults stringForKey:@"last_city"];
    return _cityName;
    
}
#pragma mark - ChooseCityName
- (void)setChooseCityName:(NSString *)chooseCityName
{
    _chooseCityName = chooseCityName;
    [UserDefaults  setObject:_chooseCityName forKey:@"choose_city"];
}
- (NSString *)choseCityName
{
    _chooseCityName = [UserDefaults stringForKey:@"choose_city"];
    return _chooseCityName;
    
}
#pragma mark - phone
- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)phone
{
    _phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    return _phone;
}
#pragma mark - historyArray
- (void)setHistoryArray:(NSMutableArray *)historyArray
{
    _historyArray = historyArray;
    [UserDefaults  setObject:_historyArray forKey:@"historyArray"];
}
- (NSMutableArray *)historyArray
{
    _historyArray = [UserDefaults objectForKey:@"historyArray"] ?
    [[UserDefaults objectForKey:@"historyArray"] mutableCopy] : [@[] mutableCopy];
    return _historyArray;
}
#pragma mark-======断网通知
- (void)addReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [Reachability reachabilityForInternetConnection];
    [_hostReach startNotifier];
}
#pragma mark=======网络监听响应方法============
- (void)reachabilityChanged:(NSNotification *)noti
{
    [self getNetStatusWithReachability:_hostReach];
}
#pragma mark=======获取当前网络的相关状态=======
- (void)getNetStatusWithReachability:(Reachability *)reachability
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        [self showAlertView:NSLocalizedString(@"网络连接失败,请检查当前网络状态", nil)];
    }else if(status == ReachableViaWWAN){
        [self showAlertView:NSLocalizedString(@"正在使用蜂窝网络", nil)];
    }else if(status == ReachableViaWiFi){
        [self showAlertView:NSLocalizedString(@"wifi已链接", nil)];
    }
}
#pragma mark=======提示框==========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)shareLink{
    if (_shareLink.length == 0) {
        return @"";
    }
    return _shareLink;
}

- (void)setShareLink:(NSString *)shareLink{
    if (![shareLink containsString:@"http"]) {
        return;
    }
    _shareLink = shareLink;
}

- (NSString *)WXSecret{
    if (_WXSecret.length) {
        return _WXSecret;
    }
    return @"";
}

- (NSArray *)payment{
    if (_payment.count == 0) {
        return @[];
    }
    return _payment;
}

- (NSString *)def_code{
    if (_def_code.length) {
        return _def_code;
    }
    return @"";

}
@end

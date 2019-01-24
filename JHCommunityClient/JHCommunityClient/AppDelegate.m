//
//  AppDelegate.m
//  JHCommunityClient
//  Created by xixixi on 16/2/20.
//  Copyright © 2016年 JiangHu. All rights reserved.

#import "AppDelegate.h"
#import "JHTabBarVC.h"

#import <UMSocialCore/UMSocialCore.h>
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>

#import "WXInfoModel.h"

#import "JHShareModel.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>
#import <IQKeyboardManager.h>

#import "MBProgressHUD.h"
//#import <UMMobClick/MobClick.h>
#import "JPUSHService.h"
#import "OpenUDID.h"
#import "JHIntroPageVC.h"
#import "JHWXBindVC.h"
#import "JHTempJumpWithRouteModel.h"
#import "JHShowAlert.h"
#import "JHTempRedBagView.h"
#import "AnimationVC.h"
#import "JHBaseNavVC.h"

#import <PayPal-iOS-SDK/PayPalMobile.h>

#import <UMCommon/UMCommon.h>
#import <Bugly/Bugly.h>

//显示hud
#define APPSHOW_HUD MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];\
hud.removeFromSuperViewOnHide = YES;\
hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];\
hud.mode = MBProgressHUDModeIndeterminate;
// 隐藏hud
#define APPHIDE_HUD [MBProgressHUD hideHUDForView:self.window.rootViewController.view animated:YES];

#define UserAgent @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_5 like Mac OS X) AppleWebKit/604.5.6 (KHTML, like Gecko) Mobile/15D60 JHCommunityClient/1.2.20160808 (iPhone; iOS 11.2; Scale/3.00) com.jhcms.ios.sq"

@interface AppDelegate ()<WXApiDelegate>{
     JHTabBarVC * rootVC;
}
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%@",NSHomeDirectory());
    [self handleUrl];
    [[NSUserDefaults standardUserDefaults]setObject:@(NO) forKey:@"jhcms_is_need_scurety"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"jhcms_nslog_info_yes"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //将icon的通知数量清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString * mp3FilePath = [NSTemporaryDirectory() stringByAppendingString:@"NewMp3.mp3"];//存储mp3文件的路径
    NSString * tmpFilePath = [NSTemporaryDirectory() stringByAppendingString:@"recoder.caf"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:mp3FilePath error:nil]&&[fileManager removeItemAtPath:tmpFilePath error:nil]) {
        NSLog(@"删除");
    }
    //
    [[UITabBar appearance] setTranslucent:NO];
    // 断网通知
    [self addReachability];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    _switchModel = [JHSwitchModel shareModel];
    [self setUserAgent];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

    //地图相关
    if ([GAODE_KEY length] > 0) {
        [XHMapKitManager shareManager].gaodeKey = GAODE_KEY;
        
    }else if ([GMS_MapKey length] > 0){
        [XHMapKitManager shareManager].gmsMapKey = GMS_MapKey;
        [XHMapKitManager shareManager].theme_color = THEME_COLOR_Alpha(1.0);
    }
    
    //判断是否过期
    NSInteger timeInterValue = [[[NSUserDefaults standardUserDefaults]objectForKey:@"advTime"] integerValue];
    NSInteger nowInterValue = [[NSDate date] timeIntervalSince1970];
    if (nowInterValue - timeInterValue > 3600*24*7) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"adv"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"advTime"];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self judgeFirst];

    // 创建极光推送
    [self createJPushWithOptions:launchOptions];
    // 修改导航栏字体及颜色
    [self setNavigationColorAndFont];

    //友盟统计
//    UMConfigInstance.appKey = @"5916de0b8f4a9d0b40001d4a";
//    UMConfigInstance.channelId = @"";
//    [MobClick startWithConfigure:UMConfigInstance];

    [Bugly startWithAppId:Bugly_Key];
    [UMConfigure initWithAppkey:UMCAnalytics_Key channel:@"App Store"];
    [self postAppInfo];
    
    //获取token
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    [JHShareModel shareModel].token = token;
    [NoticeCenter addObserver:self selector:@selector(postAppInfo) name:@"postAppInfo" object:nil];

    
    return YES;
}

#pragma mark - 修改url
-(void)handleUrl{
    [[NSUserDefaults standardUserDefaults]setObject:KReplace_Url forKey:@"KReplace_Url"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:IPADDRESS forKey:@"IPADDRESS"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark===判断是否是第一次进入程序并启动引导页=====
- (void)judgeFirst{
    NSString * key=(NSString *)kCFBundleVersionKey;
    NSString * version=[NSBundle mainBundle].infoDictionary[key];
    NSString * oldVersion=[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLanuch"];
    if([version isEqualToString:oldVersion]){
        NSArray *tempArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"adv"];
        if (tempArr.count > 0) {//有广告
            AnimationVC *vc = [[AnimationVC alloc]init];
            JHBaseNavVC *nav = [[JHBaseNavVC alloc]initWithRootViewController:vc];
            self.window.rootViewController = nav;
        }
        else{//没有广告
            self.window.rootViewController = nil;
            rootVC = [[JHTabBarVC alloc] init];
            self.window.rootViewController = rootVC;
        }
    }else{
        JHIntroPageVC *intro=[[JHIntroPageVC alloc]init];
        intro.bntBlock=^{
            JHTabBarVC *rootVC = [[JHTabBarVC alloc] init];
            self.window.rootViewController = rootVC;
            [[NSUserDefaults standardUserDefaults]setObject:version forKey:@"firstLanuch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        };
        self.window.rootViewController = intro;
    }
}

#pragma mark ====== 这是请求一些app的数据的方法 =======
-(void)postAppInfo{
    __weak typeof(self)weakself = self;
    [HttpTool postWithAPI:@"client/app/info" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            JHShareModel* model = [JHShareModel shareModel];
            model.serviseMobile = json[@"data"][@"phone"];
            model.add_function = json[@"data"][@"add_function"];
            model.payment = json[@"data"][@"payment"];
            NSDictionary *dic = json[@"data"][@"add_function"];
            model.have_staff = [dic[@"have_staff"] integerValue];
            model.have_weidian = [dic[@"have_weidian"] integerValue];
            //设置微信secret
            model.WXSecret = json[@"data"][@"app_appsecret"];
            //创建分享
            [weakself share];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self postAppInfo];
            });

        }
            
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self postAppInfo];
        });

    }];
}

#pragma mark========创建分享===========
- (void)share
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UMSocialManager defaultManager] setUmSocialAppkey:UM_KEY];
    });
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_KEY];
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAPPID appSecret:[JHShareModel shareModel].WXSecret redirectURL:@""];//http://com.ijh.waimai.ltd
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPID  appSecret:nil redirectURL:@""];
    
}

#pragma mark=====创建极光推送=============
- (void)createJPushWithOptions:(NSDictionary *)launchOptions
{
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKEY
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJPFNetworkDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRegistrationID) name:kJPFNetworkDidLoginNotification object:nil];
}

// 获取极光推送的registrationID
- (void)getRegistrationID
{
    NSString *registrationID = [JPUSHService registrationID];
    [self getOpenUDID];
    [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取极光推送所需要的openUDID
- (void)getOpenUDID
{
    NSString* openUDID = [OpenUDID value];
    [[NSUserDefaults standardUserDefaults] setObject:openUDID forKey:@"openUDID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 极光推送必要方法注册 DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateInactive) {
        if ([userInfo[@"type"] isEqualToString:@"hongbao"]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [JHTempRedBagView showRedGagViewWithUrl:userInfo[@"link_url"]];
            });
        }
    }
    else if(application.applicationState == UIApplicationStateActive){
        if ([userInfo[@"type"] isEqualToString:@"hongbao"]) {
            [JHTempRedBagView showRedGagViewWithUrl:userInfo[@"link_url"]];
        }
    }
}

// 注册远程推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"注册远程推送失败%@", error);
}


-(void)jumpWithUrl:(NSString *)url{
    JHBaseVC *vc = [JHTempJumpWithRouteModel jumpWithLink:url];
    UITabBarController *tab = (UITabBarController*)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)tab.viewControllers[tab.selectedIndex];
    [nav pushViewController:vc animated:YES];
}

#pragma mark======微信需要============
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
    
}
#pragma mark========支付宝,微信回调============
- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    BOOL result = [WXApi handleOpenURL:url delegate:self];
    if(result == FALSE)
    {
        if([url.host isEqualToString:@"safepay"])
        {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
    }
    return result;
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    BOOL result = [WXApi handleOpenURL:url delegate:self];
    if(result == FALSE)
    {
        if([url.host isEqualToString:@"safepay"])
        {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
    }
    return result;
}
#pragma mark=======微信支付结果响应============
- (void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if(aresp.errCode == 0)
        {
            NSString * code = aresp.code;
            [self getAccess_token:code];
        }
    }
    if([resp isKindOfClass:[PayResp class]])
    {
        if(resp.errCode == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WXSuccessPay_Notification object:nil];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WXFailPay_Notification object:nil];
        }
    }
}
#pragma mark==========获取微信access_token================
- (void)getAccess_token:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPID,[JHShareModel shareModel].WXSecret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self.access_token = [dic objectForKey:@"access_token"];
                self.openid = [dic objectForKey:@"openid"];
                [self getUserInfo];
            }
        });
    });
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //程序即将进入前台的一些操作
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"崩溃了");
}

#pragma mark ====== 微信登录事件 =======
- (void)handleWeiXinLogin{
    WXInfoModel *wxInfoModel = [WXInfoModel shareWXInfoModel];
    NSString *open_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"openUDID"];
    NSString *register_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
    NSDictionary * dictionary = @{@"wx_openid":wxInfoModel.wx_openid,@"wx_unionid":wxInfoModel.wx_unionid,@"open_id":(open_id ? open_id : @""),@"register_id":(register_id ? register_id : @"")};
    APPSHOW_HUD
    [HttpTool postWithAPI:NSLocalizedString(@"client/member/passport/wxlogin",nil) withParams:dictionary success:^(id json) {
        NSLog(@"这是用微信登录返回的数据%@",json);
        [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"nickname"] forKey:@"nickName"];
        if ([json[@"error"] isEqualToString:@"0"]) {
            wxInfoModel.wxtype = json[@"data"][@"wxtype"];
            if([json[@"data"][@"wxtype"] isEqualToString:@"wxlogin"]){
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
                [JHShareModel shareModel].token = json[@"data"][@"token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [JHShareModel shareModel].phone = json[@"data"][@"mobile"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"微信登录", nil) object:nil];
            }else{
                UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示",nil) message:NSLocalizedString(@"不绑定微信将无法完成微信登录",nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *bindAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"绑定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"微信登录", nil) object:nil];
                }];
                [alertViewController addAction:cancelAction];
                [alertViewController addAction:bindAction];
                [self.window.rootViewController presentViewController:alertViewController animated:YES completion:nil];
            }
        }else{
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"微信登录失败,原因:%@",nil),json[@"message"]]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        }
        APPHIDE_HUD
    } failure:^(NSError *error) {
        APPHIDE_HUD
        NSLog(@"%@",error.localizedDescription);
        [self showAlertView:NSLocalizedString(@"取消微信登录",nil)];
    }];
}

#pragma mark ====== 在个人中心绑定微信 =======
- (void)bandDingWeiXin{
    APPSHOW_HUD
    WXInfoModel *wxInfoModel = [WXInfoModel shareWXInfoModel];
    NSDictionary * dicc = @{@"wx_openid":wxInfoModel.wx_openid,@"wx_nickname":wxInfoModel.wx_nickname,@"wx_face":wxInfoModel.wx_headimgurl,
                            @"wx_unionid":wxInfoModel.wx_unionid};
    [HttpTool postWithAPI:@"client/member/bindweixin" withParams:dicc success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"]isEqualToString:@"0"]) {
            [self showAlertView:NSLocalizedString(@"微信绑定成功",nil)];
            wxInfoModel.wxtype = @"wxlogin";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wxbindsuccess" object:nil];
        }else{
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"微信绑定失败,原因:%@",nil),json[@"message"]]];
        }
        APPHIDE_HUD
    } failure:^(NSError *error) {
        APPHIDE_HUD
        NSLog(@"%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
    
}

#pragma mark=======微信绑定用户信息===========
- (void)getUserInfo
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token,self.openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if([@([dic[@"errcode"] integerValue]).stringValue isEqualToString:@"40001"]){
                    //微信出错
                    return ;
                }
                WXInfoModel *wxInfoModel = [WXInfoModel shareWXInfoModel];
                wxInfoModel.wx_headimgurl = [dic objectForKey:@"headimgurl"];
                wxInfoModel.wx_openid = self.openid;
                wxInfoModel.wx_unionid = [dic objectForKey:@"unionid"];
                wxInfoModel.wx_nickname = [dic objectForKey:@"nickname"];
                //在个人中心中
                if([UserDefaults  boolForKey:@"wxBangDing"]){
                    [UserDefaults setBool:NO forKey:@"wxBangDing"];
                    [self bandDingWeiXin];
                    return;
                }
                //从点击微信按钮登录开始
                [self handleWeiXinLogin];
            }
        });
        
    });
}

#pragma mark===========网络监听=================
- (void)addReachability
{
    _hostReach = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [_hostReach startNotifier];
}
// 网络监听响应方法
- (void)reachabilityChanged:(NSNotification *)noti
{
    Reachability *curReach = [noti object];
    [self getNetStatusWithReachability:curReach];
}
// 获取当前网络的相关状态
- (void)getNetStatusWithReachability:(Reachability *)reachability
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        //        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NetWorkStatus"];
        //        UIAlertController * controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示") message:NSLocalizedString(@"网络连接失败,请重新链接") preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *canaelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了") style:UIAlertActionStyleCancel handler:nil];
        //        [controller addAction:canaelAction];
        //        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }else if(status ==  ReachableViaWWAN){
        //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NetWorkStatus"];
        //        UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示") message:NSLocalizedString(@"正在使用蜂窝网络") preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *canaelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了") style:UIAlertActionStyleCancel handler:nil];
        //        [controller addAction:canaelAction];
        //        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }else if(status == ReachableViaWiFi){
        //        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NetWorkStatus"];
        //        UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示") message:NSLocalizedString(@"wifi已连接") preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *canaelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了") style:UIAlertActionStyleCancel handler:nil];
        //        [controller addAction:canaelAction];
        //        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }
    //    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark ====== 设置webView加载时的user_aget =======
-(void)setUserAgent{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : UserAgent, @"User-Agent" : UserAgent}];
}

#pragma mark ====== 修改导航栏字体及主题色 =======
- (void)setNavigationColorAndFont
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:HEX(@"333333", 1)}];
    //将状态栏字体该为白色
    [[UIApplication sharedApplication] setStatusBarStyle:0];
}

#pragma mark ====== SomeFunction =======
// 提示框
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示",nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}



// paypal支付
- (void)setPaypalClientID:(NSString *)clientID model:(NSString *)model{
    if ([model isEqualToString:@"sandbox"]) {
        //启用paypal支付
        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:@"",
                                                               PayPalEnvironmentSandbox:clientID}];
        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    }else{
        //启用paypal支付
        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:clientID,
                                                               PayPalEnvironmentSandbox:@""}];
        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
        
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}
@end

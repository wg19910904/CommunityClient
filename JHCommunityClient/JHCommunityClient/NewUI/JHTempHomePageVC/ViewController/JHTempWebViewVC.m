//
//  JHTempWebViewVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/7.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTempWebViewVC.h"
#import "JHTempJumpWithRouteModel.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "ZQShareView.h"
#import "JHShareModel.h"
#import "HZQJavaScriptObj.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JHTabBarVC.h"
#import "JHWMPayOrderVC.h"

@interface JHTempWebViewVC ()<UIWebViewDelegate,NJKWebViewProgressDelegate,ZQJavaScriptObjDelegate>
@property(nonatomic,strong)UIWebView *webV;
@property(nonatomic,strong)UIBarButtonItem *rightItem;//右边的按钮
@property(nonatomic,strong)NJKWebViewProgress *progressProxy;
@property(nonatomic,strong)NJKWebViewProgressView *progressView;//进度条
@property(nonatomic,strong)UIButton *pushToFirstBtn;//点击返回到原生界面的
@property (nonatomic,copy)NSURLRequest *request;
@property(nonatomic,copy)NSString *backUrl;
@property(nonatomic,strong)NSMutableArray *historyArr;
@property(nonatomic,assign) BOOL didStart;
@property(nonatomic,strong)ZQShareView *shareView;
@end

@implementation JHTempWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCookie];
    _webV = [[UIWebView alloc]init];
    if ([self.url isEqualToString:SHANGQUAN_LINK]) {
        //        self.navigationItem.rightBarButtonItem
        _webV.frame = FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT-TABBAR_HEIGHT);
    }else{
        _webV.frame = FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT);
    }
    
    self.historyArr = @[self.url].mutableCopy;
    NSString *url = [self.historyArr lastObject];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webV loadRequest:request];
    
    [self progressProxy];
    [self progressView];
    [self.view addSubview:_webV];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:KLogin_success
                                               object:nil];;
    [self pushToFirstBtn];
    if (self.isShangQuan) {
        self.backBtn.hidden = YES;
        self.pushToFirstBtn.hidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *url = [self.historyArr lastObject];
    if ([url isEqualToString:self.url]) return;//供求发布选择照片时不能重新加载
//    [self setCookie];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [_webV loadRequest:request];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webV stopLoading];
    [_progressView removeFromSuperview];
    _progressView = nil;
//    if (self.isMall == NO) {
//        [_pushToFirstBtn removeFromSuperview];
//    }
//    _pushToFirstBtn = nil;
}

-(UIButton *)pushToFirstBtn{
    if (!_pushToFirstBtn) {
        _pushToFirstBtn = [[UIButton alloc]init];
        [_pushToFirstBtn setImage:IMAGE(@"closeNew") forState:UIControlStateNormal];
        _pushToFirstBtn.frame = FRAME(0, 0, 44, 44);
//        _pushToFirstBtn.hidden = YES;
        _pushToFirstBtn.imageEdgeInsets = UIEdgeInsetsMake(13,0,13, 28);
        self.backBtn.frame = FRAME(0, 0, 44, 44);
        self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 0, 13, 28);
        
        [_pushToFirstBtn addTarget:self action:@selector(clickPushBtn) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item2 = [[UIBarButtonItem  alloc] initWithCustomView:_pushToFirstBtn];
        self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItem,item2];
    }
    return  _pushToFirstBtn;
}
-(void)clickPushBtn{
    if (self.isAdv) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        JHTabBarVC *tab = [[JHTabBarVC alloc]init];
        window.rootViewController = tab;
        return;
    }else if (self.isShangQuan && self.isMall_order == NO){
        self.tabBarController.selectedIndex = 0;
    }else if (self.isShangQuan && self.isMall_order == YES){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//添加右边的按钮
-(UIBarButtonItem *)rightItem{
    if (self.isAdv) {
        return nil;
    }
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
        self.navigationItem.rightBarButtonItem = _rightItem;
        [self.navigationController.navigationBar setTintColor:HEX(@"999999", 1)];
    }
    [self showRightBtn];
    return _rightItem;
}
- (void)showRightBtn{
    if ([self.url isEqualToString:SHANGQUAN_LINK]) {
        return;
    }
    _rightItem.title = @"";
    _rightItem.image = IMAGE(@"");
    if ([self.request.URL.absoluteString containsString:@"/ucenter/qiandao/index"]) {
        _rightItem.title = NSLocalizedString(@"签到说明", nil);
        _rightItem.tag = 1;
    }else{
        _rightItem.image = IMAGE(@"share");
        _rightItem.tag = 2;
    }
}
-(NJKWebViewProgress *)progressProxy{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc]init];
        _webV.delegate = _progressProxy;
        _progressProxy.progressDelegate = self;
        _progressProxy.webViewProxyDelegate = self;
    }
    return _progressProxy;
}
-(NJKWebViewProgressView *)progressView{
    if (!_progressView) {
        CGFloat progressBarHeight = 3.0f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.navigationController.navigationBar addSubview:_progressView];
        [_progressView setProgress:0 animated:YES];
    }
    return _progressView;
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
}

-(void)clickRightItem{
    if (_rightItem.tag == 1) {
        [_webV stringByEvaluatingJavaScriptFromString:@"get_rules()"];
    }else if(_rightItem.tag == 2){
        [self share];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        HIDE_HUD
    });
    [_progressView setProgress:1 animated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    _didStart == NO ? ({SHOW_HUD}): ({
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _didStart = YES;
        });
    });
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
        HIDE_HUD
    });
    
    [self rightItem];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
    self.shareView.shareStr = title;
    self.shareView.shareTitle = title;
    //叉号始终显示
    if (self.webV.canGoBack &&
        [self.request.URL.absoluteString isEqualToString:self.url] == NO) {
//        self.pushToFirstBtn.hidden = NO;
    }else{
//        self.pushToFirstBtn.hidden = YES;
    }
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    HZQJavaScriptObj *obj = [[HZQJavaScriptObj alloc]init];
    context[@"jsObj"] = obj;
    [obj setMyBlock:^(NSString *link,NSString *title, NSString *content,NSString *img,NSString *hiden){
        if (img.length > 0) {
            self.shareView.shareImgName = img;
            
        }
        self.shareView.isUrlImg = img.length > 0;
        self.shareView.shareStr = content;
        self.shareView.shareUrl = link;
        self.shareView.shareTitle = title;
        self.shareView.hiden_QQ = hiden;
    }];
    //app_to_share
    __weak typeof(self) weakself = self;
    [obj setMyBlock2:^(NSString *link,NSString *title, NSString *content,NSString *img,NSString *hiden){
        if (img.length > 0) {
            self.shareView.shareImgName = img;
        }
        self.shareView.isUrlImg = img.length > 0;
        self.shareView.shareStr = content;
        self.shareView.shareUrl = link;
        self.shareView.shareTitle = title;
        self.shareView.hiden_QQ = hiden;
        [weakself share];
    }];
    obj.delegate = self;
    
    [self showRightBtn];
    
    if ([self.historyArr containsObject:self.request.URL.absoluteString] == NO) {
        [self.historyArr addObject:self.request.URL.absoluteString];
    }else{
        NSInteger index = [self.historyArr indexOfObject:self.request.URL.absoluteString];
        self.historyArr = [[self.historyArr subarrayWithRange:NSMakeRange(0, index+1)] mutableCopy];
    }
    if (_isShangQuan) {
        //是否展示返回按钮
        self.backBtn.hidden = self.historyArr.count == 1 ;
        self.pushToFirstBtn.hidden = self.backBtn.hidden;
    }
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    HIDE_HUD
    if (webView.isLoading) {
        [webView stopLoading];
    }
    //
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    HZQJavaScriptObj *obj = [[HZQJavaScriptObj alloc]init];
    context[@"jsObj"] = obj;
    [obj setMyBlock:^(NSString *link,NSString *title, NSString *content,NSString *img,NSString *hiden){
        if (img.length > 0) {
            self.shareView.shareImgName = img;
            
        }
        self.shareView.isUrlImg = img.length > 0;
        self.shareView.shareStr = content;
        self.shareView.shareUrl = link;
        self.shareView.shareTitle = title;
        self.shareView.hiden_QQ = hiden;
    }];
    obj.delegate = self;
    
    self.shareView.shareUrl = request.URL.absoluteString;
    
    NSString *str = [[self.url componentsSeparatedByString:@"http://"]lastObject];
    self.request = request;
    //当是微店时,不进行路径判断
    if (self.isWeidian) return YES;
    if ([request.URL.absoluteString containsString:@"tel:"]) {
        return YES;
    }
    if ([_url containsString:@"ucenter/collect/items"] && ![request.URL.absoluteString containsString:@"shop/detail"] ) {
        return YES;
    }
    if (![request.URL.absoluteString containsString:str]) {
        UIViewController *vc = [JHTempJumpWithRouteModel jumpWithLink:request.URL.absoluteString];
        if ([vc isKindOfClass:[JHTempWebViewVC class]]) {
            return YES;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:vc animated:YES];
            });
            return NO;
        }
    }else{
        
        
    }
    [self showRightBtn];
    
    return YES;
}

//根据状态返回
-(void)clickBackBtn{
    //针对积分商城特殊处理
    if ([self.request.URL.absoluteString containsString:@"life"] ||[self.request.URL.absoluteString containsString:@"house"]||[self.request.URL.absoluteString containsString:@"gongqiu"] || [self.request.URL.absoluteString containsString:@"topline"]) {
        if (self.webV.canGoBack) {
            [self.webV goBack];
            return;
        }
    }
    
    if ([self.url containsString:@"/jifen/"]) {
        if (self.historyArr.count == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if(self.historyArr.count > 1){
            if ([self.request.URL.absoluteString containsString:@"/jifen/order/detail-"]) {
                //如果当前页面是订单详情页面,并且第一个页面不是订单列表页面,则加个订单列表的中转链接
                NSString *orderList = [NSString stringWithFormat:@"http://%@/jifen/order/index.html",KReplace_Url];
                NSString *orderList2 = [NSString stringWithFormat:@"http://%@/jifen/order/index.htm",KReplace_Url];
                if ([self.historyArr.firstObject isEqualToString:orderList] == NO &&
                    [self.historyArr.firstObject isEqualToString:orderList2] == NO) {
                    self.historyArr = @[self.historyArr.firstObject,
                                        [NSString stringWithFormat:@"http://%@/jifen/order/index.html",KReplace_Url],
                                        self.historyArr.lastObject].mutableCopy;
                }
                
            }
            NSURL *lastUrl = [NSURL URLWithString:[self.historyArr objectAtIndex:self.historyArr.count-2]];
            [self.webV loadRequest:[NSURLRequest requestWithURL:lastUrl]];
        }
        return;
    }
    //如果当前界面为积分商城订单详情界面
    if ([self.request.URL.absoluteString containsString:@"/jifen/order/detail-"] ||
        [self.request.URL.absoluteString containsString:@"/ucenter/order/detail-"] ||
        [self.request.URL.absoluteString containsString:@"/ucenter/gold/recharge/"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [_webV loadRequest:request];
        return;
    }else if ([self.request.URL.absoluteString isEqualToString:self.url] &&
              [self.request.URL.absoluteString containsString:@"/gongqiu/index"] == NO) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.webV.canGoBack) {
        [self.webV goBack];
    }else{
        if (self.isAdv) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            JHTabBarVC *tab = [[JHTabBarVC alloc]init];
            window.rootViewController = tab;
            return;
        }else if(self.isMall_order){
            
            if ([self.webV canGoBack]) {
                [self.webV goBack];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else if (self.isShangQuan && self.isMall_order == NO){
            
            self.tabBarController.selectedIndex = 0;
            
        }else [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)loginSuccess{
    NSString *url = [self.historyArr lastObject];
    [self setCookie];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webV loadRequest:request];
}

#pragma mark ====== 设置cookie---cityCode =======
-(void)setCookie{
    if (![self.url hasPrefix:@"http"] || self.url.length == 0) {
        return;
    }
    NSURL *linkUrl = [NSURL URLWithString:self.url];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *deleteArr = @[].mutableCopy;
    [arr addObjectsFromArray:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies];
    for (int i = 0 ; i<arr.count; i++) {
        NSHTTPCookie *cookie_temp = arr[i];
        if ([cookie_temp.name isEqualToString:@"KT-TOKEN"]) {
            [deleteArr addObject:cookie_temp];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie_temp];
        }
        if ([cookie_temp.name isEqualToString:@"KT-UxCityCode"]) {
            [deleteArr addObject:cookie_temp];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie_temp];
        }
        if ([cookie_temp.name isEqualToString:@"LAT"]) {
            [deleteArr addObject:cookie_temp];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie_temp];
        }
        if ([cookie_temp.name isEqualToString:@"LNG"]) {
            [deleteArr addObject:cookie_temp];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie_temp];
        }
    }
    for (NSHTTPCookie *cookie_temp in deleteArr) {
        [arr removeObject:cookie_temp];
    }
    
    //设置cityCode
    NSMutableDictionary *cityCodeDic = @{}.mutableCopy;
    [cityCodeDic setObject:linkUrl.host forKey:NSHTTPCookieDomain];
    [cityCodeDic setObject:@"KT-UxCityId" forKey:NSHTTPCookieName];
    NSString *cityCode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"]];
    [cityCodeDic setObject:cityCode forKey:NSHTTPCookieValue];
    [cityCodeDic setObject:@"/" forKey:NSHTTPCookiePath];
    [cityCodeDic setObject:@"0" forKey:NSHTTPCookieVersion];
    [cityCodeDic setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cityCodeCookie = [NSHTTPCookie cookieWithProperties:cityCodeDic];
    [arr addObject:cityCodeCookie];
    
    //设置token
    if ([[JHShareModel shareModel].token length] > 0 && [self.url hasPrefix:@"http"]) {
        
        NSMutableDictionary *tokenDic = @{}.mutableCopy;
        [tokenDic setObject:@"KT-TOKEN" forKey:NSHTTPCookieName];
        [tokenDic setObject:linkUrl.host forKey:NSHTTPCookieDomain];
        [tokenDic setObject:@"/" forKey:NSHTTPCookiePath];
        NSString *token = [NSString stringWithFormat:@"%@",[JHShareModel shareModel].token];
        [tokenDic setObject:token forKey:NSHTTPCookieValue];
        [tokenDic setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        NSHTTPCookie *tokenCookie = [NSHTTPCookie cookieWithProperties:tokenDic];
        [arr addObject:tokenCookie];
    }
    //设置lat
    NSMutableDictionary *latDic = @{}.mutableCopy;
    [latDic setObject:linkUrl.host forKey:NSHTTPCookieDomain];
    [latDic setObject:@"LAT" forKey:NSHTTPCookieName];
    NSString *latStr = [NSString stringWithFormat:@"%f",[JHShareModel shareModel].lat];
    [latDic setObject:latStr forKey:NSHTTPCookieValue];
    [latDic setObject:@"/" forKey:NSHTTPCookiePath];
    [latDic setObject:@"0" forKey:NSHTTPCookieVersion];
    [latDic setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *latCookie = [NSHTTPCookie cookieWithProperties:latDic];
    [arr addObject:latCookie];
    
    //设置lng
    NSMutableDictionary *lngDic = @{}.mutableCopy;
    [lngDic setObject:linkUrl.host forKey:NSHTTPCookieDomain];
    [lngDic setObject:@"LNG" forKey:NSHTTPCookieName];
    NSString *lngStr = [NSString stringWithFormat:@"%f",[JHShareModel shareModel].lng];
    [lngDic setObject:lngStr forKey:NSHTTPCookieValue];
    [lngDic setObject:@"/" forKey:NSHTTPCookiePath];
    [lngDic setObject:@"0" forKey:NSHTTPCookieVersion];
    [lngDic setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *lngCookie = [NSHTTPCookie cookieWithProperties:lngDic];
    [arr addObject:lngCookie];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:arr forURL:[NSURL URLWithString:self.url] mainDocumentURL:nil];
}


- (void)payorder_amount:(NSString *)amount order:(NSString *)order_id{
    JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
    vc.order_id = order_id;
    vc.amount = amount;
    vc.isOrder = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)app_go_pay:(NSString *)dataStr{
    __weak typeof(self)wealself = self;
    NSData *data = [dataStr dataUsingEncoding:(NSUTF8StringEncoding)];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers error:&error];
    NSString *order_id = [dic valueForKey:@"order_id"];
    NSString *amount = [dic valueForKey:@"need_pay"];
    JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
    vc.order_id = order_id;
    vc.amount = amount;
    vc.isOrder = YES;
    self.backUrl = [dic valueForKey:@"back_url"];
    [self.historyArr addObject:_backUrl];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)backToHomepage{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}

// 返回前一个界面
-(void)backToOrderDetail{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark ====== Functions =======
// 分享
-(void)share{
    //    JHShareAndCollectionModel *model = [JHShareAndCollectionModel shareModel];
    //    [model createTempShareView];
    
    //    self.shareView.shareStr = self.model.share_info[@"desc"];
    //    self.shareView.shareUrl = self.model.share_info[@"link"];
    //    self.shareView.shareTitle = self.model.share_info[@"title"];
    //    self.shareView.shareImgName = self.model.share_info[@"imgUrl"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.shareView showAnimation];
    });
}

#pragma mark ====== Lazy Load =======
-(ZQShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ZQShareView alloc]init];
        _shareView.superVC = self;
    }
    return _shareView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


//
//  XHWebViewViewController.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/10/19.
//  Copyright © 2018 JiangHu. All rights reserved.
//

#import "XHWebViewViewController.h"
#import <WebKit/WebKit.h>
//
#import "JHShareModel.h"

#define XHWebView_isIPhoneX ([UIScreen mainScreen].bounds.size.width>= 375.0f && [UIScreen mainScreen].bounds.size.height >= 812.0f)
#define XHWebView_Height (isIPhoneX ? ([UIScreen mainScreen].bounds.size.height -13 ) :[UIScreen mainScreen].bounds.size.height)
#define XHWebView_Width [UIScreen mainScreen].bounds.size.width
static NSString * const XHWebView_JSObject = @"JHAPP";

@interface XHWebViewViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)WKWebView *webview;
@property (nonatomic,strong)UIProgressView *progressView;
@property (nonatomic,strong)NSDictionary *extraCookieDict;
@end

@implementation XHWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCloseBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webview];
    [self.webview addSubview:self.progressView];
}
//add back button
- (void)addBackBtn{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [self.backBtn addTarget:self action:@selector(clickBackBtn)
           forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 0,13, 28);
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView: self.backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}
// add close btn
- (void)addCloseBtn{
    self.closeBtn = [[UIButton alloc]init];
    [self.closeBtn setImage:IMAGE(@"closeNew") forState:UIControlStateNormal];
    self.closeBtn.frame = CGRectMake(0, 0, 44, 44);
    self.closeBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 0, 13, 28);
    [self.closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem  alloc] initWithCustomView:self.closeBtn];
    self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItem,item2];
}

#pragma mark - click back btn
- (void)clickBackBtn{
    if (_webview.canGoBack) {
        [_webview goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - click close btn
- (void)clickCloseBtn{
    
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(webView == _webview) {
        
    }
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    if (webView == _webview) {
        //清除cookie
//        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true)[0];
//        NSString *cookiesFolderPath = [NSString stringWithFormat:@"%@/Cookies",libraryPath];
//        [NSFileManager.defaultManager removeItemAtPath:cookiesFolderPath error:nil];

        NSString *cookie = [self getExtraCookie];
        NSString *jsString = [NSString stringWithFormat:@"function setCookie(e,o){document.cookie=e+\"=\"+escape(o)+\";path=/;domain=.%@\"}for(var cookieTem= \"%@\",cookieArr=cookieTem.split(\";\"),i=0;i<cookieArr.length;i++){var temArr=cookieArr[i].split(\"=\");setCookie(temArr[0],temArr[1])}",KReplace_Url,cookie];
        [_webview evaluateJavaScript:jsString
                   completionHandler:^(id _Nullable response, NSError * _Nullable error) {


                   }];
    }
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(webView == _webview) {
        
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == _webview) {
        
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == _webview) {
        
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"requset---%@",navigationAction.request);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    //读取wkwebview中的cookie 方法1
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"wkwebview中的cookie:%@", cookie);
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}


#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - 交互方法回调
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:XHWebView_JSObject]) {
        NSLog(@"%@", message.body);
    }
}

#pragma mark - Estimated Progress KVO (WKWebView)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object && [object isEqual:self.webview] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:newprogress];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                weakSelf.progressView.alpha = 0.0;
            });
        } else {
            self.progressView.alpha = 1.0;
        }
    } else if ([object isEqual:self.webview] && [keyPath isEqualToString:@"title"]) {// 标题
        NSString *title = (NSString *)[change objectForKey:NSKeyValueChangeNewKey];
        self.navigationItem.title = title;
    } else {// 其他
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//
- (WKWebView *)webview{
    if (_webview == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        //添加交互
        [configuration.userContentController addScriptMessageHandler:self name:XHWebView_JSObject];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0,
                                                               XHWebView_isIPhoneX ? 88 : 64,
                                                               XHWebView_Width,
                                                               XHWebView_Height)
                                      configuration:configuration];
        _webview.opaque = NO;
        _webview.backgroundColor = [UIColor clearColor];
        //
        [_webview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_webview setNavigationDelegate:self];
        [_webview setUIDelegate:self];

        [_webview setMultipleTouchEnabled:YES];
        [_webview setAutoresizesSubviews:YES];
        [_webview.scrollView setAlwaysBounceVertical:YES];;
        _webview.scrollView.bounces = NO;
        _webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        // KVO，监听webView属性值得变化(estimatedProgress,title为特定的key)
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        
        //
        if (self.url.length > 0) {
            NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
            //第一次请求时 设置cookie
            [self addCookieToRequest:requset];
            [_webview loadRequest:requset];
        }
    }
    return _webview;
}
- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, XHWebView_Width,2)];
        _progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
        _progressView.progressTintColor = [UIColor colorWithRed:250/255.0 green:103/255.0 blue:32/255.0 alpha:1.0];
        // 设置初始的进度一开始设置10%的默认值
        [_progressView setProgress:0.1 animated:YES];
    }
    return _progressView;
}
#pragma mark - 交互事件


#pragma mark - cookie相关
- (void)addCookieToRequest:(NSMutableURLRequest *)requset{
    NSMutableString *cookieValue = [self getExtraCookie];
    [requset addValue:cookieValue forHTTPHeaderField:@"Cookie"];
}
//添加自己额外的cookie
- (NSMutableString *)getExtraCookie{
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    //
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    //添加额外的cookie
    for (NSString *key in self.extraCookieDict.allKeys) {
        [cookieDic setObject:self.extraCookieDict[key] forKey:key];
    }
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    return cookieValue;
}

- (NSDictionary *)extraCookieDict{
    return @{@"KT-TOKEN":[JHShareModel shareModel].token,
             @"LAT":@([JHShareModel shareModel].lat).stringValue,
             @"LNG":@([JHShareModel shareModel].lng).stringValue,
             @"KT-UxCityCode":[JHShareModel shareModel].cityCode};
}

@end

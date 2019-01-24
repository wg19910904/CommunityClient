//
//  HZQJavaScriptObj.m
//  ChengDengBeiWang
//
//  Created by ijianghu on 16/12/17.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "HZQJavaScriptObj.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>
@protocol PersonJSExport <JSExport>

//用宏转换下,使得可以接受多参数；
JSExportAs(AppToShare, - (void)share:(NSString *)link title:(NSString *)title content:(NSString *)content img:(NSString *)img hidenQQ:(NSString *)hiden);
JSExportAs(app_to_share,- (void)share2:(NSString *)link title:(NSString *)title content:(NSString *)content img:(NSString *)img hidenQQ:(NSString *)hiden);
JSExportAs(payorder,- (void)payorder_amount:(NSString *)amount order:(NSString *)order_id);
- (void)app_login;
- (void)backToHomepage;
- (void)app_go_pay:(NSString *)json;
-(void)backToOrderDetail;
@end
@interface HZQJavaScriptObj() <PersonJSExport>
@end
@implementation HZQJavaScriptObj

- (void)share:(NSString *)link title:(NSString *)title content:(NSString *)content img:(NSString *)img hidenQQ:(NSString *)hiden{
    if (self.myBlock) {
        self.myBlock(link,title,content,img,hiden);
    }
}

- (void)share2:(NSString *)link title:(NSString *)title content:(NSString *)content img:(NSString *)img hidenQQ:(NSString *)hiden{
    if (self.myBlock2) {
        self.myBlock2(link,title,content,img,hiden);
    }
}
//登录
- (void)app_login {
    if (self.delegate && [self.delegate respondsToSelector:@selector(app_login)]) {
        [self.delegate app_login];
    }
}

//支付
- (void)payorder_amount:(NSString *)amount order:(NSString *)order_id{
    if (self.delegate && [self.delegate respondsToSelector:@selector(payorder_amount:order:)]) {
        [self.delegate payorder_amount:amount order:(NSString *)order_id];
    }
}
//商城首页 点击左侧home按钮  跳转到app首页
- (void)backToHomepage{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backToHomepage)]) {
        [self.delegate backToHomepage];
    }
}

-(void)backToOrderDetail{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backToOrderDetail)]) {
        [self.delegate backToOrderDetail];
    }
}

- (void)app_go_pay:(NSString *)datadic{
    if (self.delegate && [self.delegate respondsToSelector:@selector(app_go_pay:)]) {
        [self.delegate app_go_pay:datadic];
    }
}
@end

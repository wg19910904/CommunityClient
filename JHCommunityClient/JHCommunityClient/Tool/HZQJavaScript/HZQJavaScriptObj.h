//
//  HZQJavaScriptObj.h
//  ChengDengBeiWang
//
//  Created by ijianghu on 16/12/17.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ZQJavaScriptObjDelegate<NSObject>
@optional
- (void)payorder_amount:(NSString *)amount order:(NSString *)order_id;
- (void)app_login;
- (void)backToHomepage;
- (void)app_go_pay:(NSString *)datadic;
-(void)backToOrderDetail;
@end

@interface HZQJavaScriptObj : NSObject

@property(nonatomic,copy)void(^myBlock)(NSString *link,NSString *title, NSString *content,NSString *img ,NSString *hiden);
@property(nonatomic,copy)void(^myBlock2)(NSString *link,NSString *title, NSString *content,NSString *img,NSString *hiden);
@property(nonatomic,weak)id<ZQJavaScriptObjDelegate>delegate;
@end

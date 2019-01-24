//
//  SecurityCode.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecurityCode : UIControl<UITextFieldDelegate>
@property(nonatomic,copy)void(^block)(NSString * result,NSString * code);//请求网络图片验证
//展示本地图片验证
-(void)showSecurityViewWithBlock:(void(^)(NSString * result,NSString * code))myBlock;
-(void)refesh:(UIImage *)image;
@end

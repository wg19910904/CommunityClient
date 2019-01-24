//
//  WXInfoModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXInfoModel : NSObject
@property (nonatomic,copy)NSString *wx_openid;
@property (nonatomic,copy)NSString *wx_nickname;
@property (nonatomic,copy)NSString *wx_unionid;
@property (nonatomic,copy)NSString *wx_headimgurl;
@property (nonatomic,copy)NSString *wxtype;
+ (WXInfoModel *)shareWXInfoModel;
@end

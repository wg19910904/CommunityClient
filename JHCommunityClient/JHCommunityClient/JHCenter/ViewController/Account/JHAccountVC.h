//
//  AccountVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHAccountVC : JHBaseVC
@property (nonatomic,copy)NSString *access_token;
@property (nonatomic,copy)NSString *openid;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *unionid;
@end

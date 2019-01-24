//
//  JHTempWebViewVC.h
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/7.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHTempWebViewVC : JHBaseVC
@property(nonatomic,copy)NSString *url;//需要传入的url
@property(nonatomic,assign)BOOL isWeidian;//是否是微店
@property(nonatomic,assign)BOOL isAdv;//是否是从启动广告跳转过来
@property(nonatomic,assign)BOOL isShangQuan;
@property(nonatomic,assign)BOOL isMall_order;
@end

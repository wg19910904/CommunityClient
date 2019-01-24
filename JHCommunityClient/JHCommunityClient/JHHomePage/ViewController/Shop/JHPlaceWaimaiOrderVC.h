//
//  JHPlaceWaimaiOrderVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/4/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHPlaceWaimaiOrderVC : JHBaseVC
@property(nonatomic,copy)NSString *shop_id;
//上个界面总价格
@property(nonatomic,assign)CGFloat amount;
//是否是再来一单
@property(nonatomic,assign)BOOL isFromAgain;
@end

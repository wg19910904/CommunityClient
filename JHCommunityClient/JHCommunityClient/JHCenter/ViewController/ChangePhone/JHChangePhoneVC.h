//
//  ChangePhoneVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHChangePhoneVC : JHBaseVC
@property (nonatomic,copy)NSString *phone;
@property(nonatomic,copy)void(^(myBlock))(NSString * mobile);
@end

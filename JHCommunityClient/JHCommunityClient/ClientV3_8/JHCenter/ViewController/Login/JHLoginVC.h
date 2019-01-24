//
//  LoginVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/25.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHLoginVC : JHBaseVC
@property (nonatomic,copy)void(^loginSuccessBlock)();
@property (nonatomic,assign)BOOL fromYunBuy;
@property(nonatomic,assign)BOOL fromFindCode;
@end

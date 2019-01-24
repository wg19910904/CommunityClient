//
//  JudgeToken.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHBaseVC.h"
@interface JudgeToken : NSObject

@property (nonatomic,strong)JHBaseVC *viewContoller;
+ (void)judgeTokenWithVC:(JHBaseVC *)vc withBlock:(void(^)())tokenBlock;
@end

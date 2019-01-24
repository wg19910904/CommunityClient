//
//  JHIntroPageVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^BtnBlock)(void);
@interface JHIntroPageVC : JHBaseVC
@property (nonatomic,copy)BtnBlock bntBlock;
@end

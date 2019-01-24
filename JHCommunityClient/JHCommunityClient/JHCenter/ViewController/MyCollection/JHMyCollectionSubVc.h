//
//  JHMyCollectionSubVc.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
#import "MyCollectionPersonModel.h"
#import "MyCollectionShopModel.h"
@interface JHMyCollectionSubVc : JHBaseVC
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)void  (^myBlock1)(MyCollectionShopModel *model);
@property (nonatomic,copy)void  (^myBlock2)(MyCollectionPersonModel *model);
@end

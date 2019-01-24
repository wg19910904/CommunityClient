//
//  JHShopMainVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHSupermarketMainVC : JHBaseVC
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *restStatus;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

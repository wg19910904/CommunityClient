//
//  JHIntegrationGoodDetailVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
#import "JHIntegrationGoodDetailModel.h"
@interface JHIntegrationGoodDetailVC : JHBaseVC
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,strong)JHIntegrationGoodDetailModel *detailModel;
@end

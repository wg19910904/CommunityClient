//
//  HouseKeepingModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintainHomeCateModel : NSObject
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *info;
@property (nonatomic,copy)NSString *orderby;
@property (nonatomic,copy)NSString *orders;
@property (nonatomic,copy)NSString *parent_id;
@property (nonatomic,copy)NSString *photo;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,strong)NSArray *products;
@property (nonatomic,copy)NSString *start;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,strong)NSMutableArray *productArray;

@end

//
//  WaiMaiICateModel.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/5.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaiMaiCateModel : NSObject
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *parent_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,strong)NSArray *childrens;

@end

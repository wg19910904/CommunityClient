//
//  JHTempHomeModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTempClientNewsModel : NSObject
@property(nonatomic,assign)NSInteger status;//0:只有文字,1:只有1张图片,2:多张图片和文字
@property(nonatomic,strong)NSArray *article_id;
@property(nonatomic,copy)NSString *dateline;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,strong)NSArray *thumb;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *views;
@property(nonatomic,copy)NSString *linkurl;
@end

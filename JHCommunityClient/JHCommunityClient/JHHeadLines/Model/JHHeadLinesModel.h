//
//  JHHeadLinesModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JHHeadLinesModel : NSObject
@property (nonatomic,copy) NSString* content_id;//文章内容ID
@property (nonatomic,copy) NSString *article_id;//文章ID
@property(nonatomic,copy)NSString *content;//文章内容
@property(nonatomic,copy)NSString *clientip;//客户ID
@property(nonatomic,copy)NSString *city_id;//城市ID
@property(nonatomic,copy)NSString *type;//small：小图； big：大图； more：多图
@property(nonatomic,copy)NSString *cat_id;//分类ID
@property(nonatomic,copy)NSString *title;//标题
@property(nonatomic,copy)NSString *desc;//副标题描述
@property(nonatomic,copy)NSString *views;// 总浏览数
@property(nonatomic,copy)NSString *favorites;//总收藏数
@property(nonatomic,copy)NSString *comments;// 总评论数
@property(nonatomic,copy)NSString *photos;//图片数
@property(nonatomic,copy)NSString *linkurl;//跳转地址
@property(nonatomic,copy)NSString *datelines;//创建时间
@property(nonatomic,copy)NSString *cat_title;//分类标题
@property(nonatomic,strong)NSArray *other_article;//相关内容推荐
@property(nonatomic,copy)NSString *is_collect;//是否收藏0：未收藏； 1：已收藏
@property(nonatomic,strong)NSArray *comment_list;// 用户评价列表
@property(nonatomic,strong)NSArray *article_thumb;
@property(nonatomic,strong)NSArray *cat_items;

- (id)initWithDic:(NSDictionary *)dic;

@end

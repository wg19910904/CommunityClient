//
//  JHPEvaluateModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPEvaluateModel : NSObject
@property(nonatomic,copy)NSString * content;//评价的内容
@property(nonatomic,copy)NSString * have_photo;//是否有数组
@property(nonatomic,copy)NSString * reply;//回复的内容
@property(nonatomic,copy)NSString * score;//总体评价的星级数
@property(nonatomic,copy)NSString * reply_time;//回复的时间
@property(nonatomic,retain)NSMutableArray * imageArray;//保存评价的照片的数组
@property(nonatomic,copy)NSString * face;//头像
@property(nonatomic,copy)NSString * name;//姓名
+(JHPEvaluateModel *)creatJHPEvaluateModelWithDictionary:(NSDictionary * )dic withTuan:(BOOL)isTuan;
-(id)initWithDictionary:(NSDictionary *)dic withTuan:(BOOL)isTuan;
@end

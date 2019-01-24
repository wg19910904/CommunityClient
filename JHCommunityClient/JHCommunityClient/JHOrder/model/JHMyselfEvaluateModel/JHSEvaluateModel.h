//
//  JHSEvaluateModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHSEvaluateModel : NSObject
@property(nonatomic,copy)NSString * score;//总体打分的星星数
@property(nonatomic,copy)NSString * score_kouwei;//商品打分的星星数
@property(nonatomic,copy)NSString * score_fuwu;//商品服务打分的星星数
@property(nonatomic,copy)NSString * content;//评价的内容
@property(nonatomic,copy)NSString * have_photo;//判断是否有图片
@property(nonatomic,retain)NSMutableArray * imageArray;//保存图片的数组
@property(nonatomic,copy)NSString * reply;//回复的内容
@property(nonatomic,copy)NSString * reply_time;//回复的时间
@property(nonatomic,copy)NSString * face;//头像
@property(nonatomic,copy)NSString * name;//姓名
@property(nonatomic,copy)NSString * pei_time;//送达时间
@property(nonatomic,copy)NSString * pei_time_label;//送达时间描述
+(JHSEvaluateModel *)creatJHSEvaluateModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

//
//  JHAddSeatModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JHAddSeatModel : NSObject
+(JHAddSeatModel *)shareAddSeatModelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,assign)NSInteger num;//时间段的个数
@property(nonatomic,retain)NSMutableArray *timeArray;//存放时间段的数组
@property(nonatomic,retain)NSArray *infoArray;//存放时间的数组
@end

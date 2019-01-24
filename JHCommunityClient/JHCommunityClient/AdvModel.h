//
//  AdvModel.h
//  JHCash
//
//  Created by ijianghu on 16/12/9.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvModel : NSObject
@property(nonatomic,copy)NSString *adv_id;
@property(nonatomic,copy)NSString *item_id;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *title;
+(AdvModel *)shareAdvModelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end

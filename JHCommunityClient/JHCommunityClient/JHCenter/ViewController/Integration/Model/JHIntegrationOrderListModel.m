//
//  JHIntegrationOrderListModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/9/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHIntegrationOrderListModel.h"

@implementation JHIntegrationOrderListModel
- (instancetype)init{
    if(self = [super init]){
        self.productArray = @[].mutableCopy;
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}
@end

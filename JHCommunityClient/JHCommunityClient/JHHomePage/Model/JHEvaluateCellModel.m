//
//  JHEvaluateCellModel.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHEvaluateCellModel.h"

@implementation JHEvaluateCellModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSArray *)comment_photos{
    if (_photos.count) {
        return _photos;
    }
    return _comment_photos;
}
@end

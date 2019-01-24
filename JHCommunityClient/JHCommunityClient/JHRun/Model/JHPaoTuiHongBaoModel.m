//
//  JHPaoTuiHongBaoModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/2/10.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHPaoTuiHongBaoModel.h"
 
@implementation JHPaoTuiHongBaoModel
+(void)postToGetHongBaoArr:(NSString *)amount tip:(NSString *)tip block:(void(^)(JHPaoTuiHongBaoModel *model))myBlock{
    [HttpTool postWithAPI:@"client/paotui/preinfo" withParams:@{@"amount":amount,@"xf":tip} success:^(id json) {
        NSLog(@"红包的数据%@",json);
        JHPaoTuiHongBaoModel *model = nil;
        if ([json[@"error"] isEqualToString:@"0"]) {
            model = [JHPaoTuiHongBaoModel new];
            [model setValuesForKeysWithDictionary:json[@"data"]];
        }
        if (myBlock) {
            myBlock(model);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(nil);
        }
    }];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

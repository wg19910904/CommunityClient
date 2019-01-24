//
//  NearShopModel.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "NearShopModel.h"

@implementation NearShopModel

-(NSArray *)youhuiArr{
    if (_youhuiArr==nil) {
        NSMutableArray *arr=[NSMutableArray array];
        if (self.first_amount_title.length!=0) {
            [arr addObject:@{@"title":NSLocalizedString(@"首", nil),@"des":self.first_amount_title,@"color":@"ff5722"}];
        }
        if (self.youhui_title.length!=0) {
            [arr addObject:@{@"title":NSLocalizedString(@"减", nil),@"des":self.youhui_title,@"color":@"ffb54c"}];
        }
        if(self.online_pay_title.length!=0){
            [arr addObject:@{@"title":NSLocalizedString(@"付", nil),@"des":self.online_pay_title,@"color":@"92b9e1"}];
        }
        _youhuiArr=[arr copy];
    }
    return _youhuiArr;
}
@end

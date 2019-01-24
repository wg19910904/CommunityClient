//
//  JHIntegrationCartModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHIntegrationCartModel.h"
static JHIntegrationCartModel *model = nil;
@implementation JHIntegrationCartModel
{
    BOOL _exist;//判断是否存在
}
+ (JHIntegrationCartModel *)shareIntegrationCartModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[JHIntegrationCartModel alloc] init];
        model.integrationCartInfo = @[].mutableCopy;
    });
    return model;
}
- (void)addIntegrationCartInfoWithProduct_id:(NSString *)product_id
                           withProduct_title:(NSString *)product_title
                                   withImage_url:(NSString *)image_url
                                   withPrice:(NSString *)price
                                  withJifen:(NSString *)jifen
                                 withFreight:(NSString *)freight
                                     withSku:(NSString *)sku{
    
    if(self.integrationCartInfo.count == 0){
        NSDictionary *productDic= @{@"product_id":product_id,
                                    @"product_title":product_title,
                                    @"image_url":image_url,
                                    @"price":price,
                                    @"jifen":jifen,
                                    @"freight":freight,
                                    @"sku":sku,
                                    @"product_number":@(1)
                                    };
        [self.integrationCartInfo addObject:productDic];
    }else{
        
        
        for(NSDictionary *dic in self.integrationCartInfo){
            
            if([dic[@"product_id"] integerValue] == [product_id integerValue]){
                //存在加数字
                NSUInteger index = [self.integrationCartInfo indexOfObject:dic];
                NSMutableDictionary *productDic = dic.mutableCopy;
                NSString *product_num = dic[@"product_number"];
                NSInteger num = [product_num integerValue] + 1;
                [productDic setObject:@(num) forKey:@"product_number"];
                [self.integrationCartInfo replaceObjectAtIndex:index withObject:productDic.copy];
                return;
            }
        }
                //不存在开始添加
                NSDictionary *productDic= @{@"product_id":product_id,
                                            @"product_title":product_title,
                                            @"image_url":image_url,
                                            @"price":price,
                                            @"jifen":jifen,
                                            @"freight":freight,
                                            @"sku":sku,
                                            @"product_number":@(1)
                                            };
            [self.integrationCartInfo addObject:productDic];
 
    
    }
}
- (void)removeIntegrationCartInfoWithProduct_id:(NSString *)product_id{
    for(int i = 0; i < self.integrationCartInfo.count; i ++){
        NSDictionary *dic = self.integrationCartInfo[i];
        if([dic[@"product_id"] integerValue] == [product_id integerValue]){
            NSInteger index = [self.integrationCartInfo indexOfObject:dic];
            NSMutableDictionary *productDic = dic.mutableCopy;
            NSInteger product_num = [productDic[@"product_number"] integerValue];
            NSInteger num = product_num - 1;
            [productDic setObject:@(num) forKey:@"product_number"];
            if(num > 0)
                [self.integrationCartInfo replaceObjectAtIndex:index withObject:productDic.copy];
            else
                [self.integrationCartInfo removeObjectAtIndex:index];
        }
    }
}

- (NSString *)getIntegrationFreight{
    NSInteger freight = 0;
    for(NSDictionary *dic in self.integrationCartInfo){
        freight  =  freight < [dic[@"freight"] integerValue] ? [dic[@"freight"] integerValue] : freight;
    }
    return @(freight).stringValue;
}
- (NSString *)getTotalJifen{
    NSInteger totalJiFen = 0;
    for(NSDictionary *dic in self.integrationCartInfo){
        totalJiFen += [dic[@"jifen"] integerValue]* [dic[@"product_number"] integerValue];
    }
    return @(totalJiFen).stringValue;
}
- (NSString *)getTotalPayMoney{
    float totalMoney = 0;
    for(NSDictionary *dic in self.integrationCartInfo){
        totalMoney += [dic[@"price"] floatValue] * [dic[@"product_number"] integerValue];
    }
    totalMoney += [[self getIntegrationFreight] floatValue];
    if(totalMoney > 0)
          return [NSString stringWithFormat:@"%.1f",totalMoney];
    else
         return [NSString stringWithFormat:@"%d",(int)totalMoney];
}
- (NSString *)getTotalNumer{
    NSInteger totalNumber = 0;
    for(NSDictionary *dic in self.integrationCartInfo){
        totalNumber += [dic[@"product_number"] integerValue];
    }
    return @(totalNumber).stringValue;
}

- (NSString *)getBuyNumberWithProduct_id:(NSString *)product_id
{
    NSInteger buyNumber = 0;
    for(NSDictionary *dic in self.integrationCartInfo){
        if([dic[@"product_id"] integerValue] == [product_id integerValue]){
           buyNumber = [dic[@"product_number"] integerValue];
        }
    }
    return @(buyNumber).stringValue;
}
- (NSString *)getMcart{
    NSMutableArray *mcartArry = @[].mutableCopy;
    for(NSDictionary *dic in self.integrationCartInfo){
        NSString *str = [NSString stringWithFormat:@"%@:%@",dic[@"product_id"],dic[@"product_number"]];
        [mcartArry addObject:str];
    }
    return [mcartArry componentsJoinedByString:@","];
}
@end

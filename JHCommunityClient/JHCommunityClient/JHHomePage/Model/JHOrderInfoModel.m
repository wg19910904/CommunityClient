//
//  JHOrderInfoModel.m
//  JHCommunityClient
//
//  Created by xixixi on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHOrderInfoModel.h"


@implementation JHOrderInfoModel


+(instancetype)shareModel
{
    static JHOrderInfoModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[JHOrderInfoModel alloc] init];
        model.shopCartInfo = [@{} mutableCopy];
    });
    return model;
}
- (instancetype)init
{
   
    self = [super init];
    return self;
}
#pragma mark - 添加一条信息购物车信息 key : {shop_id:xxx,products:[{@{@"product_id":product_id,@"spec_id":spec_id,@"title":title,@"number":number}....]}
- (void)addShopCartInfoWithShop_id:(NSString *)shop_id
                    withProduct_id:(NSString *)product_id
                 withProduct_title:(NSString *)product_title
                       withSpec_id:(NSString *)spec_id
                    withSpec_title:(NSString *)spec_title
                         withPrice:(NSString *)price
                 withPackage_price:(NSString *)package_price
                        withMaxNum:(NSString *)max_num
{
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSArray *shopKeys = [_shopCartInfo allKeys];
    if (![shopKeys containsObject:shop_key]) {
        //第一次添加
        NSMutableArray *products = [@[] mutableCopy];
        NSMutableDictionary *productInfo = [@{@"product_id":product_id,
                                              @"product_title":product_title,
                                              @"spec_id":spec_id,
                                              @"spec_title":spec_title,
                                              @"price":price,
                                              @"package_price":package_price,
                                              @"number":@(1),
                                              @"max_num":max_num} mutableCopy];
        [products addObject:productInfo];
        NSMutableDictionary *cartInfo = [@{} mutableCopy];
        [cartInfo addEntriesFromDictionary:@{@"shop_id":shop_id,
                                             @"products":products}];
        [self.shopCartInfo addEntriesFromDictionary:@{shop_key:cartInfo}];
        
    }else{
        //已经添加过商品
        NSMutableDictionary *cartInfo = [self.shopCartInfo[shop_key] mutableCopy];
        NSMutableArray *products = [cartInfo[@"products"] mutableCopy];
        NSInteger num = 0;
        BOOL alreadhave = false;
        NSDictionary *temDic;
        for (NSDictionary *dic in products) {
            //如果已经有对应商品,先移除
            if ([dic[@"product_id"] integerValue] == [product_id integerValue] &&
                [dic[@"spec_id"] integerValue] == [spec_id integerValue]) {
                num = [dic[@"number"] integerValue];
                //找到对应商品,移除
                temDic = dic;
                alreadhave = YES;
            }
        }
        if (alreadhave) { //已存在,替换
            NSUInteger index = [products indexOfObject:temDic];
            [products replaceObjectAtIndex:index withObject:@{@"product_id":product_id,
                                                              @"product_title":product_title,
                                                              @"spec_id":spec_id,
                                                              @"spec_title":spec_title,
                                                              @"price":price,
                                                              @"package_price":package_price,
                                                              @"number":@(++num),
                                                              @"max_num":max_num}];
        }else{
            //不存在,添加
            [products addObject:@{@"product_id":product_id,
                                  @"product_title":product_title,
                                  @"spec_id":spec_id,
                                  @"spec_title":spec_title,
                                  @"price":price,
                                  @"package_price":package_price,
                                  @"number":@(++num),
                                  @"max_num":max_num}];

            
        }
        [cartInfo addEntriesFromDictionary:@{@"products":products}];
        [self.shopCartInfo addEntriesFromDictionary:@{shop_key:cartInfo}];
    }
}
#pragma mark - 移除一条购物车信息
- (void)removeShopCartInfoWithShop_id:(NSString *)shop_id
                       withProduct_id:(NSString *)product_id
                          withSpec_id:(NSString *)spec_id
{
    
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSMutableDictionary *cartInfo = [self.shopCartInfo[shop_key] mutableCopy];
    NSMutableArray *products = [cartInfo[@"products"] mutableCopy];
    //block 遍历
    [products enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"product_id"] integerValue] == [product_id integerValue] &&
            [obj[@"spec_id"] integerValue] == [spec_id integerValue]) {
            //找到对应商品,将数量减1
            NSInteger num = [obj[@"number"] integerValue];
            NSString *product_title = obj[@"product_title"];
            NSString *spec_title = obj[@"spec_title"];
            NSString *price = obj[@"price"];
            NSString *package_price = obj[@"package_price"];
            NSString *max_num = obj[@"max_num"];
            //替换
            NSUInteger index = [products indexOfObject:obj];
            [products replaceObjectAtIndex:index withObject:@{@"product_id":product_id,
                                                              @"product_title":product_title,
                                                              @"spec_id":spec_id,
                                                              @"spec_title":spec_title,
                                                              @"price":price,
                                                              @"package_price":package_price,
                                                              @"number":@(--num),
                                                              @"max_num":max_num}];
            //为0时,删除对应商品
            if (num == 0) {
                [products removeObject:@{@"product_id":product_id,
                                         @"product_title":product_title,
                                         @"spec_id":spec_id,
                                         @"spec_title":spec_title,
                                         @"price":price,
                                         @"package_price":package_price,
                                         @"number":@(num),
                                         @"max_num":max_num}];
            }
            *stop = YES;
        }
        if (*stop) {
            [cartInfo addEntriesFromDictionary:@{@"products":products}];
            [_shopCartInfo addEntriesFromDictionary:@{shop_key:cartInfo}];
        }
    }];
}
#pragma mark - 再来一单时插入对应店铺的商品
- (void)addShopProductsWith:(NSArray<NSDictionary *>*)array withShop_id:(NSString *)shop_id
{
    
    if (!_shopCartInfo) {
        _shopCartInfo = @{}.mutableCopy;
    }
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSDictionary *productDic = @{@"products":array,
                                 @"shop_id":shop_id};
    [_shopCartInfo addEntriesFromDictionary:@{shop_key:productDic}];
    
}
#pragma mark - 获取店铺的购物车信息
- (NSDictionary *)getCartInfoWithShop_id:(NSString *)shop_id
{
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSDictionary *cartInfo = self.shopCartInfo[shop_key];
    return cartInfo;
}
#pragma mark - 删除指定店铺的购物车信息
- (void)removeShopCartInfoWithShop_id:(NSString *)shop_id
{
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSArray *allKeys = [self.shopCartInfo allKeys];
    if ([allKeys containsObject:shop_key]) {
        //删除指定店铺的信息
        [self.shopCartInfo removeObjectForKey:shop_key];
    }
}
#pragma mark - 获取商品总量
- (NSInteger)getAllProductNum:(NSString *)shop_id
{
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSDictionary *shopcartDic = self.shopCartInfo[shop_key];
    NSArray *productArray = shopcartDic[@"products"];
    NSInteger num = 0;
    for (NSDictionary *productDic in productArray) {
        num += [productDic[@"number"] integerValue];
    }
    return num;
}
#pragma mark - 获取商品总价
- (CGFloat)getAllProductPrice:(NSString *)shop_id
{
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSDictionary *shopcartDic = self.shopCartInfo[shop_key];
    if (!shopcartDic || shopcartDic.count == 0) return 0.0;
    
    NSArray *productArray = shopcartDic[@"products"];
    CGFloat price = 0.0;
    for (NSDictionary *productDic in productArray) {
        price += ([productDic[@"number"] integerValue] * [productDic[@"price"] floatValue]);
    }
    return price;
}
#pragma mark - 获取商品总打包费
- (CGFloat)getAllProductPackage_price:(NSString *)shop_id
{
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSDictionary *shopcartDic = self.shopCartInfo[shop_key];
    NSArray *productArray = shopcartDic[@"products"];
    CGFloat package_price = 0.0;
    for (NSDictionary *productDic in productArray) {
        package_price += ([productDic[@"number"] integerValue] * [productDic[@"package_price"] floatValue]);
    }
    return package_price;

}
#pragma mark - 获取商品格式化字符串
- (NSString *)getProductsString:(NSString *)shop_id
{
    //构建商家店铺唯一key
    NSString *shop_key = [NSString stringWithFormat:@"shop_id_%@",shop_id];
    NSDictionary *shopcartDic = self.shopCartInfo[shop_key];
    NSArray *productArray = shopcartDic[@"products"];
    NSMutableArray *products = [@[] mutableCopy];
    for (NSDictionary *productDic in productArray) {
        
        NSArray *temarray;
        if ([productDic[@"spec_id"] integerValue] > 0) { //存在特殊商品
            temarray = @[productDic[@"product_id"],productDic[@"spec_id"],productDic[@"number"]];
        
        }else{
            temarray = @[productDic[@"product_id"],productDic[@"number"]];
            
        }
        [products addObject:[temarray componentsJoinedByString:@":"]];
    }
    return [products componentsJoinedByString:@","];
}
@end

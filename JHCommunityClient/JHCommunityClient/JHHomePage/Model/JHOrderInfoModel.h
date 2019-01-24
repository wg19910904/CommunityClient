//
//  JHOrderInfoModel.h
//  JHCommunityClient
//
//  Created by xixixi on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHOrderInfoModel : NSObject
//存储购物车信息
@property(nonatomic,strong)NSMutableDictionary *shopCartInfo;

/**
 *  外部引用
 *
 *  @return shareModel
 */
+ (instancetype)shareModel;

/**
 *  向购物车中添加一个店铺的所选商品信息
 *
 *  @param shop_id       店铺id
 *  @param product_id    商品id
 *  @param product_title 商品title
 *  @param spec_id       规格商品id
 *  @param spec_title    规格商品title
 *  @param price         商品price
 *  @param price         商品打包费
 *  @param max_num       商品最大购买数
 */
- (void)addShopCartInfoWithShop_id:(NSString *)shop_id
                    withProduct_id:(NSString *)product_id
                 withProduct_title:(NSString *)product_title
                       withSpec_id:(NSString *)spec_id
                    withSpec_title:(NSString *)spec_title
                         withPrice:(NSString *)price
                 withPackage_price:(NSString *)package_price
                        withMaxNum:(NSString *)max_num;

/**
 *  从已保存的购物车信息对应的店铺移除某个商品
 *
 *  @param shop_id    店铺id
 *  @param product_id 商品id
 *  @param spec_id    规格商品id
 */
- (void)removeShopCartInfoWithShop_id:(NSString *)shop_id
                       withProduct_id:(NSString *)product_id
                          withSpec_id:(NSString *)spec_id;

/**
 *  获取指定店铺保存的购物车信息
 *
 *  @param shop_id 店铺id
 *
 *  @return 购物车信息
 */
- (NSDictionary *)getCartInfoWithShop_id:(NSString *)shop_id;

/**
 *  删除指定店铺的购物车信息
 *
 *  @param shop_id 店铺id
 */
- (void)removeShopCartInfoWithShop_id:(NSString *)shop_id;

/**
 *  获取指定店铺的当前商品的总数量
 *
 *  @param shop_id 店铺id
 *
 *  @return 商品总量
 */
- (NSInteger)getAllProductNum:(NSString *)shop_id;

/**
 *  获取指定店铺当前商品的总价
 *
 *  @param shop_id 店铺id
 *
 *  @return 商品总价
 */
- (CGFloat)getAllProductPrice:(NSString *)shop_id;

/**
 *  获取指定店铺当前商品的打包费
 *
 *  @param shop_id 店铺id
 *
 *  @return 商品总打包费
 */
- (CGFloat)getAllProductPackage_price:(NSString *)shop_id;

/**
 *  获取指定的商品格式
 *
 *  @param shop_id 店铺id
 *
 *  @return 商品格式化字符串
 */
- (NSString *)getProductsString:(NSString *)shop_id;

/**
 *  传入商品数组,插入到infoModel中
 *
 *  @param array   再来一单的商品数组
 *  @param shop_id 需要添加的shop_id
 */
- (void)addShopProductsWith:(NSArray<NSDictionary *>*)array withShop_id:(NSString *)shop_id;
@end

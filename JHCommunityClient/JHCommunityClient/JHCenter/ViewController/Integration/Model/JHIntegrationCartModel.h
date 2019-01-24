//
//  JHIntegrationCartModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHIntegrationCartModel : NSObject
@property (nonatomic,strong)NSMutableArray *integrationCartInfo;
+ (JHIntegrationCartModel *)shareIntegrationCartModel;
/**
 *  向购物车添加商品,存储数据
 *  @param product_id     商品id
 *  @param product_title  商品名
 *  @param price          价格
 *  @param freight        运费
 *  @param sku            库存量
 *  @param jifen          积分
 */

- (void)addIntegrationCartInfoWithProduct_id:(NSString *)product_id
                           withProduct_title:(NSString *)product_title
                                   withImage_url:(NSString *)image_url
                                   withPrice:(NSString *)price
                                   withJifen:(NSString *)jifen
                                     withFreight:(NSString *)freight
                                     withSku:(NSString *)sku;

/**
 *  移除某一个商品
 *
 *  @param product_id 商品id
 *
 */

- (void)removeIntegrationCartInfoWithProduct_id:(NSString *)product_id;





/**
 *  获取运费
 */
- (NSString *)getIntegrationFreight;

/**
 *  获取总积分
 */
- (NSString *)getTotalJifen;
/**
 *  获取支付总金额
 */
- (NSString *)getTotalPayMoney;

/**
 *  获取总数量
 */
- (NSString *)getTotalNumer;
/**
 *  获取某一商品的购买量
 */
- (NSString *)getBuyNumberWithProduct_id:(NSString *)product_id;
/**
 *  获取提交订单字符串
 */
- (NSString *)getMcart;
@end

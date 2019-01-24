//
//  JHTakeawayDetailModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHModel;
@interface JHTakeawayDetailModel : NSObject
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * intro;
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * order_status_label;
@property(nonatomic,copy)NSString * order_status_warning;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,copy)NSString * order_youhui;
@property(nonatomic,copy)NSString * title;//商超名字
@property(nonatomic,copy)NSString * title_waimai;//外卖商家名字
@property(nonatomic,copy)NSString * hongbao;//红包抵扣
@property(nonatomic,copy)NSString * logo;//商超商家图标
@property(nonatomic,copy)NSString * logo_waimai;//外卖商家图标
@property(nonatomic,copy)NSString * contact;//订单详情联系人
@property(nonatomic,copy)NSString * mobile;//订单详情联系电话
@property(nonatomic,copy)NSString *money;//余额支付的金额
@property(nonatomic,copy)NSString * addr;//订单详情联系电话
@property(nonatomic,copy)NSString * dateline;//订单详情下单时间
@property(nonatomic,copy)NSString * pay_code;//订单详情支付方式
@property(nonatomic,copy)NSString * pei_time;//订单详情送达时间
@property(nonatomic,copy)NSString * pei_type;//订单的配送方式
@property(nonatomic,copy)NSString * total_price;//订单的总价
@property(nonatomic,copy)NSString * freight;//配送费
@property(nonatomic,copy)NSString * package_price;//打包费
@property(nonatomic,copy)NSString * shop_mobile;//商家电话
@property(nonatomic,copy)NSString * staff_mobile;//配送员电话
@property(nonatomic,copy)NSString * jd_time;//接单时间
@property(nonatomic,copy)NSString * time;//外卖送的时间段
@property(nonatomic,copy)NSString * lastTime;//最终需要展示的送达时间
@property(nonatomic,copy)NSString * online_pay;//在线支付与否
@property(nonatomic,copy)NSString * shop_id;//商户id
@property(nonatomic,copy)NSString * yy_ltime;//
@property(nonatomic,copy)NSString * yy_status;//
@property(nonatomic,copy)NSString * yy_stime;//
@property(nonatomic,copy)NSString * tmpl_type;//类型
@property(nonatomic,copy)NSString *coupon;//优惠劵抵扣
@property(nonatomic,copy)NSString * first_youhui;//类型
@property(nonatomic,retain)NSMutableArray * modelArray;
@property(nonatomic,retain)JHModel * model;
@property(nonatomic,retain)NSMutableArray * product_array;
@property(nonatomic,copy)NSString * spend_number;
+(JHTakeawayDetailModel * )creatJHTakeawayDetailModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary * )dic;
@end

@interface JHModel : NSObject
@property(nonatomic,copy)NSString * product_name;//菜的名称
@property(nonatomic,copy)NSString * product_price;//菜的单价
@property(nonatomic,copy)NSString * product_number;//菜的份数
@property(nonatomic,copy)NSString * amount;//一种菜的总价
@property(nonatomic,copy)NSString * spec_id;
@property(nonatomic,copy)NSString * spec_title;
@property(nonatomic,copy)NSString * max_num;
@property(nonatomic,copy)NSString * product_id;
@property(nonatomic,copy)NSString * package_price;
+(JHModel *)creatJHModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

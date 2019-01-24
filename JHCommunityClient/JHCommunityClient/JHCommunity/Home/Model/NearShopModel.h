//
//  NearShopModel.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearShopModel : NSObject
@property(nonatomic,copy)NSString *shop_id;
//@property(nonatomic,copy)NSString *city_id;
//@property(nonatomic,copy)NSString *city_name;
//@property(nonatomic,copy)NSString *cate_id;
//@property(nonatomic,copy)NSString *cate_name;

@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *title;
//@property(nonatomic,copy)NSString *banner;

//@property(nonatomic,copy)NSString *declare;//商家公告
@property(nonatomic,copy)NSString *addr;
//@property(nonatomic,copy)NSString *lat;
//@property(nonatomic,copy)NSString *lng;
//@property(nonatomic,assign)int views;
@property(nonatomic,assign)int orders;
//@property(nonatomic,assign)int comments;
//@property(nonatomic,assign)int praise_num;//好评数
@property(nonatomic,assign)float avg_score;//综合总评分，星星可以除以评论数
//@property(nonatomic,assign)int score_fuwu;
//@property(nonatomic,assign)int score_kouwei;
//@property(nonatomic,assign)int pei_time;//平均配送时间
@property(nonatomic,assign)float min_amount;//起送价
@property(nonatomic,copy)NSString *first_amount_title;//首单优惠
@property(nonatomic,copy)NSString *online_pay_title;
@property(nonatomic,copy)NSString *youhui_title;
//@property(nonatomic,assign)float pei_distance;
@property(nonatomic,assign)float freight;//配送费
@property(nonatomic,copy)NSString *juli_label;
@property(nonatomic,copy)NSString *pei_time;
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@property(nonatomic,copy)NSString *tmpl_type;
@property(nonatomic,copy)NSString *score;//星星
@property(nonatomic,copy)NSString *freight_price;//配送费

@property(nonatomic,strong)NSArray *youhuiArr;
//@property(nonatomic,strong)NSArray *freight_stage;
//@property(nonatomic,assign)float freight_price;
//@property(nonatomic,assign)int pei_type;
//@property(nonatomic,assign)float pei_amount;
//@property(nonatomic,assign)int yy_status;
//@property(nonatomic,assign)NSInteger yy_stime;
//@property(nonatomic,assign)NSInteger yy_ltime;
//@property(nonatomic,assign)int is_new;//是否新店 0:否, 1:是
//@property(nonatomic,assign)NSInteger online_pay;//结束营业的时间
//@property(nonatomic,assign)int verify_name;
//@property(nonatomic,copy)NSString *tmpl_type;//店铺模板 waimai:外卖店铺, market:商超
//@property(nonatomic,copy)NSString *info;
//@property(nonatomic,assign)int is_daofu;
//@property(nonatomic,assign)int is_ziti;

@end

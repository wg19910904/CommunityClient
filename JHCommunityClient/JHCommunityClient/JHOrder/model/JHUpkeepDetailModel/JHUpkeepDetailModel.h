//
//  JHUpkeepDetailModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHUpkeepDetailModel : NSObject
@property(nonatomic,copy)NSString * order_status_label;//订单状态
@property(nonatomic,copy)NSString * order_status_warning;//订单警告
@property(nonatomic,copy)NSString * order_status;
@property(nonatomic,copy)NSString * pay_status;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * comment_status;
@property(nonatomic,copy)NSString * dateline;//下单时间
@property(nonatomic,copy)NSString * contact;//联系人
@property(nonatomic,copy)NSString * mobile;//联系电话
@property(nonatomic,copy)NSString * addr;//服务地址
@property(nonatomic,copy)NSString * fuwu_time;//服务地址
@property(nonatomic,copy)NSString * online_pay;//支付方式
@property(nonatomic,copy)NSString * pay_code;//支付方式
@property(nonatomic,copy)NSString * intro;//服务要求
@property(nonatomic,copy)NSString * voice;//语音
@property(nonatomic,copy)NSString * voice_time;//语音时间
@property(nonatomic,retain)NSMutableArray * photoArray;//相片数组
@property(nonatomic,copy)NSString * danbao_amount;//担保费
@property(nonatomic,copy)NSString * name;//服务人员姓名
@property(nonatomic,copy)NSString * mobile_service;//服务人员
@property(nonatomic,copy)NSString * hongbao;//红包
@property(nonatomic,copy)NSString * jiesuan_price;//总价
@property(nonatomic,copy)NSString * staff_id;
@property(nonatomic,copy)NSString *cate_title;
+(JHUpkeepDetailModel * )creatJHUpkeepDetailModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

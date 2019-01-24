//
//  MemberInfoModel.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfoModel : NSObject
@property (nonatomic,copy)NSString *gold;// 金币
@property (nonatomic,copy)NSString *uid;//用户id
@property (nonatomic,copy)NSString *nickname;//昵称
@property (nonatomic,copy)NSString *face;//图像
@property (nonatomic,copy)NSString *mobile;//手机号
@property (nonatomic,copy)NSString *money;//余额
@property (nonatomic,copy)NSString *jifen;//积分
@property (nonatomic,copy)NSString *hongbao_count;//
@property (nonatomic,copy)NSString *youhui_count;//优惠数量
@property (nonatomic,copy)NSString *msg_new_count;//新消息
@property(nonatomic,copy)NSString *quan_count;
@property (nonatomic,copy)NSString *wx_openid;
@property (nonatomic,copy)NSString *wx_unionid;

@property (nonatomic,copy)NSString *loginip;
@property (nonatomic,copy)NSString *lastlogin;
@property (nonatomic,copy)NSString *go_pay_count;
@property (nonatomic,copy)NSString *cancle_pay_count;
@property (nonatomic,copy)NSString *no_comment_count;
@property (nonatomic,copy)NSString *tuan_ticket_count;
@property (nonatomic,copy)NSString *tuiguang;
@property(nonatomic,copy)NSString *my_qianghb;
@property(nonatomic,copy)NSString *jifen_mall;
@property(nonatomic,strong)NSArray *extend;
@property(nonatomic,copy)NSString *qiandao_url;//签到连接
@property(nonatomic,copy)NSString *youhui_url;//优惠连接
@property(nonatomic,copy)NSString *about_url;//关于我们连接
@property(nonatomic,copy)NSString *feedback_url;//意见反馈链接
@property(nonatomic,copy)NSString *site_phone;//平台客服电话
@property(nonatomic,strong)NSArray *order_group;//订单数组
@property(nonatomic,strong)NSArray *function_group;//功能数组
@property(nonatomic,copy)NSString *quan_url;
@property(nonatomic,copy)NSString *jifen_url;


+ (MemberInfoModel *)shareModel;
@end

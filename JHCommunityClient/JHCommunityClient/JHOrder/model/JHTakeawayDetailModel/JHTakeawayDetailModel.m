//
//  JHTakeawayDetailModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTakeawayDetailModel.h"
@implementation JHTakeawayDetailModel
+(JHTakeawayDetailModel * )creatJHTakeawayDetailModelWithDictionary:(NSDictionary *)dic{
    return [[JHTakeawayDetailModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary * )dicc{
    if (self == [super init]) {
        NSMutableDictionary *dic = dicc.mutableCopy;
        if (![dic[@"waimai"] isKindOfClass:[NSDictionary class]]) {
            [dic addEntriesFromDictionary:@{@"waimai":@{}}];
        }
        self.pei_type = dic[@"detail"][@"pei_type"];
        self.product_array = @[].mutableCopy;
        self.modelArray = [NSMutableArray array];
        self.dateline = [self returnTime:dic[@"dateline"] withTime:0];
        self.order_id = dic[@"detail"][@"order_id"];
        self.comment_status = dic[@"comment_status"];
        self.intro = dic[@"intro"];
        if ([_pei_type integerValue] == 3) {
            self.addr = dic[@"shop"][@"addr"];
        }else{
            self.addr = [NSString stringWithFormat:@"%@%@",dic[@"addr"],dic[@"house"]];
        }
        self.mobile = dic[@"mobile"];
        self.spend_number = dic[@"detail"][@"spend_number"];
        self.order_status = dic[@"order_status"];
        self.order_status_label = dic[@"order_status_label"];
        self.order_status_warning = dic[@"order_status_warning"];
        self.title = dic[@"shop"][@"title"];
        self.title_waimai = dic[@"waimai"][@"title"];
        self.logo = dic[@"shop"][@"logo"];
        self.logo_waimai = dic[@"waimai"][@"logo"];
        self.hongbao = dic[@"hongbao"];
        self.coupon = dic[@"coupon"];
        self.contact = dic[@"contact"];
        self.pay_code = dic[@"pay_code"];
        self.pei_time = dic[@"detail"][@"pei_time"];
        self.total_price = dic[@"amount"];
        self.shop_mobile = dic[@"shop"][@"mobile"];
        self.staff_mobile = dic[@"staff"][@"mobile"];
        self.jd_time = dic[@"jd_time"];
        self.time = dic[@"waimai"][@"pei_time"];
        self.package_price = dic[@"detail"][@"package_price"];
        self.freight =  dic[@"detail"][@"freight"];
        self.online_pay = dic[@"online_pay"];
        self.pay_status = dic[@"pay_status"];
        self.order_youhui = dic[@"order_youhui"];
        self.shop_id = dic[@"shop"][@"shop_id"];
        self.tmpl_type = dic[@"waimai"][@"tmpl_type"];
        self.yy_ltime = dic[@"waimai"][@"yy_ltime"];
        self.yy_status = dic[@"waimai"][@"yy_status"];
        self.yy_stime = dic[@"waimai"][@"yy_stime"];
        self.first_youhui = dic[@"detail"][@"first_youhui"];
        self.money = dic[@"detail"][@"money"];
        
        if(![self.pei_time isEqualToString:@"0"]){
            self.lastTime = [self returnTime:self.pei_time withTime:0];
        }else{
            self.lastTime = NSLocalizedString(@"尽快送达", nil);
        }
        NSArray * tempArray = dic[@"products"];
        for (NSDictionary * dictionary in tempArray) {
            JHModel * model = [JHModel creatJHModelWithDictionary:dictionary];
            [self.modelArray addObject:model];
            [self.product_array addObject:@{@"product_id":model.product_id,
                                            @"product_title":model.product_name,
                                            @"spec_id":model.spec_id,
                                            @"spec_title":model.spec_title,
                                            @"price":model.product_price,
                                            @"package_price":model.package_price,
                                            @"number":model.product_number,
                                            @"max_num":model.max_num}];
        }
    }
    return self;
}

-(NSString *)returnTime:(NSString *)dateline  withTime:(int)minute{
    NSInteger  num = [dateline integerValue];
    num = num + minute*60;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}

- (NSString *)pay_code{
    if ([_pay_status integerValue] == 0) {
        return NSLocalizedString(@"未支付", nil);
    }else{
    if (_pay_code.length > 1) {
        return _pay_code;
    }else{
       return [_online_pay integerValue] == 1? NSLocalizedString(@"在线支付", nil):NSLocalizedString(@"货到付款", nil);
    }
  }
}
@end
@implementation JHModel
+(JHModel *)creatJHModelWithDictionary:(NSDictionary *)dic{
    return [[JHModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        if ([dic[@"spec"] isKindOfClass:[NSDictionary class]]) {
            self.spec_title = dic[@"spec"][@"spec_name"]?dic[@"spec"][@"spec_name"]:@"";
        }else{
            self.spec_title = @"";
        }
        self.product_name = [NSString stringWithFormat:@"%@%@",dic[@"product_name"],self.spec_title];
        self.product_price = dic[@"product_price"];
        self.product_number = dic[@"product_number"];
        self.amount = dic[@"amount"];
        self.spec_id = dic[@"spec_id"]? dic[@"spec_id"]:@"";
        self.max_num = @"";
        self.product_id = dic[@"product_id"];
        self.package_price = dic[@"package_price"];
    }
        return self;
}
@end

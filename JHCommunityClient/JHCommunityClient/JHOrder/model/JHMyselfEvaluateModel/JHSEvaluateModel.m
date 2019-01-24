//
//  JHSEvaluateModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSEvaluateModel.h"

@implementation JHSEvaluateModel
+(JHSEvaluateModel *)creatJHSEvaluateModelWithDictionary:(NSDictionary *)dic{
    return [[JHSEvaluateModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.imageArray = [NSMutableArray array];
        self.score = dic[@"score"];
        self.score_fuwu = dic[@"score_fuwu"];
        self.score_kouwei = dic[@"score_kouwei"];
        self.content = dic[@"content"];
        self.have_photo = dic[@"have_photo"];
        self.reply = dic[@"reply"];
        self.reply_time = [self returnTimeWithInterger:dic[@"reply_time"]];
        self.face = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"shop"][@"logo"]];
        self.name = dic[@"shop"][@"title"];
        self.pei_time = dic[@"pei_time_label"];//;[self returnTimeWithInterger:dic[@"ok_time"]];;
        NSArray * tempArray = dic[@"photo"];
        if (tempArray.count != 0) {
            for (NSDictionary * dictionary in dic[@"photo"]) {
                NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dictionary[@"photo"]];
                [self.imageArray addObject:url];
            }
        }

    }
    return self;
}
#pragma mark - 这是将时间戳转化的方法
-(NSString *)returnTimeWithInterger:(NSString *)dataLine{
    NSInteger num = [dataLine integerValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}
@end

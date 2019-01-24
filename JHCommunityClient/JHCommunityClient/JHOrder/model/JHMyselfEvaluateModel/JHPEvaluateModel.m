//
//  JHPEvaluateModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPEvaluateModel.h"

@implementation JHPEvaluateModel
+(JHPEvaluateModel * )creatJHPEvaluateModelWithDictionary:(NSDictionary * )dic withTuan:(BOOL)isTuan{
    return [[JHPEvaluateModel alloc]initWithDictionary:dic withTuan:isTuan];
}
-(id)initWithDictionary:(NSDictionary *)dic withTuan:(BOOL)isTuan{
    self = [super init];
    if (self) {
        self.imageArray = [NSMutableArray array];
        self.content = dic[@"content"];
        self.have_photo = dic[@"have_photo"];
        self.reply = dic[@"reply"];
        self.score = dic[@"score"];
        self.reply_time = [self returnTimeWithInterger:dic[@"reply_time"]];
        NSArray * tempArray = dic[@"photo"];
        if (tempArray.count != 0) {
            for (NSDictionary * dictionary in dic[@"photo"]) {
                NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dictionary[@"photo"]];
                [self.imageArray addObject:url];
            }
        }
        if (isTuan) {
        self.face = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"shop"][@"logo"]];
        self.name = dic[@"shop"][@"title"];
        }else{
        self.face = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"staff"][@"face"]];
        self.name = dic[@"staff"][@"name"];
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

//
//  JHTempHomeModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTempClientNewsModel.h"
@implementation JHTempClientNewsModel
-(NSInteger)status{
    if (self.thumb.count == 0) {
        _status = 0;
    }else if (self.thumb.count == 1){
        _status = 1;
    }else{
        _status = 2;
    }
    return _status;
}
-(NSString *)dateline{
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:[_dateline integerValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}
@end

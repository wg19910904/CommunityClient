//
//  HZQCalendarControl.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/24.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZQCalendarControl : UIControl
+(HZQCalendarControl *)creatCalendarControlWithTime:(NSString *)time
                                  withSelecterColor:(UIColor *)selColor;
@property(nonatomic,retain)UIButton * sureBtn;
@property(nonatomic,copy)void(^myBlock)(NSString * text);
@end

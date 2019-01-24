//
//  MJBannnerPlayer.h
//  MJBannerPlayer
//
//  Created by WuXushun on 16/1/21.
//  Copyright © 2016年 wuxushun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CLICKAD)(NSInteger index);

@interface MJBannnerPlayer : UIView
@property (strong, nonatomic) NSArray *sourceArray;
@property (strong, nonatomic) NSArray *urlArray;
@property(nonatomic,copy)NSString *placeHolderImage;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,copy)CLICKAD clickAD;

//初始化一个本地图片播放器
+ (void)initWithSourceArray:(NSArray *)picArray
                  addTarget:(id)controller
                   withSize:(CGRect)frame
           withTimeInterval:(CGFloat)interval;


//初始化一个网络图片播放器
+ (void)initWithUrlArray:(NSArray *)urlArray
               addTarget:(UIViewController *)controller
                withSize:(CGRect)frame
        withTimeInterval:(CGFloat)interval;


//初始化一个本地图片播放器
- (MJBannnerPlayer *)initWithSourceArray:(NSArray *)picArray
                   withSize:(CGRect)frame
           withTimeInterval:(CGFloat)interval;


//初始化一个网络图片播放器
- (MJBannnerPlayer *)initWithUrlArray:(NSArray *)urlArray
                withSize:(CGRect)frame
        withTimeInterval:(CGFloat)interval;

-(void)initTimer;
@end

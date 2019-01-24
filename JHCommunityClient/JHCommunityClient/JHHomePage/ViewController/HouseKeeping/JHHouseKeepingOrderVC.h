//
//  JHHouseKeepingOrderVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//家政阿姨下单界面

#import "JHBaseVC.h"
#import <AVFoundation/AVFoundation.h>
@interface JHHouseKeepingOrderVC : JHBaseVC
@property (nonatomic, retain)NSURL *tmpFile;
//录音
@property (nonatomic, retain)AVAudioRecorder *recorder;
//播放
@property (nonatomic, retain)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;
@property (nonatomic, retain)AVAudioSession *session;
@property (nonatomic, retain)NSURL * mp3File;
@property (nonatomic,copy)NSString *addr_id;
@property (nonatomic,assign)NSInteger weekAndDayIndex;
@property (nonatomic,assign)NSInteger timeIndex;
@property (nonatomic,copy)NSString *seriverTime;
@property (nonatomic,copy)NSString *selectTime;
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *start;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)NSString *ayiName;
@end

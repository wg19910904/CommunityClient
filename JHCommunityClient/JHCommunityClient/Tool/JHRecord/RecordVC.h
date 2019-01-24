//
//  RecordVC.h
//  JHWaiMaiUpdate
//
//  Created by jianghu2 on 16/7/12.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^ShowCellImgBlock)(int second);
typedef void(^PlayBeginBlock)();
typedef void(^PlayEndBlock)();

@interface RecordVC : JHBaseVC
@property (nonatomic, retain)NSURL *tmpFile;

@property (nonatomic,copy)ShowCellImgBlock showCellImgBlock;
@property (nonatomic,copy)PlayBeginBlock playBeginBlock;
@property (nonatomic,copy)PlayEndBlock playEndBlock;
//录音
@property (nonatomic, retain)AVAudioRecorder *recorder;
//播放
@property (nonatomic, retain)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;
@property (nonatomic,weak)NSTimer  *remindTimer;//提示定时器
@property (nonatomic,strong)UILabel *viewReminder;
@property (nonatomic, retain)AVAudioSession *session;
@property (nonatomic, retain)NSURL * mp3File;
@property (nonatomic,strong) UIView *voiceBackView;//提示音量白色背景
@property (nonatomic,strong)UIImageView * imageV_voice;//显示不同的声音波状图
@property (nonatomic,strong)UIImageView *recordImg;//录音的图片
@property (nonatomic,strong)NSTimer *voiceTimer;//开启定时器刷新音量大小的数据
@property (nonatomic,strong)UIImageView * imageV;//显示录音的气泡的
@property (nonatomic,assign)int num_second;//用来记录录音的时间的
@property (nonatomic,strong)UIImageView * imageAnnimation;//播放时的那个动画组
@property (nonatomic,strong)NSTimer *timer;//定时器
@end

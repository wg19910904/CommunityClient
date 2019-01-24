//
//  JHSeatVC.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/25.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
#import <AVFoundation/AVFoundation.h>
@interface JHSeatVC : JHBaseVC
//录音存储路径
@property (nonatomic, retain)NSURL *tmpFile;
//录音
@property (nonatomic, retain)AVAudioRecorder *recorder;
//播放
@property (nonatomic, retain)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;
@property (nonatomic, retain)AVAudioSession *session;
@property (nonatomic, retain)NSURL * mp3File;

@end

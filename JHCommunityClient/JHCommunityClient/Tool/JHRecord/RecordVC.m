//
//  RecordVC.m
//  JHWaiMaiUpdate
//
//  Created by jianghu2 on 16/7/12.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "RecordVC.h"
#import "TranslateCafToMp3.h"
#import "TransformTime.h"
#import <AVFoundation/AVFoundation.h>
@interface RecordVC ()<AVAudioPlayerDelegate>
{
    NSInteger newNum;
   
}
@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveVoice) name:@"receive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(longPressToSpeak) name:@"recording" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToPlayer) name:@"playRecord" object:nil];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.36f];
    [self initAVAudioAttributes];
}
#pragma mark - 初始化录音和播放需要的一些属性
-(void)initAVAudioAttributes{
    self.session = [AVAudioSession sharedInstance];
    //开始录音,将所获取到得录音存到文件里
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    self.tmpFile = [NSURL URLWithString:[NSTemporaryDirectory()
                                         stringByAppendingString:@"recoder.caf"]];
    //初始化
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.tmpFile settings:settings error:nil];
}
#pragma mark - 这是识别音量的大小,从而显示不同的图片,来呈现出音量图波动
-(void)changeImageWithVoice{
    [_recorder updateMeters];
    double lowPassResults = pow(10, (0.05*[_recorder peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
    if (0<lowPassResults<=0.06) {
        _imageV_voice.image = [UIImage imageNamed:@"v1"];
    }else if(0.06<lowPassResults<=0.23){
        _imageV_voice.image = [UIImage imageNamed:@"v2"];
    }else if (0.23<lowPassResults<=0.30){
        _imageV_voice.image = [UIImage imageNamed:@"v3"];
    }else if (0.30<lowPassResults<=0.37){
        _imageV_voice.image = [UIImage imageNamed:@"v4"];
    }else if (0.37<lowPassResults<=0.48){
        _imageV_voice.image = [UIImage imageNamed:@"v5"];
    }else if (0.48<lowPassResults<=0.65){
        _imageV_voice.image = [UIImage imageNamed:@"v6"];
    }else{
        _imageV_voice.image = [UIImage imageNamed:@"v7"];
    }
    
}
#pragma mark----创建蒙版上面的视图
- (void)createMengBan{
    if (_voiceBackView == nil) {
        _voiceBackView = [[UIView alloc]init];
        _voiceBackView.bounds = CGRectMake(0, 0, 150, 150);
        _voiceBackView.center = self.view.center;
        _voiceBackView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        _voiceBackView.layer.cornerRadius = 3;
        _voiceBackView.layer.masksToBounds = YES;
        [self.view addSubview:_voiceBackView];
        //显示正在录音的label
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(0, 130, 150, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"正在录音中...", nil);
        label.textColor = [UIColor whiteColor];
        [_voiceBackView addSubview:label];
        //创建显示中间的喇叭
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"lababa"];
        imageView.frame = FRAME(30, 35, 40, 80);
        [_voiceBackView addSubview:imageView];
        //创建显示音量的波状图
        _imageV_voice = [[UIImageView alloc]init];
        _imageV_voice.frame = FRAME(90, 40, 30, 75);
        _imageV_voice.image = [UIImage imageNamed:@"v1"];
        [_voiceBackView addSubview:_imageV_voice];
    }

}
#pragma mark - 这是开启定时器一直去获取音量的方法
-(void)startGetVoice{
    if (_voiceTimer == nil) {
        _voiceTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImageWithVoice) userInfo:nil repeats:YES];
        [_voiceTimer fire];
    }
}
-(void)stopGetVoice{
    if (_voiceTimer) {
        [_voiceTimer invalidate];
        _voiceTimer = nil;
    }
}
#pragma mark - 这是开启定时器的方法
-(void)startTimer{
    _num_second = 0;
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [_timer fire];
//        _voiceTime.text = @"00:01";
    }
    
}
#pragma mark - 这是暂停计时器的方法
-(void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
//这是定时器的方法
-(void)onTimer{
//    _voiceTime.text = [NSString stringWithFormat:@"%d%d:%d%d",_num_second / 600,_num_second / 60,_num_second / 10,_num_second % 10];
        _num_second ++;
}
#pragma mark - 这是录音结束后保存录音的方法
-(void)reciveVoice{
    //停止获取音量的定时器
    [self stopGetVoice];
    //移除录音提示的蒙版
    NSLog(@"这是录音结束后保存录音的方法");
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                [self stopTimer];
                NSLog(@"这是结束长按的方法");
                if (_num_second <= 5||_num_second > 120) {
                    NSString * info = nil;
                    if (_num_second <= 5) {
                        info = NSLocalizedString(@"您的录音时间太短,请重新录入", nil);
                    }else{
                        info = NSLocalizedString(@"您的录音请在120秒内完成", nil);
                    }
                    [self creatViewWithNSString:info];
                    [self stopTimer];
                }else{
                    
                    if(_showCellImgBlock){
                        _showCellImgBlock(_num_second);
                    }
                    //获取一个全局并发队列
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        //停止录音
                        [_recorder stop];
                        [self.session setActive:NO error:nil];
                        //caf转化为MP3
                        [TranslateCafToMp3 translateCafToMp3WithTmpFile:self.tmpFile withMp3Url:self.mp3File withBlock:^(NSURL *mp3Url) {
                            self.mp3File = mp3Url;
                        }];
                        
                    });
                }
                
            }else{
                
            }
        }];
    }
    
}
#pragma mark - 这是长按说话的方法
-(void)longPressToSpeak{
    NSLog(@"这是长按说话的方法");
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                    [self startTimer];
                    //显示录音提示框
                    [self createMengBan];
                    //获取一个全局的并发队列
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        if (![self.recorder isRecording]) {
                            [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//设置类别,表示该应用同时支持播放和录音
                            [self.session setActive:YES error:nil];//启动音频会话管理,此时会阻断后台音乐的播放.
                            //准备记录录音
                            [_recorder prepareToRecord];
                            [_recorder peakPowerForChannel:0.0];
                            [_recorder record];
                            _recorder.meteringEnabled = YES;
                        }
                        
                    });
                    //获取音量变化
                    [self startGetVoice];
                
            }else {
                [self creatAlertViewWithString:NSLocalizedString(@"没有打开麦克风\n请在设置->应用列表->开启麦克风权限", nil)  withTag:1];
            }
        }];
        
    }
    
}

-(void)creatAlertViewWithString:(NSString * )string withTag:(NSInteger)tag{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:string preferredStyle:UIAlertControllerStyleAlert];
    if (tag == 0) {
        
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}
//
#pragma mark - 这是点击播放录音的方法
-(void)clickToPlayer{
    //如果语音正在播放,暂停
    if ([_player isPlaying]) {
        //[_imageAnnimation stopAnimating];
        if(_playEndBlock){
            _playEndBlock ();
        }
        [_player pause];
        return;
    }
    //如果语音不是在播放,开始播放
    //[_imageAnnimation startAnimating];
    if(_playBeginBlock){
        _playBeginBlock ();
    }
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.session setActive:YES error:nil];
    if (self.mp3File != nil) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.mp3File error:nil];
    }else if (self.tmpFile != nil){
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.tmpFile error:nil];
    }
    self.player.delegate = self;
    //开始播放
    [_player prepareToPlay];
    _player.volume = 1.0;
    [_player play];
    
}
//当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //按钮标题变为播放
    NSLog(@"结束播放了");
    [self.session setActive:NO error:nil];
    //[_imageAnnimation stopAnimating];
    if(_playEndBlock){
        _playEndBlock();
    }
}
#pragma mark - 这是展示没有更多数据的view
-(void)creatViewWithNSString:(NSString*)info{
    [self creatNewTimer];
    if (_viewReminder == nil) {
        _viewReminder = [UILabel new];
        _viewReminder.bounds =  CGRectMake(0,0, 150,40);
        _viewReminder.adjustsFontSizeToFitWidth = YES;
        _viewReminder.layer.cornerRadius = 2;
        _viewReminder.layer.masksToBounds = YES;
        _viewReminder.center = CGPointMake(self.view.center.x,self.view.center.y);
        _viewReminder.backgroundColor = [UIColor colorWithRed:0/255.0
                                                        green:0/255.0
                                                         blue:0/255.0
                                                        alpha:0.35];
        [self.view.superview addSubview:_viewReminder];
    }
    _viewReminder.hidden = NO;
    _viewReminder.text = info;
    _viewReminder.textColor = [UIColor whiteColor];
    _viewReminder.textAlignment = NSTextAlignmentCenter;
    _viewReminder.font = [UIFont systemFontOfSize:13];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _viewReminder.hidden = YES;
    });
}
//开启用来计算提醒显示时间的定时器
-(void)creatNewTimer{
    newNum = 0;
    if (_remindTimer == nil) {
        _remindTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onNewTimer) userInfo:nil repeats:YES];
        [_remindTimer fire];
    }
}
-(void)removeNewTimer{
    if(_remindTimer){
        [_remindTimer invalidate];
        _remindTimer = nil;
    }
}
-(void)onNewTimer{
    newNum ++;
    if (newNum == 2) {
        [_viewReminder removeFromSuperview];
        _viewReminder = nil;
        [self removeNewTimer];
    }
}

- (void)touch_BackView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recording" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playRecord" object:nil];
}
@end

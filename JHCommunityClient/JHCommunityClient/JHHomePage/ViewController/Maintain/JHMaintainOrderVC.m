//
//  JHHouseKeepingOrderVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHMaintainOrderVC.h"
#import "NSObject+CGSize.h"
#import <IQKeyboardManager.h>
#import "TranslateCafToMp3.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "MyTapGesture.h"
#import "JHMaintainOrderDetailVC.h"
#import "JHWaiMaiAddressVC.h"
#import "JHMaintainAssignPersonVC.h"
#import "TimeBnt.h"
 
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
#import "DisplayImageInView.h"
#import "JudgeToken.h"
#import "JHWMPayOrderVC.h"
#import "JHLoginVC.h"
#import "JHHMSelectButton.h"
#import "JHCreateOrderSheetView.h"
@interface JHMaintainOrderVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,AVAudioPlayerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,JHCreateOrderSheetViewDelegate>
{
    UITableView *_tableview;
    UITextField *_timeField;
    UITextField *_addressField;
    UITextField *_houseField;
    UITextField *_phoneField;
    UILabel *_assignPerson;
    UILabel *_moneyLabel;//定金
    UITextView *_textView;
    UILabel *_describelLabel;//请输入您的要求
    UIButton *_recordBnt;//录音按钮
    UIView *view_voice;//提示音量大小的图片
    UIImageView * imageV_voice;//显示不同的声音波状图
    UIImageView *_recordImg;//录音的图片
    NSTimer * voiceTimer;//开启定时器刷新音量大小的数据
    NSTimer * timer;//录音需要的定时器
    UIImageView * imageV;//显示录音的气泡的
    int num_second;//用来记录录音的时间的
    UILabel * label_time;//用来录制语音有多少秒
    UIImageView * imageAnnimation;//播放时的那个动画组
    UILabel * viewReminder;//用来提醒的
    NSTimer * newTimer;
    int newNum;
    NSMutableArray *_imgDataArray;
    NSMutableArray *_imgArray;
    UIImagePickerController *_imagePicker;
    UIButton *_addImgBnt;
    UIView *_showImgView;
    UIControl *_tapImgControl;
    UIControl *_timeControl;//时间蒙版
    UIScrollView *_timeScrollView;
    TimeBnt *_lastWeekBnt;
    NSInteger _currentIndex;
    NSMutableArray *_timeArray;
    UIButton *_lastTimeBnt;
    UIView *_backView;//时间背景视图
    //    UIImageView *_menBanImg;
    DisplayImageInView *_displayView;
}
@property(nonatomic,strong)JHCreateOrderSheetView *hongBaoSheet;
@property(nonatomic,strong)NSArray *hongbaoArr;
@property(nonatomic,copy)NSString *hongbao_id;
@property(nonatomic,copy)NSString *hongbao_amount;
@property(nonatomic,copy)NSString *hongbao_deduct_lable;
@end

@implementation JHMaintainOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hongbao_amount = @"0";
    self.hongbao_id = @"0";
    self.hongbaoArr = @[];
    [self getHongBaoArr:_cate_id];
    
    self.title = self.name;
    self.view.backgroundColor = BACK_COLOR;
    [self handleData];
    [self getTimeArray];
    [self createRecordBnt];
    [self createUI];
    [self creaeteBnt];
    [self initAVAudioAttributes];
    [JudgeToken judgeTokenWithVC:self withBlock:nil];
    
}
#pragma mark======初始化相关控件=====
- (void)handleData
{
    _timeArray = [NSMutableArray array];
    _imagePicker = [[UIImagePickerController alloc] init];
    _imgDataArray = [NSMutableArray array];
    _imgArray = [NSMutableArray array];
    _addImgBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addImgBnt setBackgroundImage:IMAGE(@"add") forState:UIControlStateNormal];
    [_addImgBnt addTarget:self action:@selector(addImg:) forControlEvents:UIControlEventTouchUpInside];
     _timeField = [[UITextField alloc] initWithFrame:FRAME(110, 0, WIDTH - 110 - 30, 40)];
    _addressField = [[UITextField alloc] initWithFrame:FRAME(110, 0, WIDTH - 110 - 30, 40)];
    _houseField = [[UITextField alloc] initWithFrame:FRAME(100, 0, WIDTH - 100 - 30, 40)];
    _phoneField = [[UITextField alloc] initWithFrame:FRAME(110, 0, WIDTH - 110, 40)];
    _assignPerson = [[UILabel alloc] initWithFrame:FRAME(110, 12, WIDTH - 30 - 110, 15)];
    _textView = [[UITextView alloc] init];
    _describelLabel = [[UILabel alloc] initWithFrame:FRAME(10, 10, 200, 10)];
    if(self.index == 1)
    {
        _assignPerson.text = NSLocalizedString(@"选择师傅,否则系统随机指定", nil);
    }
    else
    {
        _assignPerson.text = self.shiFuName;
    }
}
#pragma mark=====创建录音按钮========
- (void)createRecordBnt
{
    _recordBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordBnt.frame = FRAME(WIDTH - 55, 60, 30, 30);
    [_recordBnt setBackgroundImage:IMAGE(@"lab") forState:UIControlStateNormal];
    [_recordBnt addTarget:self action:@selector(reciveVoice) forControlEvents:UIControlEventTouchUpInside];
    [_recordBnt addTarget:self action:@selector(reciveVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_recordBnt addTarget:self action:@selector(longPressToSpeak) forControlEvents:UIControlEventTouchDown];
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
#pragma mark - 这是创建录音时正在录音的提示框
-(void)creatVoiceMengBan{
    if (view_voice == nil) {
        view_voice = [[UIView alloc]init];
        view_voice.bounds = CGRectMake(0, 0, 150, 150);
        view_voice.center = self.view.center;
        view_voice.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        view_voice.layer.cornerRadius = 3;
        view_voice.layer.masksToBounds = YES;
        [self.view addSubview:view_voice];
        //显示正在录音的label
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(0, 130, 150, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"正在录音中...", nil);
        label.textColor = [UIColor whiteColor];
        [view_voice addSubview:label];
        //创建显示中间的喇叭
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"lababa"];
        imageView.frame = FRAME(30, 35, 40, 80);
        [view_voice addSubview:imageView];
        //创建显示音量的波状图
        imageV_voice = [[UIImageView alloc]init];
        imageV_voice.frame = FRAME(90, 40, 30, 75);
        imageV_voice.image = [UIImage imageNamed:@"v1"];
        [view_voice addSubview:imageV_voice];
    }
}
#pragma mark - 这是识别音量的大小,从而显示不同的图片,来呈现出音量图波动
-(void)changeImageWithVoice{
    [_recorder updateMeters];
    double lowPassResults = pow(10, (0.05*[_recorder peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
    if (0<lowPassResults<=0.06) {
        imageV_voice.image = [UIImage imageNamed:@"v1"];
    }else if(0.06<lowPassResults<=0.23){
        imageV_voice.image = [UIImage imageNamed:@"v2"];
    }else if (0.23<lowPassResults<=0.30){
        imageV_voice.image = [UIImage imageNamed:@"v3"];
    }else if (0.30<lowPassResults<=0.37){
        imageV_voice.image = [UIImage imageNamed:@"v4"];
    }else if (0.37<lowPassResults<=0.48){
        imageV_voice.image = [UIImage imageNamed:@"v5"];
    }else if (0.48<lowPassResults<=0.65){
        imageV_voice.image = [UIImage imageNamed:@"v6"];
    }else{
        imageV_voice.image = [UIImage imageNamed:@"v7"];
    }
}
#pragma mark - 这是开启定时器一直去获取音量的方法
-(void)startGetVoice{
    if (voiceTimer == nil) {
        voiceTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImageWithVoice) userInfo:nil repeats:YES];
        [voiceTimer fire];
    }
}
-(void)stopGetVoice{
    if (voiceTimer) {
        [voiceTimer invalidate];
        voiceTimer = nil;
    }
}
#pragma mark - 这是长按说话的方法
-(void)longPressToSpeak{
    NSLog(@"这是长按说话的方法");
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                if (imageV == nil) {
                    [self startTimer];
                    //显示录音提示框
                    [self creatVoiceMengBan];
                    //获取一个全局的并发队列
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    //将任务加到队列中
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
                }else{
                    [self creatAlertViewWithString:NSLocalizedString(@"您确定要重新录入语音", nil) withTag:0];
                }
                
            }else {
                [self creatAlertViewWithString:NSLocalizedString(@"没有打开麦克风\n请在设置->应用列表->开启麦克风权限", nil)  withTag:1];
            }
        }];
        
    }
    
}
#pragma mark - 这是录音结束后保存录音的方法
-(void)reciveVoice{
    //停止获取音量的定时器
    [self stopGetVoice];
    //移除录音提示的蒙版
    [self removeVoiceMengBan];
    NSLog(@"这是录音结束后保存录音的方法");
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                [self stopTimer];
                NSLog(@"这是结束长按的方法");
                if (num_second <= 1||num_second > 60) {
                    NSString * info = nil;
                    if (num_second <= 1) {
                        info = NSLocalizedString(@"您的录音时间太短,请重新录入", nil);
                    }else{
                        info = NSLocalizedString(@"您的录音请在一分钟内完成", nil);
                    }
                    [self creatViewWithNSString:info];
                    [self stopTimer];
                }else{
                    if(imageV == nil&& label_time== nil){
                        imageV = [[UIImageView alloc]init];
                        UITableViewCell * cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                        imageV.image = [UIImage imageNamed:@"newyuyin"];
                        [cell addSubview:imageV];
                        imageV.frame = FRAME(WIDTH - 180, 60, 120, 30);
                        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToPlayer)];
                        imageV.userInteractionEnabled = YES;
                        [imageV addGestureRecognizer:tapGestureRecognizer];
                        UILongPressGestureRecognizer * longGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longToRemoveImageV)];
                        [imageV addGestureRecognizer:longGestureRecognizer];
                        label_time = [[UILabel alloc]init];
                        label_time.textAlignment = NSTextAlignmentCenter;
                        label_time.text = [NSString stringWithFormat:@"%ds",num_second];
                        label_time.font = [UIFont systemFontOfSize:14];
                        label_time.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                        label_time.frame = FRAME(WIDTH -200, 60, 20, 30);
                        imageAnnimation = [[UIImageView alloc]init];
                        imageAnnimation.image = [UIImage imageNamed:@"sy_1"];
                        imageAnnimation.animationImages = [NSArray arrayWithObjects:
                                                           [UIImage imageNamed:@"sy_3"],
                                                           [UIImage imageNamed:@"sy_2"],
                                                           [UIImage imageNamed:@"sy_1"],nil];
                        imageAnnimation.animationDuration = 1;
                        imageAnnimation.animationRepeatCount = 0;
                        [cell addSubview:label_time];
                        [cell addSubview:imageAnnimation];
                        imageAnnimation.frame = FRAME(WIDTH - 100, 65, 15, 20);
                    }
                    //获取一个全局的并发队列
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    //将任务加到队列中
                    dispatch_async(queue, ^{
                        //停止录音
                        [_recorder stop];
                        [self.session setActive:NO error:nil];
                        //caf转化为MP3
                        [TranslateCafToMp3 translateCafToMp3WithTmpFile:self.tmpFile withMp3Url:self.mp3File withBlock:^(NSURL *mp3Url){
                            self.mp3File = mp3Url;
                        }];
                    });
              }
            }else{
                
            }
        }];
    }
}
#pragma mark - 这是开启定时器的方法
-(void)startTimer{
    num_second = 0;
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [timer fire];
    }
}
#pragma mark - 这是暂停计时器的方法
-(void)stopTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
//这是定时器的方法
-(void)onTimer{
    num_second ++;
}

#pragma mark - 这是结束录音后删除录音提示的方法
-(void)removeVoiceMengBan{
    [view_voice removeFromSuperview];
    view_voice = nil;
}
-(void)creatAlertViewWithString:(NSString * )string withTag:(NSInteger)tag{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:string preferredStyle:UIAlertControllerStyleAlert];
    if (tag == 0) {
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"你点击了取消");
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            [imageV removeFromSuperview];
            [label_time removeFromSuperview];
            [imageAnnimation removeFromSuperview];
            label_time = nil;
            imageV = nil;
            imageAnnimation = nil;
            num_second = 0;
            NSString *mp3FilePath = [NSTemporaryDirectory() stringByAppendingString:@"NewMp3.mp3"];//存储mp3文件的路径
            NSString * tmpFilePath = [NSTemporaryDirectory() stringByAppendingString:@"recoder.caf"];
            NSFileManager * fileManager = [NSFileManager defaultManager];
            if ([fileManager removeItemAtPath:mp3FilePath error:nil]&&[fileManager removeItemAtPath:tmpFilePath error:nil]) {
                NSLog(@"删除");
            }
        }]];
        
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 这是长按后显示是否要删除录音内容的提示框
-(void)longToRemoveImageV{
    NSLog(@"这是长按后显示是否要删除录音内容的提示框");
    if (imageV != nil) {
        [self creatAlertViewWithString:NSLocalizedString(@"您确定要删除语音", nil) withTag:0];
    }else{
    }
}
#pragma mark - 这是点击播放录音的方法
-(void)clickToPlayer{
    //如果语音正在播放,暂停
    if ([_player isPlaying]) {
        [imageAnnimation stopAnimating];
        [_player pause];
        return;
    }
    //如果语音不是在播放,开始播放
    [imageAnnimation startAnimating];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.session setActive:YES error:nil];
    if (self.mp3File != nil) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.mp3File error:nil];
    }
    else if (self.tmpFile != nil){
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
    [imageAnnimation stopAnimating];
}
//开启用来计算提醒显示时间的定时器
-(void)creatNewTimer{
    newNum = 0;
    if (newTimer == nil) {
        newTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onNewTimer) userInfo:nil repeats:YES];
        [newTimer fire];
    }
}
-(void)removeNewTimer{
    if(newTimer){
        [newTimer invalidate];
        newTimer = nil;
    }
}
-(void)onNewTimer{
    newNum ++;
    if (newNum == 2) {
        [viewReminder removeFromSuperview];
        viewReminder = nil;
        [self removeNewTimer];
    }
}

#pragma mark====创建提交按钮========
- (void)creaeteBnt
{
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, HEIGHT - 50, WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = HEX(@"fc7400", 1.0f);
    _moneyLabel.font = FONT(14);
    NSString *string = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"定金:", nil),self.start];
    NSRange range = [string rangeOfString:NSLocalizedString(@"定金:", nil)];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:range];
    _moneyLabel.text = string;
    CGSize size = [self currentSizeWithString:_moneyLabel.text font:FONT(14) withWidth:0];
    _moneyLabel.frame = FRAME(10,20, size.width, 10);
    _moneyLabel.attributedText = attribute;
    [view addSubview:_moneyLabel];
    UIButton *submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBnt.frame = FRAME(WIDTH - 110, 7.5, 100, 35);
    [submitBnt setTitle:NSLocalizedString(@"提交订单", nil) forState:UIControlStateNormal];
    [submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBnt.layer.cornerRadius = 4.0f;
    submitBnt.clipsToBounds = YES;
    submitBnt.titleLabel.font = FONT(14);
    [submitBnt setBackgroundColor:HEX(@"fc7400", 1.0f) forState:UIControlStateNormal];
    [submitBnt setBackgroundColor:HEX(@"ff5500", 1.0f) forState:UIControlStateHighlighted];
    [submitBnt addTarget:self action:@selector(submitOrderBnt) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitBnt];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [view addSubview:thread];
}
#pragma mark======提交订单按钮点击事件======
- (void)submitOrderBnt
{
    NSLog(@"提交订单了");
    
    if(_timeField.text.length == 0 || _addressField.text.length == 0 || _houseField.text.length == 0 || _phoneField.text.length == 0 )
    {
        [self showAlertView:NSLocalizedString(@"亲,请完善订单相关信息哦", nil)];
    }
    else if (_textView.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"请输入你的要求", nil)];
    }
    else
    {
        NSString *timeStr = [NSString stringWithFormat:@"%@ 09:00",_timeArray[self.weekAndDayIndex - 101][@"year"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate *selectDate = [formatter dateFromString:timeStr];
        double selectDateTime = [selectDate timeIntervalSince1970];
        selectDateTime += self.timeIndex * 3600;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@(1) forKey:@"city_id"];
        [dic setObject:self.cate_id forKey:@"cate_id"];
        [dic setObject:self.addr_id forKey:@"addr_id"];
        [dic setObject:_textView.text forKey:@"intro"];
        [dic setObject:self.start forKey:@"danbao_amount"];
        [dic setObject:self.hongbao_id forKey:@"hongbao_id"];
        [dic setObject:@(selectDateTime) forKey:@"fuwu_time"];
        if(self.staff_id.length != 0)
        {
            [dic setObject:self.staff_id forKey:@"staff_id"];
        }
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        if(_imgDataArray.count != 0)
        {
            for(int i = 0; i < _imgDataArray.count ; i++)
            {
                [dataDic setObject:_imgDataArray[i] forKey:[NSString stringWithFormat:@"photo%d",i + 1]];
            }
            
        }
        NSData *dataVoice = nil;
         dataVoice = [NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingString:@"NewMp3.mp3"]];
        if (dataVoice.length != 0) {
            [dataDic setObject:dataVoice forKey:@"voice"];
            [dic setObject:@(num_second) forKey:@"voice_time"];
        }
        NSLog(@"%@",dic);
        SHOW_HUD
        [HttpTool postWithAPI:@"client/weixiu/order/create" params:dic dataDic:dataDic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"])
            {
                HIDE_HUD
                //[self showAlertView:NSLocalizedString(@"订单提交成功", nil)];
                //跳转到支付界面
                JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
                vc.order_id = json[@"data"][@"order_id"];
                 vc.amount = [NSString stringWithFormat:@"%g",[self.start floatValue] - [self.hongbao_amount floatValue]];
                vc.isWeiXiu = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                HIDE_HUD
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"订单提交失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
        
    }
}
#pragma mark====搭建UI界面=========
- (void)createUI
{
    _tableview = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50) style:UITableViewStyleGrouped];
    _tableview.delegate  = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.backgroundColor = BACK_COLOR;
    [self.view addSubview:_tableview];
}
#pragma mark=======UITableViewDelegate=============
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else if (section == 1)
        return 6;
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 20, 50, 50)];
        iconImg.contentMode = UIViewContentModeScaleAspectFill;
        iconImg.clipsToBounds = YES;
        NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:self.imgUrl]];
        [iconImg sd_image:url plimage:IMAGE(@"house&maintainservice")];
        [cell.contentView addSubview:iconImg];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:FRAME(70, 20, WIDTH - 100, 10)];
        nameLabel.text = self.name;
        nameLabel.font = FONT(14);
        nameLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:nameLabel];
//        UILabel *priceLbael = [[UILabel alloc] initWithFrame:FRAME(70, 50, WIDTH - 100, 10)];
//        priceLbael.text = [NSString stringWithFormat:NSLocalizedString(@"计价方式:%@元/%@", nil),self.price,self.unit];
//        priceLbael.font = FONT(14);
//        priceLbael.textColor = HEX(@"999999", 1.0f);
//        [cell.contentView addSubview:priceLbael];
        UILabel *areaLabel = [[UILabel alloc] initWithFrame:FRAME(70, 50, WIDTH - 100, 10)];
        areaLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@元起", nil),self.start];
        areaLabel.font = FONT(14);
        areaLabel.textColor = HEX(@"999999", 1.0f);
        [cell.contentView addSubview:areaLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 89.5, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread];
        return cell;
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 11.5, 15, 15)];
                iconImg.image = IMAGE(@"time");
                [cell.contentView addSubview:iconImg];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 13, 70, 15)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.text = NSLocalizedString(@"服务时间", nil);
                [cell.contentView addSubview:titleLabel];
                _timeField.placeholder = NSLocalizedString(@"请选择详细时间", nil);
                _timeField.font = FONT(14);
                _timeField.enabled = NO;
                _timeField.textColor = HEX(@"f85357", 1.0f);
                [_timeField setValue:HEX(@"f85357", 1.0f) forKeyPath:@"_placeholderLabel.textColor"];
                [cell.contentView addSubview:_timeField];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
                thread1.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread1];
                UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread2.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread2];
                return cell;
            }
                break;
            case 1:{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 11.5, 15, 15)];
                iconImg.image = IMAGE(@"address");
                [cell.contentView addSubview:iconImg];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 13, 70, 12)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.text = NSLocalizedString(@"服务地址", nil);
                [cell.contentView addSubview:titleLabel];
                
                _addressField.placeholder = NSLocalizedString(@"请选择服务地址", nil);
                _addressField.font = FONT(14);
                _addressField.enabled = NO;
                [cell.contentView addSubview:_addressField];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                return cell;
            }
                break;
            case 2:{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 11.5, 15, 15)];
                iconImg.image = IMAGE(@"door");
                [cell.contentView addSubview:iconImg];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 13, 60, 12)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.text = NSLocalizedString(@"门牌号", nil);
                [cell.contentView addSubview:titleLabel];
               
                _houseField.placeholder = NSLocalizedString(@"请输入具体地址", nil);
                _houseField.font = FONT(14);
                _houseField.delegate = self;
                [cell.contentView addSubview:_houseField];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                return cell;
            }
                break;
            case 3:{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 11.5, 15, 15)];
                iconImg.image = IMAGE(@"phone");
                [cell.contentView addSubview:iconImg];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 13, 70, 12)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.text = NSLocalizedString(@"联系方式", nil);
                [cell.contentView addSubview:titleLabel];
                
                _phoneField.placeholder = NSLocalizedString(@"请输入手机号码", nil);
                _phoneField.font = FONT(14);

                _phoneField.delegate = self;
                _phoneField.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:_phoneField];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                return cell;
            }
                break;
            case 4:{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 11.5, 15, 15)];
                iconImg.image = IMAGE(@"name");
                [cell.contentView addSubview:iconImg];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 13, 100, 12)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.text = NSLocalizedString(@"系统指派人员", nil);
                [cell.contentView addSubview:titleLabel];
                _assignPerson.textAlignment = NSTextAlignmentRight;
                _assignPerson.font = FONT(12);
                _assignPerson.textColor = HEX(@"f85357", 1.0f);
                [cell.contentView addSubview:_assignPerson];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                return cell;
            }
                break;
            default:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIImageView *iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 11.5, 15, 15)];
                iconImg.image = IMAGE(@"name");
                [cell.contentView addSubview:iconImg];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 13, 80, 12)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.text = NSLocalizedString(@"红包抵扣", nil);
                [cell.contentView addSubview:titleLabel];
                
                UILabel *amountLab = [UILabel new];
                [cell.contentView addSubview:amountLab];
                [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset=0;
                    make.centerY.offset=0;
                    make.height.offset=20;
                }];
                amountLab.font = FONT(14);
                amountLab.textColor = HEX(@"f85357", 1.0f);
                amountLab.textAlignment = NSTextAlignmentRight;
                
//                if(self.hongbaoArr.count == 0){
//                    amountLab.text =  NSLocalizedString(@"暂无可用红包", NSStringFromClass([self class]));
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }else{
//                    if([self.hongbao_amount floatValue] == 0){
//                        amountLab.text =  NSLocalizedString(@"未选择红包", NSStringFromClass([self class]));
//                    }else{
                        amountLab.text = [NSString stringWithFormat:@"%@",self.hongbao_deduct_lable];
//                    }
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                }
                
                cell.contentView.backgroundColor = [UIColor whiteColor];

                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                return cell;
            }
                break;
                

        }
        
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIView *view= [[UIView alloc] init];
        view.frame = FRAME(10, 0, WIDTH - 20, 100);
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = LINE_COLOR.CGColor;
        view.layer.borderWidth = 0.5f;
        [cell.contentView addSubview:view];
        
        _textView.frame =  FRAME(0, 0, WIDTH - 20, 60);
        _textView.textColor = HEX(@"666666", 1.0f);
        //        _textView.backgroundColor = HEX(@"999999", 0.1f);
        //        _textView.layer.cornerRadius = 4.0f;
        _textView.delegate = self;
        _textView.showsVerticalScrollIndicator = NO;
        [view addSubview:_textView];
        
        _describelLabel.text = NSLocalizedString(@"请输入您的要求", nil);
        _describelLabel.textColor = HEX(@"999999", 1.0f);
        _describelLabel.font = FONT(14);
        [_textView addSubview:_describelLabel];
        [view addSubview:_recordBnt];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenDescribel) name:UITextViewTextDidBeginEditingNotification object:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACK_COLOR;
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread1.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread1];
        UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 89.5, WIDTH, 0.5)];
        thread2.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread2];
        _showImgView = [[UIView alloc] initWithFrame:FRAME(0, 15, WIDTH, 60)];
        if(_imgArray.count == 0)
        {
            
        }
        else
        {
            for(int i = 0; i < _imgArray.count;i++)
            {
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(50 *i + 10, 10, 40, 40)];
                img.userInteractionEnabled = YES;
                MyTapGesture *tapImage = [[MyTapGesture alloc] initWithTarget:self action:@selector(tapImage:)];
                tapImage.tag = i + 1;
                [img addGestureRecognizer:tapImage];
                img.image = _imgArray[i];
                [_showImgView addSubview:img];
            }
        }
        _addImgBnt.frame = FRAME(10 + (_imgArray.count) *50, 10, 40, 40);
        [_showImgView addSubview:_addImgBnt];
        [cell.contentView addSubview:_showImgView];
        return cell;
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 90;
    }else if(indexPath.section == 1){
        return 40;
    }else if(indexPath.section == 2){
        return 100;
    }
    else{
        return 90;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 3){
        return 0.1;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        JHMaintainOrderDetailVC *detail = [[JHMaintainOrderDetailVC alloc] init];
        detail.name = [NSString stringWithFormat:NSLocalizedString(@"%@详情", nil),self.name];
        detail.price = self.price;
        detail.unit = self.unit;
        detail.cate_id = self.cate_id;
        detail.start = self.start;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [self createTimeMenBan];
        }
        else if(indexPath.row == 1)
        {
            JHWaiMaiAddressVC *list = [[JHWaiMaiAddressVC alloc] init];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if(token){
                
                
                list.selectorBlock = ^(JHWaimaiMineAddressListDetailModel *model) {
                    _addressField.text = model.addr;
                    _houseField.text = model.house;
                    _phoneField.text = model.mobile;
                    self.addr_id = model.addr_id;
                    if(_houseField.text.length != 0){
                        _houseField.userInteractionEnabled = NO;
                    }else{
                        _houseField.userInteractionEnabled = YES;
                    }
                };
                
                [self.navigationController pushViewController:list animated:YES];
                
                
                
            }
            else{
                [self showAlert:NSLocalizedString(@"您还未登录,请登录", nil)];
            }        }
        else if(indexPath.row == 4)
        {
            JHMaintainAssignPersonVC *assignPerson = [[JHMaintainAssignPersonVC alloc] init];
            assignPerson.staff_id = self.staff_id;
            assignPerson.cate_id = self.cate_id;
            assignPerson.myBlock = ^(NSString *staff_id,NSString *name)
            {
                self.shiFuName = name;
                _assignPerson.text = self.shiFuName;
                self.staff_id = staff_id;
                _assignPerson.text = name;
            };
            [self.navigationController pushViewController:assignPerson animated:YES];
        }else if(indexPath.row == 5)
        {
            if (self.hongbaoArr.count == 0) {
                return;
            }
            self.hongBaoSheet.dataSource = self.hongbaoArr;
            self.hongBaoSheet.hongbao_id = self.hongbao_id;
            [self.hongBaoSheet sheetShow];
            
        }
    }
}
#pragma mark=====UITextFieldDelegate=======
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
#pragma mark====隐藏Describel=======
- (void)hiddenDescribel
{
    _describelLabel.hidden = YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
        if(_textView.text.length == 0){
            _describelLabel.hidden = NO;
        }else{
            _describelLabel.hidden = YES;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark=====UITextViewDelegate========
- (void)textViewDidChange:(UITextView *)textView
{
    if(_textView.text.length > 100){
        [_textView resignFirstResponder];
    }else{
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
}
#pragma mark - 这是展示没有更多数据的view
-(void)creatViewWithNSString:(NSString*)info{
    [self creatNewTimer];
    if (viewReminder == nil) {
        viewReminder = [UILabel new];
        viewReminder.bounds =  CGRectMake(0,0, 150,40);
        viewReminder.adjustsFontSizeToFitWidth = YES;
        viewReminder.layer.cornerRadius = 2;
        viewReminder.layer.masksToBounds = YES;
        viewReminder.center = CGPointMake(self.view.center.x,self.view.center.y);
        viewReminder.backgroundColor = [UIColor colorWithRed:0/255.0
                                                       green:0/255.0
                                                        blue:0/255.0
                                                       alpha:0.35];
        [self.view.superview addSubview:viewReminder];
    }
    viewReminder.hidden = NO;
    viewReminder.text = info;
    viewReminder.textColor = [UIColor whiteColor];
    viewReminder.textAlignment = NSTextAlignmentCenter;
    viewReminder.font = [UIFont systemFontOfSize:13];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        viewReminder.hidden = YES;
    });
}
#pragma mark========创建添加图片按钮===============
- (void)createAddImgBnt
{
    
    _addImgBnt.frame = FRAME(10 + (_imgDataArray.count) *50, 10, 40, 40);
    if(_imgDataArray.count == 4)
    {
        [_addImgBnt removeFromSuperview];
    }
}
#pragma mark======添加照片的点击事件==========
- (void)addImg:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消了");
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imageFromCamera];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从手机相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imageFromAlbum];
    }];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark=========相册中选择=========
- (void)imageFromAlbum
{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma mark=========打开相机=========
- (void)imageFromCamera
{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma  mark - 这是UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"哈哈");
}
#pragma  mark=======选择照片================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newImage = [self scaleToSize:editImage size:CGSizeMake(800, 800)];
    NSData   *data = UIImagePNGRepresentation(newImage);
    [_imgDataArray addObject:data];
    [_imgArray addObject:newImage];
    //将图片放到屏幕上
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = _imgArray[_imgArray.count-1];
    imageView.tag   = 100 + _imgArray.count;
    imageView.userInteractionEnabled = YES;
    MyTapGesture *tapImage = [[MyTapGesture alloc] initWithTarget:self action:@selector(tapImage:)];
    tapImage.tag = (int)_imgArray.count;
    [imageView addGestureRecognizer:tapImage];
    //imageView.image = IMAGE(@"add");
    imageView.frame = CGRectMake(50 *(_imgArray.count - 1) + 10, 10, 40, 40);
    // 内容模式
    imageView.clipsToBounds = YES;
    imageView.contentMode   = UIViewContentModeScaleAspectFill;
    [_showImgView addSubview:imageView];
    [self createAddImgBnt];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark==============
- (void)tapImage:(MyTapGesture *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消了");
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"查看原图", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(_displayView == nil)
        {
            _displayView = [[DisplayImageInView alloc] init];
            [ _displayView showInViewWithImageArray:_imgArray withIndex:sender.tag withBlock:^{
                [_displayView removeFromSuperview];
                _displayView = nil;
            }];
        }
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除图片", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_imgArray removeObjectAtIndex:sender.tag - 1];
        [_imgDataArray removeObjectAtIndex:sender.tag - 1];
        NSArray *indexPath = @[[NSIndexPath indexPathForRow:0 inSection:3]];
        [_tableview reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark  压缩图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
#pragma mark===============点击取消调用========
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark========创建时间选择蒙版========
- (void)createTimeMenBan
{
    _timeControl = [[UIControl alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    [_timeControl addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    _timeControl.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2];
    [self.view addSubview:_timeControl];
    _backView = [[UIView alloc] init];
    if(WIDTH > 320){
        _backView.frame =  FRAME(0, HEIGHT - 220, WIDTH, 220);//增加30
    }else{
        _backView.frame =  FRAME(0, HEIGHT - 260, WIDTH, 260);//增加40
    }
    _backView.backgroundColor = [UIColor whiteColor];
    [_timeControl addSubview:_backView];
    UIView *weekView = [[UIView alloc] initWithFrame:FRAME(0, 0,WIDTH, 50)];
    weekView.backgroundColor = HEX(@"f5f5f5", 0.5f);
    [_backView addSubview:weekView];
    for(int i = 0; i < 2;i ++)
    {
        UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            bnt.frame = FRAME(10, 15, 10, 20);
            [bnt setBackgroundImage:IMAGE(@"left_time") forState:UIControlStateNormal];
        }
        else
        {
            bnt.frame = FRAME(WIDTH - 20, 15, 10, 20);
            [bnt setBackgroundImage:IMAGE(@"right_time") forState:UIControlStateNormal];
        }
        bnt.tag = i + 1;
        [bnt addTarget:self action:@selector(clickLeftAndRightTimeBnt:) forControlEvents:UIControlEventTouchUpInside];
        [weekView addSubview:bnt];
    }
    _timeScrollView = [[UIScrollView alloc] initWithFrame:FRAME(20, 0, WIDTH - 40, 50)];
    _timeScrollView.backgroundColor = HEX(@"f5f5f5", 0.1f);
    _timeScrollView.pagingEnabled = YES;
    _timeScrollView.showsVerticalScrollIndicator = NO;
    _timeScrollView.showsHorizontalScrollIndicator = NO;
    _timeScrollView.bounces = NO;
    _timeScrollView.delegate = self;
    [weekView addSubview:_timeScrollView];
    for(int i = 0; i < 7; i++)
    {
        TimeBnt *bnt = [[TimeBnt alloc] initWithFrame:FRAME(10 + i * (WIDTH - 40)/5, 5, 40, 40)];
        bnt.tag = 101 + i;
        [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [bnt addTarget:self action:@selector(clickWeek:) forControlEvents:UIControlEventTouchUpInside];
        [_timeScrollView addSubview:bnt];
        if(i == 0)
        {
            bnt.weekLabel.text = NSLocalizedString(@"今天", nil);
        }else{
            NSDictionary *dic = _timeArray[i];
            switch ([dic[@"weekday"] integerValue]) {
                case 1:
                    bnt.weekLabel.text = NSLocalizedString(@"星期日", nil);
                    break;
                case 2:
                    bnt.weekLabel.text = NSLocalizedString(@"星期一", nil);
                    break;
                case 3:
                    bnt.weekLabel.text = NSLocalizedString(@"星期二", nil);
                    break;
                case 4:
                    bnt.weekLabel.text = NSLocalizedString(@"星期三", nil);
                    break;
                case 5:
                    bnt.weekLabel.text = NSLocalizedString(@"星期四", nil);
                    break;
                case 6:
                    bnt.weekLabel.text = NSLocalizedString(@"星期五", nil);
                    break;
                default:
                    bnt.weekLabel.text = NSLocalizedString(@"星期六", nil);
                    break;
            }
        }
        NSDictionary *dic = _timeArray[i];
        bnt.dayLabel.text = [NSString stringWithFormat:@"%@-%@",dic[@"month"],dic[@"day"]];
        if(i == 0)
        {
            bnt.selected = YES;
            bnt.weekLabel.textColor = THEME_COLOR;
            bnt.dayLabel.textColor = THEME_COLOR;
            _lastWeekBnt = bnt;
            _weekAndDayIndex = bnt.tag;
        }
    }
    _timeScrollView.contentSize = CGSizeMake(20 + 7 * (WIDTH - 40) / 5, 50);
    _currentIndex = 0;
    [self canSelectTime];
    UIView *thread = [[UIView alloc] init];
    if(WIDTH > 320){
        thread.frame = FRAME(0, 180, WIDTH, 0.5);
    }else{
        thread.frame = FRAME(0, 220, WIDTH, 0.5);
    }
    thread.backgroundColor = LINE_COLOR;
    [_backView addSubview:thread];
    UILabel *middleLine =[UILabel new];
    middleLine.backgroundColor = LINE_COLOR;
    [_backView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = (WIDTH - 1) / 2;
        make.width.offset = 1;
        make.bottom.offset = 0;
        make.height.offset = 40;
    }];
    for(int i = 0; i < 2;i ++)
    {
        UIButton *bnt = [UIButton new];
        [_backView addSubview:bnt];
        if(i == 0)
        {
            [bnt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset = 0;
                make.width.offset = (WIDTH - 1) / 2;
                make.bottom.offset = 0;
                make.height.offset = 40;
            }];
            [bnt setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
            [bnt setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f] forState:UIControlStateNormal];
            [bnt setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0f] forState:UIControlStateNormal];
        }else{
            [bnt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset = 0;
                make.width.offset = (WIDTH - 1) / 2;
                make.bottom.offset = 0;
                make.height.offset = 40;
            }];
            [bnt setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
            [bnt setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [bnt setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0f] forState:UIControlStateNormal];
        }
        bnt.layer.cornerRadius = 4.0f;
        bnt.clipsToBounds = YES;
        bnt.tag = i + 1;
        [bnt addTarget:self action:@selector(cancelAndCertain:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark======时间是否能选择========
- (void)canSelectTime
{
    CGFloat space1 = (WIDTH - 20 - 4 * 85) / 3;
    CGFloat space2 = (WIDTH - 20 - 3 * 85) / 3;
    NSArray *titles = @[@"9:00-10:00",@"10:00-11:00",@"11:00-12:00",@"12:00-13:00",@"13:00-14:00",@"14:00-15:00",@"15:00-16:00",@"16:00-17:00",@"17:00-18:00",@"18:00-19:00",@"19:00-20:00"];
    for(int i = 0; i < 11; i ++)
    {
        JHHMSelectButton *bnt = [[JHHMSelectButton alloc] init];
        if(WIDTH > 320){
            bnt.frame = FRAME(10 + i % 4 * (85 + space1) , 60 + i / 4 * 40, 85, 30);
        }else{
            bnt.frame = FRAME(10 + i % 3 * (85 + space2) , 60 + i / 3 * 40, 85, 30);
        }
        bnt.tag = i + 1000;
        bnt.title.text = titles[i];
        [_backView addSubview:bnt];
        [bnt addTarget:self action:@selector(timeBnt:) forControlEvents:UIControlEventTouchUpInside];
        
        if(_weekAndDayIndex - 101 == 0)
        {
            NSDate *date = [NSDate date];
            float dateTime = [date timeIntervalSince1970];
            NSString *timeStr = [NSString stringWithFormat:@"%@ 09:00",_timeArray[0][@"year"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSDate *selectDate = [formatter dateFromString:timeStr];
            float selectDateTime = [selectDate timeIntervalSince1970];
            selectDateTime += i * 3600;
            if(dateTime > selectDateTime){
                bnt.userInteractionEnabled = NO;
            }else{
                bnt.userInteractionEnabled = YES;
            }
        }else{
            bnt.userInteractionEnabled = YES;
            
        }
    }
    
}
#pragma mark======服务时间蒙版下面的取消和确定按钮==========
- (void)cancelAndCertain:(UIButton *)sender
{
    if(sender.tag == 1)
    {
        [_timeControl removeFromSuperview];
    }else{
        NSDictionary *dic = _timeArray[_weekAndDayIndex - 101];
        NSString *str = nil;
        switch ([dic[@"weekday"] integerValue]) {
            case 1:
                str = NSLocalizedString(@"星期日", nil);
                break;
            case 2:
                str = NSLocalizedString(@"星期一", nil);
                break;
            case 3:
                str = NSLocalizedString(@"星期二", nil);
                break;
            case 4:
                str = NSLocalizedString(@"星期三", nil);
                break;
            case 5:
                str = NSLocalizedString(@"星期四", nil);
                break;
            case 6:
                str = NSLocalizedString(@"星期五", nil);
                break;
            default:
                str = NSLocalizedString(@"星期六", nil);
                break;
        }
        if(_selectTime.length == 0)
        {
            [self showAlertView:NSLocalizedString(@"请选择时间", nil)];
        }else{
            if(_weekAndDayIndex - 101 == 0)
            {
                NSDate *date = [NSDate date];
                float dateTime = [date timeIntervalSince1970];
                NSString *timeStr = [NSString stringWithFormat:@"%@ 09:00",_timeArray[0][@"year"]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                NSDate *selectDate = [formatter dateFromString:timeStr];
                float selectDateTime = [selectDate timeIntervalSince1970];
                selectDateTime += 10 * 3600;
                if(dateTime > selectDateTime)
                {
                    [self showAlertView:NSLocalizedString(@"抱歉,服务时间已满", nil)];
                    return;
                }
                else
                {
                    _seriverTime = [NSString stringWithFormat:NSLocalizedString(@"%@今天%@", nil),dic[@"year"],_selectTime];
                }
            }
            else
            {
                _seriverTime = [NSString stringWithFormat:NSLocalizedString(@"%@%@%@", nil),dic[@"year"],str,_selectTime];
            }
            _timeField.text = _seriverTime;
            [_timeControl removeFromSuperview];
        }
        
    }
    
}
#pragma mark=====底部时间按钮点击事件=======
- (void)timeBnt:(JHHMSelectButton *)sender
{
    if(_lastTimeBnt != nil){
        _lastTimeBnt.selected = NO;
    }
    sender.selected = YES;
    _lastTimeBnt = sender;
    self.timeIndex = sender.tag - 1000;
    _selectTime = sender.title.text;
}
#pragma mark======获取从今天开始的一周时间=======
- (void)getTimeArray
{
    NSDate *date = [NSDate date];
    NSInteger interval = 0;
    for(int i = 0; i<7; i++)
    {
        if(i == 0){
            interval += 0;
        }else{
            interval += 24 * 60 * 60;
        }
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString *  locationString =[dateformatter stringFromDate:localeDate];
        NSLog(@"%@",date);
        NSLog(@"locationString:%@",localeDate);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday;
        comps = [calendar components:unitFlags fromDate:localeDate];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@([comps weekday]) forKey:@"weekday"];
        [dic setObject:@([comps month]) forKey:@"month"];
        [dic setObject:@([comps day]) forKey:@"day"];
        [dic setObject:locationString forKey:@"year"];
        [_timeArray addObject:dic];
    }
    NSLog(@"%@",_timeArray);
    
}
#pragma mark=====一周按钮点击事件=============
- (void)clickWeek:(TimeBnt *)sender
{
    if(_lastWeekBnt != nil)
    {
        _lastWeekBnt.selected = NO;
        _lastWeekBnt.weekLabel.textColor = HEX(@"666666", 1.0f);
        _lastWeekBnt.dayLabel.textColor = HEX(@"999999", 1.0f);
    }
    sender.selected = YES;
    sender.weekLabel.textColor = THEME_COLOR;
    sender.dayLabel.textColor = THEME_COLOR;
    _lastWeekBnt = sender;
    _currentIndex = sender.tag - 101;
    if(_currentIndex > 3)
    {
        [_timeScrollView setContentOffset:CGPointMake((WIDTH - 40) / 5 * 2 , 0) animated:YES];
    }
    _weekAndDayIndex = sender.tag;
    [self canSelectTime];
}
#pragma mark==========时间左键和右键按钮点击事件============
- (void)clickLeftAndRightTimeBnt:(TimeBnt *)sender
{
    if(sender.tag == 2)
    {
        
        if(_currentIndex < 6)
        {
            _currentIndex ++;
            for(int i = 0;i < 7; i ++)
            {
                TimeBnt *bnt = (TimeBnt *)[_timeScrollView viewWithTag:i + 101];
                if(bnt.tag == _currentIndex + 101)
                {
                    bnt.selected = YES;
                    bnt.weekLabel.textColor = THEME_COLOR;
                    bnt.dayLabel.textColor = THEME_COLOR;
                    _lastWeekBnt = bnt;
                    _weekAndDayIndex = bnt.tag;
                    
                }
                else
                {
                    bnt.selected = NO;
                    bnt.weekLabel.textColor = HEX(@"666666", 1.0f);
                    bnt.dayLabel.textColor = HEX(@"999999", 1.0f);
                }
            }
        }
        
        if(_currentIndex > 4){
            [_timeScrollView setContentOffset:CGPointMake((WIDTH - 40) / 5 * 2 , 0) animated:YES];
        }
    }
    else
    {
        
        if(_currentIndex > 0)
        {
            _currentIndex --;
            for(int i = 0;i < 7; i ++)
            {
                TimeBnt *bnt = (TimeBnt *)[_timeScrollView viewWithTag:i + 101];
                if(bnt.tag == _currentIndex + 101)
                {
                    bnt.selected = YES;
                    bnt.weekLabel.textColor = THEME_COLOR;
                    bnt.dayLabel.textColor = THEME_COLOR;
                    _lastWeekBnt = bnt;
                    _weekAndDayIndex = bnt.tag;
                    
                }
                else
                {
                    bnt.selected = NO;
                    bnt.weekLabel.textColor = HEX(@"666666", 1.0f);
                    bnt.dayLabel.textColor = HEX(@"999999", 1.0f);
                }
            }
        }
        if(_currentIndex < 2)
        {
            [_timeScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }
    [self canSelectTime];
}
#pragma mark==========退出键盘===============
- (void)touch_BackView
{
    [_tapImgControl removeFromSuperview];
    [_timeControl removeFromSuperview];
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)showAlert:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"去登录", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JHLoginVC *loginVC = [[JHLoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
    [alertController addAction:loginAction];
    [self  presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark ====== JHCreateOrderSheetViewDelegate =======
-(void)sheetView:(JHCreateOrderSheetView *)sheetView clickIndex:(NSInteger)index choosedValue:(NSString *)str{
    if (sheetView == _hongBaoSheet){// 选择红包的回调

            NSDictionary *dic = self.hongbaoArr[index];
            self.hongbao_id = dic[@"hongbao_id"];
            self.hongbao_amount = dic[@"amount"];
        self.hongbao_deduct_lable = dic[@"deduct_lable"];
    
        [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        [self amountChange];
    }
}

// 获取红包数组
-(void)getHongBaoArr:(NSString *)cate_id{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/weixiu/order/preinfo" withParams:@{@"cate_id":cate_id} success:^(NSDictionary* json) {
        NSLog(@"维修红包 =======  %@",json);
        HIDE_HUD
        if (ISPostSuccess) {
            NSDictionary *dic = json[@"data"][@"hongbao"];
            self.hongbaoArr = json[@"data"][@"hongbaos"];
            self.hongbao_id = dic[@"hongbao_id"];
            self.hongbao_amount = dic[@"amount"];
            self.hongbao_deduct_lable = dic[@"deduct_lable"];
            [self amountChange];
            [_tableview reloadData];
        }else{
            [self showMsg:json[@"message"]];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error : %@",error.description);
        [self showMsg: NSLocalizedString(@"服务器繁忙,请稍后再试!", NSStringFromClass([self class]))];
    }];
}

// 定金修改
-(void)amountChange{
    float amount =  [self.start floatValue] - [self.hongbao_amount floatValue];
    NSString *string = [NSString stringWithFormat:@"%@%g",NSLocalizedString(@"定金:", nil),amount];
    NSRange range = [string rangeOfString:NSLocalizedString(@"定金:", nil)];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:range];
    _moneyLabel.text = string;
}

-(JHCreateOrderSheetView *)hongBaoSheet{
    if (_hongBaoSheet==nil) {
        _hongBaoSheet=[[JHCreateOrderSheetView alloc] initWithTitle:NSLocalizedString(@"选择红包", @"JHWMCreateOrderVC") amount:@"" delegate:self sheetViewType:SheetViewChooseHongBao dataSource:self.hongbaoArr];
    }
    return _hongBaoSheet;
}

@end

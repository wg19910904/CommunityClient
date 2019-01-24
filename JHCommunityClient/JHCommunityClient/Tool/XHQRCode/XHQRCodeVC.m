//
//  XHQRCodeVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 2017/5/16.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

//屏幕宽高
#define XHQR_width  [UIScreen mainScreen].bounds.size.width
#define XHQR_height [UIScreen mainScreen].bounds.size.height

#import "XHQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>

@interface XHQRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIView *vcBackView;
// 有结果
@property(nonatomic,assign)BOOL is_haveResult;
// 输入输出的管理者
@property (strong,nonatomic)AVCaptureSession *session;
// 播放扫描成功后的声音
@property(nonatomic,strong)AVAudioPlayer *player;

// 预览图层
@property(nonatomic,weak)AVCaptureVideoPreviewLayer *previewLayer;
// 用于存放框出扫描的二维码的layer框
@property(nonatomic,weak)CALayer *contentLayer;

#pragma mark ======需要设初始化的一些信息=======
// 扫描区域四个角的图片
@property(nonatomic,copy)NSString *codeRangeImgName;
// 扫描动画线的图片
@property(nonatomic,copy)NSString *codeLineImgName;
// 扫描的有效范围,再次范围外的扫描无效
@property(nonatomic,assign)CGRect scanFrame;
// 是否显示选中二维码的框
@property(nonatomic,assign)BOOL is_showSelectedLayer;

@end

@implementation XHQRCodeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"扫一扫", nil);
    [self configSetting];
    [self setUpView];
}

-(void)setUpView{
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeQRCodeFromPic)];
    //
    // 判断有无摄像头
    [self isOnorOffCamera];
    
}


//一些需要修改的设置
-(void)configSetting{
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.frame = CGRectMake(0, 0, XHQR_width, XHQR_height-NAVI_HEIGHT);
    self.vcBackView = backView;
    self.vcBackView.backgroundColor = [UIColor blackColor];
    self.codeRangeImgName = @"commodity_sao";
    self.codeLineImgName = @"QRCodeScanLine";
    self.scanFrame = CGRectMake(XHQR_width/2-0.6*XHQR_width/2,XHQR_height/2-0.6*XHQR_width/1.3, 0.6*XHQR_width, 0.6*XHQR_width);
    self.is_showSelectedLayer = NO;
}

#pragma mark 判断 有无摄像头
- (void)isOnorOffCamera{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        //        input = nil;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请在设置-隐私-中打开相机权限", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        // 设置扫描功能
        [self configCodeFunction];
    }
}

#pragma mark 设置扫描功能
- (void)configCodeFunction {
#pragma mark ======获取设备=======
    // 1 实例化摄像头设备
    AVCaptureDevice *device = nil;
    for (AVCaptureDevice *current_device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (current_device.position == AVCaptureDevicePositionBack) {
            device = current_device;
        }
    }
    if (!device) {
        NSLog(@"不存在摄像头或者无权限");
        return;
    }
    
    // 2 设置输入
    NSError *error=nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"输入设备获取失败");
        return;
    }
    
#pragma mark ======✨✨✨✨✨✨✨✨设置扫描范围 =======
    // 3 设置输出
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    if (!outPut) {
        NSLog(@"输出获取失败");
        return;
    }
    outPut.rectOfInterest =CGRectMake(0.25,0.25,0.5,0.5);
    // 4 设置输出的代理,扫描到结果后的回调
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 5 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPreset1280x720;
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:outPut];
    self.session = session;
    //启动会话
    [session startRunning];
    
    // 6 设置输出的格式，扫描的格式
    /*
     二维码 AVMetadataObjectTypeQRCode
     
     条形码 AVMetadataObjectTypeEAN13Code,
     AVMetadataObjectTypeEAN8Code,
     AVMetadataObjectTypeCode128Code
     */
    if (self.is_barcode) {
        [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code]];
    }else{
        [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }
    
#pragma mark ======标记显示扫描的范围 和 扫描的动画=======
    //标记显示扫描的范围
    UIImageView *scanView = [[UIImageView alloc] initWithFrame:self.scanFrame];
    scanView.image = [UIImage imageNamed:self.codeRangeImgName];
    [self.vcBackView addSubview:scanView];
    
    //添加蒙层
    [self addAlphaViewWithFrame:self.scanFrame];
    
    //扫描的动画
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-25, 0,self.scanFrame.size.width+50, 6)];
    lineImgView.image = [UIImage imageNamed:self.codeLineImgName];
    [scanView addSubview:lineImgView];
    

    
    
    //使用基础动画的原因: 使用UIView动画会在present的时候导致动画失效,但是基础动画不会
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.fromValue=@(0);
    animation.toValue=@(self.scanFrame.size.height);
    animation.duration = 2.0;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [lineImgView.layer addAnimation:animation forKey:nil];
    
#pragma mark ======设置预览图层=======
    // 7 设置预览图层(用来让用户能够看到扫描情况)
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // 7.1 设置preview图层的属性
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 7.2设置preview图层的大小
    [previewLayer setFrame:FRAME(0, 0, XHQR_width, XHQR_height)];
    //7.3将图层添加到视图的图层
    [self.vcBackView.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
    
    if ([_previewLayer.connection isVideoOrientationSupported]) {
        _previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:self.preferredInterfaceOrientationForPresentation];
    }
    
#pragma mark ======存放框出扫描的二维码的框的layer======
    if (self.is_showSelectedLayer) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = self.vcBackView.bounds;
        [self.vcBackView.layer addSublayer:layer];
        self.contentLayer = layer;
    }
    
    // 返回按钮
    UIButton *btn = nil;
    btn =[[UIButton alloc] initWithFrame:FRAME(10, 10, 50, 50)];
    [self.view addSubview:btn];
    [btn setImage:IMAGE(@"member_det") forState:UIControlStateNormal];
    [btn sizeToFit];
//    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark ======添加额外的控件=======
  }

#pragma mark ======获取设备方向=======
+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark ======AVCaptureMetadataOutputObjectsDelegate=======
// 扫描成功后的代理回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
  
    
    if (self.is_haveResult) {//扫描有结果后过2秒后再扫描新的
        return;
    }
    
    if ([[metadataObjects.lastObject class] isSubclassOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        
        self.is_haveResult = YES;
        
        if (self.is_showSelectedLayer) {
            [self createLayerWith:metadataObjects.lastObject];
        }
        
        [self playSound];
        
        AVMetadataMachineReadableCodeObject * ty  = (AVMetadataMachineReadableCodeObject *)metadataObjects.lastObject;
        //ty.stringValue  扫描的结果
        NSLog(@"%@  string  %@",ty.type, ty.stringValue);
        
        //扫描成功后的回调
        if (self.completionBlock) {
            
            self.completionBlock(ty.stringValue);
            
        }
        //避免连续扫描
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.is_haveResult = NO;
        });
    }
}

#pragma mark ======添加模糊效果=======
-(void)addAlphaViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, XHQR_width, XHQR_height)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:view];
    //创建贝塞尔曲线 rect 曲线作用的范围
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:FRAME(0, 0, XHQR_width, XHQR_height)];
    
    // 曲线路劲，需要抠出的范围大小
    [path appendPath:[[UIBezierPath bezierPathWithRect:frame] bezierPathByReversingPath]];
    // 裁剪
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [view.layer setMask:shapeLayer];
    
}

#pragma mark ======框出被扫描的二维码=======
-(void)createLayerWith:(AVMetadataMachineReadableCodeObject *)object{
    
    AVMetadataObject *metadata = [self.previewLayer transformedMetadataObjectForMetadataObject:object];
    object = (AVMetadataMachineReadableCodeObject *)metadata;
    
    UIBezierPath *path = nil;
    NSLog(@"===== %@",NSStringFromCGRect(metadata.bounds));
    
    if (metadata.type == AVMetadataObjectTypeQRCode) {
        path = [[UIBezierPath alloc] init];
        int index =0;
        CGPoint point = CGPointZero;
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)object.corners[index++], &point);
        
        [path moveToPoint:point];
        while (index < object.corners.count ) {
            CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)object.corners[index++], &point);
            [path addLineToPoint:point];
        }
        [path closePath];
    }else {
        path = [UIBezierPath bezierPathWithRect:metadata.bounds];
    }
    
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 2.0;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.frame = self.vcBackView.bounds;
    layer.path = path.CGPath;
    [self.contentLayer addSublayer:layer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearLayer];
    });
}

//清除框layer
-(void)clearLayer{
    if ( self.contentLayer.sublayers.count > 0) {
        for (CALayer *layer in self.contentLayer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
}

#pragma mark ======播放语音=======
-(void)playSound{
    if (self.player.isPlaying)  return;
    [self.player play];
}

- (AVAudioPlayer *)player
{
    if (_player == nil) {
        NSString *str = [[NSBundle mainBundle] pathForResource:@"di.wav" ofType:nil];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:str];
        NSData *data=[NSData dataWithContentsOfURL:url];
        NSError *err = nil;
        _player = [[AVAudioPlayer alloc] initWithData:data error:&err];
        [_player prepareToPlay];
        _player.volume = 1.0;
    }
    return _player;
}

#pragma mark - 相册中读取二维码
/* navi按钮实现 */
-(void)takeQRCodeFromPic{
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请更新系统至8.0以上!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            
            pickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;  //来自相册
            
            [self presentViewController:pickerC animated:YES completion:NULL];
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"设备不支持访问相册，请在设置->隐私->照片中进行设置！", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //监测到的结果数组  放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        //判断是否有数据（即是否是二维码）
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            
            [self playSound];
            NSLog(@"相册中的二维码  %@",scannedResult);
            if (self.completionBlock) {
                self.completionBlock(scannedResult);
            }
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"该图片没有包含二维码！", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}



- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
    
}
@end

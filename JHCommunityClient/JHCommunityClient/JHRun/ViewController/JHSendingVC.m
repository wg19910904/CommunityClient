//
//  JHSendingVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/25.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSendingVC.h"
#import "SendTableViewCellOne.h"
#import "SendTableViewCellTwo.h"
#import "SendTableViewCellThree.h"
#import "SendTableViewCellFour.h"
#import "SendTableViewCellFive.h"
#import "SendTableViewCellSix.h"
#import "SendTableViewCellSeven.h"
#import <Masonry.h>
#import "SendTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import <IQKeyboardManager.h>
#import "TLAlertView.h"
 
#import "JHLoginVC.h"
#import "JHRunOederListViewController.h"
#import "JHWMPayOrderVC.h"
#import "TranslateCafToMp3.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HZQChangeDateLine.h"
#import "JHShowAlert.h"
#import "HZQDatePicker.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHPaoTuiHongBaoModel.h"
#import "JHWaiMaiAddressVC.h"
@interface JHSendingVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{
    UITableView * myTableView;//表格
    NSArray * titleArray;
    NSArray * placeHoderArray;//输入框的提示符
    NSArray * imageArray;//
    UITextView * myTextView;//指向输入购买物件要求的那个输入框
    UITextField * textField_takeTime;//取货时间
    UITextField * textField_getTime;//收货时间
    UITextField * textField_takeLocation;//取货地址
    UITextField * textField_takeDoor;//门牌号
    UITextField * textField_takeName;//姓名
    UITextField * textField_takePhone;//取货地的联系电话
    UITextField * textField_getLocation;//收货地址
    UITextField * textField_getDoor;//收货地的门牌号
    UITextField * textField_getName;//收货地的姓名
    UITextField * textField_getPhone;//收货地的联系电话
    //保存时间选择器上面的时间的
    NSString * str_day;
    NSString * str_hour;
    NSString * str_minute;
    UIControl * control;//创建选择时间时的蒙版
    NSArray * array_day;//保存天数的数组
    NSArray * array_hour;//保存小时的数组
    NSArray * array_minute;//保存分钟的数组
    NSInteger selectNum;//记录点击单元格时选中的第几个单元格
    UIImage * image_chose;//保存从相册选择的某张图片或者是拍照的图片
    UIButton * btn_choseImage;//指向那个选择照片的按钮
    //下面的六个label是用来指向slider下面的显示
    UILabel * label_one;
    UILabel * label_two;
    UILabel * label_three;
    UILabel * label_four;
    UILabel * label_five;
    UILabel * label_six;
    UILabel * label_money;//指向显示配送费用的label的
    NSString * dateLine_take;//保存取货的时间戳的
    NSString * dateLine_get;//保存收货的时间戳的
    UIImageView * imageV;//显示录音的气泡的
    NSTimer * timer;//录音需要的定时器
    int num_second;//用来记录录音的时间的
    UILabel * label_time;//用来录制语音有多少秒
    UILabel * viewReminder;//用来提醒的
    NSTimer * newTimer;
    int newNum;
    UIImageView * imageAnnimation;//播放时的那个动画组
    NSData * data;//保存图片的数据流
    NSData * dataVoice;//保存录音的数据流
    UILabel * label_totalMoney;//显示总的钱数的
    UILabel * label_current;//指向slider当前的值
    NSString * lat_take;//取货地纬度
    NSString * lng_take;//取货地经度
    NSString * lat_get;//收货地纬度
    NSString * lng_get;//收货地经度
    
    NSString * lat_take_bd;//取货地纬度
    NSString * lng_take_bd;//取货地经度
    NSString * lat_get_bd;//收货地纬度
    NSString * lng_get_bd;//收货地经度
    
    float Distance;//保存取货地和送货地之间的距离
    NSString * km;
    NSString * weight;
    float max_num;
    float min_num;
    float money;
    UILabel * distance_label;//指向距离的
    UISlider * mySlider;//指向那个滑动条的
    UITextField * textField_weight;//指向那个重量的
    UIView * myView;//这是点击图片查看原图的方法
    NSString * totalMoney;//保存最后的价格
    NSTimer * voiceTimer;//开启定时器刷新音量大小的数据
    UIView * view_voice;//显示正在录音的提示框
    UIImageView * imageV_voice;//显示不同的声音波状图
    UIView * btnView;
    NSString * order_id;//保存下单成功后的order_id
    NSString *  _song_start_price;//起送价
    NSString *  _song_start_km;//起送距离
    NSString *  _song_start_kg;//起送重量
    NSString *  _song_addkm_price;//每超出1km需要的价格
    NSString *  _song_addkg_price;//每超出1kg需要的价格
    NSString * take_time;
    NSString * get_time;
    NSString * take_location;
    NSString * take_door;
    NSString * take_name;
    NSString * take_phone;
    NSString * get_location;
    NSString * get_door;
    NSString * get_name;
    NSString * get_phone;
    NSString * voice_time;
    NSMutableArray * infoArray;
    
    NSString *dis;
    NSString *str_pei;
    
    NSString *hongbao_id;
    NSString *hongbaoMoney;
}
@property(nonatomic,strong)JHPaoTuiHongBaoModel *hongbaoModel;
@end
@implementation JHSendingVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //[IQKeyboardManager sharedManager].enable = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
   // [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //创建表视图
    [self creatTableView];
    //创建底部的view
    [self creatUIView];
    //录音和播放设置属性
    [self initAVAudioAttributes];
    //检测文本框发生文本发生改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:textField_weight];
    
}
//初始化一些数据
-(void)initData{
    self.fd_interactivePopDisabled = YES;
    [HttpTool postWithAPI:@"client/paotui/gongshi" withParams:@{@"type":@"song"} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"]integerValue] == 0) {
            _song_start_price = json[@"data"][@"config"][@"song_start_price"];
            _song_start_km = json[@"data"][@"config"][@"song_start_km"];
            _song_start_kg = json[@"data"][@"config"][@"song_start_kg"];
            _song_addkm_price = json[@"data"][@"config"][@"song_addkm_price"];
            _song_addkg_price = json[@"data"][@"config"][@"song_addkg_price"];
            min_num = [_song_start_price floatValue];
            money = min_num;
            [self changeColorWithNum:min_num];
            infoArray = [NSMutableArray arrayWithObjects:_song_start_price,_song_start_km,_song_start_kg,_song_addkm_price,_song_addkg_price, nil];
            [myTableView reloadData];
            [JHPaoTuiHongBaoModel postToGetHongBaoArr:@(min_num).stringValue tip:@"0" block:^(JHPaoTuiHongBaoModel *model) {
                __weak typeof (self)weakSelf = self;
                weakSelf.hongbaoModel = model;
                [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:16 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
        }else{
            _song_start_price = @"8";
            _song_start_km = @"5";
            _song_start_kg = @"1";
            _song_addkm_price = @"1";
            _song_addkg_price = @"1";
            min_num = 8.0;
            money = 8.0;
            [self changeColorWithNum:min_num];
            infoArray = [NSMutableArray arrayWithObjects:_song_start_price,_song_start_km,_song_start_kg,_song_addkm_price,_song_addkg_price, nil];
            [myTableView reloadData];
            [JHPaoTuiHongBaoModel postToGetHongBaoArr:@(min_num).stringValue tip:@"0" block:^(JHPaoTuiHongBaoModel *model) {
                __weak typeof (self)weakSelf = self;
                weakSelf.hongbaoModel = model;
                [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:16 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    titleArray = @[@"",NSLocalizedString(@"取货时间", nil),NSLocalizedString(@"收货时间", nil),@"",NSLocalizedString(@"取货地", nil),NSLocalizedString(@"门牌号", nil),NSLocalizedString(@"姓名", nil),NSLocalizedString(@"电话", nil),@"",NSLocalizedString(@"收货地", nil),NSLocalizedString(@"门牌号", nil),NSLocalizedString(@"姓名", nil),NSLocalizedString(@"电话", nil)];
    placeHoderArray = @[@"",NSLocalizedString(@"请选择时间", nil),NSLocalizedString(@"请选择时间", nil),@"",NSLocalizedString(@"请选择取货地址", nil),NSLocalizedString(@"请输入门牌号", nil),NSLocalizedString(@"请输入姓名", nil),NSLocalizedString(@"请输入联系方式", nil),@"",NSLocalizedString(@"请输入收货地址", nil),NSLocalizedString(@"请输入门牌号", nil),NSLocalizedString(@"请输入姓名", nil),NSLocalizedString(@"请输入联系方式", nil)];
    imageArray = @[@"",@"time",@"time",@"",@"address",@"door",@"name",@"phone",@"",@"map",@"door",@"name",@"phone"];
    array_day =  @[NSLocalizedString(@"今天", nil),NSLocalizedString(@"明天", nil),NSLocalizedString(@"后天", nil)];
    array_hour = @[@"00",@"01",@"02",
                   @"03",@"04",@"05",
                   @"06",@"07",@"08",
                   @"09",@"10",@"11",
                   @"12",@"13",@"14",
                   @"15",@"16",@"17",
                   @"18",@"19",@"20",
                   @"21",@"22",@"23"];
    array_minute = @[@"00",@"15",@"30",
                     @"45"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"帮我送", nil);
    num_second = 0;
    newNum = 0;
}
#pragma mark - 这是文本框文本发生改变的通知
-(void)textFieldTextDidChangeOneCI:(NSNotification *)not{
    if (not.object != textField_weight) {
        return;
    }
    if (km == nil) {
        km = @"0.1";
    }
    weight = textField_weight.text;
    min_num = [self creatPriceWithX:[km floatValue] withY:[textField_weight.text floatValue]];
    label_money.text = [NSString stringWithFormat:@"¥%.2f",min_num];
    mySlider.minimumValue = 0;
    mySlider.maximumValue = 0+100;
    [mySlider setValue:0];
    label_current.hidden = YES;
//    label_one.text = [NSString stringWithFormat:@"%.2f",min_num];
    label_money.text = [NSString stringWithFormat:@"%.2f元",min_num];
    [self changeColorWithNum:min_num];
    SendTableViewCellFive *cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:16 inSection:0]];
    _hongbaoModel.isChange = NO;
    NSString *str = [[label_money.text componentsSeparatedByString:@"¥"] firstObject];
    if (str.floatValue > 0 && cell && hongbaoMoney > 0) {
        [JHPaoTuiHongBaoModel postToGetHongBaoArr:@(min_num).stringValue tip:[NSString stringWithFormat:@"%g",str.floatValue - min_num] block:^(JHPaoTuiHongBaoModel *model) {
            __weak typeof (self)weakSelf = self;
            weakSelf.hongbaoModel = model;
            cell.model = _hongbaoModel;
        }];
    }
}
#pragma mark - 创建底下的立即下单的按钮
-(void)creatUIView{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, HEIGHT - 50, WIDTH, 50);
    [self.view addSubview:view];
    //创建显示多少钱的label
    label_totalMoney = [[UILabel alloc]init];
    label_totalMoney.frame = CGRectMake(10, 10, WIDTH/2.0, 30);
    [view addSubview:label_totalMoney];
    [self changeColorWithNum:min_num];
    //创建立即下单的按钮
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(WIDTH - 100, 10, 90, 30);
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(clickToTrue:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(clickToTrue:) forControlEvents:UIControlEventTouchUpOutside];
    [btn addTarget:self action:@selector(clickToDown:) forControlEvents:UIControlEventTouchDown];
    btn.backgroundColor = THEME_COLOR;
    [btn setTitle:NSLocalizedString(@"立即下单", nil) forState: UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:btn];
    }
#pragma mark - 初始化录音和播放需要的一些属性
-(void)initAVAudioAttributes{
    self.session = [AVAudioSession sharedInstance];
    //开始录音,将所获取到得录音存到文件里
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
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
#pragma mark - 这是创建表的方法
-(void)creatTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT - 50) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[SendTableViewCell class] forCellReuseIdentifier:@"cell0"];
    [myTableView registerClass:[SendTableViewCellOne class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[SendTableViewCellTwo class] forCellReuseIdentifier:@"cell2"];
    [myTableView registerClass:[SendTableViewCellThree class] forCellReuseIdentifier:@"cell3"];
    [myTableView registerClass:[SendTableViewCellFour class] forCellReuseIdentifier:@"cell4"];
    [myTableView registerClass:[SendTableViewCellFive class] forCellReuseIdentifier:@"cell5"];
    [myTableView registerClass:[SendTableViewCellSix class] forCellReuseIdentifier:@"cell6"];
    [myTableView registerClass:[SendTableViewCellSeven class] forCellReuseIdentifier:@"cell7"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 19;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
       return 140;
    }
    if (indexPath.row==1||indexPath.row == 2||indexPath.row == 4||indexPath.row==5||indexPath.row == 6||indexPath.row==7||indexPath.row==9||indexPath.row==10||indexPath.row == 11||indexPath.row ==12){
    return 40;
    }else if (indexPath.row == 3||indexPath.row == 13){
    return 12;
    }else if (indexPath.row == 8){
    return 40;
    }else if (indexPath.row == 14||indexPath.row==15){
    return 40;
    }else if (indexPath.row == 16){
    return 160;
    }else if(indexPath.row == 17){
    return 205;
    }else{
    return 30; 
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        SendTableViewCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [cell.addBtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        btn_choseImage = cell.addBtn;
        [cell.labBtn addTarget:self action:@selector(reciveVoice) forControlEvents:UIControlEventTouchUpInside];
        [cell.labBtn addTarget:self action:@selector(reciveVoice) forControlEvents:UIControlEventTouchUpOutside];
        [cell.labBtn addTarget:self action:@selector(longPressToSpeak) forControlEvents:UIControlEventTouchDown];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        myTextView = cell.textView;
        myTextView.delegate = self;
        return cell;
    }else if (indexPath.row==1||indexPath.row == 2||indexPath.row == 4||indexPath.row==5||indexPath.row == 6||indexPath.row==7||indexPath.row==9||indexPath.row==10||indexPath.row == 11||indexPath.row == 12){
        SendTableViewCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.myLabel.text = titleArray[indexPath.row];
        cell.imageV.image = [UIImage imageNamed:imageArray[indexPath.row]];
        cell.myTextField.placeholder = placeHoderArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==5||indexPath.row == 6||indexPath.row==7||indexPath.row==10||indexPath.row==11||indexPath.row == 12) {
             cell.imageVV.hidden =  YES;
        }
        cell.myTextField.delegate =self;
        cell.myTextField.keyboardType = UIKeyboardTypeDefault;
        if (indexPath.row == 1) {
            cell.myTextField.text = take_time;
            textField_takeTime = cell.myTextField;
            cell.myTextField.enabled = NO;
        }else if (indexPath.row == 2){
            cell.myTextField.text = get_time;
            textField_getTime = cell.myTextField;
            cell.myTextField.enabled = NO;
        }else if(indexPath.row == 4){
            cell.myTextField.text = take_location;
            textField_takeLocation = cell.myTextField;
            cell.myTextField.enabled = NO;
        }else if (indexPath.row == 5){
            cell.myTextField.text = take_door;
            textField_takeDoor = cell.myTextField;
            cell.myTextField.enabled = YES;
        }else if (indexPath.row == 6){
            cell.myTextField.text = take_name;
            textField_takeName = cell.myTextField;
             cell.myTextField.enabled = YES;
        }else if (indexPath.row == 7){
            cell.myTextField.text = take_phone;
            textField_takePhone = cell.myTextField;
            cell.myTextField.enabled = YES;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (indexPath.row == 9){
            cell.myTextField.text = get_location;
            textField_getLocation = cell.myTextField;
            cell.myTextField.enabled = NO;
        }else if (indexPath.row == 10){
            cell.myTextField.text = get_door;
            textField_getDoor = cell.myTextField;
            cell.myTextField.enabled = YES;
        }else if (indexPath.row == 11){
            cell.myTextField.text = get_name;
            textField_getName = cell.myTextField;
            cell.myTextField.enabled = YES;
        }else if (indexPath.row == 12){
            cell.myTextField.text = get_phone;
            textField_getPhone = cell.myTextField;
            cell.myTextField.enabled = YES;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        return cell;
    }else if(indexPath.row == 3||indexPath.row ==13){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 8){
        SendTableViewCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        return cell;
    }else if(indexPath.row == 14){
        SendTableViewCellFour * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        distance_label = cell.distanceLabel;
        distance_label.text = dis ? dis : @"";
        return cell;
    }else if (indexPath.row == 15){
        SendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        textField_weight = cell.wTextFiled;
        cell.wTextFiled.delegate = self;
        return cell;
    }
    else if (indexPath.row == 16){
        SendTableViewCellFive * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [cell.mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        label_one = cell.label1;
//        cell.label1.text = [NSString stringWithFormat:@"%.2f",min_num];
        label_two = cell.label2;
        label_three = cell.label3;
        label_money = cell.moneyLabel;
        cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",money];
        mySlider = cell.mySlider;
        cell.mySlider.minimumValue = 0;
        cell.mySlider.maximumValue = 100;
        //[cell.mySlider setValue:min_num];
        //label_current.hidden = YES;
        cell.model = _hongbaoModel;
        hongbao_id = cell.hongbao_id;
        __weak typeof (self)weakSelf = self;
        [cell setMyBlock:^(NSString *mon){
            hongbao_id = cell.hongbao_id;
            hongbaoMoney = mon;
            if (hongbaoMoney.floatValue > min_num) {
                hongbaoMoney = @(min_num).stringValue;
            }
            NSString *str = [[label_money.text componentsSeparatedByString:@"¥"] firstObject];
            [weakSelf changeColorWithNum:str.floatValue];
        }];
         return cell;
    }else if(indexPath.row == 17){
        SendTableViewCellSix * cell = [tableView dequeueReusableCellWithIdentifier:@"cell6" forIndexPath:indexPath];
        cell.infoArray = infoArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [self.view endEditing:YES];
//        str_day = NSLocalizedString(@"今天", nil);
//        str_hour = @"00";
//        str_minute = @"00";
//        //创建选择时间的蒙版
//        [self creatMengBan];
          //取货时间
        HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
        [datePicker setMyBlock:^(NSString * time) {
            if (textField_getTime.text.length == 0) {
                textField_takeTime.text = time;
                take_time = time;
            }else{
                if ([time compare:textField_getTime.text] == -1) {
                    textField_takeTime.text = time;
                     take_time = time;
                }else{
                    [JHShowAlert showAlertWithMsg:NSLocalizedString(@"取货时间不能大于收货时间", nil)];;
                }
            }
        }];
        [datePicker creatDatePickerWithObj:datePicker withDate:[HZQChangeDateLine ExchangeWithTimeString:textField_takeTime.text]];

    }else if (indexPath.row == 2){
        //收货时间
        HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
        [datePicker setMyBlock:^(NSString * time) {
            if (textField_takeTime.text.length == 0) {
                 textField_getTime.text = time;
                 get_time = time;
            }else{
            if ([time compare:textField_takeTime.text] == -1) {
                [JHShowAlert showAlertWithMsg:NSLocalizedString(@"收货时间不能小于取货时间", nil)];
            }else{
                 textField_getTime.text = time;
                 get_time = time;
            }
          }
        }];
        [datePicker creatDatePickerWithObj:datePicker withDate:[HZQChangeDateLine ExchangeWithTimeString:textField_getTime.text]];

    }else if (indexPath.row == 4){
        JHWaiMaiAddressVC *list = [JHWaiMaiAddressVC new];
        list.is_paotui = YES;
        __weak typeof(self) weakSelf = self;
        [list setSelectorBlock:^(JHWaimaiMineAddressListDetailModel *model) {
            take_name = model.contact;
            take_door = model.house;
            take_location = model.addr;
            take_phone = model.mobile;
            textField_takeLocation.text = model.addr;
            textField_takeDoor.text = model.house;
            
            textField_takeName.text = model.contact;
            textField_takePhone.text = model.mobile;
            
            lat_take_bd = model.lat;
            lng_take_bd = model.lng;
            //模型是百度坐标,需要先转为高德坐标
            double gd_lat,gd_lng;
            [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[lat_take_bd doubleValue]
                                                         WithBD_lon:[lng_take_bd doubleValue]
                                                         WithGD_lat:&gd_lat
                                                         WithGD_lon:&gd_lng];
            
            lat_take = @(gd_lat).description;
            lng_take = @(gd_lng).description;
            [weakSelf getdistance];
            
        }];
        
        [self.navigationController pushViewController:list animated:YES];
    
    }else if (indexPath.row == 9){
        XHPlacePicker * vc = [[XHPlacePicker alloc] initWithPlaceCallback:^(XHLocationInfo *place) {
            textField_getLocation.text = place.address;
            get_location = place.address;
            lat_get = [@(place.coordinate.latitude) stringValue];
            lng_get = [@(place.coordinate.longitude) stringValue];
            lat_get_bd = [@(place.bdCoordinate.latitude) stringValue];
            lng_get_bd = [@(place.bdCoordinate.longitude) stringValue];
            [self getdistance];
        }];
        [vc startPlacePicker];
    }else if (indexPath.row == 8){
        //点击的时候上下内容交换
        [self clickToChange];
    }
    selectNum  = indexPath.row;
}
- (void)getdistance{
    NSLog(@"%@====%@",lat_take,lat_get);
    if (lat_take!=nil&&lat_get!=nil) {
        CLLocationCoordinate2D amapcoord1 = CLLocationCoordinate2DMake([lat_take floatValue],[lng_take floatValue]);
        CLLocationCoordinate2D amapcoord2 = CLLocationCoordinate2DMake([lat_get floatValue],[lng_get floatValue]);
        //1.将两个经纬度点转成投影点
        MAMapPoint point1 = MAMapPointForCoordinate(amapcoord1);
        MAMapPoint point2 = MAMapPointForCoordinate(amapcoord2);
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        NSLog(@"%f",distance);
   NSLog(@"%f===%f===%f===%f===%f",amapcoord1.latitude,amapcoord1.longitude,amapcoord2.latitude,amapcoord2.longitude,distance);
        NSString * a = [NSString stringWithFormat:@"%f",distance/1000];
        int int_a = distance/1000;
        Distance = distance/1000;
        NSString * float_a = [[a componentsSeparatedByString:@"."]lastObject];
        NSString * float_b = [float_a substringWithRange:NSMakeRange(0, 2)];
        NSLog(@"%f",distance/1000);
        if (distance/1000 > 0&&[float_b floatValue]>0) {
            dis = [NSString stringWithFormat:@"%d.%@km",int_a,float_b];
        }else{
            dis = @"0.1km";
        }
        km = [NSString stringWithFormat:@"%d.%@",int_a,float_b];
        NSLog(@"距离>>>>>>>>>>>>>>>>>>>>>>%@",dis);
        if (weight == nil) {
            weight = @"1";
        }
        min_num = [self creatPriceWithX:[km floatValue] withY:[weight floatValue]];
        mySlider.minimumValue = 0;
        mySlider.maximumValue = 0+100;
        money = min_num;
//        label_one.text = [NSString stringWithFormat:@"%.2f",min_num];
        label_money.text = [NSString stringWithFormat:@"%.2f元",min_num];
        [self changeColorWithNum:min_num];
        label_one.text = @"0";
        [mySlider setValue:0];
        distance_label.text = dis;
        SendTableViewCellFive *cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:16 inSection:0]];
        _hongbaoModel.isChange = NO;
        NSString *str = [[label_money.text componentsSeparatedByString:@"¥"] firstObject];
        if (str.floatValue > 0 && cell && hongbaoMoney > 0) {
            [JHPaoTuiHongBaoModel postToGetHongBaoArr:@(min_num).stringValue tip:[NSString stringWithFormat:@"%g",str.floatValue - min_num] block:^(JHPaoTuiHongBaoModel *model) {
                __weak typeof (self)weakSelf = self;
                weakSelf.hongbaoModel = model;
                cell.model = _hongbaoModel;
            }];
        }
    }
}
#pragma mark - 创建蒙版
-(void)creatMengBan{
    control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    control.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    [control addTarget:self action:@selector(RemoveMengBen) forControlEvents:UIControlEventTouchUpInside];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:control];
    //创建选择时间的View
    UIView * whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame = CGRectMake(30, 110, CGRectGetWidth(self.view.bounds)-60, 235);
    whiteView.layer.cornerRadius = 2;
    whiteView.layer.masksToBounds = YES;
    [control addSubview:whiteView];
    //创建头上的标题
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"选择时间", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    label.frame= CGRectMake(0, 5, CGRectGetWidth(whiteView.bounds), 30);
    label.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:label];
    //创建底下的两个按钮
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake((CGRectGetWidth(whiteView.bounds)- 150)/2+(50+50)*i, 195, 50, 25);
        if (i == 0) {
            btn.backgroundColor = [UIColor colorWithRed:35/255.0 green:180/255.0 blue:175/255.0 alpha:1];
            [btn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
            [btn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        [whiteView addSubview:btn];
        [btn addTarget:self action:@selector(MengBengBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //创建时间选择的picker
    UIPickerView * picker = [[UIPickerView alloc]init];
    picker.frame = CGRectMake(20, 30, CGRectGetWidth(whiteView.bounds) - 40, 120);
    [whiteView addSubview:picker];
    picker.delegate = self;
    picker.dataSource = self;
}
#pragma mark - 这是pickerView的代理和数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
//每列有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return array_day.count;
    }else if(component == 1){
        return array_hour.count;
    }else{
        return array_minute.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        return array_day[row];
    }
    else if(component == 1)
    {
        return array_hour[row];
    }else{
        return array_minute[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        str_day = array_day[row];
    } else if(component == 1){
        str_hour = array_hour[row];
    } else{
        str_minute = array_minute[row];
    }
}
#pragma mark - 这是蒙版上的那个view的两个按钮的方法
-(void)MengBengBtnClick:(UIButton *)sender{
    [self RemoveMengBen];
    NSInteger timeLine = [self changeWithDay:str_day withHour:str_hour withMinute:str_minute];
    if (sender.tag == 0) {
    if (selectNum == 1) {
        if ([[HZQChangeDateLine dateLineExchangeWithTime:@(timeLine).stringValue]compare:[HZQChangeDateLine dateLineExchangeWithTime:dateLine_get]] == 1 && dateLine_get ) {
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"取货时间不能大于收货时间", nil)];
            return;
        }
        textField_takeTime.text = [NSString stringWithFormat:@"%@ %@:%@",str_day,str_hour,str_minute];
        take_time = [NSString stringWithFormat:@"%@ %@:%@",str_day,str_hour,str_minute];
;
         dateLine_take = [NSString stringWithFormat:@"%ld",(long)timeLine];
        }else if (selectNum == 2){
            if ([[HZQChangeDateLine dateLineExchangeWithTime:@(timeLine).stringValue]compare:[HZQChangeDateLine dateLineExchangeWithTime:dateLine_take]] == -1 && dateLine_take ) {
                [JHShowAlert showAlertWithMsg:NSLocalizedString(@"收货时间不能小于取货时间", nil)];
                return;
            }
        textField_getTime.text = [NSString stringWithFormat:@"%@ %@:%@",str_day,str_hour,str_minute];
        dateLine_get = [NSString stringWithFormat:@"%ld",(long)timeLine];
            get_time = [NSString stringWithFormat:@"%@ %@:%@",str_day,str_hour,str_minute];
            ;
        }
         NSLog(@"%@++%@",dateLine_take,dateLine_get);
    }else{
        
    }
    
}
#pragma mark - 这是将选择的时间转化为时间戳的方法
-(NSInteger)changeWithDay:(NSString * )day withHour:(NSString *)hour withMinute:(NSString *)minute{
    NSDate * date = [NSDate date];
    NSInteger dateInterval= [date timeIntervalSince1970];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([day isEqualToString:NSLocalizedString(@"今天", nil)]) {
        dateInterval = dateInterval;
    }else if ([day isEqualToString:NSLocalizedString(@"明天", nil)]){
        dateInterval += 3600 * 24;
    }else{
        dateInterval += 2*3600*24;
    }
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:dateInterval];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * datestring = [dateFormatter stringFromDate:date2];
    datestring = [datestring substringToIndex:10];
    NSString * finalDateString = [NSString stringWithFormat:@"%@ %@:%@:00",datestring,hour,minute];
    NSDate * date3 = [dateFormatter dateFromString:finalDateString];
    NSInteger finalInterval = [date3 timeIntervalSince1970];
    return finalInterval;
}
#pragma mark - 这是移除蒙版的方法
-(void)RemoveMengBen{
    [control removeFromSuperview];
    control = nil;
}
#pragma mark - 这是UITextViewde代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //开始编辑的时候
    if ([myTextView.text isEqualToString:NSLocalizedString(@"请输入要求", nil)]) {
        myTextView.text = @"";
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    if (textView.text.length == 0) {
        myTextView.text = NSLocalizedString(@"请输入要求", nil);
    }
    //结束编辑的时候
}
#pragma mark - 滑动表的时候让键盘下落
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
#pragma mark - 这是表结束减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是表开始拖动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
#pragma mark - 点击那个双向箭头的时候让内容交换
-(void)clickToChange{
    NSLog(@"这是点击上下交换内容的方法");
    NSString * str_changeOne = textField_takeLocation.text;
    textField_takeLocation.text = textField_getLocation.text;
    textField_getLocation.text = str_changeOne;
    NSString * str_changeTwo = textField_takeDoor.text;
    textField_takeDoor.text = textField_getDoor.text;
    textField_getDoor.text = str_changeTwo;
    NSString * str_changeThree = textField_takeName.text;
    textField_takeName.text = textField_getName.text;
    textField_getName.text = str_changeThree;
    NSString * str_changeFour = textField_takePhone.text;
    textField_takePhone.text = textField_getPhone.text;
    textField_getPhone.text = str_changeFour;
    take_location = textField_takeLocation.text;
    get_location  = textField_getLocation.text;
    take_door = textField_takeDoor.text;
    get_door = textField_getDoor.text;
    take_name = textField_takeName.text;
    get_name = textField_getName.text;
    take_phone = textField_takePhone.text;
    get_phone = textField_getPhone.text;
    NSString * str_changeFive = lat_take;
    lat_take = lat_get;
    lat_get = str_changeFive;
    NSString * str_changeSix = lng_take;
    lng_take = lng_get;
    lng_get = str_changeSix;
    
}
#pragma mark - 这是点击添加图片的方法
-(void)addImage{
    NSLog(@"你点击了添加图片的方法");
    [self.view endEditing:YES];
    if (image_chose == nil) {
        //点击选择图片
       [self creatButtomChoseWithAlertCountrol];
    }else{
        //点击删除或者查看图片原图
        [self creatButtomTocherkOrRemoveImage];
    }
 }
#pragma mark - 这是已经选择了图片之后点击图片出现删除或者查看原图的按钮
-(void)creatButtomTocherkOrRemoveImage{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"查看原图", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //查看原图
        //[UIView animateWithDuration:0.3 animations:^{
            [self creatImageMengBan];
        //}];
        }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"删除图片", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除图片
        [btn_choseImage setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        image_chose = nil;
        data = nil;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
//创建一层蒙版和imageview
-(void)creatImageMengBan{
    if (myView == nil) {
        myView = [[UIView alloc]init];
        myView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        myView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:myView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeImage)];
        [myView addGestureRecognizer:tap];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.bounds = CGRectMake(0, 0, WIDTH, HEIGHT/2);
        imageView.center = myView.center;
        imageView.image = image_chose;
        //缩放手势
        UIPinchGestureRecognizer * pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:pinchGesture];
        //旋转手势
        UIRotationGestureRecognizer * panGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [imageView addGestureRecognizer:panGesture];
        [myView addSubview:imageView];
    }
}
-(void)removeImage{
    [myView removeFromSuperview];
     myView = nil;
}
//缩放手势调用的方法
-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}
//旋转手势
- (void) handlePan:(UIRotationGestureRecognizer*) recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}
#pragma mark - 这是创建底部的选择照片和拍照的方法
-(void)creatButtomChoseWithAlertCountrol{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //创建图片选择控制
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    //添加button
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理点击拍照
        NSLog(@"点击了拍照");
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理点击从相册选取
        NSLog(@"点击了相册选照片");
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 这是UIImagePickerController的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"哈哈");
}
//选择某张图片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.allowsEditing) {
        image_chose = [info objectForKey:UIImagePickerControllerEditedImage];
        
    }else{
        image_chose = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    data = UIImagePNGRepresentation(image_chose);
    [btn_choseImage setBackgroundImage:image_chose forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//点击取消的时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
                    //1.获取一个全局并发队列
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    //2.把任务放到队列中执行
                    dispatch_async(queue, ^{
                        NSLog(@"%@",[NSThread currentThread]);
                        if (![self.recorder isRecording]) {
                            [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//设置类别,表示该应用同时支持播放和录音
                            [self.session setActive:YES error:nil];//启动音频会话管理,此时会阻断后台音乐的播放.
                            //准备记录录音
                            [_recorder prepareToRecord];
                            [_recorder peakPowerForChannel:0.0];
                            [_recorder record];
                            //允许获取音量的大小
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
#pragma mark - 这是开启定时器一直去获取音量的方法
-(void)startGetVoice{
    if (voiceTimer == nil) {
        voiceTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeImageWithVoice) userInfo:nil repeats:YES];
        [voiceTimer fire];
    }
}
-(void)stopGetVoice{
    if (voiceTimer) {
        [voiceTimer invalidate];
        voiceTimer = nil;
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
#pragma mark - 这是创建录音时正在录音的提示框
-(void)creatVoiceMengBan{
    if (view_voice == nil){
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
#pragma mark - 这是结束录音后删除录音提示的方法
-(void)removeVoiceMengBan{
    [view_voice removeFromSuperview];
    view_voice = nil;
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
#pragma mark - 这是警告框的方法
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
            NSString * mp3FilePath = [NSTemporaryDirectory() stringByAppendingString:@"NewMp3.mp3"];//存储mp3文件的路径
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
                        SendTableViewCellThree * cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        imageV.image = [UIImage imageNamed:@"newyuyin"];
                        [cell addSubview:imageV];
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.offset(-55);
                            make.bottom.offset(-29);
                            make.width.offset(120);
                            make.height.offset(30);
                        }];
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
                        [cell addSubview:label_time];
                        [label_time mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.offset(-180);
                            make.bottom.offset(-29);
                            make.width.offset(30);
                            make.height.offset(30);
                        }];
                        imageAnnimation = [[UIImageView alloc]init];
                        imageAnnimation.image = [UIImage imageNamed:@"sy_1"];
                        imageAnnimation.animationImages = [NSArray arrayWithObjects:
                                                           [UIImage imageNamed:@"sy_3"],
                                                           [UIImage imageNamed:@"sy_2"],
                                                           [UIImage imageNamed:@"sy_1"],nil];
                        imageAnnimation.animationDuration = 1;
                        imageAnnimation.animationRepeatCount = 0;
                        [cell addSubview:imageAnnimation];
                        [imageAnnimation mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.offset(-75);
                            make.bottom.offset(-34);
                            make.width.offset(15);
                            make.height.offset(20);
                        }];
                    }
                    NSLog(@"%@",[NSThread currentThread]);
                    //1.获取一个全局并发队列
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    //2.把任务添加到队列中执行
                    dispatch_async(queue, ^{
                        NSLog(@"%@",[NSThread currentThread]);
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
#pragma mark - 这是长按后显示是否要删除录音内容的提示框
-(void)longToRemoveImageV{
    if (imageV != nil) {
        [self creatAlertViewWithString:NSLocalizedString(@"您确定要删除语音", nil) withTag:0];
    }else{}
}
#pragma mark - 这是点击播放录音的方法
-(void)clickToPlayer{
    NSLog(@"这是点击播放录音的方法");
    //如果语音正在播放,暂停
    if ([_player isPlaying]) {
        [imageAnnimation stopAnimating];
        [_player pause];
        return;
    }
    //如果语音不是在播放,开始播放
    [imageAnnimation startAnimating];
    NSLog(@"%@",self.mp3File);
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

#pragma mark - 这是确定下单的方法
-(void)clickToDown:(UIButton *)sender{
    if (btnView == nil) {
        btnView = [[UIView alloc]init];
        btnView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        btnView.frame = CGRectMake(0, 0, 90, 30);
        btnView.layer.cornerRadius = 3;
        btnView.layer.masksToBounds = YES;
        [sender addSubview:btnView];
    }
}
-(void)clickToTrue:(UIButton *)sender{
    [btnView removeFromSuperview];
    btnView = nil;
    NSLog(@"这是确定下单的方法");
       if ([myTextView.text isEqualToString:NSLocalizedString(@"请输入要求", nil)]||textField_takeTime.text.length == 0 ||textField_getTime.text.length == 0||textField_takeLocation.text.length == 0||textField_takeDoor.text.length == 0||textField_takeName.text.length == 0||textField_takePhone.text.length == 0||textField_getLocation.text.length == 0||textField_getDoor.text.length == 0||textField_getName.text.length == 0||textField_getPhone.text.length == 0) {
        //显示提醒
           [self creatAlertViewWithMessage:NSLocalizedString(@"请将信息补充完整", nil) withError:@""];
           return;
    }

    if (textField_getPhone.text.length == 0) {
        //显示提醒
        [self creatAlertViewWithMessage:NSLocalizedString(@"您输入的手机号码有误,请核对", nil) withError:@""];
        return;
    }
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"token"])
    {
        [self creatAlertViewWithMessage:NSLocalizedString(@"很抱歉,请登录后下单", nil) withError:@""];
        return;
    }
    if (label_time.text == nil) {
        label_time.text = @"0";
    }
    if (label_time != nil) {
        voice_time = [label_time.text componentsSeparatedByString:@"s"][0];
    }else {
        voice_time = @"0";
    }
    if (hongbao_id.length == 0) {
        hongbao_id = @"0";
    }
    NSDictionary * dic = @{@"o_time":@([HZQChangeDateLine ExchangeWithTime:textField_takeTime.text]).stringValue,
                           @"time":@([HZQChangeDateLine ExchangeWithTime:textField_getTime.text]).stringValue,
                           @"o_addr":textField_takeLocation.text,
                           @"o_house":textField_takeDoor.text,
                           @"o_contact":textField_takeName.text,
                           @"o_mobile":textField_takePhone.text,
                           @"o_lng":lng_take_bd,
                           @"o_lat":lat_take_bd,
                           @"addr":textField_getLocation.text,
                           @"house":textField_getDoor.text,
                           @"contact":textField_getName.text,
                           @"mobile":textField_getPhone.text,
                           @"lng":lng_get_bd,
                           @"lat":lat_get_bd,
                           @"intro":myTextView.text,
                           @"xf":label_one.text,
                           @"voice_time":voice_time,
                           @"amount":@(min_num).stringValue,
                           @"hongbao_id":hongbao_id
                           };
    
    if (imageV== nil) {
        dataVoice = nil;
    }else{
        //dataVoice = [NSData dataWithContentsOfURL:self.mp3File];
         dataVoice = [NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingString:@"NewMp3.mp3"]];
    }
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
    if (data) {
        [dataDic addEntriesFromDictionary:@{@"photo":data}];
    }
    if (dataVoice) {
        [dataDic addEntriesFromDictionary:@{@"voice":dataVoice}];
    }
    SHOW_HUD
    //发送请求
    [HttpTool postWithAPI:@"client/paotui/song" params:dic dataDic:dataDic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            HIDE_HUD
            [self creatAlertViewWithMessage:NSLocalizedString(@"恭喜您下单成功", nil) withError:json[@"error"]];
            order_id = json[@"data"][@"order_id"];
        }else if([json[@"error"] integerValue] == 101){
            [self creatAlertViewWithMessage:NSLocalizedString(@"很抱歉,请登录后下单", nil) withError:json[@"error"]];
        }else{
            HIDE_HUD
            [self creatAlertViewWithMessage:json[@"message"] withError:json[@"error"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是slider开始滑动的时候调用的方法
-(void)sliderValueChanged:(UISlider *)sender{
    NSLog(@"我的值发生了变化");
    NSString * value = [NSString stringWithFormat:@"%f",sender.value];
    NSString * newValue = [[value componentsSeparatedByString:@"."]firstObject];
    NSLog(@"%@+++%@",value,newValue);
    money = [newValue intValue] +min_num;

[self changeColorWithNum:([newValue intValue]+ min_num)];
        label_one.text = newValue;

}
#pragma mark - 这是textField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField; {
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == textField_takeTime) {
        take_time = textField_takeTime.text;
    }else if (textField == textField_getTime){
        get_time = textField_getTime.text;
    }else if (textField == textField_takeDoor){
        take_door = textField_takeDoor.text;
    }else if (textField == textField_takeName){
        take_name = textField_takeName.text;
    }else if (textField == textField_takePhone){
        take_phone = textField_takePhone.text;
    }else if (textField == textField_getDoor){
        get_door = textField_getDoor.text;
    }else if (textField == textField_getName){
        get_name = textField_getName.text;
    }else if (textField == textField_getPhone){
        get_phone = textField_getPhone.text;
    }
}
#pragma mark - 这是显示最终价格的label展示不同颜色的方法
-(void)changeColorWithNum:(float)num{
    if (hongbaoMoney > 0) {
        num = num - hongbaoMoney.floatValue;
    }
    if (num <= 0) {
        num = 0.01;
    }
    totalMoney = [NSString stringWithFormat:@"%.2f",num];
    NSString * string = [NSString stringWithFormat:NSLocalizedString(@"跑腿费 :%.2f元", nil),num];
    NSRange range = [string rangeOfString:[NSString stringWithFormat:NSLocalizedString(@"%.2f元", nil),num]];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:range];
    label_totalMoney.text = string;
    label_totalMoney.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    label_totalMoney.font = [UIFont systemFontOfSize:13];
    label_totalMoney.attributedText = attribute;
}
#pragma mark - 这是算价格的函数
-(float)creatPriceWithX:(float)xx withY:(float)yy{
    float  a = [_song_start_price floatValue]+((xx-[_song_start_km floatValue])>0?(xx-[_song_start_km floatValue])*[_song_addkm_price floatValue]:0)+((yy-[_song_start_kg floatValue])>0?(yy-[_song_start_kg floatValue])*[_song_addkg_price floatValue]:0);
    str_pei = [NSString stringWithFormat:@"%.2f",a];
    return a;
}
#pragma mark - 这是提醒的弹框
-(void)creatAlertViewWithMessage:(NSString *)message withError:(NSString *)error{
    TLAlertView *alertView = [[TLAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:message buttonTitle:@"OK" handler:^(TLAlertView *alertView) {
        NSLog(@"ok");
        if ([message isEqualToString:NSLocalizedString(@"很抱歉,请登录后下单", nil)]) {
            JHLoginVC * login = [[JHLoginVC alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }else if ([error isEqualToString:@"0"]){
            JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
            vc.order_id = order_id;
            vc.amount = totalMoney;
            vc.isSong = YES;
            [vc setPaySuccessBlock:^(BOOL success, NSString *msg) {
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
];
    [alertView show];
}
-(void)removeAll{
    //删除图片
    [btn_choseImage setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    image_chose = nil;
    data = nil;
    [imageV removeFromSuperview];
    [label_time removeFromSuperview];
    [imageAnnimation removeFromSuperview];
    label_time = nil;
    imageV = nil;
    imageAnnimation = nil;
    num_second = 0;
    NSString *mp3FilePath = [NSTemporaryDirectory() stringByAppendingString:@"MP3.caf"];//存储mp3文件的路径
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:mp3FilePath error:nil]) {
        NSLog(@"删除");
    }
    myTextView.text = NSLocalizedString(@"请输入要求", nil);
    textField_takeTime.text = nil;
    textField_getTime.text = nil;
    textField_takeLocation.text = nil;
    textField_takeDoor.text = nil;
    textField_takeName.text = nil;
    textField_takePhone.text = nil;
    textField_getLocation.text = nil;
    textField_getPhone.text = nil;
    textField_getName.text = nil;
    textField_getDoor.text = nil;
    textField_weight.text = nil;

}
@end

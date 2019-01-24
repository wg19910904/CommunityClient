//
//  JHSeatVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/25.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSeatVC.h"
#import "SendTableViewCellThree.h"
#import "SendTableViewCellOne.h"
#import "SendTableViewCellFive.h"
#import "SendTableViewCellEight.h"
#import "TranslateCafToMp3.h"
#import <Masonry.h>
#import <IQKeyboardManager.h>
 
#import "TLAlertView.h"
#import "JHLoginVC.h"
#import "JHRunOederListViewController.h"
#import "JHWMPayOrderVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HZQDatePicker.h"
#import "HZQChangeDateLine.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHPaoTuiHongBaoModel.h"
@interface JHSeatVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate>
{
    UILabel * label_totalMoney;//显示总的钱数的
    UITableView * myTableView;//表格
    UITextView * myTextView;//指向输入购买物件要求的那个输入框
    UIButton * btn_choseImage;//指向那个选择照片的按钮
    UIImage * image_chose;//保存从相册选择的某张图片或者是拍照的图片
    NSArray * titleArray;//存放图片旁边的标题的
    NSArray * placeHoderArray;//输入框的提示符
    NSArray * imageArray;//存放图片的
    UILabel * label_min;//指向slider的最小值
    UILabel * label_current;//指向slider当前的值
    UILabel * label_peiMoney;//指向配送费用的
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
    UITextField * textField_address;//指向服务地址的
    UITextField * textField_door;//指向门牌号的
    UITextField * textField_name;//指向联系人的
    UITextField * textField_phone;//指向联系方式的
    UITextField * textField_time;//指向选择的时间的
    NSInteger selectNum;//记录点击单元格时选中的第几个单元格
    //保存时间选择器上面的时间的
    NSString * str_day;
    NSString * str_hour;
    NSString * str_minute;
    NSArray * array_day;//保存天数的数组
    NSArray * array_hour;//保存小时的数组
    NSArray * array_minute;//保存分钟的数组
    UIControl * control;//创建选择时间时的蒙版
    NSString * dateLine_get;//保存收货的时间戳的
    float min_num;//最小值
    float money;
    UIView * myView;//这是点击图片查看原图的方法
    NSString * totalMoney;//保存最终价格的方法
    NSTimer * voiceTimer;//开启定时器刷新音量大小的数据
    UIView * view_voice;//显示正在录音的提示框
    UIImageView * imageV_voice;//显示不同的声音波状图
    NSString * order_id;//保存下单成功后的order_id
    NSString * _lat;
    NSString * _lng;
    NSString *  _seat_start_price;
    NSString * voice_time;
    NSString *hongbao_id;
    NSString *hongbaoMoney;
}
@property(nonatomic,strong)JHPaoTuiHongBaoModel *hongbaoModel;
@end

@implementation JHSeatVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
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

}
#pragma mark - 初始化一些数据
-(void)initData{
     self.fd_interactivePopDisabled = YES;
    label_time.text = @"0";
    [HttpTool postWithAPI:@"client/paotui/gongshi" withParams:@{@"type":@"seat"} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"]intValue] == 0) {
            _seat_start_price = json[@"data"][@"config"][@"seat_start_price"];
            min_num = [_seat_start_price intValue];
            money = min_num;
            [myTableView reloadData];
            [JHPaoTuiHongBaoModel postToGetHongBaoArr:@(min_num).stringValue tip:@"0" block:^(JHPaoTuiHongBaoModel *model) {
                __weak typeof (self)weakSelf = self;
                weakSelf.hongbaoModel = model;
                [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self changeColorWithNum:min_num];
        }else{
            min_num = 8;
            money = 8;
            [myTableView reloadData];
            [JHPaoTuiHongBaoModel postToGetHongBaoArr:@(min_num).stringValue tip:@"0" block:^(JHPaoTuiHongBaoModel *model) {
                __weak typeof (self)weakSelf = self;
                weakSelf.hongbaoModel = model;
                [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self changeColorWithNum:min_num];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"餐馆占座", nil);
    
    num_second = 0;
    newNum = 0;
    //初始化三个数组
    titleArray = @[@"",NSLocalizedString(@"服务地址", nil),NSLocalizedString(@"门牌号", nil),NSLocalizedString(@"联系人", nil),NSLocalizedString(@"联系方式", nil),NSLocalizedString(@"服务时间", nil)];
    placeHoderArray = @[@"",NSLocalizedString(@"请选择地址", nil),NSLocalizedString(@"请输入门牌号", nil),NSLocalizedString(@"请输入姓名", nil),NSLocalizedString(@"请输入联系方式", nil),NSLocalizedString(@"请选择时间", nil)];
    imageArray = @[@"",@"address",@"door",@"name",@"phone",@"time"];
    imageArray = @[@"",@"address",@"door",@"name",@"phone",@"time"];
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
 
}
#pragma mark - 这是初始化录音的一些属性
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
#pragma mark - 这是创建表的方法
-(void)creatTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT-50) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[SendTableViewCellOne class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[SendTableViewCellThree class] forCellReuseIdentifier:@"cell3"];
    [myTableView registerClass:[SendTableViewCellFive class] forCellReuseIdentifier:@"cell5"];
    [myTableView registerClass:[SendTableViewCellEight class] forCellReuseIdentifier:@"cell10"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
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
//    NSString * string = NSLocalizedString(@"定金 :  0元", nil);
//    NSRange range = [string rangeOfString:NSLocalizedString(@"0元", nil)];
//    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
//    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:range];
//    label_totalMoney.text = string;
//    label_totalMoney.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//    label_totalMoney.font = [UIFont systemFontOfSize:13];
//    label_totalMoney.attributedText = attribute;
    [self changeColorWithNum:min_num];
    //创建立即下单的按钮
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(WIDTH - 100, 10, 90, 30);
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(clickToTrue) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = THEME_COLOR;
    [btn setTitle:NSLocalizedString(@"立即下单", nil) forState: UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:btn];
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 140;
    }else if (indexPath.row<6&&indexPath.row>0){
        return 40;
    }else if (indexPath.row == 6){
        return 160;
    }
    else if(indexPath.row == 7){
        return 160;
    }else{
        return 30;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SendTableViewCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [cell.addBtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        [cell.labBtn addTarget:self action:@selector(reciveVoice) forControlEvents:UIControlEventTouchUpInside];
        [cell.labBtn addTarget:self action:@selector(reciveVoice) forControlEvents:UIControlEventTouchUpOutside];
        [cell.labBtn addTarget:self action:@selector(longPressToSpeak) forControlEvents:UIControlEventTouchDown];
        btn_choseImage = cell.addBtn;
        myTextView = cell.textView;
        cell.textView.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.row<6&&indexPath.row>0){
        SendTableViewCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.row >1&&indexPath.row<5) {
            cell.imageVV.hidden = YES;
        }
        cell.myTextField.delegate = self;
        if(indexPath.row == 1){
            textField_address = cell.myTextField;
            cell.myTextField.enabled = NO;
        }else if (indexPath.row == 2){
            textField_door = cell.myTextField;
        }else if (indexPath.row == 3){
            textField_name = cell.myTextField;
        }else if (indexPath.row == 4){
            textField_phone = cell.myTextField;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            textField_time = cell.myTextField;
            cell.myTextField.enabled = NO;
        }
        cell.imageV.image = [UIImage imageNamed:imageArray[indexPath.row]];
        cell.myLabel.text = titleArray[indexPath.row];
        cell.myTextField.placeholder = placeHoderArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 6){
        SendTableViewCellFive * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [cell.mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        label_min = cell.label1;
        label_current = cell.label_currentMoney;
        label_peiMoney = cell.moneyLabel;
        cell.mySlider.minimumValue = 0;
        cell.mySlider.maximumValue = 0+100;
        cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",money];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _hongbaoModel;
        hongbao_id = cell.hongbao_id;
        __weak typeof (self)weakSelf = self;
        [cell setMyBlock:^(NSString *mon){
            hongbao_id = cell.hongbao_id;
            hongbaoMoney = mon;
            if (hongbaoMoney.floatValue > min_num) {
                hongbaoMoney = @(min_num).stringValue;
            }
            NSString *str = [[label_peiMoney.text componentsSeparatedByString:@"¥"] firstObject];
            [weakSelf changeColorWithNum:min_num];
        }];
        return cell;
    }
    else if(indexPath.row == 7){
        SendTableViewCellEight * cell = [tableView dequeueReusableCellWithIdentifier:@"cell10" forIndexPath:indexPath];
        cell.start_price = _seat_start_price;
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
    selectNum = indexPath.row;
    if (indexPath.row == 5) {
        [self.view endEditing:YES];
//        str_day = NSLocalizedString(@"今天", nil);
//        str_hour = @"00";
//        str_minute = @"00";
//        //创建选择时间的蒙版
//        [self creatMengBan];
        
        HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
        [datePicker setMyBlock:^(NSString * time) {
            textField_time.text = time;
        }];
        [datePicker creatDatePickerWithObj:datePicker withDate:[HZQChangeDateLine ExchangeWithTimeString:textField_time.text]];
        
    }else if (indexPath.row == 1){
        XHPlacePicker * vc = [[XHPlacePicker alloc] initWithPlaceCallback:^(XHLocationInfo *place) {
            textField_address.text = place.address;
            _lat = @(place.coordinate.latitude).stringValue;
            _lng = @(place.coordinate.longitude).stringValue;
        }];
        [vc startPlacePicker];
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
    //[picker selectRow:<#(NSInteger)#> inComponent:<#(NSInteger)#> animated:YES];
    
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
    NSInteger timeLine = [self changeWithDay:str_day withHour:str_hour withMinute:str_minute];
    if (sender.tag == 0) {
        textField_time.text = [NSString stringWithFormat:@"%@ %@:%@",str_day,str_hour,str_minute];
        dateLine_get = [NSString stringWithFormat:@"%ld",timeLine];
    }else{
    }
    [self RemoveMengBen];
    NSLog(@"%ld",timeLine);
}
#pragma mark - 这是讲选择的时间转化为时间戳的方法
-(NSInteger)changeWithDay:(NSString * )day withHour:(NSString *)hour withMinute:(NSString *)minute{
    //取出当前的时间
    NSDate * date = [NSDate date];
    //获取当前的时间戳
    NSInteger dateInteval = [date timeIntervalSince1970];
    if ([day isEqualToString:NSLocalizedString(@"今天", nil)]) {
        dateInteval = dateInteval;
    }else if ([day isEqualToString:NSLocalizedString(@"明天", nil)]){
        dateInteval += 3600*24;
    }else if([day isEqualToString:NSLocalizedString(@"后天", nil)]){
        dateInteval += 2*3600*24;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateNew= [NSDate dateWithTimeIntervalSince1970:dateInteval];
    NSString * str_time = [dateFormatter stringFromDate:dateNew];
    str_time = [str_time substringToIndex:10];
    NSString * finalString = [NSString stringWithFormat:@"%@ %@:%@:00",str_time,hour,minute];
    NSDate * dateLast = [dateFormatter dateFromString:finalString];
    NSInteger finalInterval = [dateLast timeIntervalSince1970];
    return finalInterval;
}
#pragma mark - 这是移除蒙版的方法
-(void)RemoveMengBen{
    [control removeFromSuperview];
    control = nil;
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
#pragma mark - 这是textView的代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:NSLocalizedString(@"请输入要求", nil)]) {
        textView.text = @"";
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    if (textView.text.length == 0) {
        textView.text = NSLocalizedString(@"请输入要求", nil);
    }
}
#pragma mark - 这是slider开始滑动的时候调用的方法
-(void)sliderValueChanged:(UISlider *)sender{
    NSLog(@"这是slider开始滑动的时候调用的方法");
    NSString * value = [NSString stringWithFormat:@"%f",sender.value];
    NSString * newValue = [[value componentsSeparatedByString:@"."]firstObject];
    NSLog(@"%@+++%@",value,newValue);
    money = [newValue intValue] +min_num;

         [self changeColorWithNum:[newValue floatValue] +min_num];
        label_min.text = newValue;
    

}
#pragma mark - 这是改变让显示总价的那个label上的字显示不同的颜色的方法
-(void)changeColorWithNum:(float)num{
    if (num > 0) {
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
#pragma mark - 这是弹出底部的选择从哪选取照片的方法
-(void)creatButtomChoseWithAlertCountrol{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController * pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
     [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         NSLog(@"拍照");
         pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
         [self presentViewController:pickerController animated:YES completion:nil];
     }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"从相册选择");
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:pickerController animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }]];
    [self presentViewController:alert animated:YES completion:nil];
 }
#pragma makr - 这是uiimagePickerController的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"哈哈");
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.allowsEditing) {
        image_chose = info[UIImagePickerControllerEditedImage];
    }else{
        image_chose = info[UIImagePickerControllerOriginalImage];
    }
    data = UIImagePNGRepresentation(image_chose);
    [btn_choseImage setBackgroundImage:image_chose forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark - 这是结束录音后删除录音提示的方法
-(void)removeVoiceMengBan{
    [view_voice removeFromSuperview];
    view_voice = nil;
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
                    //获取一个全局并发队列
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    //将任务加到队列中
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
#pragma mark - 这是长按后显示是否要删除录音内容的提示框
-(void)longToRemoveImageV{
    NSLog(@"这是长按后显示是否要删除录音内容的提示框");
    if (imageV != nil) {
        [self creatAlertViewWithString:NSLocalizedString(@"您确定要删除语音", nil) withTag:0];
    }else{
    }
}
#pragma mark - 这是文本框的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}

#pragma mark - 这是确定下单的方法
-(void)clickToTrue{
    NSLog(@"这是确定下单的方法");
//    dataVoice = [NSData dataWithContentsOfURL:self.mp3File];
//    NSLog(@"%@++这是图片的数据流%@++这是语音的数据流%@++%@++%@++%@++%@++%@++%@++%@",myTextView.text,data,dataVoice,textField_address.text,textField_door.text,textField_name.text,textField_phone.text,textField_time.text,label_peiMoney.text,totalMoney);
    if ([myTextView.text isEqualToString:NSLocalizedString(@"请输入要求", nil)]||textField_address.text.length == 0||textField_door.text.length == 0||textField_name.text.length == 0||textField_phone.text.length == 0||textField_time.text.length == 0) {
        [self creatAlertViewWithMessage:NSLocalizedString(@"请将信息补充完整", nil)];
        return;
    }
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"token"])
    {
        [self creatAlertViewWithMessage:NSLocalizedString(@"很抱歉,请登录后下单", nil)];
        return;
    }
    if (label_time != nil) {
        voice_time = [label_time.text componentsSeparatedByString:@"s"][0];
    }else {
        voice_time = @"0";
    }
    double bd_lat;
    double bd_lon;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:_lat.doubleValue
                                                 WithGD_lon:_lng.doubleValue
                                                 WithBD_lat:&bd_lat
                                                 WithBD_lon:&bd_lon];
    NSDictionary * dic = @{@"time":@([HZQChangeDateLine ExchangeWithTime:textField_time.text]).stringValue,
                           @"addr":textField_address.text,
                           @"house":textField_door.text,
                           @"contact":textField_name.text,
                           @"mobile":textField_phone.text,
                           @"lng":@(bd_lon),
                           @"lat":@(bd_lat),
                           @"xf":label_min.text,
                           @"intro":myTextView.text,
                           @"voice_time":voice_time,
                           @"amount":@(min_num).stringValue,
                           @"hongbao_id":hongbao_id
                           };
    if (imageV== nil) {
        dataVoice = nil;
    }else{
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
    [HttpTool postWithAPI:@"client/paotui/seat" params:dic dataDic:dataDic success:^(id json) {
        HIDE_HUD
        if ([json[@"error"]integerValue] == 0) {
            [self creatAlertViewWithMessage:NSLocalizedString(@"恭喜您下单成功", nil)];
            order_id = json[@"data"][@"order_id"];
        }else if([json[@"error"] integerValue] == 101){
            [self creatAlertViewWithMessage:NSLocalizedString(@"很抱歉,请登录后下单", nil)];
        }else{
            [self creatAlertViewWithMessage:json[@"message"]];
        }
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        HIDE_HUD
    }];
}
#pragma mark - 这是提醒的弹框
-(void)creatAlertViewWithMessage:(NSString *)message{
    TLAlertView *alertView = [[TLAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:message buttonTitle:@"OK" handler:^(TLAlertView *alertView) {
        NSLog(@"ok");
        if ([message isEqualToString:NSLocalizedString(@"很抱歉,请登录后下单", nil)]) {
            JHLoginVC * login = [[JHLoginVC alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }else if ([message isEqualToString:NSLocalizedString(@"恭喜您下单成功", nil)]){
            JHWMPayOrderVC *vc = [[JHWMPayOrderVC alloc]init];
            vc.order_id = order_id;
            vc.amount = totalMoney;
            vc.isSeat = YES;
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
    textField_address.text = nil;
    textField_door.text = nil;
    textField_name.text = nil;
    textField_phone.text = nil;
    textField_time.text = nil;
}

@end

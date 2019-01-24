//
//  JHAddSeatVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAddSeatVC.h"
#import "JHAddSeatHeaderVeiw.h"
#import "JHAddSeatModel.h"
#import "AddSeatNameCell.h"
#import "HZQChosePickerView.h"
#import <IQKeyboardManager.h>
#import "AddSeatPhoneCell.h"
#import "AddButtomCell.h"
#import "ChoseTimeCell.h"
#import "JHSeatAndNumberListVC.h"
#import "HZQCalendarControl.h"
#import "HZQChangeDateLine.h"
#import "HZQDatePicker.h"
 
#import "JHShowAlert.h"
#import "JHDetailOfSeatAndNumberVC.h"
@interface JHAddSeatVC ()<UITableViewDataSource,UITableViewDelegate,HZQChosePickerViewDelegate,UITextFieldDelegate,AddSeatNameCellDelegate,UITextViewDelegate,JHAddSeatHeaderVeiwDelegate,HZQDatePickerDelegate>
{
    NSInteger time_num;//时间点的个数
    NSString * date;//选择的日期
    NSString * people_num;//人数
    BOOL isAddBox;//是否定包厢
    NSInteger index;//选择人时选中的索引
    JHAddSeatModel *model;
    UITextField* textField_user;//联系人
    UITextField * textField_mobile;//联系电话
    UITextView * textView_notice;//备注显示
    NSString * sex;//性别
    NSArray * array_people;//人数的数组
}
@property(nonatomic,retain)UIButton *btn;//底部的立即订座的按钮
@property(nonatomic,strong)UITableView *myTableView;//创建表视图
@end

@implementation JHAddSeatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    //添加底部的按钮
    [self.view addSubview:self.btn];
    //添加表视图
    [self.view addSubview:self.myTableView];
    
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"在线定座", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    //暂时的处理
    isAddBox = YES;
    sex = NSLocalizedString(@"先生", nil);
    array_people = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                     @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
                     @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",
                     @"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40"];
}
#pragma mark - 这是创建底部立即订座的方法
-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc]initWithFrame:FRAME(10, HEIGHT - 45, WIDTH - 20, 40)];
        _btn.backgroundColor = THEME_COLOR;
        [_btn setTitle:NSLocalizedString(@"立即占座", nil) forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.titleLabel.font = FONT(18);
        [_btn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 50) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = BACK_COLOR;
            table;
        });
    }
    return _myTableView;
}
#pragma mark 这是补齐UITableViewCell分割线
-(void)viewDidLayoutSubviews {
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_myTableView setSeparatorColor:[UIColor colorWithWhite:0.95 alpha:1]];
    }
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return 2;
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 3:
        {
            return 100;
        }
            break;
        default:
        {
            return 40;
        }
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ( section == 2 || section == 3) {
        return 40;
    }else if (section == 1){
        return 0.01;
    }
    else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 3) {
        return 10;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 2:
        {
            UILabel * label = [UILabel new];
            label.backgroundColor = BACK_COLOR;
            label.textColor = HEX(@"333333", 1.0);
            label.text = @"   顾客信息";
            label.font = FONT(14);
            return label;
        }
            break;
        case 3:
        {
            UILabel * label = [UILabel new];
            label.backgroundColor = BACK_COLOR;
            label.textColor = HEX(@"333333", 1.0);
            label.text = @"   备注信息";
            label.font = FONT(14);
            return label;
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString * str_cell = @"cell_time_people";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str_cell];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str_cell];
            }
            cell.textLabel.textColor = HEX(@"333333", 1.0);
            cell.detailTextLabel.textColor = HEX(@"333333", 1.0);
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(14);
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"icon-date"];
                cell.textLabel.text = NSLocalizedString(@"日期", nil);
                cell.detailTextLabel.text = date;
            }else{
                cell.imageView.image = [UIImage imageNamed:@"icon-people"];
                cell.textLabel.text = NSLocalizedString(@"人数", nil);
                cell.detailTextLabel.text = people_num;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        case 1:{
            UITableViewCell * cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = NSLocalizedString(@"订包厢", nil);
            cell.textLabel.font = FONT(14);
            cell.textLabel.textColor = HEX(@"666666", 1.0);
            UISwitch * right_switch = [[UISwitch alloc]init];
            right_switch.frame = FRAME(WIDTH - 55, 5, 80, 30);
            right_switch.onTintColor = THEME_COLOR;
            right_switch.transform = CGAffineTransformMakeScale(0.8, 0.8);
            right_switch.on = isAddBox;
            [right_switch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:right_switch];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                static NSString * cell_name = @"cell_name";
                AddSeatNameCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_name];
                if (!cell) {
                    cell = [[AddSeatNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_name];
                }
                cell.delegate = self;
                cell.textField_input.delegate = self;
                textField_user = cell.textField_input;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                static NSString * cell_phone = @"cell_phone";
                AddSeatPhoneCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_phone];
                if (!cell) {
                    cell = [[AddSeatPhoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_phone];
                }
                cell.textFiled_phone.delegate = self;
                textField_mobile = cell.textFiled_phone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
        default:
        {
           static NSString * cell_special = @"cell_special";
            AddButtomCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_special];
            if (!cell) {
                cell = [[AddButtomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_special];
            }
            cell.textView_input.delegate = self;
            textView_notice = cell.textView_input;
            return cell;
        }
            break;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     [self.view endEditing:YES];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
               //点击的日期
//                HZQCalendarControl * view = nil;
//                if (date == nil) {
//                 view = [HZQCalendarControl creatCalendarControlWithTime: [HZQChangeDateLine ExchangeWithdate:[NSDate date] withString:@"yyyy-MM-dd"] withSelecterColor:THEME_COLOR];
//                }else{
//                   view = [HZQCalendarControl creatCalendarControlWithTime: date withSelecterColor:THEME_COLOR];
//                }
//                [view setMyBlock:^(NSString *text) {
//                    date = text;
//                    [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                }];
                HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
                [datePicker creatDatePickerWithObj:datePicker withDate:date?[HZQChangeDateLine ExchangeWithTimeString:date]:[NSDate date] withMinuteInterval:30 withDatePickerMode:UIDatePickerModeDateAndTime];
                datePicker.delegate = self;
                
            }else{
               //选择人数
               HZQChosePickerView * view =  [HZQChosePickerView showChosePeopleNumViewWithArray:array_people withIndex:index];
                view.delegate = self;
            }
        }
            break;
    }
}
#pragma mark - 选择日期的代理方法
-(void)getDatePickerTime:(NSString *)time{
    date = time;
    [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
//#pragma mark - 这是点击时间段回调的方法
//-(void)clickTimeWithTag:(NSInteger)tag{
//    if (tag == 0) {
//        array_time = @[@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00"];
//    }else{
//        array_time = @[@"17:00",@"17:30",@"18:00",@"18:30"];
//    }
//    time_num = array_time.count;
//    [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
//}
#pragma mark - 这是点击是否定包厢的
-(void)clickSwitch:(UISwitch *)sender{
    if (sender.on) {
        isAddBox = YES;
    }else{
        isAddBox = NO;
    }
}
#pragma mark - 这是点击选择性别的方法
-(void)choseSex:(NSInteger)tag{
    if (tag == 0) {
        sex = NSLocalizedString(@"先生", nil);
        NSLog(@"选择的是先生");
    }else{
        sex = NSLocalizedString(@"女士", nil);
        NSLog(@"选择的是女士");
    }
}
#pragma mark - 选择人数时的代理方法
-(void)choseWithText:(NSString *)text withIndex:(NSInteger)num{
    index = num;
    people_num = text;
    [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - 这是UITextView的代理方法
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:NSLocalizedString(@"如有特殊要求,请填写,我们会尽量满足~", nil)]) {
        textView.text = @"";
        textView.textColor = HEX(@"333333", 1.0);
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.textColor = HEX(@"999999", 1.0);
        textView.text = NSLocalizedString(@"如有特殊要求,请填写,我们会尽量满足~", nil);
    }
}
#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
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
#pragma mark - 这是点击立即订座的方法
-(void)clickSureBtn{
    [self postAddSeatHttp];
}

#pragma mark - 这是订座下单的接口
-(void)postAddSeatHttp{
    if (!date || !people_num || textField_user.text.length
         == 0|| textField_mobile.text.length == 0 ) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请将信息补充完整", nil)];
        return;
    }
    if ([textView_notice.text isEqualToString:@
         "如有特殊要求,请填写,我们会尽量满足~"]) {
        textView_notice.text = @"";
    }
    SHOW_HUD
    NSDictionary * dic = @{@"shop_id":self.shop_id,
                           @"yuyue_time":date,
                           @"yuyue_number":people_num,
                           @"is_baoxiang":@(isAddBox).stringValue,
                           @"contact":[NSString stringWithFormat:@"%@%@",textField_user.text,sex],
                           @"mobile":textField_mobile.text,
                           @"notice":textView_notice.text};
    [HttpTool postWithAPI:@"client/yuyue/dingzuo/create" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
           JHDetailOfSeatAndNumberVC * vc = [[JHDetailOfSeatAndNumberVC alloc]init];
            vc.is_seat = YES;
            vc.order_id = json[@"data"][@"dingzuo_id"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error------>%@",error.localizedDescription);
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"网络连接有误,请检查您的网络", nil)];
    }];
}
@end

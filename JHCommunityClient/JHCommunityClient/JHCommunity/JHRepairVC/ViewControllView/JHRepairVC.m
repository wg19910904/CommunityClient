//
//  JHRepairVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRepairVC.h"
#import "YFTextView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "JHTouSuCellOne.h"
#import "JHTouSuCellTwo.h"
#import "JHTouSuCellThree.h"
#import "JHRepairTimeCell.h"
#import "HZQDatePicker.h"
#import "SelectImageVC.h"
#import "JHShareModel.h"
#import "CommunityHttpTool.h"
#import "JHInquiryRepairVC.h"
#define space (WIDTH - 105) / 4
@interface JHRepairVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_repairTableView;
    YFTextView *_textView;
    NSMutableArray *_imgArray;
    NSMutableArray *_imgDataArray;//作为参数
    UIButton *_inquiryBtn;//进度查询
    UIButton *_mobileBtn;//物业电话按钮
    UILabel *_wuYeMobile;//物业电话
    UIView *_wuYeMobileView;
    YFTextView *_note;//备注
    UIImagePickerController *_imagePicker;
    UILabel *_selectTimeLbale;
    UIImageView *_dirimg;
    UIView *_timeView;//选择时间背景图
    HZQDatePicker *_datePicker;
    SelectImageVC *_selectImg;
    JHShareModel *_shareModel;
    NSString *_time;//预约时间(参数)
    NSString *_name;//姓名(参数)
    NSString *_mobile;//电话(参数)
    NSDate *_date;//预约时间的时间格式数据
}
@end

@implementation JHRepairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"报修", nil);
    _date = [[NSDate alloc] init];
    [self configSubViews];
    [self initSubViews];
    [self createTableView];
    [self createRightButton];
}
#pragma mark--==初始化配置
- (void)configSubViews{
    _shareModel = [JHShareModel shareModel];
    _selectImg = [[SelectImageVC alloc] init];
    _imgArray = [@[] mutableCopy];
    _imgDataArray = [@[] mutableCopy];
    _datePicker = [[HZQDatePicker alloc] init];
}
#pragma mark--==创建表视图
- (void)createTableView{
    if(_repairTableView == nil){
        _repairTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT , WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _repairTableView.showsVerticalScrollIndicator = NO;
        _repairTableView.delegate = self;
        _repairTableView.dataSource = self;
        _repairTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BACK_COLOR;
        _repairTableView.backgroundView = view;
        [self.view addSubview:_repairTableView];
        
    }else{
        [_repairTableView reloadData];
    }
}
#pragma mark--==创建右侧提交按钮
- (void)createRightButton{
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = FRAME(0,0,44, 44);
    submitBtn.titleLabel.font = FONT(14);
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark--==提交按钮点击事件
- (void)clickSubmitButton{
    NSLog(@"提交按钮");
    [self getPostParams];
    if (_name.length == 0 || _name == nil){
        [self showAlertView:NSLocalizedString(@"请输入称呼", nil)];
    }else if (_mobile == nil || _mobile.length == 0){
        [self showAlertView:NSLocalizedString(@"请输入电话", nil)];
    }else if(_time == nil || _time.length == 0){
        [self showAlertView:NSLocalizedString(@"请选择处理时间", nil)];
    }else if (_note.inputText.length == 0 || _note.inputText == nil){
        [self showAlertView:NSLocalizedString(@"请输入您的建议以及你需要的服务", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = @{@"yezhu_id":_shareModel.communityModel.yezhu_id,@"yuyue_date":_time,@"contact":_name,@"mobile":_mobile,@"content":_note.inputText};
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        if(_imgDataArray.count != 0){
            for(int i = 0; i < _imgDataArray.count ; i++)
            {
                [dataDic setObject:_imgDataArray[i] forKey:[NSString stringWithFormat:@"photo%d",i + 1]];
            }
        }
        [CommunityHttpTool postWithAPI:@"client/xiaoqu/baoxiu/create" params:dic fromMoreDataDic:dataDic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD

                JHInquiryRepairVC *inquiry = [[JHInquiryRepairVC alloc] init];
                [self.navigationController pushViewController:inquiry animated:YES];
            }else{
                HIDE_HUD
                [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"报修提交失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            [self showNoNetOrBusy:YES];
        }];
    }
    
}
#pragma mark--==获取请求参数
- (void)getPostParams{
    JHTouSuCellOne *cell1 = [_repairTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    JHTouSuCellOne *cell2 = [_repairTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    _name = cell1.textField.text;
    _mobile = cell2.textField.text;
}
#pragma mark--==初始化子控件
- (void)initSubViews
{
    _inquiryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _inquiryBtn.frame = FRAME(15, 0, WIDTH - 30, 30);
    _inquiryBtn.titleLabel.font = FONT(14);
    _inquiryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_inquiryBtn setTitle:NSLocalizedString(@"记录查询", nil) forState:0];
    [_inquiryBtn setTitleColor:HEX(@"92b9e1", 1.0f) forState:0];
    [_inquiryBtn addTarget:self action:@selector(clickInquiryButton) forControlEvents:UIControlEventTouchUpInside];
    _note = [[YFTextView alloc] initWithFrame:FRAME(3, 0.5,WIDTH - 40,120)];
    _note.maxCount=10000;
    _note.hiddenCountLab=YES;
    _note.textFont=14;
    _note.placeholderColor=HEX(@"cccccc", 1.0f);
    _note.placeholderFont=14;
    _note.placeholderStr=@"您的建议以及你的需要的服务";
}
#pragma mark--===物业电话点击事件
- (void)clickWuYeMobileButton{
    NSLog(@"点击物业电话");
    [self showMobile:_shareModel.communityModel.phone];
}
#pragma mark---==进度查询和记录查询按钮点击事件
- (void)clickInquiryButton{
    NSLog(@"进度查询");
    JHInquiryRepairVC *inquiry = [[JHInquiryRepairVC alloc] init];
    [self.navigationController pushViewController:inquiry animated:YES];
}

#pragma mark--=====UITableViewDelegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return 5;
    else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 4)
            return space + 20;
        else if(indexPath.row == 3)
            return 120;
        else
            return 50;
    }else
        return 40;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 65;
    else
        return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 4){
                JHTouSuCellThree *cell = [[JHTouSuCellThree alloc] init];
                [cell.addImgBnt addTarget:self action:@selector(selectedImg) forControlEvents:UIControlEventTouchUpInside];
                __unsafe_unretained typeof(_repairTableView)weakTableView = _repairTableView;
                [cell setRefreshImgCellBlock:^(NSArray *imgArray, NSArray *imgDataArray) {
                    _imgArray = [imgArray mutableCopy];
                    _imgDataArray = [imgDataArray mutableCopy];
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                [cell setImgArray:_imgArray imgDataArray:_imgDataArray];
                return cell;
            }else if(indexPath.row == 3){
                JHTouSuCellTwo *cell = [[JHTouSuCellTwo alloc] init];
                [cell.backView addSubview:_note];
                return cell;
            }else if(indexPath.row == 2){
                JHRepairTimeCell *cell = [[JHRepairTimeCell alloc] init];
                return cell;
            }else{
                static NSString *identifier = @"cellOne";
                JHTouSuCellOne *cell = [_repairTableView dequeueReusableCellWithIdentifier:identifier];
                if(cell == nil){
                    cell = [[JHTouSuCellOne alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.indexPath = indexPath;
                return cell;
            }
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = BACK_COLOR;
            [cell.contentView addSubview:_inquiryBtn];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 2){
        [self.view endEditing:YES];
        JHRepairTimeCell *cell = [_repairTableView cellForRowAtIndexPath:indexPath];
        [_datePicker creatDatePickerWithObj:_datePicker withDate:[NSDate date]];
        [_datePicker setMyBlock:^(NSString *time) {
            if(time != nil || time.length != 0){
                cell.timeLabel.text = time;
                _time = time;
            }
        }];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BACK_COLOR;
        _wuYeMobileView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 50)];
        _wuYeMobileView.backgroundColor = [UIColor whiteColor];
        [view addSubview:_wuYeMobileView];
        _wuYeMobile = [[UILabel alloc] initWithFrame:FRAME(15, 0, WIDTH - 45, 50)];
        _wuYeMobile.font = FONT(16);
        _wuYeMobile.textColor = THEME_COLOR;
        
        _wuYeMobile.text = [NSString stringWithFormat:NSLocalizedString(@"物业电话   %@", nil),_shareModel.communityModel.phone];
//        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_wuYeMobile.text];
//        NSRange range = [_wuYeMobile.text rangeOfString:NSLocalizedString(@"物业电话", nil)];
//        [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"59c181", 1.0f)} range:range];
//        _wuYeMobile.attributedText = attributed;
        _mobileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mobileBtn.frame = FRAME(WIDTH - 35, 0, 35, 50);
        _mobileBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 15);
        
        [_mobileBtn setImage:IMAGE(@"complain_phone") forState:UIControlStateNormal];
        [_mobileBtn addTarget:self action:@selector(clickWuYeMobileButton) forControlEvents:UIControlEventTouchUpInside];
        [_wuYeMobileView addSubview:_mobileBtn];
        [_wuYeMobileView addSubview:_wuYeMobile];
        return view;
    }
    return nil;
}
#pragma mark--===选择图片
- (void)selectedImg{
    [_selectImg createImagePickerWithImgArray:_imgArray imgDataArray:_imgDataArray selectImgSuccessBlock:^(NSMutableArray *imgArray, NSMutableArray *imgDataArray) {
        _imgArray = imgArray;
        _imgDataArray = imgDataArray;
        __unsafe_unretained typeof(_repairTableView)weakTableView = _repairTableView;
        [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
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
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

@end

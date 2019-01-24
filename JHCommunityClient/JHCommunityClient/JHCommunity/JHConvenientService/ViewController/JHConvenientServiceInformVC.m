//
//  JHConvenientServiceInformVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHConvenientServiceInformVC.h"
#import "JHConvenientServiceInformCell.h"
#import "YFTextView.h"
#import "CommunityHttpTool.h"
#import "JHShareModel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface JHConvenientServiceInformVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_informTableView;
    UIButton *_submitBtn;//提交举报
    YFTextView *_note;//原因
    NSString *_title;//举报标题
    JHConvenientServiceInformCell *_lastCell;
    JHShareModel *_shareModel;
    NSArray *_dataSource;//数据源
}
@end

@implementation JHConvenientServiceInformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"举报", nil);
    _dataSource = [@[] mutableCopy];
    _title = nil;
    _shareModel = [JHShareModel shareModel];
    [self initNote];
    [self cofigTouSuData];
    [self createSubmitButton];
}
#pragma mark--===配置投诉类型
- (void)cofigTouSuData{
    SHOW_HUD
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/bianmin/reportType" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            _dataSource = json[@"data"][@"items"];
            [self createInformTableView];
            HIDE_HUD
        }else{
          HIDE_HUD
            [self showNoNetOrBusy:NO];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showNoNetOrBusy:YES];
    }];
}

#pragma mark--=====创建右侧提交按钮
- (void)createSubmitButton{
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.layer.cornerRadius = 4.0f;
    _submitBtn.clipsToBounds = YES;
    _submitBtn.frame = FRAME(15, 0, WIDTH - 30, 40);
    [_submitBtn addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.titleLabel.font = FONT(16);
    _submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:HEX(@"59C181",0.3f) forState:UIControlStateHighlighted];
    [_submitBtn setBackgroundColor:HEX(@"59C181",0.3f) forState:UIControlStateSelected];
}

#pragma mark--==初始化备注
- (void)initNote{
    _note = [[YFTextView alloc] initWithFrame:FRAME(0, 0, WIDTH, 100)];
    _note.maxCount=10000;
    _note.hiddenCountLab=YES;
    _note.textFont=14;
    _note.placeholderColor=HEX(@"999999", 1.0f);
    _note.placeholderFont=14;
    _note.placeholderStr=@"描述举报理由";
}

#pragma mark--===提交按钮点击事件
- (void)clickSubmitButton{
    NSLog(@"提交");
  
    if(_title == nil || _title.length == 0){
        [self showAlertView:NSLocalizedString(@"请选择举报标题", nil)];
    }else if (_note.inputText.length == 0 || _note.inputText == nil){
        [self showAlertView:NSLocalizedString(@"请完善举报内容", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = @{@"bianmin_id":self.bianmin_id,@"yezhu_id":_shareModel.communityModel.yezhu_id,@"title":_title,@"content":_note.inputText};
        [CommunityHttpTool postWithAPI:@"client/xiaoqu/bianmin/report" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                HIDE_HUD
                //[self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"举报失败,原因:%@", nil),json[@"message"]]];
                [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"举报失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            [self showNoNetOrBusy:YES];
        }];
 
    }
}

#pragma mark-===创建表视图
- (void)createInformTableView{
    if(_informTableView == nil){
        _informTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _informTableView.showsVerticalScrollIndicator = NO;
        _informTableView.delegate = self;
        _informTableView.dataSource = self;
        _informTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BACK_COLOR;
        _informTableView.backgroundView = view;
        [self.view addSubview:_informTableView];
    }else{
        [_informTableView reloadData];
    }
}

#pragma mark--====UITableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return _dataSource.count;//举报原因个数
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 50;
    else if(indexPath.section == 1)
        return 100;
    else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 50;
    else if(section == 1)
        return 10;
    else
        return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *identifier = @"convenientServiceInformCell";
        JHConvenientServiceInformCell *cell = [_informTableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[JHConvenientServiceInformCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.title.text = _dataSource[indexPath.row];
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:_note];
        UIView *line1 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        line1.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:line1];
        UIView *line2 = [UIView new];
        [cell.contentView addSubview:line2];
        line2.backgroundColor = LINE_COLOR;
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(WIDTH, 0.5));
            make.left.offset = 0;
            make.height.offset = 0.5;
            make.bottom.offset = 0;
        }];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = BACK_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:_submitBtn];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = BACK_COLOR;
        label.font = FONT(16);
        label.textColor = HEX(@"333333", 1.0f);
        label.text = @"   举报理由";
        return label;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        JHConvenientServiceInformCell *cell = [_informTableView cellForRowAtIndexPath:indexPath];
        cell.selectedImg.image = IMAGE(@"neighbourhood_select");
        _title = cell.title.text;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        JHConvenientServiceInformCell *cell = [_informTableView cellForRowAtIndexPath:indexPath];
        cell.selectedImg.image = IMAGE(@"Check_no");
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![IQKeyboardManager sharedManager].enable)
        [self.view endEditing:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
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

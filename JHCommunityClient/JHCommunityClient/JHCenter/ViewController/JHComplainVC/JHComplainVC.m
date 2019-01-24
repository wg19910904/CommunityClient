//
//  JHComplainVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHComplainVC.h"
#import <IQKeyboardManager.h>
#import "ComplainCell.h"
#import "MBProgressHUD.h"
 
#import "JHShowAlert.h"
@interface JHComplainVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_tableview;
    UITextView *_textView;
     UILabel *_describelLabel;
     UIControl *_backView;
    ComplainCell *_lastCell;
    NSString *_str;
    NSInteger _row;
}
@end

@implementation JHComplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title =NSLocalizedString(@"投诉", nil);
   [self handleData];
   [self createTableView];
}
#pragma mark====初始化控件=====
-(void)handleData{
    _str = nil;
    _backView = [[UIControl alloc] initWithFrame:FRAME(0,0,WIDTH,self.view.frame.size.height)];
    _backView.backgroundColor = BACK_COLOR;
    [_backView addTarget:self action:@selector(touchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backView];
    _textView = [[UITextView alloc] initWithFrame:FRAME(10, 10, WIDTH - 20, 80)];
    _describelLabel = [[UILabel alloc] initWithFrame:FRAME(10, 10, 200, 10)];
    _describelLabel.text = NSLocalizedString(@"输入您要投诉的内容", nil);
}
#pragma mark===创建表视图=========
- (void)createTableView
{
    _tableview = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH,HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = BACK_COLOR;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backView addSubview:_tableview];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [_tableview addSubview:thread];
}
#pragma mark======UITableViewDelegate=========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if(section == 0)
       return 3;
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *identifier = @"complain";
        ComplainCell *cell = [_tableview dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ComplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        switch (indexPath.row) {
            case 0:
                cell.title.text = NSLocalizedString(@"商家已接单,但没送达", nil);
                break;
            case 1:
                cell.title.text = NSLocalizedString(@"商家参加了活动,但没给优惠", nil);
                break;
            case 2:
                cell.title.text = NSLocalizedString(@"投诉其他", nil);
                break;
            default:
                break;
        }
        if(_row == indexPath.row){
        
            cell.img.image = IMAGE(@"selectCurrent");
            _lastCell = cell;
            _str = cell.title.text;
            
        }else{
        
             cell.img.image = IMAGE(@"selectDefault");
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        _textView.delegate = self;
        _textView.font = FONT(14);
        _textView.textColor = [UIColor blackColor];
        _textView.backgroundColor = HEX(@"999999", 0.1f);
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = HEX(@"999999", 0.3f).CGColor;
        _textView.layer.borderWidth = 0.2f;
        [cell.contentView addSubview:_textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenDescribel) name:UITextViewTextDidBeginEditingNotification object:nil];
        
        _describelLabel.textColor = HEX(@"999999", 1.0f);
        _describelLabel.font = FONT(14);
        [_textView addSubview:_describelLabel];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 99.5, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;

    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIButton  *submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBnt.frame = FRAME(10, 0, WIDTH - 20, 40);
        [submitBnt setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBnt.layer.cornerRadius = 4.0f;
        submitBnt.clipsToBounds = YES;
        submitBnt.titleLabel.font = FONT(14);
        [submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [submitBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
        [submitBnt addTarget:self action:@selector(submitBnt) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:submitBnt];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = HEX(@"e6e6e6", 0.2f);
        return cell;

    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1)
        return 10;
    else
        return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 40;
    else if(indexPath.section == 1)
        return 100;
    else
        return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplainCell *cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    cell.img.image = IMAGE(@"selectCurrent");
    if(_lastCell != nil)
    {
        _lastCell.img.image = IMAGE(@"selectDefault");
    }
    _lastCell = cell;
    _str = cell.title.text;
    _row = indexPath.row;
}
#pragma mark======提交按钮点击事件=========
- (void)submitBnt
{
    if(_textView.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"亲,请大声说出你投诉的理由", nil)];
    }
    else
    {
        SHOW_HUD
         NSDictionary *dic = @{@"order_id":self.order_id,@"title":_str,@"content":_textView.text};
        [HttpTool postWithAPI:@"client/member/order/complaint_handle" withParams:dic success:^(id json) {
            if([json[@"error"] isEqualToString:@"0"])
            {
                HIDE_HUD
                //[self showAlertView:NSLocalizedString(@"投诉成功", nil)];
                [self.view endEditing:YES];
                [JHShowAlert showAlertWithMsg:NSLocalizedString(@"投诉成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            else
            {
                HIDE_HUD
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"投诉失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
    }
   
    
}
#pragma mark=====隐藏输入你要投诉的内容=======
- (void)hiddenDescribel
{
    _describelLabel.hidden = YES;
}
#pragma mark========隐藏键盘=====
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    if(manager.enable)
    {
        
    }
    else
    {
        [self.view endEditing:YES];
        if(_textView.text.length == 0)
        {
            _describelLabel.hidden = NO;
        }
    }
}
- (void)touchView
{
    [self.view endEditing:YES];
}
#pragma mark=======提示框==========
- (void)showAlertView:(NSString *)title
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  JHEvaluationVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//评价页

#import "JHShopEvaluationVC.h"
#import "EvaluationStar.h"
#import "AppDelegate.h"
#import "MyTapGesture.h"
#import "MBProgressHUD.h"
 
#import "DisplayImageInView.h"
#import <IQKeyboardManager.h>
@interface JHShopEvaluationVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>

{
    
    UILabel *_integrationLabel;//评价可的积分
    EvaluationStar *_star1;
    EvaluationStar *_star2;
    EvaluationStar *_star3;
    EvaluationStar *_star4;
    NSInteger _row;
    UIControl *_control;
    UILabel *_timerLabel;//送达时间
    UIPickerView *_pickerView;
    UILabel *_time;
    NSString *_selectTime;
    UITextView *_textView;
    UILabel *_describelLabel;
    NSMutableArray *_imgDataArray;
    NSMutableArray *_imgArray;
    UIImagePickerController *_imagePicker;
    UIButton *_addImgBnt;
    UIView *_showImgView;
    DisplayImageInView *_displayView;
    UITableView *_tableView;
    NSString *content;
    
}

@property (nonatomic,copy)NSString *number;//积分
@property (nonatomic,assign)BOOL isZiti;
/*
 time": [
 {
 "minute": "10",
 "date": "15:17"
 },
 {
 "minute": "110",
 "date": "16:57"
 },
 {
 "minute": "120",
 "date": "17:07"
 }
 ]
 */
@property(nonatomic,strong)NSDictionary *orderInfoDic;
@end

@implementation JHShopEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"评价", nil);
    [self handleData];
    [self createTableView];
    [self getData];
    _row = 0;
}

-(void)getData{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/v3/waimai/order/comment_info" withParams:@{@"order_id":_order_id} success:^(id json) {
        HIDE_HUD
        NSLog(@"外卖订单评价 =======  %@",json);
        if (ISPostSuccess) {
            self.orderInfoDic = json[@"data"];
            self.number = json[@"data"][@"jifen_total"];
            self.isZiti = [json[@"data"][@"pei_type"] isEqualToString:@"3"];
            [_tableView reloadData];
        }else{
            [self showToastAlertMessageWithTitle:Error_Msg];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error : %@",error.description);
        [self showToastAlertMessageWithTitle:NOTCONNECT_STR];
    }];
}


#pragma mark====创建所需控件======
- (void)handleData
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imgDataArray = [NSMutableArray array];
    _imgArray = [NSMutableArray array];
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _addImgBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addImgBnt setBackgroundImage:IMAGE(@"add") forState:UIControlStateNormal];
    [_addImgBnt addTarget:self action:@selector(addImg:) forControlEvents:UIControlEventTouchUpInside];
    _star1 = [[EvaluationStar alloc] initWithFrame:FRAME(110, 10, WIDTH - 110, 20)];
    _star2 = [[EvaluationStar alloc] initWithFrame: FRAME(80, 10, 270, 20)];
    _star3 = [[EvaluationStar alloc] initWithFrame:FRAME(80, 10, 270, 20)];
    _star4 = [[EvaluationStar alloc] initWithFrame:FRAME(80, 10, 270, 20)];
    _timerLabel = [[UILabel alloc] initWithFrame:FRAME(100, 15, WIDTH - 120, 10)];
    _timerLabel.text = NSLocalizedString(@"请选择", nil);
    _textView = [[UITextView alloc] initWithFrame:FRAME(10, 10, WIDTH - 20, 80)];
    _describelLabel = [[UILabel alloc] initWithFrame:FRAME(10, 5, 200, 10)];
    _describelLabel.text = NSLocalizedString(@"您对Ta的印象", nil);
}
#pragma mark========创建表视图=========
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = BACK_COLOR;
    [self.view addSubview:_tableView];
}
#pragma mark======UITableViewDelegate========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.orderInfoDic) {
        [self showEmptyViewWithImgName:@"noMessage" desStr:nil btnTitle:nil inView:tableView];
        return  0;
    }else{
        [self hiddenEmptyView];
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1) return _isZiti ? 1 : 4;
    else return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2) return 100;
    else if(indexPath.section == 3) return  60;
    else if (indexPath.section == 4) return 65;
    else return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0) return 5;
    else if(section == 1) return  10;
    else if(section == 3) return 15;
    else return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:_star1];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(10, 10, 20, 20)];
        imgView.image = IMAGE(@"orderevaluation");
        [cell.contentView addSubview:imgView];
        UILabel *label = [[UILabel alloc] init];
        label.frame = FRAME(40, 15, 60, 10);
        label.text = NSLocalizedString(@"总体评价", nil);
        label.textColor = HEX(@"666666", 1.0f);
        label.font = FONT(14);
        [cell.contentView addSubview:label];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_star2];
                UILabel *label = [[UILabel alloc] init];
                label.frame = FRAME(10, 15, 60, 10);
                label.text = NSLocalizedString(@"商品打分", nil);
                label.font = FONT(14);
                label.textColor = HEX(@"666666", 1.0f);
                [cell.contentView addSubview:label];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread1.backgroundColor = LINE_COLOR;
                UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
                thread2.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread1];
                [cell.contentView addSubview:thread2];
                return cell;
                
            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_star3];
                UILabel *label = [[UILabel alloc] init];
                label.frame = FRAME(10, 15, 60, 10);
                label.text = NSLocalizedString(@"服务评价", nil);
                label.textColor = HEX(@"666666", 1.0f);
                label.font = FONT(14);
                [cell.contentView addSubview:label];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread1.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread1];
                return cell;
            }
                break;
            case 2:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_star4];
                UILabel *label = [[UILabel alloc] init];
                label.frame = FRAME(10, 15, 60, 10);
                label.text = NSLocalizedString(@"配送评价", nil);
                label.textColor = HEX(@"666666", 1.0f);
                label.font = FONT(14);
                [cell.contentView addSubview:label];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread1.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread1];
                return cell;
            }
                break;
            default:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *label = [[UILabel alloc] init];
                label.frame = FRAME(10, 15, 60, 10);
                label.text = NSLocalizedString(@"送达时间", nil);
                label.font = FONT(14);
                label.textColor = HEX(@"666666", 1.0f);
                [cell.contentView addSubview:label];
                _timerLabel.textAlignment = NSTextAlignmentLeft;
                _timerLabel.textColor = THEME_COLOR;
                _timerLabel.font = FONT(14);
                _timerLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
                [_timerLabel addGestureRecognizer:tap];
                [cell.contentView addSubview:_timerLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread1.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread1];
                return cell;
            }
                break;
        }
    }
    else if(indexPath.section== 2)
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
        UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 99.5, WIDTH, 0.5)];
        thread1.backgroundColor = LINE_COLOR;
        UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread2.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread1];
        [cell.contentView addSubview:thread2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else if(indexPath.section == 3)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 59.5, WIDTH, 0.5)];
        thread1.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread1];
        _showImgView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 60)];
        if(_imgArray.count != 0)
        {
            for(int i = 0; i < _imgArray.count; i ++)
            {
                UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(50 *i + 10, 10, 40, 40)];
                MyTapGesture *tap = [[MyTapGesture alloc] initWithTarget:self action:@selector(tapImage:)];
                tap.tag = i + 1;
                img.userInteractionEnabled = YES;
                img.image = _imgArray[i];
                [img addGestureRecognizer:tap];
                [_showImgView addSubview:img];
            }
            _addImgBnt.frame = FRAME(10 + (_imgArray.count)*50, 10, 40, 40);
            
        }
        else
        {
            _addImgBnt.frame = FRAME(10,10, 40, 40);
        }
        [_showImgView addSubview:_addImgBnt];
        [cell.contentView addSubview:_showImgView];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIButton  *submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBnt.frame = FRAME(10, 0, WIDTH - 20, 40);
        [submitBnt setTitle:NSLocalizedString(@"确定评价", nil) forState:UIControlStateNormal];
        [submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBnt.layer.cornerRadius = 4.0f;
        submitBnt.clipsToBounds = YES;
        submitBnt.titleLabel.font = FONT(14);
        [submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [submitBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
        [submitBnt addTarget:self action:@selector(submitBnt) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:submitBnt];
        _integrationLabel = [[UILabel alloc] initWithFrame:FRAME(10, 50, WIDTH - 20, 15)];
        _integrationLabel.textAlignment = NSTextAlignmentCenter;
        _integrationLabel.font = FONT(12);
        _integrationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"评价可得%@积分", nil),self.number];
        _integrationLabel.textColor = HEX(@"999999", 1.0f);
        [cell.contentView addSubview:_integrationLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = HEX(@"e6e6e6", 0.2f);
        return cell;
    }
    return nil;
}
#pragma mark=========UIPickerView的相关方法=========
//设置列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//设置每列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.orderInfoDic[@"time"] count];
}
//设置每列每行显示的view
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label=[[UILabel alloc]initWithFrame:FRAME((WIDTH - 120)/2, 0, 200, 40)];
    NSDictionary *dic = self.orderInfoDic[@"time"][row];
    label.text=dic[@"minute"];
    label.textAlignment = NSTextAlignmentCenter;
    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:THEME_COLOR];
    CGRect rect1 = [pickerView.subviews objectAtIndex:1].frame;
    rect1.origin.x = 20;
    rect1.size.width = pickerView.frame.size.width - 40;
    [[pickerView.subviews objectAtIndex:1] setFrame:rect1];
    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:THEME_COLOR];
    CGRect rect2 = [pickerView.subviews objectAtIndex:2].frame;
    rect2.origin.x = 20;
    rect2.size.width = pickerView.frame.size.width - 40;
    [[pickerView.subviews objectAtIndex:2] setFrame:rect2];
    return label;
}
//设置每列中项的高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
//设置每列的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}
//当用户选择某行内容时执行，row是用户选择的行，component是用户选择的行所在的列
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _row = row;
    NSDictionary *dic = self.orderInfoDic[@"time"][row];
    _selectTime=dic[@"minute"];
    _time.text = [NSString stringWithFormat:NSLocalizedString(@"%@送达", nil),dic[@"date"]];
    
}

#pragma mark====提交按钮点击事件=========
- (void)submitBnt
{
    NSLog(@"提交了");
    if(_star1.starNumber == 0)
    {
        [self showAlertView:NSLocalizedString(@"亲,请给一个总体评价哦", nil)];
        return;
    }
    
    if (_star2.starNumber == 0)
    {
        [self showAlertView:NSLocalizedString(@"亲,请给商品打分哦", nil)];
        return;
    }
    
    if (!_isZiti) {
         if (_star3.starNumber == 0)
        {
            [self showAlertView:NSLocalizedString(@"亲,请给出一个服务评价哦", nil)];
            return;
        }else if (_star4.starNumber == 0)
        {
            [self showAlertView:NSLocalizedString(@"亲,请给出一个配送评价哦", nil)];
            return;
        }
        else if([_timerLabel.text isEqualToString:NSLocalizedString(@"请选择", nil)])
        {
            [self showAlertView:NSLocalizedString(@"请选择送达时间", nil)];
            return;
        }
    }
    
    if(_textView.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"亲,请说出你对Ta的印象吧", nil)];
        return;
    }
  
    NSMutableDictionary *dic = @{@"score":@(_star1.starNumber),
                                 @"score_kouwei":@(_star2.starNumber),
                                 @"content":_textView.text,
                                 @"order_id":self.order_id}.mutableCopy;
    if (!_isZiti) {
        [dic addEntriesFromDictionary:@{@"score_fuwu":@(_star3.starNumber)}];
        [dic addEntriesFromDictionary:@{@"pei_score":@(_star4.starNumber)}];
        [dic addEntriesFromDictionary:@{@"pei_time":_selectTime}];
    }
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if(_imgDataArray.count != 0)
    {
        for(int i = 0; i < _imgDataArray.count; i++)
        {
            [dataDic setObject:_imgDataArray[i] forKey:[NSString stringWithFormat:@"photo%d",i + 1]];
        }
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"client/member/order/comment_handle" params:dic dataDic:dataDic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            HIDE_HUD
            [self showAlertView:NSLocalizedString(@"评价提交成功", nil)];
        }
        else
        {
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"评价提交失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
        }];
        
    
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
    [self.view endEditing:YES];
    if(_textView.text.length == 0){
        _describelLabel.hidden = NO;
    }
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
#pragma mark=========点击图片放大=======
- (void)tapImage:(MyTapGesture *)sender
{
    [self.view endEditing:YES];
    if(_textView.text.length == 0){
        _describelLabel.hidden = NO;
    }
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
        [_tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark==================
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
#pragma mark======选择送达时间Tap=========
- (void)tap
{
    [self.view endEditing:YES];
    [self createMenBan];
   
}
#pragma mark=====创建蒙版=============
- (void)createMenBan
{
    _control = [[UIControl alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    [ _control addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    _control.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_control];
    UIView *view = [[UIView alloc] initWithFrame:FRAME(20,( HEIGHT - 200)/2, WIDTH - 40, 250)];
    view.layer.cornerRadius = 4.0f;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [_control addSubview:view];
    _time = [[UILabel alloc] initWithFrame:FRAME(10,10,100,10)];
    _time.font = FONT(12);
    _time.textColor = THEME_COLOR;
    
    NSDictionary *dic = self.orderInfoDic[@"time"][_row];
    _selectTime=dic[@"minute"];
    _time.text = [NSString stringWithFormat:NSLocalizedString(@"%@送达", nil),dic[@"date"]];
   
    [view addSubview:_time];
    _pickerView.frame = FRAME(0, 0, WIDTH - 40, 200);
    [view addSubview:_pickerView ];
    if ([self.orderInfoDic[@"time"] count] > 0) {
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        [self pickerView:_pickerView didSelectRow:0 inComponent:0];
    }

    CGFloat space = (WIDTH - 120)/3;
    UIButton *certainBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    certainBnt.frame = FRAME(2 * space + 40, 215, 40, 30);
    [certainBnt addTarget:self action:@selector(certainBnt) forControlEvents:UIControlEventTouchUpInside];
    [certainBnt setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [certainBnt setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [view addSubview:certainBnt];
    UIButton *cancelBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBnt.frame = FRAME( space, 215, 40, 30);
    [cancelBnt addTarget:self action:@selector(cancelBnt) forControlEvents:UIControlEventTouchUpInside];
    [cancelBnt setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBnt setTitleColor:HEX(@"999999", 1.0f) forState:UIControlStateNormal];
    [view addSubview:cancelBnt];
}
#pragma mark=====时间选择器确定按钮=========
- (void)certainBnt
{
    
    NSDictionary *dic = self.orderInfoDic[@"time"][_row];
    _selectTime=dic[@"minute"];
    _timerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@送达", nil),dic[@"date"]];
    [_control removeFromSuperview];
}
#pragma mark======时间选择器取消按钮=======
- (void)cancelBnt
{
    [_control removeFromSuperview];
}
- (void)hiddenDescribel
{
    _describelLabel.hidden = YES;
}
- (void)touch_BackView
{
    [_control removeFromSuperview];
}
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

#pragma mark=======时间戳转化==========
- (NSString *)transfromWithString:(NSString *)str
{
    NSTimeInterval time = [str doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}

#pragma mark=======提示框==========
- (void)showAlertView:(NSString *)title
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if([title isEqualToString:NSLocalizedString(@"评价提交成功", nil)]){
            if (self.shopEvaluationSuccess) {
                self.shopEvaluationSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end

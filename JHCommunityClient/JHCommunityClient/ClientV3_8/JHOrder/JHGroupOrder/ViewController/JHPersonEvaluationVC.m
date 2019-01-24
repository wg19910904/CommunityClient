//
//  JHPersonEvaluationVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPersonEvaluationVC.h"
#import "EvaluationStar.h"
#import "AppDelegate.h"
#import "MyTapGesture.h"
#import "MBProgressHUD.h"
 
#import "DisplayImageInView.h"
#import <IQKeyboardManager.h>
@interface JHPersonEvaluationVC ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *_integrationLabel;//评价可的积分
    EvaluationStar *_star;
    UITextView *_textView;
    UILabel *_describelLabel;
    NSMutableArray *_imgDataArray;
    NSMutableArray *_imgArray;
    UIImagePickerController *_imagePicker;
    UIButton *_addImgBnt;
    UIView *_showImgView;
    DisplayImageInView *_displayView;
}
@end

@implementation JHPersonEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    self.title = NSLocalizedString(@"评价", nil);
//    self.view.backgroundColor = BACK_COLOR;
    [self handleData];

}

#pragma mark====初始化相关控件=====
- (void)handleData
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imgDataArray = [NSMutableArray array];
    _imgArray = [NSMutableArray array];
    _addImgBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addImgBnt setBackgroundImage:IMAGE(@"add") forState:UIControlStateNormal];
    [_addImgBnt addTarget:self action:@selector(addImg:) forControlEvents:UIControlEventTouchUpInside];
    _star = [[EvaluationStar alloc] initWithFrame:FRAME(110, 10, WIDTH - 110, 20)];
    _textView = [[UITextView alloc] initWithFrame:FRAME(10, 10, WIDTH - 20, 80)];
    _describelLabel = [[UILabel alloc] initWithFrame:FRAME(10, 5, 200, 10)];
    _describelLabel.text = NSLocalizedString(@"您对Ta的印象", nil);
}
#pragma mark====提交按钮点击事件=========
- (void)submitBnt
{
    NSLog(@"提交了");
    if(_star.starNumber == 0){
        [self showAlertView:NSLocalizedString(@"亲,请给一个总体评价哦", nil)];
    }else if(_textView.text.length == 0){
        [self showAlertView:NSLocalizedString(@"亲,请说出你对Ta的印象吧", nil)];
    }else{
        NSDictionary *dic = @{@"score":@(_star.starNumber),@"content":_textView.text,@"order_id":self.order_id};
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        if(_imgDataArray.count != 0)
        {
            for(int i = 0; i < _imgDataArray.count; i ++){
                [dataDic setObject:_imgDataArray[i] forKey:[NSString stringWithFormat:@"photo%d",i + 1]];
            }
        }
        SHOW_HUD
        NSString *api = nil;
        if(_isTuan){
            api = @"client/member/order/comment_handle";
        }else{
            api = @"client/member/order/staff_comment_handle";
        }
        [HttpTool postWithAPI:api params:dic dataDic:dataDic success:^(id json) {
            if([json[@"error"] isEqualToString:@"0"])
            {
                HIDE_HUD
                [self showAlertView:NSLocalizedString(@"评价提交成功", nil)];
            }else{
                HIDE_HUD
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"评价提交失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
    }
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
    return  4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 100;
    }
    else if(indexPath.section == 2)
    {
        return  60;
    }
    else if (indexPath.section == 3)
    {
        return 65;
    }
    else
    {
        return 40;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 5;
    }
    else if(section == 2)
    {
        return 15;
    }
    else
    {
        return 0.01;
    }
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
        [cell.contentView addSubview:_star];
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
    else if(indexPath.section== 1)
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
    else if(indexPath.section == 2)
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
        _integrationLabel = [[UILabel alloc] initWithFrame:FRAME((WIDTH - 110)/2, 50, 110, 15)];
        _integrationLabel.textAlignment = NSTextAlignmentCenter;
        _integrationLabel.font = FONT(12);
        _integrationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"评价可得%@积分", nil),self.number];
        _integrationLabel.textColor = HEX(@"999999", 1.0f);
        _integrationLabel.hidden = YES;
        [cell.contentView addSubview:_integrationLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = HEX(@"e6e6e6", 0.2f);
        return cell;
    }
    return nil;
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
#pragma mark==============
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
        NSArray *indexPath = @[[NSIndexPath indexPathForRow:0 inSection:2]];
        [_tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)hiddenDescribel
{
    _describelLabel.hidden = YES;
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
#pragma mark=======提示框==========
- (void)showAlertView:(NSString *)title
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if([title isEqualToString:NSLocalizedString(@"评价提交成功", nil)]){
            if (self.personEvaluationSuccess) {
                self.personEvaluationSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end

//
//  SelectImageVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SelectImageVC.h"
#import "AppDelegate.h"
@interface SelectImageVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation SelectImageVC

- (id)init{
    if(self = [super init]){
        if(_imagePicker == nil){
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.navigationBar.barTintColor = THEME_COLOR;
        }
    }
    return self;
}

- (void)createImagePickerWithImgArray:(NSMutableArray *)imgArray imgDataArray:(NSMutableArray *)imgDataArray selectImgSuccessBlock:(void (^)(NSMutableArray *, NSMutableArray *))selctImgSuccessBlock{
    self.imgArray = imgArray;
    self.imgDataArray = imgDataArray;
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
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController  presentViewController:alertController animated:YES completion:nil];
    [self setSelectImgBlock:^(NSMutableArray *imgArray, NSMutableArray *imgDataArray) {
        selctImgSuccessBlock(imgArray,imgDataArray);
    }];
}
#pragma mark=========相册中选择=========
- (void)imageFromAlbum
{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma mark=========打开相机=========
- (void)imageFromCamera
{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:_imagePicker animated:YES completion:nil];
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
    if(self.selectImgBlock){
        self.selectImgBlock(_imgArray,_imgDataArray);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
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

@end

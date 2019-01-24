//
//  SelectImageVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectImageVC : UIViewController
@property (nonatomic,copy)void(^selectImgBlock)(NSMutableArray *imgArray,NSMutableArray*imgDataArray);
@property (nonatomic,strong)NSMutableArray *imgDataArray;
@property (nonatomic,strong)NSMutableArray *imgArray;
@property (nonatomic,strong)UIImagePickerController *imagePicker;

- (void)createImagePickerWithImgArray:(NSMutableArray *)imgArray imgDataArray:(NSMutableArray *)imgDataArray selectImgSuccessBlock:(void (^)(NSMutableArray *imgArray,NSMutableArray *imgDataArray))selctImgSuccessBlock;
@end

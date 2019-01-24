//
//  JHHouseOrderDetailCellSix.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseOrderDetailCellSix.h"
#import "MyTapGestureRecognizer.h"
#import "DisplayImageInView.h"
@implementation JHHouseOrderDetailCellSix
{
    UIView * view;//蒙版
    UILabel * label_image;//显示查看图片的时候的选中张数
    UIScrollView * scrollV;//创建滑动视图
    DisplayImageInView * DisplayView;
}

-(void)setPhotoArray:(NSMutableArray *)photoArray{
    _photoArray = photoArray;
    if (self.imageV_One == nil) {
        self.imageV_One = [[UIImageView alloc]init];
        self.imageV_One.frame = FRAME(10, 10, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [self addSubview:self.imageV_One];
        MyTapGestureRecognizer * tapGusture = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        self.imageV_One.userInteractionEnabled = YES;
        tapGusture.tag = 1;
        [self.imageV_One addGestureRecognizer:tapGusture];
    }
    if (self.imageV_Two == nil) {
        self.imageV_Two = [[UIImageView alloc]init];
        self.imageV_Two.frame = FRAME(10*2+(WIDTH - 50)/4, 10, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [self addSubview:self.imageV_Two];
        MyTapGestureRecognizer * tapGusture1 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        self.imageV_Two.userInteractionEnabled = YES;
        tapGusture1.tag = 2;
        [self.imageV_Two addGestureRecognizer:tapGusture1];
    }
    if (self.imageV_Three == nil) {
        self.imageV_Three = [[UIImageView alloc]init];
        self.imageV_Three.frame = FRAME(10*3+(WIDTH - 50)/4*2, 10, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [self addSubview:self.imageV_Three];
        MyTapGestureRecognizer * tapGusture2 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        self.imageV_Three.userInteractionEnabled = YES;
        tapGusture2.tag = 3;
        [self.imageV_Three addGestureRecognizer:tapGusture2];
    }
    if (self.imageV_Four == nil) {
        self.imageV_Four = [[UIImageView alloc]init];
        self.imageV_Four.frame = FRAME(10*4+(WIDTH - 50)/4*3, 10, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [self addSubview:self.imageV_Four];
        MyTapGestureRecognizer * tapGusture3 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        self.imageV_Four.userInteractionEnabled = YES;
        tapGusture3.tag = 4;
        [self.imageV_Four addGestureRecognizer:tapGusture3];
    }
    if (self.photoArray.count == 0) {
        self.imageV_One.hidden = YES;
        self.imageV_Two.hidden = YES;
        self.imageV_Three.hidden = YES;
        self.imageV_Four.hidden = YES;
    }else if (self.photoArray.count == 1){
        self.imageV_One.hidden = NO;
        self.imageV_Two.hidden = YES;
        self.imageV_Three.hidden = YES;
        self.imageV_Four.hidden = YES;
        [self.imageV_One sd_image:[NSURL URLWithString:self.photoArray[0]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
    }else if (self.photoArray.count == 2){
        self.imageV_One.hidden = NO;
        self.imageV_Two.hidden = NO;
        self.imageV_Three.hidden = YES;
        self.imageV_Four.hidden = YES;
        [self.imageV_One sd_image:[NSURL URLWithString:self.photoArray[0]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
        [self.imageV_Two sd_image:[NSURL URLWithString:self.photoArray[1]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
    }else if (self.photoArray.count == 3){
        self.imageV_One.hidden = NO;
        self.imageV_Two.hidden = NO;
        self.imageV_Three.hidden = NO;
        self.imageV_Four.hidden = YES;
        [self.imageV_One sd_image:[NSURL URLWithString:self.photoArray[0]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
        [self.imageV_Two sd_image:[NSURL URLWithString:self.photoArray[1]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
        [self.imageV_Three sd_image:[NSURL URLWithString:self.photoArray[2]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
    }else if (self.photoArray.count == 4){
        self.imageV_One.hidden = NO;
        self.imageV_Two.hidden = NO;
        self.imageV_Three.hidden = NO;
        self.imageV_Four.hidden = NO;
        [self.imageV_One sd_image:[NSURL URLWithString:self.photoArray[0]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
        [self.imageV_Two sd_image:[NSURL URLWithString:self.photoArray[1]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
        [self.imageV_Three sd_image:[NSURL URLWithString:self.photoArray[2]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
        [self.imageV_Four sd_image:[NSURL URLWithString:self.photoArray[3]] plimage:[UIImage imageNamed:@"supermarketproduct"]];
    }

}
#pragma mark - 这是点击图片查看大图的方法
-(void)clickToSeeImage:(MyTapGestureRecognizer * )sender{
    //直接传图片
//    if (DisplayView == nil) {
//        DisplayView = [[DisplayImageInView alloc]init];
//        NSArray * array = @[[UIImage imageNamed:@"pic"],
//                            [UIImage imageNamed:@"pic"],
//                            [UIImage imageNamed:@"pic"],
//                            [UIImage imageNamed:@"pic"]];
//        [DisplayView showInViewWithImageArray:array withIndex:sender.tag  withBlock:^{
//            [DisplayView removeFromSuperview];
//            DisplayView = nil;
//        }];
//    }
    //传已经拼接好的图片url
        if (DisplayView == nil) {
            DisplayView = [[DisplayImageInView alloc]init];
            [DisplayView showInViewWithImageUrlArray:self.photoArray withIndex:sender.tag withBlock:^{
                [DisplayView removeFromSuperview];
                DisplayView = nil;
            }];
        }

}
@end

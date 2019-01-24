//
//  JHPetOrderDetailCellFour.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPetOrderDetailCellFour.h"

@implementation JHPetOrderDetailCellFour
{
    UILabel * label_title;
    UILabel * label_voice;
    UILabel * label_no;
    UILabel * label_time;
    UIView * view;
}

-(void)setHeight:(float)height{
    _height = height;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (label_title == nil) {
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(15, 10, WIDTH, 20);
        label_title.text = NSLocalizedString(@"跑腿明细", nil);
        label_title.font = [UIFont systemFontOfSize:13];
        label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        [self addSubview:label_title];
    }
    //创建显示要求得
    if (self.label_request == nil) {
        self.label_request = [[UILabel alloc]init];
        self.label_request.frame = FRAME(15, 35, WIDTH - 30, height);
        self.label_request.font = [UIFont systemFontOfSize:12];
        self.label_request.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        self.label_request.numberOfLines = 0;
        [self addSubview:self.label_request];
    }
    if (self.imageV == nil) {
        self.imageV = [[UIImageView alloc]init];
        self.imageV.frame = FRAME(15, 40+height, 60, 60);
        [self addSubview:self.imageV];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeBigImage)];
        self.imageV.userInteractionEnabled = YES;
        [self.imageV addGestureRecognizer:tap];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.photo];
    [self.imageV sd_image:[NSURL URLWithString:url] plimage:[UIImage imageNamed:@"supermarketproduct"]];
    if (self.photo == nil) {
        self.imageV.hidden = YES;
    }else{
        self.imageV.hidden = NO;
        
    }
    if (label_voice == nil) {
        label_voice = [[UILabel alloc]init];
        if (self.photo) {
            label_voice.frame = FRAME(15, 115+height, 60, 20);
        }else{
            label_voice.frame = FRAME(15, 115+height- 70, 60, 20);
        }
        label_voice.text = NSLocalizedString(@"语音内容:", nil);
        label_voice.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_voice.font = [UIFont systemFontOfSize:13];
        [self addSubview:label_voice];
    }
    if (self.imageVoice == nil) {
        self.imageVoice = [[UIImageView alloc]init];
        if (self.photo) {
            self.imageVoice.frame = FRAME(85, 110+height, 120, 30);
        }else{
            self.imageVoice.frame = FRAME(85, 110+height- 70, 120, 30);
        }
        [self addSubview:self.imageVoice];
        [self.imageVoice setImage:[UIImage imageNamed:@"newyuyin1"]];
    }
    if (label_no == nil) {
        label_no = [[UILabel alloc]init];
        if (self.photo) {
            label_no.frame = FRAME(90, 115+height, 20, 20);
        }else{
            label_no.frame = FRAME(90, 115+height-70, 20, 20);
        }
        label_no.text = NSLocalizedString(@"无", nil);
        label_no.font = [UIFont systemFontOfSize:13];
        label_no.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_no];
    }
    label_no.hidden = YES;
    if (label_time == nil) {
        label_time = [[UILabel alloc]init];
        if (self.photo) {
            label_time.frame = FRAME(210, 115+height, 60, 20);
        }else{
            label_time.frame = FRAME(210, 115+height-70, 60, 20);
        }
        label_time.text = [NSString stringWithFormat:@"%@s",self.voice_time];
        label_time.font = [UIFont systemFontOfSize:13];
        label_time.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_time];
    }
    if (self.animationImage == nil) {
        self.animationImage = [[UIImageView alloc]init];
        if (self.photo) {
            self.animationImage.frame = FRAME(95, 115+height, 16, 20);
        }else{
            self.animationImage.frame = FRAME(95, 115+height-70, 16, 20);
        }
        [self addSubview:self.animationImage];
    }
    if (self.voice == nil) {
        self.imageVoice.hidden = YES;
        self.animationImage.hidden = YES;
        label_time.hidden = YES;
        label_no.hidden = NO;
    }else{
        self.imageVoice.hidden = NO;
        self.animationImage.hidden = NO;
        label_time.hidden = NO;
        label_no.hidden = YES;
    }
}
#pragma mark - 这是点击手势查看大图的方法
-(void)clickToSeeBigImage{
    NSLog(@"想查看大图吗");
    [self creatMengBan];
}
#pragma mark - 创建蒙版
-(void)creatMengBan{
    if (view == nil) {
        view = [[UIView alloc]init];
        view.frame = FRAME(0, 0, WIDTH, HEIGHT);
        view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:view];
        UIImageView * imageView = [[UIImageView alloc]init];
        NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.photo];
        [imageView sd_image:[NSURL URLWithString:url] plimage:[UIImage imageNamed:@"supermarketproduct"]];
        [view addSubview:imageView];
        imageView.bounds = CGRectMake(0, 0, WIDTH, HEIGHT/2.4);
        imageView.center = view .center;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeMengban)];
        [view addGestureRecognizer:tap];
    }
}
//移除蒙版
-(void)removeMengban{
    [view removeFromSuperview];
    view = nil;
}
@end

//
//  JHTakeawayMengBan.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTakeawayMengBan.h"
#import "UIImage+MDQRCode.h"
@implementation JHTakeawayMengBan{
    JHTakeawayMengBan * mengBan;
}
+(void)shareMengBanWithCode:(NSString * )code withType:(NSString * )text{
    JHTakeawayMengBan * control = [[JHTakeawayMengBan alloc]init];
    [control creatMengBan:control withCode:code withType:text];
}
-(void)creatMengBan:(JHTakeawayMengBan *)control withCode:(NSString *)code withType:(NSString *)type{
    control.frame = FRAME(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    mengBan = control;
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:control];
    [control addTarget:self action:@selector(clickToCancel) forControlEvents:UIControlEventTouchUpInside];
    //创建中间白色的view
    UIView * view = [[UIView alloc]init];
    view.frame = FRAME(20, (HEIGHT - WIDTH + 40)/2, WIDTH - 40, WIDTH - 40);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    [control addSubview:view];
    //创建显示自提码三字的label
    UILabel * label_title = [[UILabel alloc]init];
    label_title.frame = FRAME(0, 10, WIDTH - 40, 20);
    label_title.font = [UIFont systemFontOfSize:15];
    label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    label_title.textAlignment = NSTextAlignmentCenter;
    label_title.text = NSLocalizedString(@"自提码", nil);
    [view addSubview:label_title];
    //中间的分割线
    UIView * label_line = [[UIView alloc]init];
    label_line.frame = FRAME(0, 39.5, WIDTH - 40, 0.5);
    label_line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:label_line];
    //创建显示自提码的label
    UILabel * label_code = [[UILabel alloc]init];
    label_code.frame = FRAME(0, 45, WIDTH - 40, 20);
    if ([type isEqualToString:NSLocalizedString(@"待商家核销", nil)]) {
        label_code.textColor = [UIColor colorWithRed:227/255.0 green:107/255.0 blue:30/255.0 alpha:1];
    }else{
        label_code.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    label_code.textAlignment = NSTextAlignmentCenter;
    label_code.font = [UIFont systemFontOfSize:16];
    label_code.text = code;
    [view addSubview:label_code];
    //创建显示是否核销的label
    UILabel * label_type = [[UILabel alloc]init];
    label_type.frame = FRAME(0, WIDTH - 80, WIDTH - 40, 20);
    label_type.text = type;
    label_type.font = [UIFont systemFontOfSize:15];
    label_type.textAlignment = NSTextAlignmentCenter;
    label_type.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    [view addSubview:label_type];
    //创建中间的二维码
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = FRAME(65, 80, WIDTH - 170, WIDTH - 170);
    imageView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    imageView.layer.borderWidth = 1;
    if ([type isEqualToString:NSLocalizedString(@"待商家核销", nil)]) {
        imageView.alpha = 1;
    }else{
        imageView.alpha = 0.3;
    }
    [view addSubview:imageView];
    imageView.image = [UIImage mdQRCodeForString:code size:imageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
}
#pragma mark - 这是点击移除蒙版的方法
-(void)clickToCancel{
    [mengBan removeFromSuperview];
     mengBan = nil;
}
@end

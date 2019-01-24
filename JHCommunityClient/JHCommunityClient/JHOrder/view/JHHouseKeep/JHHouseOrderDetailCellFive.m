//
//  JHHouseOrderDetailCellFive.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseOrderDetailCellFive.h"

@implementation JHHouseOrderDetailCellFive
{
    UILabel * label_voice;//显示语音内容
    UIView * label_line;//显示分割线
    UILabel * label_no;//显示无语音
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(label_voice == nil){
        label_voice = [[UILabel alloc]init];
        label_voice.frame = FRAME(15, 15, 80, 20);
        label_voice.text = NSLocalizedString(@"语音内容:", nil);
        label_voice.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_voice.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_voice];
    }
    if(label_line == nil){
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 49.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    if (self.imageVoice == nil) {
        self.imageVoice = [[UIImageView alloc]init];
        self.imageVoice.frame = FRAME(95,10, 120, 30);
        [self addSubview:self.imageVoice];
        [self.imageVoice setImage:[UIImage imageNamed:@"newyuyin1"]];
    }
    if (label_no == nil) {
        label_no = [[UILabel alloc]init];
        label_no.frame = FRAME(90,15 , 20, 20);
        label_no.text = NSLocalizedString(@"无", nil);
        label_no.font = [UIFont systemFontOfSize:13];
        label_no.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_no];
    }
    if(self.label_time == nil){
        self.label_time = [[UILabel alloc]init];
        self.label_time.frame = FRAME(220, 15, 60, 20);
        self.label_time.font = [UIFont systemFontOfSize:13];
        self.label_time.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:self.label_time];
    }
    self.label_time.text = [NSString stringWithFormat:@"%@s",self.voice_time];
    if (self.animationImage == nil) {
        self.animationImage = [[UIImageView alloc]init];
        self.animationImage.frame = FRAME(105, 15, 16, 20);
        [self addSubview:self.animationImage];
    }
    if (self.voice == nil) {
        self.imageVoice.hidden = YES;
        self.animationImage.hidden = YES;
        self.label_time.hidden = YES;
        label_no.hidden = NO;
    }else{
        self.imageVoice.hidden = NO;
        self.animationImage.hidden = NO;
        self.label_time.hidden = NO;
        label_no.hidden = YES;
    }

}

@end

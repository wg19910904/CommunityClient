//
//  SendTableViewCellFour.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCellFour.h"

@implementation SendTableViewCellFour

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.myLabel == nil) {
        //创建前面的imageView
        self.imageV = [[UIImageView alloc]init];
        self.imageV.frame = CGRectMake(10, 12.5, 15, 15);
        //self.imageV.backgroundColor = [UIColor redColor];
        self.imageV.image = [UIImage imageNamed:@"distance"];
        [self addSubview:self.imageV];
        //创建前面的label
        self.myLabel = [[UILabel alloc]init];
        self.myLabel.frame = CGRectMake(30, 13.5, 30, 15);
        self.myLabel.text = NSLocalizedString(@"距离", nil);
        self.myLabel.font = [UIFont systemFontOfSize:13];
        self.myLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.myLabel];
        //创建显示送达距离的label
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(70, 13.5, 60, 15);
        label.text = NSLocalizedString(@"送达距离", nil);
        label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        self.distanceLabel = [[UILabel alloc]init];
        self.distanceLabel.textColor = [UIColor redColor];
        self.distanceLabel.frame = CGRectMake(123, 13.5, 50, 15);
        self.distanceLabel.text = @"0.1km";
        self.distanceLabel.textAlignment = NSTextAlignmentCenter;
        self.distanceLabel.adjustsFontSizeToFitWidth = YES;
        self.distanceLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.distanceLabel];
        UILabel * label1 = [UILabel new];
        label1.frame = CGRectMake(173, 13.5, 100, 15);
        label1.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        label1.text = NSLocalizedString(@"左右", nil);
        label1.font = [UIFont systemFontOfSize:13];
        [self addSubview:label1];
        UILabel * labb = [[UILabel alloc]init];
        labb.frame = CGRectMake(0, 39, WIDTH, 1);
        labb.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self addSubview:labb];
    }
}
@end

//
//  SendTableViewCellSix.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCellSix.h"

@implementation SendTableViewCellSix

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.label1 == nil) {
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, WIDTH, 20);
        label.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self addSubview:label];
        self.label1 = [[UILabel alloc]init];
        self.label1.frame = CGRectMake(10, 30, WIDTH-10, 20);
        self.label1.text = NSLocalizedString(@"计费说明", nil);
        self.label1.textColor = [UIColor redColor];
        self.label1.font = [UIFont systemFontOfSize:13];
        //self.label1.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.label1];
        self.label2 = [[UILabel alloc]init];
        self.label2.frame = CGRectMake(10, 50, WIDTH-10, 80);
        self.label2.numberOfLines = 0;
        self.label2.adjustsFontSizeToFitWidth = YES;
        self.label2.font = [UIFont systemFontOfSize:13];
        self.label2.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.label2];
        self.label4 = [[UILabel alloc]init];
        self.label4.frame = CGRectMake(10, 133, WIDTH-10, 20);
        self.label4.text = NSLocalizedString(@"友情提示", nil);
        self.label4.textColor = [UIColor redColor];
        self.label4.font = [UIFont systemFontOfSize:13];
        //self.label4.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.label4];
        self.label5 = [[UILabel alloc]init];
        self.label5.frame = CGRectMake(10, 150, WIDTH-10, 50);
        self.label5.text = NSLocalizedString(@"节假日、交通拥堵时段、恶劣天气等情况，适当增加服务费，接单成功率会大大提高", nil);
        self.label5.numberOfLines = 0;
        //self.label5.adjustsFontSizeToFitWidth = YES;
        self.label5.font = [UIFont systemFontOfSize:13];
        self.label5.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.label5];


    }
}
-(void)setInfoArray:(NSMutableArray *)infoArray{
    _infoArray = infoArray;
    if (infoArray.count > 0) {
        if (self.isBuy) {
            self.label2.text = [NSString stringWithFormat:NSLocalizedString(@"起步价格: %@元,起步里程:%@公里\n每超过起步里程每公里的价格:%@元", nil),self.infoArray[0]?self.infoArray[0]:@"",self.infoArray[1]?self.infoArray[1]:@"",self.infoArray[3]?self.infoArray[3]:@""];
            NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:self.label2.text];
            NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
            [paragraph setLineSpacing:8];
            [attributed addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.label2.text.length)];
            self.label2.attributedText = attributed;
        }else{
            self.label2.text = [NSString stringWithFormat:NSLocalizedString(@"起步价格: %@元,起步里程:%@公里,起步重量:%@公斤\n每超过起步里程每公里的价格:%@元\n每超过起步重量每公斤的价格:%@元", nil),self.infoArray[0]?self.infoArray[0]:@"",self.infoArray[1]?self.infoArray[1]:@"",self.infoArray[2]?self.infoArray[2]:@"",self.infoArray[3]?self.infoArray[3]:@"",self.infoArray[4]?self.infoArray[4]:@""];
            NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:self.label2.text];
            NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
            [paragraph setLineSpacing:8];
            [attributed addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.label2.text.length)];
            self.label2.attributedText = attributed;
        }
       

    }
}
@end

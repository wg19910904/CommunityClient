//
//  SendTableViewCellEight.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCellEight.h"

@implementation SendTableViewCellEight

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
        [self addSubview:self.label1];
        self.label2 = [[UILabel alloc]init];
        self.label2.frame = CGRectMake(10, 50, WIDTH-10, 40);
        self.label2.numberOfLines = 0;
        self.label2.adjustsFontSizeToFitWidth = YES;
        self.label2.font = [UIFont systemFontOfSize:13];
        self.label2.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.label2];
        self.label3 = [[UILabel alloc]init];
        self.label3.frame = CGRectMake(10, 90, WIDTH-10, 20);
        self.label3.text = NSLocalizedString(@"友情提示", nil);
        self.label3.textColor = [UIColor redColor];
        self.label3.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.label3];
        self.label4 = [[UILabel alloc]init];
        self.label4.frame = CGRectMake(10, 110, WIDTH-10, 40);
        self.label4.text = NSLocalizedString(@"节假日、交通拥堵时段、恶劣天气等情况，适当增加服务费，接单成功率会大大提高", nil);
        self.label4.numberOfLines = 0;
        self.label4.adjustsFontSizeToFitWidth = YES;
        self.label4.font = [UIFont systemFontOfSize:13];
        self.label4.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.label4];

    }
}
-(void)setStart_price:(NSString *)start_price{
    _start_price = start_price;
    self.label2.text = [NSString stringWithFormat:NSLocalizedString(@"起步价格:%@元", nil),start_price?start_price:@""];
    
}
@end

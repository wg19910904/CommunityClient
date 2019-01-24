//
//  BalanceCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "BalanceCell.h"

@implementation BalanceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.titleLable = [[UILabel alloc] initWithFrame:FRAME(10, 10, WIDTH - 20, 15)];
        self.titleLable.font = FONT(14);
        self.titleLable.textColor = [UIColor blackColor];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLable];
        self.timeLabel = [[UILabel alloc] initWithFrame:FRAME(10, 35, 150, 10)];
        self.timeLabel.font = FONT(12);
        self.timeLabel.textColor = HEX(@"999999", 1.0f);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        self.moneyLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 100, 20, 90, 10)];
        self.moneyLabel.font = FONT(12);
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.moneyLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [self.contentView addSubview:thread];
        
    }
    return  self;
}
- (void)setBalanceModel:(BalanceModel *)balanceModel
{
    _balanceModel = balanceModel;
    self.titleLable.text = balanceModel.intro;
    self.timeLabel.text = [self transfromWithString:_balanceModel.dateline];
    if([balanceModel.number floatValue] < 0)
    {
        self.moneyLabel.textColor = HEX(@"f85357", 1.0f);
       
    }
    else
    {
         self.moneyLabel.textColor = THEME_COLOR;
    }
    
    self.moneyLabel.text = balanceModel.number;
    
}
//时间戳转换时间
- (NSString *)transfromWithString:(NSString *)str
{
    NSTimeInterval time = [str doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}
@end

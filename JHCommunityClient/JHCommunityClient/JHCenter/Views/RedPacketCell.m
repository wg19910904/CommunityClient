//
//  RedPacketCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "RedPacketCell.h"

@implementation RedPacketCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backView = [[UIView alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 95)];
        self.backView .backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(5, 18, 60, 60)];
        self.iconImg.image = IMAGE(@"10");
        [self.backView addSubview:self.iconImg];
        self.amount = [[UILabel alloc] initWithFrame:FRAME(0, 15, 60, 45)];
        self.amount.textAlignment = NSTextAlignmentCenter;
        self.amount.font = FONT(20);
        [self.iconImg addSubview:self.amount];
        self.titleLabel = [[UILabel alloc] initWithFrame:FRAME(75, 15, 150, 10)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = FONT(16);
        self.titleLabel.textColor = [UIColor blackColor];
        [self.backView addSubview:self.titleLabel];
        self.limitLabel = [[UILabel alloc] initWithFrame:FRAME(75, 35,150, 10)];
        self.limitLabel.textAlignment = NSTextAlignmentLeft;
        self.limitLabel.font = FONT(12);
        self.limitLabel.textColor = HEX(@"999999", 1.0f);
        [self.backView addSubview:self.limitLabel];
        self.timeLable = [[UILabel alloc] initWithFrame:FRAME(75, 55, 200, 10)];
        self.timeLable.textAlignment = NSTextAlignmentLeft;
        self.timeLable.font = FONT(12);
        self.timeLable.textColor = HEX(@"999999", 1.0f);
        [self.backView addSubview:self.timeLable];
        
        self.typeLable = [[UILabel alloc] initWithFrame:FRAME(75, 75, 200, 10)];
        self.typeLable.textAlignment = NSTextAlignmentLeft;
        self.typeLable.font = FONT(12);
        self.typeLable.textColor = HEX(@"999999", 1.0f);
        [self.backView addSubview:self.typeLable];
        
        self.img = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 95, 10, 75, 50)];
        [self.backView addSubview:self.img];
        self.contentView.backgroundColor = BACK_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
}
//- (void)setRedPacketModel:(RedPacketModel *)redPacketModel
//{
//    _redPacketModel = redPacketModel;
//    self.amount.text = [NSString stringWithFormat:NSLocalizedString(@"￥%@", nil),redPacketModel.amount];
//    if([redPacketModel.used_time integerValue] >= [redPacketModel.stime integerValue] && [redPacketModel.used_time integerValue] < [redPacketModel.ltime integerValue])
//    {
//        //已使用
//        self.img.image = IMAGE(@"guoqi_2");
//        self.amount.textColor = HEX(@"cccccc", 1.0f);
//        self.iconImg.image = IMAGE(@"redbagray");
//    }
//    else if([redPacketModel.nowtime integerValue] >= [redPacketModel.ltime integerValue])
//    {
//        //已过期
//         self.img.image= IMAGE(@"guoqi");
//         self.amount.textColor = HEX(@"cccccc", 1.0f);
//         self.iconImg.image = IMAGE(@"redbagray");
//    }
//    else
//    {
//        self.amount.textColor = HEX(@"ff2424", 1.0f);
//        self.iconImg.image = IMAGE(@"redbag");
//    }
//    self.titleLabel.text = redPacketModel.title;
//    self.limitLabel.text = [NSString stringWithFormat:NSLocalizedString(@"使用限制:%@元可使用", nil),redPacketModel.min_amount];
//    self.timeLable.text = [NSString stringWithFormat:NSLocalizedString(@"过期时间:%@", nil),[self transfromWithString:redPacketModel.ltime]];
//}
- (void)setRedPacketModel:(RedPacketModel *)redPacketModel selectRedPacket:(BOOL)selectRedPacket
{
    _redPacketModel = redPacketModel;
    self.amount.text = [NSString stringWithFormat:NSLocalizedString(@"￥%@", nil),redPacketModel.amount];
    if([redPacketModel.status isEqualToString:@"3"])
    {
        //已使用
        if(selectRedPacket)
        {
            self.img.frame = FRAME(self.backView.frame.size.width - 40, 25, 30, 30);
            self.img.image = IMAGE(@"selectDefault");
            self.img.highlightedImage = IMAGE(@"selectCurrent");
        }
        else
        {
            self.img.image = IMAGE(@"guoqi_2");
            
        }
        self.amount.textColor = HEX(@"cccccc", 1.0f);
        self.iconImg.image = IMAGE(@"redbagray");
    }
    else if([redPacketModel.status isEqualToString:@"2"])
    {
        //已过期
        if(selectRedPacket)
        {
            self.img.frame = FRAME(self.backView.frame.size.width - 40, 25, 30, 30);
            self.img.image = IMAGE(@"selectDefault");
            self.img.highlightedImage = IMAGE(@"selectCurrent");
        }
        else
        {
            self.img.image= IMAGE(@"guoqi");
            
        }
        self.amount.textColor = HEX(@"cccccc", 1.0f);
        self.iconImg.image = IMAGE(@"redbagray");
    }
    else
    {
        if(selectRedPacket)
        {
            self.img.frame = FRAME(self.backView.frame.size.width - 40, 25, 30, 30);
            self.img.image = IMAGE(@"selectDefault");
            self.img.highlightedImage = IMAGE(@"selectCurrent");
        }
        else
        {
            
        }
        
        self.amount.textColor = HEX(@"ff2424", 1.0f);
        self.iconImg.image = IMAGE(@"redbag");
    }
    self.titleLabel.text = redPacketModel.title;
    self.limitLabel.text = [NSString stringWithFormat:NSLocalizedString(@"使用限制:%@元可使用", nil),redPacketModel.min_amount];
    self.timeLable.text = [NSString stringWithFormat:NSLocalizedString(@"过期时间:%@", nil),[self transfromWithString:redPacketModel.ltime]];
    self.typeLable.text = [NSLocalizedString(@"红包类型:", nil) stringByAppendingString:redPacketModel.from_lable];
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

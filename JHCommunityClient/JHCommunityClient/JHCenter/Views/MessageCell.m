//
//  MessageCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/3.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MessageCell.h"
#import "NSObject+CGSize.h"
@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _iconImg = [[UIImageView alloc] initWithFrame:FRAME(10,22.5,20, 25)];
        [self.contentView addSubview:_iconImg];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(14);
        _titleLabel.frame = FRAME(35, 10, WIDTH - 45, 10);
        [self.contentView addSubview:_titleLabel];
        _timeLabel = [[UILabel alloc] initWithFrame:FRAME(35, 50, 150, 10)];
        _timeLabel.font = FONT(12);
        _timeLabel.textColor = HEX(@"999999", 1.0f);
        [self.contentView addSubview:_timeLabel];
        _detailLabel = [[UILabel alloc] initWithFrame:FRAME(35, 30, WIDTH - 45, 10)];
        _detailLabel.font = FONT(12);
        _detailLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_detailLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 69, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [self.contentView addSubview:thread];
    }
    return self;
}
- (void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    
    if([messageModel.is_read isEqualToString:@"0"])
    {
        _titleLabel.textColor = [UIColor blackColor];
        if([_messageModel.type isEqualToString:@"1"])
        {
            _iconImg.image = IMAGE(@"bao");
        }
        else if([_messageModel.type isEqualToString:@"2"])
        {
            _iconImg.image = IMAGE(@"dingdan-1");
        }
    }
    else if([messageModel.is_read isEqualToString:@"1"])
    {
        _titleLabel.textColor = HEX(@"999999", 1.0f);
        if([_messageModel.type isEqualToString:@"1"])
        {
            _iconImg.image = IMAGE(@"bao_2");
        }
        else if([_messageModel.type isEqualToString:@"2"])
        {
            _iconImg.image = IMAGE(@"dingdan_2");
        }
    
    }
    _titleLabel.text = messageModel.title;
    _detailLabel.text = messageModel.content;
    _timeLabel.text = [self transfromWithString:_messageModel.dateline];
}
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

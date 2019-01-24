//
//  JHHouseKeepingEvalutionCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseKeepingEvalutionCell.h"

@implementation JHHouseKeepingEvalutionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backView = [[UIView alloc] init];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        self.evalutionLabel = [[UILabel alloc] init];
        self.evalutionLabel.textColor = HEX(@"666666", 1.0f);
        self.evalutionLabel.font = FONT(14);
        [self.backView addSubview:self.evalutionLabel];
        self.fromLabel = [[UILabel alloc] init];
        self.fromLabel.textColor = HEX(@"999999", 1.0f);
        self.fromLabel.font = FONT(12);
        [self.backView addSubview:self.fromLabel];
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = HEX(@"999999", 1.0f);
        self.timeLabel.font = FONT(12);
        [self.backView addSubview:self.timeLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BACK_COLOR;
    }
    return  self;
}
- (void)setFrameModel:(HoseKeepingCommentFrameModel *)frameModel
{
    _frameModel = frameModel;
    self.evalutionLabel.text = frameModel.commentModel.content;
    self.evalutionLabel.frame = frameModel.commentRect;
    [self.starView removeFromSuperview];
    self.starView = nil;
    self.starView = [StarView addEvaluateViewWithStarNO:[self.frameModel.commentModel.score floatValue] withStarSize:10 withBackViewFrame:frameModel.starRect];
    [self.backView addSubview:self.starView];
    self.fromLabel.text = [NSString stringWithFormat:NSLocalizedString(@"来自%@", nil),frameModel.commentModel.nickname];
    self.fromLabel.frame = FRAME(10, 40 + self.evalutionLabel.frame.size.height, 150, 15);
    self.timeLabel.text = [self transfromWithString:frameModel.commentModel.dateline];
    self.timeLabel.frame = FRAME(WIDTH - 130, 40 + self.evalutionLabel.frame.size.height, 110, 15);
    self.backView.frame = FRAME(10, 10, WIDTH - 20, 60 + self.evalutionLabel.frame.size.height);
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

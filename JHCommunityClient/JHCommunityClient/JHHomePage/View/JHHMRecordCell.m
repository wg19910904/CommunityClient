//
//  JHHMRecordCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHMRecordCell.h"

@implementation JHHMRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
    }
    return self;
}
- (void)initSubViews{
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceBtn.frame = FRAME(WIDTH - 55, 60, 30, 30);
    [_voiceBtn setBackgroundImage:IMAGE(@"lab") forState:UIControlStateNormal];
    _recordBackImg = [[UIView alloc]init];
    [self.contentView addSubview:_recordBackImg];
    
    [_recordBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.width.offset = 120;
        make.top.offset = 115;
        make.height.offset = 30;
    }];
    _recordBackImg.layer.cornerRadius = 15.0f;
    _recordBackImg.clipsToBounds = YES;
    _recordBackImg.backgroundColor = THEME_COLOR;
    _recordBackImg.userInteractionEnabled = YES;
    _recordBackImg.hidden = YES;
    
    
    _recordTime = [[UILabel alloc]init];
    [_recordBackImg addSubview:_recordTime];
    _recordTime.textAlignment = NSTextAlignmentRight;
    _recordTime.font = [UIFont systemFontOfSize:14];
    _recordTime.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    [_recordTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.width.offset = 60;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
    
    _recordImageAnnimation = [[UIImageView alloc]init];
    [_recordBackImg addSubview:_recordImageAnnimation];
    _recordImageAnnimation.image = [UIImage imageNamed:@"ph_voiceC"];
    _recordImageAnnimation.animationImages = [NSArray arrayWithObjects:
                                              [UIImage imageNamed:@"ph_voiceA"],
                                              [UIImage imageNamed:@"ph_voiceB"],
                                              [UIImage imageNamed:@"ph_voiceC"],nil];
    _recordImageAnnimation.animationDuration = 1;
    _recordImageAnnimation.animationRepeatCount = 0;
    [_recordImageAnnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.offset = 5;
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

}
- (void)setRecordTimeText:(int)recordTimeText{
    
}
@end

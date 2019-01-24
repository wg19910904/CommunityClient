//
//  HouseKeepingAssginPersonCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/19.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MaintainAssginPersonCell.h"
#import "StarView.h"
#import "NSObject+CGSize.h"
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
@implementation MaintainAssginPersonCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectImg = [[UIImageView alloc] init];
        self.selectImg.frame = FRAME(10, 30, 20, 20);
        self.selectImg.image = IMAGE(@"selectDefault");
        [self.contentView addSubview:self.selectImg];
        self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(40, 15, 50, 50)];
        self.iconImg.layer.cornerRadius = self.iconImg.frame.size.width / 2;
        self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImg.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImg];
        self.name = [[UILabel alloc] init];
        self.name.font = FONT(14);
        self.name.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:self.name];
        self.length = [[UILabel alloc] init];
        self.length.textColor = HEX(@"fc7400", 1.0f);
        self.length.font = FONT(11);
        [self.contentView addSubview:self.length];
        self.service = [[UILabel alloc] initWithFrame:FRAME(157 + 30, 40, 110, 15)];
        self.service.font = FONT(12);
        self.service.textColor = HEX(@"999999", 1.0f);
        [self.contentView addSubview:self.service];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *thraed = [[UIView alloc] initWithFrame:FRAME(0, 79.5, WIDTH, 0.5)];
        thraed.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thraed];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setAssignModel:(MaintainListModel *)assignModel
{
    _assignModel = assignModel;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:assignModel.face]];
    [self.iconImg sd_image:url plimage:IMAGE(@"maintainheader")];
    self.name.text = assignModel.name;
    CGSize nameSize = [self currentSizeWithString:self.name.text font:FONT(14) withWidth:0];
    self.name.frame = FRAME(100, 17, nameSize.width, 15);
    self.length.text = assignModel.juli;
    CGSize lenghtSize = [self currentSizeWithString:assignModel.juli font:FONT(11) withWidth:150];
    _length.frame = FRAME(WIDTH  - lenghtSize.width - 20, 17, lenghtSize.width, 15);
    self.service.text = [NSString stringWithFormat:NSLocalizedString(@"服务%@次", nil),assignModel.orders];
    self.startView = [StarView addEvaluateViewWithStarNO:[assignModel.avg_score floatValue] withStarSize:10 withBackViewFrame:FRAME(100, 35, 70, 10)];
    [self.contentView addSubview:self.startView];

}
@end

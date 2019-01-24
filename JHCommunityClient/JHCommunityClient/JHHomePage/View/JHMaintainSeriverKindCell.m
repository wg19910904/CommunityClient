//
//  JHHouseKeepingSeriverKindCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHMaintainSeriverKindCell.h"
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
@implementation JHMaintainSeriverKindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 15, 50, 50)];
        self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImg.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImg];
        self.nameLabel = [[UILabel alloc] initWithFrame:FRAME(70, 20, WIDTH - 100, 10)];
        
        self.nameLabel.font = FONT(14);
        self.nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLabel];
//        self.priceLbael = [[UILabel alloc] initWithFrame:FRAME(70, 30, WIDTH - 100, 10)];
//       
//        self.priceLbael.font = FONT(14);
//        self.priceLbael.textColor = HEX(@"999999", 1.0f);
//        [self.contentView addSubview:self.priceLbael];
        self.areaLabel = [[UILabel alloc] initWithFrame:FRAME(70, 50, WIDTH - 100, 10)];
        
        self.areaLabel.font = FONT(14);
        self.areaLabel.textColor = HEX(@"999999", 1.0f);
        [self.contentView addSubview:self.areaLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 79.5, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thread];
    }
    return  self;
    
}
- (void)setSeriverModel:(MaintainSeriverKindModel *)seriverModel
{
    _seriverModel = seriverModel;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:seriverModel.icon]];
    [self.iconImg sd_image:url plimage:IMAGE(@"house&maintainservice")];
    self.nameLabel.text = seriverModel.title;
//    self.priceLbael.text = [NSString stringWithFormat:NSLocalizedString(@"计价方式:%@元/%@", nil),seriverModel.price,seriverModel.unit];
    self.areaLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@元起", nil),seriverModel.start];
}
@end

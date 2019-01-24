//
//  ComplainCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ComplainCell.h"

@implementation ComplainCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.title = [[UILabel alloc] initWithFrame:FRAME(10, 12.5, WIDTH - 40, 15)];
        self.title.font = FONT(14);
        self.title.text = NSLocalizedString(@"商家已接单,但没送达", nil);
        self.title.textColor = HEX(@"666666", 1.0f);
        [self.contentView addSubview:self.title];
        self.img = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 30, 10, 20,20)];
        [self.contentView addSubview:self.img];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thread];
    }
    return  self;
}

@end

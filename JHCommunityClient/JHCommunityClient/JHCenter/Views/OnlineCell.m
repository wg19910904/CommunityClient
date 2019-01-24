//
//  OnlineCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "OnlineCell.h"

@implementation OnlineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.titleLabel = [[UILabel alloc] init];
        self.detailLabel = [[UILabel alloc] init];
        self.iconImg = [[UIImageView alloc] init];
        self.img = [[UIImageView alloc] init];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.img];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}
@end

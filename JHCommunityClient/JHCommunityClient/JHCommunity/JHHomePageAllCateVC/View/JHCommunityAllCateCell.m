//
//  JHCommunityAllCateCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHCommunityAllCateCell.h"

@implementation JHCommunityAllCateCell
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _iconImg = [UIImageView new];
        _iconImg.image = IMAGE(@"pay_4");
        _iconImg.frame = FRAME(20, 20, frame.size.width - 40, frame.size.height - 60);
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
        _iconImg.clipsToBounds = YES;
        [self.contentView addSubview:_iconImg];
        _title = [UILabel new];
        _title.font = FONT(12);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = HEX(@"666666", 1.0f);
        [self.contentView addSubview:_title];
        _title.frame = FRAME(0, frame.size.height - 30, frame.size.width, 20);
        _title.text = NSLocalizedString(@"小区", nil);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end

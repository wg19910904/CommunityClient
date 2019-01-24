//
//  HouseKeppeingHomeCateCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "HouseKeppeingHomeCateCell.h"
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
@implementation HouseKeppeingHomeCateCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pictureImg = [[UIImageView alloc] initWithFrame:FRAME(20, 20, frame.size.width - 40, frame.size.height - 60)];
        self.pictureImg.contentMode = UIViewContentModeScaleAspectFill;
        self.pictureImg.clipsToBounds = YES;
        [self.contentView addSubview:self.pictureImg];
        self.titleLabel = [[UILabel alloc] initWithFrame:FRAME(0, frame.size.height - 30, frame.size.width, 20)];
        self.titleLabel.font = FONT(12);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = HEX(@"666666", 1.0f);
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setProductModel:(HouseKeepingHomeCateProductModel *)productModel
{
    _productModel = productModel;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:productModel.icon]];
    [self.pictureImg sd_image:url plimage:IMAGE(@"housetwocategory")];
    self.titleLabel.text = productModel.title;
    NSLog(@"%@",productModel.title);
}
@end

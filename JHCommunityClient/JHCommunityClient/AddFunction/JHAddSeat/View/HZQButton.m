//
//  HZQButton.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "HZQButton.h"

@implementation HZQButton
{
    UIImageView * imageV;
    UILabel * title_label;
    UIImage * selecter_image;
    UIImage * nor_image;
}
-(instancetype)initWithText:(NSString *)title
              selecterImage:(UIImage *)selecterImage
               defaultImage:(UIImage *)defaultImage
{
    if (self = [super init]) {
        selecter_image = selecterImage;
        nor_image = defaultImage;
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME(10, 5, 20, 20);
        imageV.image = defaultImage;
        [self addSubview:imageV];
        title_label = [[UILabel alloc]init];
        title_label.frame = FRAME(45, 5,title.length*14+10, 20);
        title_label.font = FONT(14);
        title_label.textColor = HEX(@"333333", 1.0);
        title_label.text = title;
        [self addSubview:title_label];
    }
    return self;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        imageV.image = selecter_image;
    }else{
        imageV.image = nor_image;
    }
}
@end

//
//  JHHouseKeepingCateCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHMaintainCateCell.h"
#import "NSObject+CGSize.h"
@implementation JHMaintainCateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *selectedBV = [UIView new];
        selectedBV.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0f];
        self.selectedBackgroundView = selectedBV;
    }
    return self;
}
#pragma mark--===初始化子空间
- (void)initSubViews{
    self.titleLbel = [[UILabel alloc] initWithFrame:FRAME(46, 0, WIDTH*0.4 - 50, 40)];
    self.titleLbel.font = FONT(12);
    self.titleLbel.textColor = HEX(@"333333", 1.0);
    [self addSubview:self.titleLbel];
    
    self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(15, 12, 16, 16)];
    [self addSubview:self.iconImg];
    
    self.dirImg = [[UIImageView alloc] init];
    self.dirImg.image = IMAGE(@"jiantou_1");
    self.dirImg.frame = FRAME(WIDTH / 5 * 2 - 27, 14, 7, 12);
    self.dirImg.tag = 200;
    [self.contentView addSubview:self.dirImg];
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

@end

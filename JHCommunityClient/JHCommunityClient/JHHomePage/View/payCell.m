//
//  payCell.m
//  Lunch
//
//  Created by xixixi on 16/1/30.
//  Copyright © 2016年 jianghu. All rights reserved.
//

#import "payCell.h"

@implementation payCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加子视图
        [self createSubViews];
    }
    return self;
}

//添加子控件
- (void)createSubViews
{
    //添加title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 30)];
    _titleLabel.text = NSLocalizedString(@"在线支付", nil);
    _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    //添加btn
    //添加右侧选中按钮
    self.rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 38, 20, 20, 20)];
    [self addSubview:_rightIV];
}
@end

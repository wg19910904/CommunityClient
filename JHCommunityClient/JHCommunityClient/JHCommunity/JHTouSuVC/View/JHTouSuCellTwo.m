//
//  JHTouSuCellTwo.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTouSuCellTwo.h"


@implementation JHTouSuCellTwo
{
   
    UIView *_topLine;
    UIView *_leftLine;
    UIView *_rightLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BACK_COLOR;
    }
    return self;
}
#pragma mark--====初始化子控件
- (void)initSubViews{
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = - 15;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
    _topLine = [UIView new];
    _topLine.backgroundColor = LINE_COLOR;
    [_backView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 0.5;
    }];
    
    _leftLine = [UIView new];
    _leftLine.backgroundColor = LINE_COLOR;
    [_backView addSubview:_leftLine];
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.width.offset = 0.5;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
    
    _rightLine = [UIView new];
    _rightLine.backgroundColor = LINE_COLOR;
    [_backView addSubview:_rightLine];
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.width.offset = 0.5;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
}
@end

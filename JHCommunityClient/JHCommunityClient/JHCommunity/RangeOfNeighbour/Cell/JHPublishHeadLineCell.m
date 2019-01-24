//
//  JHPublishHeadLineCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPublishHeadLineCell.h"

@implementation JHPublishHeadLineCell
{
    UIView *_topLine;
    UIView *_leftLine;
    UIView *_rightLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = BACK_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark--==初始化子控件
- (void)initSubViews{
    _headLine = [UITextField new];
    _headLine.backgroundColor = [UIColor whiteColor];
    _headLine.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10,0)];
    _headLine.leftView.backgroundColor = [UIColor whiteColor];
    _headLine.leftViewMode = UITextFieldViewModeAlways;
    _headLine.placeholder = NSLocalizedString(@"标题", nil);
    _headLine.font = FONT(15);
    _headLine.delegate = self;
    _headLine.textColor = HEX(@"191a19", 1.0f);
    [self.contentView addSubview:_headLine];
    [_headLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 0;
        make.bottom.offset = 0;
        make.right.offset = -15;
    }];
    _topLine = [UIView new];
    _topLine.backgroundColor = LINE_COLOR;
    [_headLine addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 0.5;
    }];
    
    _leftLine = [UIView new];
    _leftLine.backgroundColor = LINE_COLOR;
    [_headLine addSubview:_leftLine];
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.top.offset = 0;
        make.bottom.offset = 0;
        make.width.offset = 0.5;
    }];
    
    _rightLine = [UIView new];
    _rightLine.backgroundColor = LINE_COLOR;
    [_headLine addSubview:_rightLine];
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.top.offset = 0;
        make.bottom.offset = 0;
        make.width.offset = 0.5;
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return  [_headLine resignFirstResponder];
}
@end

//
//  JHTouSuCellOne.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTouSuCellOne.h"

@implementation JHTouSuCellOne
{
    UIView *_backView;
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
#pragma mark-===初始化子控件
- (void)initSubViews{
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
    
    _textField = [UITextField new];
    _textField.delegate = self;
    _textField.font = FONT(14);
    _textField.textColor = HEX(@"333333", 1.0f);
    [_backView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 50;
        make.right.offset = 0;
        make.height.offset = 50;
        make.top.offset = 0;
    }];
    
    _iconImg = [UIImageView new];
    [_backView addSubview:_iconImg];
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.centerY.equalTo(_backView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
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
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    switch (indexPath.row) {
        case 0:
        {
            _textField.placeholder = NSLocalizedString(@"名称", nil);
            _iconImg.image = IMAGE(@"complain_user");
        }
            break;
        case 1:
        {
            _textField.placeholder = NSLocalizedString(@"电话", nil);
            _iconImg.image = IMAGE(@"complain_phone");
            _textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        default:
            break;
    }
}

#pragma mark--===UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [_textField resignFirstResponder];
}
@end

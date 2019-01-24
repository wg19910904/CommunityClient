//
//  JHPublishUsedCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPublishUsedCell.h"

@implementation JHPublishUsedCell
{
    UIView *_topLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark--==初始化子控件
- (void)initSubViews{
    _title = [UILabel new];
    _title.font = FONT(15);
    _title.textColor = HEX(@"191a19", 1.0f);
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 0;
        make.bottom.offset = 0;
        make.width.offset = 60;
    }];
    
    _introLabel = [UITextField new];
    _introLabel.textColor = HEX(@"191a19", 1.0f);
    _introLabel.font = FONT(15);
    _introLabel.delegate = self;
    [self.contentView addSubview:_introLabel];
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title.mas_right).offset = 15;
        make.right.offset = -23;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
    _dirImg = [UIImageView new];
    [self.contentView addSubview:_dirImg];
    [_dirImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.top.offset = 17.5;
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    _dirImg.image = IMAGE(@"jiantou_1");
    _topLine = [UIView new];
    _topLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 0.5;
    }];
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    switch (indexPath.row) {
        case 0:{
            _title.text = NSLocalizedString(@"价格", nil);
            _introLabel.keyboardType = UIKeyboardTypeNumberPad;
            _introLabel.userInteractionEnabled = YES;
            _introLabel.placeholder = @"¥0.00";
            _dirImg.hidden = YES;
        }
            break;
        case 1:{
            _title.text = NSLocalizedString(@"联系人", nil);
            _introLabel.userInteractionEnabled = YES;
            _introLabel.placeholder = NSLocalizedString(@"填写联系人", nil);
            _dirImg.hidden = YES;
        }
            break;
        case 2:{
            _title.text = NSLocalizedString(@"联系方式", nil);
            _introLabel.userInteractionEnabled = YES;
            _introLabel.placeholder = NSLocalizedString(@"填写联系方式可以方便转让", nil);
            _dirImg.hidden = YES;
            
        }
            break;
        case 3:{
            _title.text = NSLocalizedString(@"所在小区", nil);
            _introLabel.userInteractionEnabled = NO;
            _introLabel.placeholder = NSLocalizedString(@"可勾选显示所在小区", nil);
            _dirImg.hidden = NO;
        }
            break;
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [_introLabel resignFirstResponder];
}
@end

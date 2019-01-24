//
//  AddSeatPhoneCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "AddSeatPhoneCell.h"

@implementation AddSeatPhoneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
    }
    return self;
}
-(void)creatSubView{
    //添加输入框
    [self addSubview:self.textFiled_phone];
    //添加label
    [self addSubview:self.label_title];
}
#pragma mark - 这是返回输入框
-(UITextField *)textFiled_phone{
    if (!_textFiled_phone) {
        _textFiled_phone = [[UITextField alloc]init];
        _textFiled_phone.frame = FRAME(75, 5, WIDTH-75, 30);
        _textFiled_phone.placeholder = NSLocalizedString(@"请填写您的手机号", nil);
        _textFiled_phone.font = FONT(14);
        _textFiled_phone.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textFiled_phone;
}
#pragma mark - 这是返回联系电话四个字
-(UILabel *)label_title{
    if (!_label_title) {
        _label_title = [[UILabel alloc]init];
        _label_title.frame = FRAME(10, 10, 65, 20);
        _label_title.text = NSLocalizedString(@"联系电话:", nil);
        _label_title.font = FONT(14);
        _label_title.textColor = HEX(@"333333", 1.0);
    }
    return _label_title;
}
@end

//
//  AddButtomCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "AddButtomCell.h"

@implementation AddButtomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.textView_input];
    }
    return self;
}
-(UITextView *)textView_input{
    if (!_textView_input) {
        _textView_input = [[UITextView alloc]init];
        _textView_input.frame = FRAME(10, 5, WIDTH - 20, 85);
        _textView_input.font = FONT(14);
        _textView_input.textColor = HEX(@"999999", 1.0);
        _textView_input.text = NSLocalizedString(@"如有特殊要求,请填写,我们会尽量满足~", nil);
    }
    return _textView_input;
}
@end

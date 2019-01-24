//
//  XHCodeTF.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/4/8.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "XHCodeTF.h"
#import "JHCountryCodeVC.h"
#import "JHShareModel.h"
@implementation XHCodeTF
{
    UIButton *_codeBtn;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)setShowCode:(BOOL)showCode{
    _showCode = showCode;
    if (showCode) {
        //显示区号
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 35, 30)];
        _codeBtn.titleLabel.font = FONT(12);
        [_codeBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        _codeBtn.layer.cornerRadius = 4;
        _codeBtn.clipsToBounds = YES;
        _codeBtn.backgroundColor = HEX(@"fafafa",1.0f);
        NSString *def_code = [NSString stringWithFormat:@"+%@",[JHShareModel shareModel].def_code];
        [_codeBtn setTitle:def_code forState:(UIControlStateNormal)];
        [leftV addSubview:_codeBtn];
        [_codeBtn addTarget:self action:@selector(selecorPhoneCode) forControlEvents:(UIControlEventTouchUpInside)];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = leftV;
    }else{
        //不显示区号
        
    }
}
// 选择国家手机区号
-(void)selecorPhoneCode{
    if(self.fatherVC){
        JHCountryCodeVC *codeListVC = [[JHCountryCodeVC alloc] init];
        codeListVC.chooseCountryCode = ^(BOOL success, NSString *code) {
            if (code.length) {
                code = [NSString stringWithFormat:@"+%@",code];
                [_codeBtn setTitle:code forState:UIControlStateNormal];
            }
        };
        [self.fatherVC.navigationController pushViewController:codeListVC animated:YES];
    }
}

- (NSString *)code{
    NSMutableString *codeText = _codeBtn.titleLabel.text.mutableCopy;
    [codeText replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    return codeText;
}

- (NSString *)format_content{
    if (self.code.length) {
        return [NSString stringWithFormat:@"%@-%@",self.code,[self valueForKey:@"_text"]];
    }
    return [self valueForKey:@"_text"];
}
- (NSString *)text{
    return [self format_content];
}

@end






//
//  YN_PassWordView.m
//  自己玩
//
//  Created by ijianghu on 2018/5/11.
//  Copyright © 2018年 杨楠. All rights reserved.
//

#import "YN_PassWordView.h"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height self.frame.size.height  //每一个输入框的高度等于当前view的高度
@interface YN_PassWordView()<UITextFieldDelegate>

@property(nonatomic,strong)NSMutableArray *dotArr;
@property(nonatomic,strong)NSMutableArray *bottomLineArr;
@property(nonatomic,strong)NSMutableArray *codeLArr;
@end

@implementation YN_PassWordView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.bottomLineArr= @[].mutableCopy;
//        [self initPwdTextF];
        [self initCodeL];
    }
    return self;
}
-(void)initCodeL{
    
    CGFloat width = (self.frame.size.width/kDotCount)-10;
    for (int i =0; i<kDotCount; i++) {
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textF.frame)+(i)*(self.frame.size.width/kDotCount)+5, K_Field_Height-1,width,1)];
        lineV.backgroundColor = HEX(@"dfdfdf", 1);
        [self addSubview:lineV];
        [self.bottomLineArr addObject:lineV];
        
    }
    
    
    self.codeLArr = @[].mutableCopy;
    for (int i=0; i<kDotCount; i++) {
        UILabel *codeL =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textF.frame) + (i)*(self.frame.size.width/kDotCount)+5, 0, width, width)];
        codeL.backgroundColor = [UIColor whiteColor];
        codeL.hidden = YES;
        codeL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:codeL];
        [self.codeLArr addObject:codeL];
    }
    
}
-(void)initPwdTextF{
    
    CGFloat width = self.frame.size.width/kDotCount;
    
    for (int i = 0; i< kDotCount -1; i++) {
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textF.frame)+(i+1)*width, 0, 1,K_Field_Height)];
            lineV.backgroundColor = self.tintColor;
            [self addSubview:lineV];
            
    
       
        
    }
    self.dotArr = @[].mutableCopy;
    for (int i=0; i<kDotCount; i++) {
        UIView *dotView =[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textF.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textF.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width/2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES;
        [self addSubview:dotView];
        [self.dotArr addObject:dotView];
    }
   
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }else if(string.length == 0){
        return YES;
    }else if(textField.text.length >= kDotCount){
        return NO;
    }else{
        return YES;
    }
}
-(void)cleanPassword{
    self.textF.text = @"";
    [self textFieldDidChange:self.textF];
    
}
- (void)textFieldDidChange:(UITextField *)textField
{
//    //密码点
//    for (UIView *dotView in self.dotArr) {
//        dotView.hidden = YES;
//    }
//    
//    for (int i = 0; i < textField.text.length; i++) {
//        ((UIView *)[self.dotArr objectAtIndex:i]).hidden = NO;
//    }
    
    //验证码
    for (UILabel *codeL in self.codeLArr) {
        codeL.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UILabel *)[self.codeLArr objectAtIndex:i]).hidden = NO;
        ((UILabel *)[self.codeLArr objectAtIndex:i]).text =[textField.text substringWithRange:NSMakeRange(i, 1)];
    }
    
    for (UIView *lineV in self.bottomLineArr) {
        lineV.backgroundColor = HEX(@"dfdfdf", 1);
        [self bringSubviewToFront:lineV];
    }
    
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.bottomLineArr objectAtIndex:i]).backgroundColor = HEX(@"F96720 ", 1);
    }
    
    
    if (textField.text.length == kDotCount) {
        if (_textBlock) {
            self.textBlock(textField.text);
        }
    }
}

-(UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, K_Field_Height)];
        _textF.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textF.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textF.tintColor = [UIColor whiteColor];
        _textF.delegate = self;
        _textF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textF.keyboardType = UIKeyboardTypeNumberPad;
//        _textF.layer.borderColor = self.tintColor.CGColor;
//        _textF.layer.borderWidth = 1;
        [_textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textF];
    }
     return _textF;

}
-(UIColor*)tintColor{
    
    if (_tintColor == nil) {
        _tintColor = [UIColor blackColor];
    }
    
    return _tintColor;
}

@end

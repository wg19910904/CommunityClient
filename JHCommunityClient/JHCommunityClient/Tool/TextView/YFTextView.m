//
//  YFTextView.m
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "YFTextView.h"

//@interface CustomTextView : UITextView
//- (CGRect)caretRectForPosition:(UITextPosition *)position;
//@end
//
//@implementation CustomTextView
//- (CGRect)caretRectForPosition:(UITextPosition *)position
//{
//    CGRect originalRect = [super caretRectForPosition:position];
//    
////    originalRect.size.height = self.font.lineHeight + 2;
////    originalRect.size.width = 5;
//    originalRect.origin.y=(50-originalRect.size.height)/2.0;
//    return originalRect;
//}
//
//@end

@interface YFTextView()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,weak)UILabel *placeholderLab;
@property(nonatomic,weak)UILabel *countLab;

@end

@implementation YFTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUIWithFrame:frame];
    }
    return self;
}

-(void)configUIWithFrame:(CGRect )frame{

    UITextView *textView=[[UITextView alloc] initWithFrame:frame];
    textView.delegate=self;
    [self addSubview:textView];
    self.textView=textView;
    textView.textColor=HEX(@"333333", 1.0);
    textView.font=FONT(14);
    [textView setTextContainerInset:UIEdgeInsetsMake(5, 5, 5, 5)];

    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.width-20, 20)];
    [self addSubview:lab];
    self.placeholderLab=lab;
    self.placeholderLab.hidden=YES;
    lab.textColor=HEX(@"999999", 1.0);
    lab.font=FONT(14);
    
    UILabel *countLab=[[UILabel alloc] initWithFrame:CGRectMake(10, self.height-20-10,self.width-20, 20)];
    [self addSubview:countLab];
    self.countLab=countLab;
    self.countLab.hidden=YES;
    countLab.textAlignment=NSTextAlignmentRight;
    countLab.textColor=HEX(@"999999", 1.0);
    countLab.font=FONT(14);
}

//通过判断表层TextView的内容来实现底层TextView的显示于隐藏
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@" "]) return NO;
    
    //删除到最后一个字
    if([text isEqualToString:@""]  && range.location==0) [self.placeholderLab setHidden:NO];
    else if([text isEqualToString:@""] ){
        return YES;
    }
    //写入
    if(![text isEqualToString:@""]) self.placeholderLab.hidden=YES;
    
    if (textView.text.length >=self.maxCount) return NO;
    
    //回车
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length==0) self.placeholderLab.hidden=NO;
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLab.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView.text.length == 0){
        self.placeholderLab.hidden = NO;
    }else{
        self.placeholderLab.hidden = YES;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    
    if(textView.text.length>0) self.placeholderLab.hidden=YES;
  
    if (textView.text.length > self.maxCount) {
        self.countLab.text=[NSString stringWithFormat:NSLocalizedString(@"还可以输入0字", nil)];
          textView.text=[textView.text substringToIndex:self.maxCount];
    }else  {
       self.countLab.text=[NSString stringWithFormat:NSLocalizedString(@"还可以输入%ld字", nil),self.maxCount - textView.text.length];
    }
}


-(void)clearText{
    self.placeholderLab.hidden=NO;
    self.maxCount=self.maxCount;
    self.textView.text=@"";
}

#pragma mark ======setter and getter=======

-(void)setTextFont:(float)textFont{
    _textFont=textFont;
    self.textView.font=FONT(textFont);
}

-(void)setPlaceholderFont:(float)placeholderFont{
    _placeholderFont=placeholderFont;
    self.placeholderLab.font=[UIFont systemFontOfSize:placeholderFont];
}
-(void)setPlaceholderStr:(NSString *)placeholderStr{
    if (self.textView.text.length==0)  self.placeholderLab.hidden=NO;
    else  self.placeholderLab.hidden=YES;
   
    _placeholderStr=placeholderStr;
    self.placeholderLab.text=placeholderStr;
}

-(NSString *)inputText{
    return self.textView.text;
}

-(void)setInputText:(NSString *)inputText{
    self.textView.text=inputText;
    self.placeholderLab.hidden=YES;
}

-(void)setMaxCount:(int)maxCount{
    self.countLab.hidden=NO;
    _maxCount=maxCount;
    self.countLab.text=[NSString stringWithFormat:NSLocalizedString(@"还可以输入%d字", nil),maxCount];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    self.textView.backgroundColor=backgroundColor;
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor=placeholderColor;
    self.placeholderLab.textColor=placeholderColor;
}

-(void)setHiddenCountLab:(BOOL)hiddenCountLab{
    _hiddenCountLab=hiddenCountLab;
    self.countLab.hidden=hiddenCountLab;
}

-(void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator{
    _showsVerticalScrollIndicator=showsVerticalScrollIndicator;
    self.textView.showsVerticalScrollIndicator=showsVerticalScrollIndicator;
}

-(void)setShowPlaceholdInVerticalCenter:(BOOL)showPlaceholdInVerticalCenter{
    _showPlaceholdInVerticalCenter=showPlaceholdInVerticalCenter;
    if (showPlaceholdInVerticalCenter) {
        self.placeholderLab.centerY=self.height/2.0;
        float margin=(self.height-20)/2.0;
        [self.textView setTextContainerInset:UIEdgeInsetsMake(margin, 5, margin, 5)];
    } else{
        self.placeholderLab.y=5;
        [self.textView setTextContainerInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
}

@end

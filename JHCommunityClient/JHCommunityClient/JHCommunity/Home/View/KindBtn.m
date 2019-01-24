//
//  categoryBt.m
//  Lunch
//
//  Created by jianghu on 15/12/9.
//  Copyright © 2015年 jianghu. All rights reserved.
//

#import "KindBtn.h"

@interface KindBtn ()
@property(nonatomic,strong)UILabel *label;
@end
@implementation KindBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    _iconView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, self.width-30, self.width-30)];
    [self addSubview:_iconView];
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.width-20, self.width, 20)];
    _label.font=[UIFont systemFontOfSize:13];
    _label.textColor=HEX(@"666666", 1.0);
    _label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_label];
}

-(void)setTitle:(NSString *)title{
    _title=title;
    self.label.text=title;
}

@end

//
//  IndexIndicatorCell.m
//  YFPageViewControllerVC
//
//  Created by ios_yangfei on 2017/12/16.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "IndexIndicatorCell.h"
#import "YFTool.h"

@interface IndexIndicatorCell()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *countLab;
@end

@implementation IndexIndicatorCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    [titleLab addLayoutConstraint:UIEdgeInsetsZero];
    titleLab.textColor = [self colorWithHex:@"333333" alpha:1.0];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
    
    CGFloat w = 15;
    UILabel *countLab = [UILabel new];
    [self addSubview:countLab];
    [countLab mas_constraint:^(UIView *make) {
        make.yf_mas_right = 0;
        make.yf_mas_top = 0;
        make.yf_mas_width = w;
        make.yf_mas_height = w;
    }];
    countLab.textColor = [self colorWithHex:@"333333" alpha:1.0];
    countLab.font = [UIFont systemFontOfSize:15];
    countLab.textAlignment = NSTextAlignmentCenter;
    countLab.layer.cornerRadius = w/2.0;
    countLab.clipsToBounds = YES;
    countLab.backgroundColor = [self colorWithHex:@"f96720" alpha:1.0];
    self.countLab = countLab;
    
}

-(void)realoadCellWith:(NSString *)title count:(NSString *)count{
    self.titleLab.text = title;
    self.countLab.hidden = [count intValue] == 0;
    self.countLab.text = count;
    if (self.show_scale_animation) {
        if (self.selected) {
            self.titleLab.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }else{
            self.titleLab.transform = CGAffineTransformIdentity;
        }
    }
    
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        if (self.show_scale_animation) {
            [UIView animateWithDuration:0.25 animations:^{
                self.titleLab.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }];
        }
        self.titleLab.textColor = [self colorWithHex:@"f96720" alpha:1.0];
    }else{
        if (self.show_scale_animation) {
            [UIView animateWithDuration:0.25 animations:^{
                self.titleLab.transform = CGAffineTransformIdentity;
            }];
        }
        self.titleLab.textColor = [self colorWithHex:@"333333" alpha:1.0];
    }

}

- (UIColor *)colorWithHex:(NSString *)hexValue alpha:(CGFloat)alpha
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    range.location =0;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:alpha];
}

@end

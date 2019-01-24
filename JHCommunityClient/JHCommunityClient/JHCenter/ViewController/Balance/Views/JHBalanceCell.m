//
//  JHBalanceCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHBalanceCell.h"
@interface JHBalanceCell()
{
    UILabel *titleL;
    UILabel *timeL;
    UILabel *moneyL;
    UILabel *addmoneyL;
    
    
}

@end


@implementation JHBalanceCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    titleL = [[UILabel alloc]init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset =12;
        make.width.offset = 150;
        make.height.offset = 22;
    }];
    titleL.textColor = TEXT_COLOR;
    titleL.font = FONT(16);
    
    timeL = [[UILabel alloc]init];
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset =12;
        make.width.offset = 150;
        make.right.offset = -12;
        make.height.offset = 22;
    }];
    timeL.textColor = HEX(@"999999", 1);
    timeL.font = FONT(14);
    timeL.textAlignment = NSTextAlignmentRight;
    
    moneyL = [[UILabel alloc]init];
    [self addSubview:moneyL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleL.mas_left);
        make.top.equalTo(timeL.mas_bottom).offset = 7;
        make.width.offset = 150;
        make.height.offset = 22;
    }];
    moneyL.textColor = HEX(@"151515", 1);
    moneyL.font = FONT(13);
    
    
    
    addmoneyL = [[UILabel alloc]init];
    [self addSubview:addmoneyL];
    [addmoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeL.mas_right);
        make.top.equalTo(timeL.mas_bottom).offset = 7;
        make.width.offset = 150;
        make.height.offset = 22;
    }];
    addmoneyL.textAlignment= NSTextAlignmentRight;
    addmoneyL.textColor = RED_COLOR;
    addmoneyL.font = FONT(16);
    
}
-(void)getdata{
    
    
    
    
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString(@"余额:%@",nil),@"1111"]];
    NSRange range1=[[hintString string]rangeOfString:@"余额:"];
    [hintString addAttribute:NSForegroundColorAttributeName value:HEX(@"999999", 1) range:range1];
    moneyL.attributedText = hintString;   
}


+(NSString *)getIdentifier{
    return @"JHBalanceCell";
}

+(CGFloat)getHeight:( id )model{
    return 72;
}

@end

//
//  JHNewMyCenterOneCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/15.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewMyCenterOneCell.h"

@interface JHNewMyCenterOneCell()
{
    NSArray *titleArr;
}


@end

@implementation JHNewMyCenterOneCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        titleArr = @[@"余额",@"消费券",@"优惠",@"积分"];
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    for (int i = 0; i<4; i++) {
        UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(i*WIDTH/4, 0, WIDTH/4, 70)];
        [self addSubview:bgV];
        bgV.backgroundColor = [UIColor whiteColor];
        bgV.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [bgV addGestureRecognizer:tap];
        
        UILabel*titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgV.width, 30)];
        [bgV addSubview:titleL];
        titleL.text = @"0";
        titleL.textAlignment = NSTextAlignmentCenter;
        if(i ==0)
        titleL.textColor = RED_COLOR;
        else
        titleL.textColor = TEXT_COLOR;
        
        UILabel *desL = [[UILabel alloc]initWithFrame:CGRectMake(0,  30, bgV.width, bgV.height/2)];
        desL.font = FONT(13);
        desL.textAlignment = NSTextAlignmentCenter;
        desL.text = titleArr[i];
        desL.textColor = HEX(@"666666", 1);
        [bgV addSubview:desL];
    }
}

-(void)setModel:(MemberInfoModel *)model{
    _model = model;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i<4; i++) {
        UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(i*WIDTH/4, 0, WIDTH/4, 70)];
        [self addSubview:bgV];
        bgV.backgroundColor = [UIColor whiteColor];
        bgV.userInteractionEnabled = YES;
        bgV.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [bgV addGestureRecognizer:tap];
        UILabel*titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgV.width, 30)];
        [bgV addSubview:titleL];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"0";
        if(i ==0)
            titleL.textColor = RED_COLOR;
        else
            titleL.textColor = TEXT_COLOR;
        
        if (i == 0) {
            titleL.text = @([model.money floatValue]).description;
        }else if(i == 1){
            titleL.text = @([model.quan_count integerValue]).stringValue;
        }else if(i == 2){
            titleL.text = @([model.youhui_count integerValue]).stringValue;
        }else{
            titleL.text = @([model.jifen integerValue]).stringValue;
        }
        
        
        UILabel *desL = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, bgV.width, bgV.height/2)];
        desL.font = FONT(13);
        desL.text = titleArr[i];
        desL.textColor = HEX(@"666666", 1);
        desL.textAlignment = NSTextAlignmentCenter;
        [bgV addSubview:desL];
    }
}


+(NSString *)getIdentifier{
    return @"JHNewMyCenterOneCell";
}
-(void)click:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    
    if (_clickBlock) {
        self.clickBlock(tag);
    }
    
    
}
+(CGFloat)getHeight:(id)model{
    return 70;
}
@end

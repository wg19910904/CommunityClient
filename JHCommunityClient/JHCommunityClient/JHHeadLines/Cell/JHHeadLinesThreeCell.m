//
//  JHHeadLinesThreeCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/16.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHHeadLinesThreeCell.h"
#import <UIImageView+WebCache.h>

@interface JHHeadLinesThreeCell(){
    UIImageView * imgV;
    UILabel *titleL;
    UILabel *contentL;
    UILabel *browseL;//浏览
    NSMutableArray *imgVArr;
    UILabel * desL ;
    UILabel *starL;
    UIImageView *starImg;
}
@end

@implementation JHHeadLinesThreeCell

-(void)creatUI{
    imgVArr = @[].mutableCopy;
    imgV = [[UIImageView alloc]init];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset =10*WIDTH/375;
        make.left.offset = 12*WIDTH/375;
        make.width.offset = 110*WIDTH/375;
        make.height.offset = 80*WIDTH/375;
    }];
    imgV.clipsToBounds = YES;
    imgV.image = IMAGE(@"defaultimg");
    
    titleL = [[UILabel alloc]init];
    titleL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    titleL.textColor = TEXT_COLOR;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV);
        make.left.equalTo(imgV.mas_right).offset =15*WIDTH/375;
        make.right.offset = -14*WIDTH/375;
        make.height.offset = 20*WIDTH/375;
    }];
    
    contentL =[[UILabel alloc]init];
    contentL.numberOfLines = 2;
    [contentL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    contentL.font = FONT(13);
    contentL.textColor = HEX(@"595959", 1);
    [self addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset =1;
        make.left.equalTo(titleL.mas_left).offset =0;
        make.right.offset = -14*WIDTH/375;
    }];
    
    desL =[[UILabel alloc]init];
    [self addSubview:desL];
    desL.layer.cornerRadius = 4;//设置圆角
    [desL.layer setBorderWidth:0.5];//边框宽度
    [desL.layer setMasksToBounds:YES];//是否有边框
    desL.layer.borderColor=HEX(@"999999", 1).CGColor;//边框颜色
    desL.textColor = HEX(@"999999", 1);
    desL.font = FONT(12);
    desL.textAlignment = NSTextAlignmentCenter;
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -10*WIDTH/375;
       make.left.equalTo(titleL.mas_left).offset =0;
        make.width.offset = 36*WIDTH/375;
        make.height.offset = 20*WIDTH/375;
    }];
    desL.text = @"没事";
    desL.adjustsFontSizeToFitWidth = YES;
    
    browseL =[[UILabel alloc]init];
    [self addSubview:browseL];
    browseL.textColor = HEX(@"999999", 1);
    browseL.font = FONT(12);
    browseL.textAlignment = NSTextAlignmentLeft;
    
    [browseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -10*WIDTH/375;
        make.left.equalTo(desL.mas_right).offset = 12*WIDTH/375;
        make.width.offset = 100*WIDTH/375;
        make.height.offset = 20*WIDTH/375;
    }];
    browseL.text = @"7888人看过";
    
    starL =[[UILabel alloc]init];
    [self addSubview:starL];
    starL.font = FONT(12);
    starL.textAlignment = NSTextAlignmentLeft;
    starL.textColor = HEX(@"999999", 1);
    [starL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -10*WIDTH/375;
        make.right.offset = -12*WIDTH/375;
        make.width.offset = 40*WIDTH/375;
        make.height.offset = 20*WIDTH/375;
    }];
    starL.text= @"9999";
    
    
    starImg =[[UIImageView alloc]init];
    [self addSubview:starImg];
    starImg.image = IMAGE(@"topstar");
    [starImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -12*WIDTH/375;
        make.right.equalTo(starL.mas_left).offset = -5*WIDTH/375;
        make.width.offset = 14*WIDTH/375;
        make.height.offset = 14*WIDTH/375;
    }];
    
    
    UIView *linev =[[UIView alloc]init];
    [self addSubview:linev];
    [linev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -1;
        make.left.right.offset = 0;
        make.height.offset = 1;
    }];
    linev.backgroundColor = HEX(@"e6e6e6", 1);
//    starImg.hidden = YES;
//    starL.hidden = YES;
}
-(void)setModel:(JHHeadLinesModel *)model{
    
    titleL.text = model.title;
    contentL.text = model.desc;
    desL.text = model.cat_title.length>0?model.cat_title:@"其他";
    browseL.text = [NSString stringWithFormat:@"%@人看过",model.views];
    starL.text  = model.favorites;
    if(model.article_thumb.count>0)
    [imgV sd_setImageWithURL:[NSURL URLWithString:model.article_thumb[0][@"photo"]] placeholderImage:IMAGE(@"defaultimg")];//article_thumb
    
    
}

+(NSString *)getIdentifier{
    return @"JHHeadLinesThreeCell";
    
}
+(CGFloat )getHeight:(JHHeadLinesModel *)model{
    
    return 105*WIDTH/375;
    
}
@end

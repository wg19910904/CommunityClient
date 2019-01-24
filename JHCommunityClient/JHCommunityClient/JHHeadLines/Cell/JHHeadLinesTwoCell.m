//
//  JHHeadLinesTwoCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/16.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHHeadLinesTwoCell.h"
#import <UIImageView+WebCache.h>
@interface JHHeadLinesTwoCell(){
    UILabel *titleL;
    NSMutableArray *imgVArr;
    UILabel * desL ;
    UILabel *browseL;
    //    UIButton* starB;
    UILabel *starL;
    UIImageView *starImg;
  
}
@end
@implementation JHHeadLinesTwoCell

-(void)creatUI{
    imgVArr = @[].mutableCopy;
    titleL = [[UILabel alloc]init];
    titleL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    titleL.textColor = HEX(@"333333", 1);
    titleL.numberOfLines = 2;
    [titleL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.right.offset = -12;
        make.top.offset = 17*WIDTH/375;
    }];
    
    
    desL =[[UILabel alloc]init];
    [self addSubview:desL];
    desL.layer.cornerRadius = 4;//设置圆角
    [desL.layer setBorderWidth:1];//边框宽度
    [desL.layer setMasksToBounds:YES];//是否有边框
    desL.layer.borderColor=HEX(@"999999", 1).CGColor;//边框颜色
    desL.textColor = HEX(@"999999", 1);
    desL.font = FONT(12);
    desL.textAlignment = NSTextAlignmentCenter;
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -10*WIDTH/375;
        make.left.offset = 12;
        make.width.offset = 36;
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
        make.left.equalTo(desL.mas_right).offset = 12;
        make.width.offset = 100;
        make.height.offset = 20*WIDTH/375;
    }];
    browseL.text = @"7888人看";
    
    
    starL =[[UILabel alloc]init];
    [self addSubview:starL];
    starL.font = FONT(12);
    starL.textAlignment = NSTextAlignmentLeft;
    starL.textColor = HEX(@"999999", 1);
    [starL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -10*WIDTH/375;
        make.right.offset = -12;
        make.width.offset = 40;
        make.height.offset = 20*WIDTH/375;
    }];
    starL.text= @"9999";
    
    
    starImg =[[UIImageView alloc]init];
    [self addSubview:starImg];
    starImg.image = IMAGE(@"topstar");
    [starImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -12*WIDTH/375;
        make.right.equalTo(starL.mas_left).offset = -5;
        make.width.offset = 14;
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
    desL.text = model.cat_title.length>0?model.cat_title:@"其他";
    browseL.text = [NSString stringWithFormat:@"%@人看过",model.views];
    starL.text  = model.favorites;
    
    for (UIImageView *imgV in imgVArr) {
        [imgV removeFromSuperview];
    }
    
    UIImageView * imgV = [[UIImageView alloc]init];
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset = 9*WIDTH/375;
        make.left.offset = 12;
        make.height.offset = 180*WIDTH/375;
        make.right.offset = -12;
    }];
    [imgV sd_setImageWithURL:[NSURL URLWithString:model.article_thumb[0][@"photo"]] placeholderImage:IMAGE(@"defaultimg")];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    [imgVArr addObject:imgV];
}

+(NSString *)getIdentifier{
    return @"JHHeadLinesTwoCell";
    
}
+(CGFloat )getHeight:(JHHeadLinesModel *)model{
 
    // 根据字体得到NSString的尺寸
//    CGFloat H = size.height;
    CGFloat H =  [model.title boundingRectWithSize:CGSizeMake(WIDTH - 24, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:15]} context:nil].size.height;


    return (H+ 180+17 +9 +20+10+8)*WIDTH/375;
    
}
@end

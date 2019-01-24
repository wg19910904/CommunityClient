//
//  JHHeadLinesOneCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/16.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHHeadLinesOneCell.h"
#import <UIImageView+WebCache.h>

@interface JHHeadLinesOneCell(){
    UILabel *titleL;
    NSMutableArray *imgVArr;
    UILabel * desL ;
    UILabel *browseL;
//    UIButton* starB;
    UILabel *starL;
    UIImageView *starImg;
}

@end

@implementation JHHeadLinesOneCell

-(void)creatUI{
    titleL = [[UILabel alloc]init];
    titleL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    titleL.textColor = HEX(@"333333", 1);
    titleL.numberOfLines = 0;
    [titleL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.right.offset = -12;
        make.top.offset = 17*WIDTH/375;
    }];
    
    imgVArr =@[].mutableCopy;
    
    
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
    browseL.text = @"7888人看过";
    
    
    starL =[[UILabel alloc]init];
    [self addSubview:starL];
    starL.font = FONT(12);
    starL.textAlignment = NSTextAlignmentLeft;
     starL.textColor = HEX(@"999999", 1);
    [starL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -10*WIDTH/375;
        make.right.offset = -12;
        make.width.offset = 40;
        make.height.offset = 18*WIDTH/375;
    }];
    starL.text= @"3758";
    
   
    starImg =[[UIImageView alloc]init];
    [self addSubview:starImg];
    starImg.image = IMAGE(@"topstar");
    [starImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -12*WIDTH/375;
        make.right.equalTo(starL.mas_left).offset = -5;
        make.width.offset = 14;
        make.height.offset = 14*WIDTH/375;
    }];
//    starImg.hidden = YES;
//    starL.hidden = YES;
    
    UIView *linev =[[UIView alloc]init];
    [self addSubview:linev];
    [linev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -1;
        make.left.right.offset = 0;
        make.height.offset = 1;
    }];
    linev.backgroundColor = HEX(@"e6e6e6", 1);
}

-(void)setModel:(JHHeadLinesModel *)model{
    titleL.text = model.title;
    desL.text = model.cat_title.length>0?model.cat_title:@"其他";
    browseL.text = [NSString stringWithFormat:@"%@人看过",model.views];
    starL.text  = model.favorites;

    for (UIImageView *imgV in imgVArr) {
        [imgV removeFromSuperview];
    }
    
    for (int i = 0; i < model.article_thumb.count; i++) {
        UIImageView * imgV = [[UIImageView alloc]init];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleL.mas_bottom).offset =7;
            make.left.offset = i*((WIDTH- 48)/3)+12*(i+1);
            make.height.offset =80*WIDTH/375;
            make.width.offset = 110*WIDTH/375;
        }];
    
        [imgV sd_setImageWithURL:[NSURL URLWithString:model.article_thumb[i][@"photo"]] placeholderImage:IMAGE(@"")];
        imgV.clipsToBounds = YES;
        [imgVArr addObject:imgV];
    }
    
    
    
}

-(void)addimageV{
    
  

}
+(NSString *)getIdentifier{
    return @"JHHeadLinesOneCell";
    
}
+(CGFloat )getHeight:(JHHeadLinesModel *)model{
    CGFloat h =  [model.title boundingRectWithSize:CGSizeMake(WIDTH - 24, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15.0f]} context:nil].size.height;
    
    
    return (h + 80 +17+7 +8+17+14)*WIDTH/375;
    
}
@end

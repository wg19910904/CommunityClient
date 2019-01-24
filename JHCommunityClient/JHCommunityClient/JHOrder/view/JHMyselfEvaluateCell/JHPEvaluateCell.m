//
//  JHPEvaluateCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPEvaluateCell.h"
#import "MyTapGestureRecognizer.h"
#import "DisplayImageInView.h"
#import "UIImageView+NetStatus.h"
@implementation JHPEvaluateCell
{
    UIView * bj_view;
    UIImageView * imageView_header;
    UILabel * label_name;
    UIView * label_line;
    UILabel * label_text;
    UIView * view_star;
    UILabel * label_evaluate;
    UILabel * label_replay;
    UILabel * label_time;
    UIImageView * imageView_one;
    UIImageView * imageView_two;
    UIImageView * imageView_three;
    UIImageView * imageView_four;
    DisplayImageInView * displayView;
}

-(void)setModel:(JHPEvaluateModel *)model{
    _model = model;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (bj_view == nil) {
        bj_view = [[UIView alloc]init];
        bj_view.frame = FRAME(10, 10, WIDTH - 20, self.frame.size.height - 10);
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        bj_view.layer.borderWidth = 0.5;
        bj_view.layer.cornerRadius = 3;
        bj_view.layer.masksToBounds = YES;
        bj_view.backgroundColor = [UIColor whiteColor];
        [self addSubview:bj_view];
    }
    if (imageView_header) {
        [imageView_header removeFromSuperview];
        imageView_header = nil;
    }
    if (imageView_header == nil) {
        imageView_header = [[UIImageView alloc]init];
        imageView_header.frame = FRAME(10, 15, 40, 40);
        imageView_header.layer.cornerRadius = 20;
        imageView_header.layer.masksToBounds = YES;
        [bj_view addSubview:imageView_header];
    }
    [imageView_header sd_image:[NSURL URLWithString:model.face] plimage:[UIImage imageNamed:@"loginheader"]];
    if (label_name) {
        [label_name removeFromSuperview];
        label_name = nil;
    }
    if (label_name == nil) {
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(60, 25, 200, 20);
        label_name.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_name.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label_name];
    }
    label_name.text = model.name;
    if (label_line) {
        [label_line removeFromSuperview];
        label_line = nil;
    }
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(10, 69.5, WIDTH - 40, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_line];
    }
    if (label_text) {
        [label_text removeFromSuperview];
        label_text = nil;
    }
    if (label_text == nil) {
        label_text = [[UILabel alloc]init];
        label_text.frame = FRAME(10, 85, 70, 20);
        label_text.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_text.text = NSLocalizedString(@"总体评价", nil);
        label_text.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label_text];
    }
    if (view_star) {
        [view_star removeFromSuperview];
        view_star = nil;
    }
    if (view_star == nil) {
        view_star = [StarView addEvaluateViewWithStarNO:[model.score floatValue] withStarSize:20 withBackViewFrame:FRAME(90, 83, 150, 20)];
        [bj_view addSubview:view_star];
    }
    if (label_evaluate) {
        [label_evaluate removeFromSuperview];
        label_evaluate = nil;
    }
    if (label_evaluate == nil) {
        UIView * view = [[UIView alloc]init];
        view.frame = FRAME(10, 120, WIDTH - 40, self.height_evaluate + 20);
        view.layer.cornerRadius = 2;
        view.clipsToBounds = YES;
        view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        view.layer.borderWidth = 0.5;
        [bj_view addSubview:view];
        label_evaluate = [[UILabel alloc]init];
        label_evaluate.frame = FRAME(10, 10, WIDTH - 60, self.height_evaluate);
        label_evaluate.font = [UIFont systemFontOfSize:15];
        label_evaluate.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_evaluate.numberOfLines = 0;
        [view addSubview:label_evaluate];
    }
    NSString * str_eavaluate = model.content;
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    [paragraph setLineSpacing:5];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str_eavaluate];
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, str_eavaluate.length)];
    label_evaluate.attributedText = attribute;
    if (label_replay) {
        [label_replay removeFromSuperview];
        label_replay = nil;
    }
    if (label_replay == nil && self.isReplay ) {
        UIView * view = [[UIView alloc]init];
        view.frame = FRAME(10, 120+self.height_evaluate + 40, WIDTH - 40, self.height_replay + 40);
        view.layer.cornerRadius = 4;
        view.clipsToBounds = YES;
        view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        view.layer.borderWidth = 0.5;
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [bj_view addSubview:view];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME(20, 120+self.height_evaluate + 31, 15, 10);
        imageView.image = [UIImage imageNamed:@"boxarrowTop"];
        [bj_view addSubview:imageView];
        label_replay = [[UILabel alloc]init];
        label_replay.frame = FRAME(10, 10, WIDTH - 60, self.height_replay);
        label_replay.font = [UIFont systemFontOfSize:14];
        label_replay.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_replay.numberOfLines = 0;
        [view addSubview:label_replay];
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(WIDTH - 170, self.height_replay + 15, 120, 20);
        label_time.font = [UIFont systemFontOfSize:13];
        label_time.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        label_time.textAlignment = NSTextAlignmentRight;
        [view addSubview:label_time];
    }
     label_time.text = model.reply_time;
    NSString * str_replay = [NSString stringWithFormat:NSLocalizedString(@"回复:%@", nil),model.reply];
    NSRange range = [str_replay rangeOfString:NSLocalizedString(@"回复:", nil)];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:str_replay];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:range];
    NSMutableParagraphStyle * para = [[NSMutableParagraphStyle alloc]init];
    [para setLineSpacing:4];
    [att addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, str_replay.length)];
    label_replay.attributedText = att;
    if (imageView_one) {
        [imageView_one removeFromSuperview];
        imageView_one = nil;
    }
    if (imageView_one == nil && self.isPhoto && model.imageArray.count >= 1) {
        imageView_one = [[UIImageView alloc]init];
        if (self.isReplay) {
            imageView_one.frame = FRAME(10, 120+self.height_evaluate + 50 + self.height_replay + 40, (WIDTH - 70)/4, (WIDTH - 70)/4);
        }else{
             imageView_one.frame = FRAME(10, 120+self.height_evaluate + 30, (WIDTH - 70)/4, (WIDTH - 70)/4);
        }
        [imageView_one sd_image:[NSURL URLWithString:model.imageArray[0]] plimage:[UIImage imageNamed:@"evaluate_default"]];
        MyTapGestureRecognizer * tap = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        tap.tag = 1;
        imageView_one.userInteractionEnabled = YES;
        [imageView_one addGestureRecognizer:tap];
        
        [bj_view addSubview:imageView_one];
    }
    if (imageView_two) {
        [imageView_two removeFromSuperview];
        imageView_two = nil;
    }
    if (imageView_two == nil && self.isPhoto && model.imageArray.count >= 2) {
        imageView_two = [[UIImageView alloc]init];
        if (self.isReplay) {
            imageView_two.frame = FRAME(20 + (WIDTH - 70)/4, 120+self.height_evaluate + 50 + self.height_replay + 40, (WIDTH - 70)/4, (WIDTH - 70)/4);
        }else{
            imageView_two.frame = FRAME(20 + (WIDTH - 70)/4, 120+self.height_evaluate + 30,(WIDTH - 70)/4, (WIDTH - 70)/4);
        }
         [imageView_two sd_image:[NSURL URLWithString:model.imageArray[1]] plimage:[UIImage imageNamed:@"evaluate_default"]];
        MyTapGestureRecognizer * tap = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        tap.tag = 2;
        imageView_two.userInteractionEnabled = YES;
        [imageView_two addGestureRecognizer:tap];
        [bj_view addSubview:imageView_two];
    }
    if (imageView_three) {
        [imageView_three removeFromSuperview];
        imageView_three = nil;
    }
    if (imageView_three == nil && self.isPhoto && model.imageArray.count >= 3) {
        imageView_three = [[UIImageView alloc]init];
        if (self.isReplay) {
            imageView_three.frame = FRAME(30 + (WIDTH - 70)/4*2, 120+self.height_evaluate + 50 + self.height_replay + 40, (WIDTH - 70)/4, (WIDTH - 70)/4);
        }else{
            imageView_three.frame = FRAME(30 + (WIDTH - 70)/4*2, 120+self.height_evaluate + 30, (WIDTH - 70)/4, (WIDTH - 70)/4);
        }
        [imageView_three sd_image:[NSURL URLWithString:model.imageArray[2]] plimage:[UIImage imageNamed:@"evaluate_default"]];
        MyTapGestureRecognizer * tap = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        tap.tag = 3;
        imageView_three.userInteractionEnabled = YES;
        [imageView_three addGestureRecognizer:tap];
        [bj_view addSubview:imageView_three];
    }
    
    if (imageView_four) {
        [imageView_four removeFromSuperview];
        imageView_four = nil;
    }
    if (imageView_four == nil && self.isPhoto && model.imageArray.count >= 4) {
        imageView_four = [[UIImageView alloc]init];
        if (self.isReplay) {
            imageView_four.frame = FRAME(40 + (WIDTH - 70)/4*3, 120+self.height_evaluate + 50 + self.height_replay + 40, (WIDTH - 70)/4, (WIDTH - 70)/4);
        }else{
            imageView_four.frame = FRAME(40 + (WIDTH - 70)/4*3, 120+self.height_evaluate + 30, (WIDTH - 70)/4, (WIDTH - 70)/4);
        }
        MyTapGestureRecognizer * tap = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        tap.tag = 4;
        imageView_four.userInteractionEnabled = YES;
        [imageView_four addGestureRecognizer:tap];
        [imageView_four sd_image:[NSURL URLWithString:model.imageArray[3]] plimage:[UIImage imageNamed:@"evaluate_default"]];
        [bj_view addSubview:imageView_four];
    }

}
#pragma mark - 这是点击图片查看的方法
-(void)clickToSeeImage:(MyTapGestureRecognizer *)sender{
        //传已经拼接好的图片url
        if (displayView == nil) {
            displayView = [[DisplayImageInView alloc]init];
            [displayView showInViewWithImageUrlArray:_model.imageArray withIndex:sender.tag withBlock:^{
                [displayView removeFromSuperview];
                displayView = nil;
            }];
        }

}
@end

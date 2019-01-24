//
//  BottomCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/24.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "BottomCell.h"
#import <UIImageView+WebCache.h>
@interface BottomCell(){
    NSMutableArray *imgArr;
}
@property(nonatomic,strong)UIView *bottomL;//底部的线
@property(nonatomic,strong)UILabel *textL;//显示的文本
@property(nonatomic,strong)UILabel *timeL;//显示时间和浏览人数
@end
@implementation BottomCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        imgArr = @[].mutableCopy;
        //底部的线
        [self bottomL];
        //显示时间和浏览人数
        [self timeL];
    }
    return self;
}
//底部的线
-(UIView *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UIView alloc]init];
        _bottomL.backgroundColor = HEX(@"dedede", 1);
        [self addSubview:_bottomL];
        [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.bottom.offset = -0;
            make.right.offset = -0;
            make.height.offset = 0.5;
        }];
    }
    return _bottomL;
}
//显示的文本
-(UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc]init];
        _textL.textColor = HEX(@"1d1c1c", 1);
        _textL.font = FONT(16);
        _textL.numberOfLines = 0;
        [self addSubview:_textL];
        if (self.model.thumb.count == 1) {
            [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset = 12;
                make.right.offset = -155;
                make.top.offset = 25;
            }];
        }else{
            [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset = 12;
                make.right.offset = -12;
                make.top.offset = 25;
            }];
        }

    }
    return _textL;
}
//显示时间和浏览人数
-(UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = HEX(@"666666", 1);
        _timeL.font = FONT(12);
        [self addSubview:_timeL];
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.bottom.offset = -15;
            make.height.offset = 20;
        }];
}
    return _timeL;
}

-(void)setModel:(JHTempClientNewsModel *)model{
    _model = model;
    [_textL removeFromSuperview];
    _textL = nil;
    self.textL.text = model.title;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:_textL.text];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:8];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, _model.title.length)];
    _textL.attributedText = attributeStr;
    _timeL.text = [NSString stringWithFormat:NSLocalizedString(@"%@  %@人浏览", nil),model.dateline,model.views];
    for (int a = 0; a < imgArr.count;a++) {
        UIImageView *imgView = imgArr[a];
        [imgView removeFromSuperview];
        imgView = nil;
    }
    [imgArr removeAllObjects];
    if (model.status != 0) {
        [self creatImg];
    }
}
//创建图片
-(void)creatImg{
    if (self.model.thumb.count == 1) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.model.thumb[0]]];
        UIImageView *imageV = [[UIImageView alloc]init];
        [imageV sd_setImageWithURL:url placeholderImage:IMAGE(@"evaluate_default")];
        //imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageV];
        [imgArr addObject:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 70;
            make.right.offset = -15;
            make.top.offset = 25;
            make.width.offset = 112;
        }];
    }else{
        CGFloat w = (WIDTH - 36)/3;
        for (int i = 0; i < self.model.thumb.count; i ++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.model.thumb[i]]];
            UIImageView *imageV = [[UIImageView alloc]init];
            [imageV sd_setImageWithURL:url placeholderImage:IMAGE(@"evaluate_default")];
            // imageV.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:imageV];
            [imgArr addObject:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset = 70;
                make.top.equalTo(_textL.mas_bottom).offset = 5;
                make.left.offset = 12+(w+6)*i;
                make.width.offset = w;
            }];

        }
    }
}
@end

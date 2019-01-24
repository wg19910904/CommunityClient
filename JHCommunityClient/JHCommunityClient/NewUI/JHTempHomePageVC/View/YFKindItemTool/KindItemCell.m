//
//  KindItemCell.m
//  LayoutTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "KindItemCell.h"
#import "YFTypeBtn.h"
#import <UIImageView+WebCache.h>
@interface KindItemCell ()
@property(nonatomic,weak)UIImageView *imgV;
@property(nonatomic,weak)UILabel *titleL;
@property(nonatomic,weak)YFTypeBtn *kindBtn;
@property(nonatomic,strong)CALayer *rightL;//右边的分割线
@property(nonatomic,strong)CALayer *bottomL;//底部的分割线
@end

@implementation KindItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
//    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.frame = FRAME((WIDTH/4-45*(WIDTH/375))/2, 10*(WIDTH/375), 45*(WIDTH/375), 45*(WIDTH/375));
//    //imageView.layer.cornerRadius = 22.5;
//    //imageView.layer.masksToBounds = YES;
//    [self addSubview:imageView];
//    self.imgV = imageView;
//    UILabel *label = [[UILabel alloc]init];
//    label.frame = FRAME(0, 65*(WIDTH/375), WIDTH/4, 20);
//    label.textColor = HEX(@"333333", 1);
//    label.font = FONT(12);
//    label.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:label];
//    self.titleL = label;
    UIImageView *imgView = [UIImageView new];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.offset=10;
        make.width.offset= self.width - 27*WIDTH/375;
        make.height.offset= self.width - 27*WIDTH/375;
    }];
    self.imgV = imgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.equalTo(imgView.mas_bottom).offset=10;
        make.width.offset=self.width;
        make.bottom.offset = -10;
    }];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = HEX(@"222222", 1.0);
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleL = titleLab;

//    self.rightL = [[CALayer alloc]init];
//    self.rightL.frame = FRAME(WIDTH/4-0.5, 0, 0.5, 110);
//    self.rightL.hidden = YES;
//    self.rightL.backgroundColor = HEX(@"dedede", 1).CGColor;
//    [self.layer addSublayer:self.rightL];
//    self.bottomL = [[CALayer alloc]init];
//    self.bottomL.frame = FRAME(0, 109.5, WIDTH/4,0.5);
//    self.bottomL.hidden = YES;
//    self.bottomL.backgroundColor = HEX(@"dedede", 1).CGColor;
//    [self.layer addSublayer:self.bottomL];
}
-(void)reloadCellWithDic:(NSDictionary *)dic{
    self.titleL.text = dic[@"title"]?dic[@"title"]:NSLocalizedString(@"频道",nil);
    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"thumb"]]];
    NSString *placeStr = @"supermarketproduct";
    if (_isTool) {
        placeStr = @"index_tool04";
    }
    [self.imgV sd_setImageWithURL:imgUrl placeholderImage:IMAGE(placeStr)];
    
}
-(void)setIsTool:(BOOL)isTool{
    _isTool = isTool;
    if (isTool) {
//        self.imgV.frame = FRAME((WIDTH/4-37)/2, 20, 37, 35);
        [self.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 37*(WIDTH/375);
            make.height.offset = 35*(WIDTH/375);
        }];

        self.imgV.contentMode = UIViewContentModeScaleAspectFit;
//        self.titleL.frame = FRAME(0, 75, WIDTH/4, 20);
        self.rightL.hidden = NO;
        self.bottomL.hidden = NO;
    }
}
@end

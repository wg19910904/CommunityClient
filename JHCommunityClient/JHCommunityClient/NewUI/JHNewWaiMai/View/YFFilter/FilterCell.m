//
//  FilterCell.m
//  Lunch
//
//  Created by ios_yangfei on 17/3/21.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import "FilterCell.h"
#import <UIImageView+WebCache.h>
#define ImageAddress [NSString stringWithFormat:@"http://%@/attachs/",KReplace_Url]
@interface FilterCell ()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIImageView *selectedImgView;
@property(nonatomic,weak)UIImageView *icon_imgV;
@end

@implementation FilterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.centerY.offset = 0;
        make.width.height.offset = 15;
    }];
    self.icon_imgV = imgView;
    
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"4a4c4d", 1.0);
    self.titleLab = titleLab;
    
    UIImageView *selectedImgView = [UIImageView new];
    [self.contentView addSubview:selectedImgView];
    [selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=15;
        make.height.offset=10;
    }];
    selectedImgView.hidden = YES;
    self.selectedImgView = selectedImgView;
    
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
    [self updateTitleLableLocation];
    
}
-(void)updateTitleLableLocation{
    [_titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=_imgStr?30:10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    self.icon_imgV.hidden = _imgStr?NO:YES;
}
-(void)setImgStr:(NSString *)imgStr{
    _imgStr = imgStr;
    if (imgStr.length == 0) {
        _imgStr = nil;
    }
    [self.icon_imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageAddress,_imgStr]] placeholderImage:IMAGE(@"shop_sort_default")];
     [self updateTitleLableLocation];
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLab.textColor = THEME_COLOR;
        self.selectedImgView.image = IMAGE(@"selected-0");
        
        if (self.type == 1) {
            self.backgroundColor = [UIColor whiteColor];
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
    
    }else{
        self.titleLab.textColor = HEX(@"4a4c4d", 1.0);
        self.selectedImgView.image = nil;
        
        if (self.type == 1) {
            self.backgroundColor = HEX(@"f4f4f4", 1.0);
            self.contentView.backgroundColor = HEX(@"f4f4f4", 1.0);
        }
    }
}

-(void)setType:(int)type{
    _type = type;
    if (type == 1) {
        self.selectedImgView.hidden = YES;
    }else{
        self.selectedImgView.hidden = NO;
    }
}

@end

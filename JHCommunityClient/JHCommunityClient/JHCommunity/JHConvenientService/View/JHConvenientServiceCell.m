//
//  JHConvenientServiceCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHConvenientServiceCell.h"
#import <Masonry/Masonry.h>
#import "NSObject+CGSize.h"
@implementation JHConvenientServiceCell
{
    UILabel *_title;//标题
    UILabel *_type;//类型
    UILabel *_addr;//地址
    UILabel *_useNumber;//使用次数
   
    UILabel *_bottomLine;//底部边线
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return  self;
}
#pragma mark--====初始化子控件
- (void)initSubViews{
    
    _title = [UILabel new];
    _title.font = FONT(14);
    _title.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_title];
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.layer.cornerRadius = 3.0f;
    _type.layer.borderColor = LINE_COLOR.CGColor;
    _type.layer.borderWidth = 0.5f;
    _type.clipsToBounds = YES;
    _type.textAlignment = NSTextAlignmentCenter;
    _type.font = FONT(12);
    _type.textColor = HEX(@"999999", 1.0f);
   
    
    _mobileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mobileBtn.frame = FRAME(WIDTH - 35, 0, 35, 70);
    _mobileBtn.imageEdgeInsets = UIEdgeInsetsMake(25, 0, 25, 15);
    [_mobileBtn setImage:IMAGE(@"neighbourhood_dial") forState:UIControlStateNormal];
    [_mobileBtn setImage:IMAGE(@"neighbourhood_dial") forState:UIControlStateHighlighted];
    [_mobileBtn setImage:IMAGE(@"neighbourhood_dial") forState:UIControlStateSelected];
    [self.contentView addSubview:_mobileBtn];
    
    _addr = [UILabel new];
    _addr.font = FONT(12);
    _addr.textColor = HEX(@"999999",1.0f);
    [self.contentView addSubview:_addr];
   
    _useNumber = [UILabel new];
    _useNumber.font = FONT(12);
    _useNumber.textColor = HEX(@"999999", 1.0f);
    [self.contentView addSubview:_useNumber];
    
    _bottomLine = [UILabel new];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = WIDTH;
        make.height.offset = 0.5;
        make.bottom.offset = 0;
        make.left.offset = 0;
    }];
    _bottomLine.backgroundColor = LINE_COLOR;
}

- (void)setConvenientServiceModel:(JHConvenientServiceModel *)convenientServiceModel{
    _convenientServiceModel = convenientServiceModel;
    _title.text = convenientServiceModel.title;
    _type.text = convenientServiceModel.cate_title;
    _addr.text = [NSString stringWithFormat:NSLocalizedString(@"地址:%@", nil),convenientServiceModel.addr];
    _useNumber.text = [NSString stringWithFormat:NSLocalizedString(@"使用次数:%@次", nil),convenientServiceModel.views];
    [self layoutTitleAndType];
    [self layoutAddrAngViews];
}

#pragma mark--==布局标题和类型
- (void)layoutTitleAndType{
    CGSize typeSize = [self currentSizeWithString:[NSString stringWithFormat:@"y%@",_type.text] font:FONT(12) withWidth:0];
     CGSize titleSize = [self currentSizeWithString:_title.text font:FONT(14) withWidth:0];
    if(titleSize.width + 10 + typeSize.width + 60 <= WIDTH){
        _title.frame = FRAME(15, 15, titleSize.width, 14);
        _type.frame = FRAME(15 + titleSize.width + 10, 15, typeSize.width, 14);
    }else{
        _title.frame = FRAME(15, 15, WIDTH - 70 - typeSize.width, 14);
        _type.frame = FRAME(WIDTH - 45 - typeSize.width , 15, typeSize.width, 14);
    }
}
#pragma mark--==布局地址和使用次数
- (void)layoutAddrAngViews{
    
    CGSize addrSize = [self currentSizeWithString:_addr.text font:FONT(12) withWidth:0];
    CGSize viewsSize = [self currentSizeWithString:_useNumber.text font:FONT(12) withWidth:0];
    if(addrSize.width + 20 + viewsSize.width + 60 <= WIDTH){
        _addr.frame = FRAME(15, 48, addrSize.width, 12);
        _useNumber.frame = FRAME(15 + 20 + addrSize.width, 48, viewsSize.width, 12);
    }else{
        _addr.frame = FRAME(15, 48, WIDTH - 80 - viewsSize.width, 12);
        _useNumber.frame = FRAME( WIDTH - 45 - viewsSize.width, 48, viewsSize.width, 12);
    }
}
@end

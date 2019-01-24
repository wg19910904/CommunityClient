//
//  AddressListCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "AddressListCell.h"
#import "NSObject+CGSize.h"
@implementation AddressListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.nameImg = [[UIImageView alloc] init];
        self.nameImg.image = IMAGE(@"ren@2x(1)");
        [self.contentView addSubview:self.nameImg];
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        self.phoneLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.phoneLabel];
        self.addressImg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.addressImg];
        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.font = FONT(13);
        self.addressLabel.textColor = HEX(@"999999", 1.0f);
        self.addressLabel.numberOfLines = 0;
        [self.contentView addSubview:self.addressLabel];
        self.operateBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.operateBnt.frame = FRAME(WIDTH - 40, self.center.y, 20, 30);
        [self.operateBnt setImage:IMAGE(@"bi") forState:UIControlStateNormal];
        [self.operateBnt setImage:IMAGE(@"bi") forState:UIControlStateHighlighted];
        self.operateBnt.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        [self.contentView addSubview:self.operateBnt];
        self.selectImg = [[UIImageView alloc] initWithFrame:FRAME(10, self.center.y, 20, 20)];
        self.selectImg.image = IMAGE(@"selectDefault");
        self.selectImg.highlightedImage = IMAGE(@"selectCurrent");
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
    }
    return  self;
}
//- (void)setAddrListModel:(AddrListModel *)addrListModel
//{
//    _addrListModel = addrListModel;
//    
//    //WithFrame:FRAME(10, self.center.y, 20, 20)
//    self.nameLabel.text = addrListModel.contact;
//    self.nameLabel.font = FONT(14);
//    self.nameLabel.textColor = [UIColor blackColor];
//    self.phoneLabel.text = addrListModel.mobile;
//    self.phoneLabel.font = FONT(14);
//    self.phoneLabel.textColor = HEX(@"999999", 1.0f);
//    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",addrListModel.addr,addrListModel.house];
//    if([addrListModel.type isEqualToString:@"1"])
//    {
//        _addressImg.image = IMAGE(@"gongsi");
//    }
//    else if([addrListModel.type isEqualToString:@"2"])
//    {
//        _addressImg.image = IMAGE(@"jia");
//
//    }
//    else if([addrListModel.type isEqualToString:@"3"])
//    {
//         _addressImg.image = IMAGE(@"xuexiao");
//    }
//    else
//    {
//         _addressImg.image = IMAGE(@"dizhi-1");
//    }
//}
- (void)setAddrListModel:(AddrListModel *)addrListModel withIndex:(NSInteger)index{
    _addrListModel = addrListModel;
    if(index != 1){
       [self.contentView addSubview:self.selectImg];
        self.nameImg.frame = FRAME(45, 12.5, 15, 15);
        CGSize nameSize = [self currentSizeWithString:addrListModel.contact font:FONT(14) withWidth:0];
        self.nameLabel.frame = FRAME(65, 15, nameSize.width, 15);
        self.phoneLabel.frame = FRAME(65 + nameSize.width + 5, 15, WIDTH - (15 + nameSize.width), 14);
        CGSize size = [self currentSizeWithString:[NSString stringWithFormat:@"%@%@",addrListModel.addr,addrListModel.house] font:FONT(13) withWidth:105];
        self.addressLabel.frame = FRAME(65, 35, size.width, size.height);
        self.addressImg.frame = FRAME(45, 35, 15, 15);
    }else{
        [self.selectImg removeFromSuperview];
        self.nameImg.frame = FRAME(10, 12.5, 15, 15);
        CGSize nameSize = [self currentSizeWithString:addrListModel.contact font:FONT(14) withWidth:0];
        self.nameLabel.frame = FRAME(35, 15, nameSize.width, 15);
        self.phoneLabel.frame = FRAME(35 + nameSize.width + 5, 15, WIDTH - (15 + nameSize.width), 14);
        CGSize size = [self currentSizeWithString:[NSString stringWithFormat:@"%@%@",addrListModel.addr,addrListModel.house] font:FONT(13) withWidth:70];
        self.addressLabel.frame = FRAME(30, 35, size.width, size.height);
        self.addressImg.frame = FRAME(10, 35,15, 15);
    }
    self.nameLabel.text = addrListModel.contact;
    self.nameLabel.font = FONT(14);
    self.nameLabel.textColor = [UIColor blackColor];
    self.phoneLabel.text = addrListModel.mobile;
    self.phoneLabel.font = FONT(14);
    self.phoneLabel.textColor = HEX(@"999999", 1.0f);
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",addrListModel.addr,addrListModel.house];
    if([addrListModel.type isEqualToString:@"1"]){
        _addressImg.image = IMAGE(@"gongsi");
    }else if([addrListModel.type isEqualToString:@"2"]){
        _addressImg.image = IMAGE(@"jia");
        
    }else if([addrListModel.type isEqualToString:@"3"]){
        _addressImg.image = IMAGE(@"xuexiao");
    }else{
        _addressImg.image = IMAGE(@"dizhi-1");
    }
    if (self.isCenter) {
        self.selectImg.hidden = YES;
        self.nameImg.frame = FRAME(10, 12.5, 15, 15);
        CGSize nameSize = [self currentSizeWithString:addrListModel.contact font:FONT(14) withWidth:0];
        self.nameLabel.frame = FRAME(35, 15, nameSize.width, 15);
        self.phoneLabel.frame = FRAME(35 + nameSize.width + 5, 15, WIDTH - (15 + nameSize.width), 14);
        CGSize size = [self currentSizeWithString:[NSString stringWithFormat:@"%@%@",addrListModel.addr,addrListModel.house] font:FONT(13) withWidth:70];
        self.addressLabel.frame = FRAME(30, 35, size.width, size.height);
        self.addressImg.frame = FRAME(10, 35,15, 15);
    }
}
@end

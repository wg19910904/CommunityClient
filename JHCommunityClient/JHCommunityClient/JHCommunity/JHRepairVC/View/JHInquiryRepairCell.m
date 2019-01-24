//
//  JHInquiryRepairCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHInquiryRepairCell.h"
#import "NSObject+CGSize.h"
#import "MyTapGesture.h"
#import "DisplayImageInView.h"
#import "UIImageView+WebCache.h"
#define  space  (WIDTH - 75) / 4
@implementation JHInquiryRepairCell
{
    UIView *_line;
    DisplayImageInView *_displayView;
    UIView *_bottomLine;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark--===初始化子控件
- (void)initSubViews{
    _infoLabel = [UILabel new];
    _infoLabel.font = FONT(14);
    _infoLabel.textColor = HEX(@"999999", 1.0f);
    [self.contentView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = 60;
        make.top.offset = 18;
        make.height.offset = 14;
    }];
    
    
    _statusLabel = [UILabel new];
    _statusLabel.font = FONT(14);
    _statusLabel.textColor = HEX(@"ff3300", 1.0f);
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.top.offset = 18;
        make.height.offset = 15;
        make.width.offset = 60;
    }];
    
    
    _line = [UIView new];
    _line.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.height.offset = 0.5;
        make.top.offset = 50;
        make.width.offset = WIDTH;
    }];
    
    
    _contentLabel = [UILabel new];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = FONT(15);
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = HEX(@"191a19", 1.0f);
    
    
    _imgBackView = [UIView new];
    _imgBackView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imgBackView];
    [_imgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = - 50;
        make.size.mas_equalTo(CGSizeMake(WIDTH, space));
        make.left.offset = 0;
        make.right.offset = 0;
    }];
    _cancelBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBnt.titleLabel.font = FONT(14);
    _cancelBnt.layer.cornerRadius = 2.0f;
    _cancelBnt.layer.borderColor = LINE_COLOR.CGColor;
    _cancelBnt.layer.borderWidth = 0.5f;
    _cancelBnt.clipsToBounds = YES;
    _cancelBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_cancelBnt setTitle:NSLocalizedString(@"撤销", nil) forState:UIControlStateNormal];
    [_cancelBnt setTitleColor:HEX(@"999999", 1.0f) forState:0];
    [self.contentView addSubview:_cancelBnt];
    [_cancelBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.bottom.offset = -15;
    }];
    
    _alertBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _alertBnt.titleLabel.font = FONT(14);
    _alertBnt.layer.cornerRadius = 2.0f;
    _alertBnt.layer.borderColor = LINE_COLOR.CGColor;
    _alertBnt.layer.borderWidth = 0.5f;
    _alertBnt.clipsToBounds = YES;
    _alertBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_alertBnt setTitle:NSLocalizedString(@"提醒", nil) forState:UIControlStateNormal];
    [_alertBnt setTitleColor:HEX(@"999999", 1.0f) forState:0];
    [self.contentView addSubview:_alertBnt];
    [_alertBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_cancelBnt.mas_left).offset = -15;
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.bottom.offset = -15;
    }];
    
    _deleteBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBnt.titleLabel.font = FONT(14);
    _deleteBnt.layer.cornerRadius = 2.0f;
    _deleteBnt.layer.borderColor = LINE_COLOR.CGColor;
    _deleteBnt.layer.borderWidth = 0.5f;
    _deleteBnt.clipsToBounds = YES;
    _deleteBnt.hidden = YES;
    _deleteBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_deleteBnt setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [_deleteBnt setTitleColor:HEX(@"999999", 1.0f) forState:0];
    [self.contentView addSubview:_deleteBnt];
    [_deleteBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.bottom.offset = -15;
    }];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = 0;
        make.size.mas_equalTo(CGSizeMake(WIDTH, 0.5));
        
    }];
}

- (void)setInquiryModel:(JHInquiryRepairModel *)inquiryModel{
    _inquiryModel = inquiryModel;
    _infoLabel.text = [NSString stringWithFormat:@"%@ %@",inquiryModel.contact,[self transfromWithString:inquiryModel.dateline]];
    if([inquiryModel.status isEqualToString:@"1"]){
        _statusLabel.text = NSLocalizedString(@"已处理", nil);
        _cancelBnt.hidden = YES;
        _cancelBnt.userInteractionEnabled = NO;
        _alertBnt.hidden = YES;
        _alertBnt.userInteractionEnabled = NO;
        _deleteBnt.hidden = NO;
        _deleteBnt.userInteractionEnabled = YES;
    }else if([inquiryModel.status isEqualToString:@"0"]){
        _statusLabel.text = NSLocalizedString(@"待处理", nil);
        _cancelBnt.hidden = NO;
        _cancelBnt.userInteractionEnabled = YES;
        _alertBnt.hidden = NO;
        _alertBnt.userInteractionEnabled = YES;
        _deleteBnt.hidden = YES;
        _deleteBnt.userInteractionEnabled = NO;
    }else if([inquiryModel.status isEqualToString:@"-1"]){
        _statusLabel.text = NSLocalizedString(@"已撤销", nil);
        _cancelBnt.hidden = YES;
        _cancelBnt.userInteractionEnabled = NO;
        _alertBnt.hidden = YES;
        _alertBnt.userInteractionEnabled = NO;
        _deleteBnt.hidden = NO;
        _deleteBnt.userInteractionEnabled = YES;
    }
    
    _contentLabel.text = inquiryModel.content;
    
    _contentSize = [self currentSizeWithString:_contentLabel.text font:FONT(15) withWidth:30];
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    [paragraph setLineSpacing:6];
    
    [attributed addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, _contentLabel.text.length)];
    
    _contentLabel.attributedText = attributed;
    
    _contentLabel.frame = FRAME(15, 65, WIDTH - 30, _contentSize.height + (_contentSize.height / 14 - 1) * 6);
    
    _imgArray = inquiryModel.photos;
    for(UIView *view in _imgBackView.subviews){
        [view removeFromSuperview];
    }
    if(inquiryModel.photos.count <= 0){
        _imgBackView.hidden = YES;
    }else{
        _imgBackView.hidden = NO;
        for(int i = 0 ; i < inquiryModel.photos.count; i ++){
            UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(15 + i * (space + 15),0, space, space)];
            img.image = IMAGE(inquiryModel.photos[i]) ;
            [img sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:inquiryModel.photos[i]]] placeholderImage:IMAGE(@"pic_shopProduct_no")];
            img.userInteractionEnabled = YES;
            MyTapGesture *imgTap = [[MyTapGesture alloc] initWithTarget:self action:@selector(tapImage:)];
            imgTap.tag = i + 1;
            [img addGestureRecognizer:imgTap];
            [_imgBackView addSubview:img];
        }
    }
    
}
#pragma mark--==点击查看图片
- (void)tapImage:(MyTapGesture *)sender{
    if(_displayView == nil)
    {
        _displayView = [[DisplayImageInView alloc] init];
        [ _displayView showInViewWithImageUrlArray:_imgArray withIndex:sender.tag withBlock:^{
            [_displayView removeFromSuperview];
            _displayView = nil;
        }];
    }
}
- (CGFloat)getCellHeight{
    
    if(_imgArray.count <= 0)
        return _contentSize.height + (_contentSize.height / 14 - 1) * 6 + 50 + 45 + 15;
    else
        return  _contentSize.height + (_contentSize.height / 14 - 1) * 6 + 50 + 45 + 30 + space ;
}
//时间戳转换时间
- (NSString *)transfromWithString:(NSString *)str
{
    NSTimeInterval time = [str doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}
@end

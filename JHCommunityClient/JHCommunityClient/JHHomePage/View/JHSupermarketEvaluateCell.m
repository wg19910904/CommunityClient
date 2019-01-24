//
//  JHSupermarketEvaluateCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSupermarketEvaluateCell.h"
#import <UIImageView+WebCache.h>
#import "UILabel+SuitableHeight.h"
#import "StarView.h"
#import "DisplayImageInView.h"
#import "NSDateToString.h"
@implementation JHSupermarketEvaluateCell
{
    DisplayImageInView *disPlayView;
    //定义所需要传入的url
    NSMutableArray *urlArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        urlArray = [@[] mutableCopy];
        //添加子控件
        [self addSubviews];
        
    }
    return self;
}
- (void)addSubviews
{
    _protraitIV = [UIImageView new];
    _nameLabel = [UILabel new];
    _evaluateTimeLabel = [UILabel new];
    //评价星级单独处理
    _evalucateContentLabel = [UILabel new];
    _imageView_image1 = [UIImageView new];
    _imageView_image2 = [UIImageView new];
    _imageView_image3 = [UIImageView new];
    _imageView_image4 = [UIImageView new];
    _replyLabel = [UILabel new];
    _replyTimeLabel = [UILabel new];
    _imageBackView = [UIView new];
    _replyBackView = [UIView new];
    _arrowIV = [UIImageView new];
    
    [self addSubview:_protraitIV];
    [self addSubview:_nameLabel];
    [self addSubview:_evaluateTimeLabel];
    [self addSubview:_evalucateContentLabel];
    [self addSubview:_replyLabel];
    [self addSubview:_replyTimeLabel];
    [self addSubview:_imageBackView];
    [self addSubview:_replyBackView];
    [self addSubview:_arrowIV];
    
    [_imageBackView addSubview:_imageView_image1];
    [_imageBackView addSubview:_imageView_image2];
    [_imageBackView addSubview:_imageView_image3];
    [_imageBackView addSubview:_imageView_image4];
    NSArray *imageArray = @[_imageView_image1,_imageView_image2,_imageView_image3,_imageView_image4];
    NSInteger m = 0;
    for (UIImageView *iv in imageArray) {
        m++;
        iv.userInteractionEnabled = YES;
        iv.tag = m;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(tapIV:)];
        [iv addGestureRecognizer:gesture];
    }
    [_replyBackView addSubview:_replyLabel];
    //添加上边线
    UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self addSubview:lineView];
}
- (void)setDataModel:(JHEvaluateCellModel *)dataModel
{
    _dataModel = dataModel;
    urlArray = @[].mutableCopy;
    //创建评论头像
    _protraitIV.frame = CGRectMake(10, 5, 20, 20);
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_dataModel.face?_dataModel.face:@""]];
    [_protraitIV sd_setImageWithURL:url placeholderImage:IMAGE(@"headImg03")];
    _protraitIV.layer.cornerRadius = 10.0f;
    _protraitIV.layer.masksToBounds = YES;
    
    //创建用户名
    _nameLabel.frame = CGRectMake(40, 5, 100, 20);
    _nameLabel.text = _dataModel.nickname?_dataModel.nickname:@"";
    _nameLabel.font = [UIFont systemFontOfSize:11];
    _nameLabel.textColor = HEX(@"333333", 1.0f);
    
    //用户评价时间
    _evaluateTimeLabel.frame = FRAME(WIDTH - 200, 5, 190, 20);
    _evaluateTimeLabel.text = [NSDateToString stringFromUnixTime:_dataModel.dateline];
    _evaluateTimeLabel.textAlignment = NSTextAlignmentRight;
    _evaluateTimeLabel.font = FONT(11);
    _evaluateTimeLabel.textColor = HEX(@"999999", 1.0f);
    
    //服务星级
    [self.starView removeFromSuperview];
    self.starView = nil;
    _starView = [StarView addEvaluateViewWithStarNO:[_dataModel.score doubleValue]
                                       withStarSize:10
                                  withBackViewFrame:FRAME(40, 20, 120, 20)];
    [self addSubview:_starView];
    
    //添加评价内容
    _evalucateContentLabel.frame = FRAME(40, 40, WIDTH - 55, 30);
    _evalucateContentLabel.font = FONT(13);
    _evalucateContentLabel.textColor = HEX(@"333333", 1.0);
    _evalucateContentLabel.text = _dataModel.content;
    _evalucateContentLabel.numberOfLines = 0;
    CGFloat tem_h =[_evalucateContentLabel
                    getLabelFitHeight:_evalucateContentLabel withFont:FONT(13)];
    CGFloat height = (tem_h > 30 ? tem_h : 30) + 50;
    _evalucateContentLabel.frame = FRAME(40, 40, WIDTH - 55, tem_h > 30 ? tem_h : 30);
    if (_dataModel.comment_photos) {
        _imageBackView.frame = CGRectMake(40, height + 5, 270, 50);
        self.imageView_image1.image = IMAGE(@"");
        self.imageView_image2.image = IMAGE(@"");
        self.imageView_image3.image = IMAGE(@"");
        self.imageView_image4.image = IMAGE(@"");
        if (_dataModel.comment_photos.count > 0) {
            self.imageView_image1.frame = CGRectMake(0 , 0, 60, 50);
            NSString *urlString= [IMAGEADDRESS stringByAppendingString:_dataModel.comment_photos[0][@"photo"]];
            NSURL *url = [NSURL URLWithString:urlString];
            [_imageView_image1 sd_setImageWithURL:url placeholderImage:IMAGE(@"evaluate_default")];
            [urlArray addObject:urlString];
        }
        if (_dataModel.comment_photos.count > 1){
            self.imageView_image2.frame = CGRectMake(70, 0 , 60, 50);
            NSString *urlString= [IMAGEADDRESS stringByAppendingString:_dataModel.comment_photos[1][@"photo"]];
            NSURL *url = [NSURL URLWithString:urlString];
            [_imageView_image2 sd_setImageWithURL:url placeholderImage:IMAGE(@"evaluate_default")];
            [urlArray addObject:urlString];
        }
        if (_dataModel.comment_photos.count > 2) {
            self.imageView_image3.frame = CGRectMake(140, 0 , 60, 50);
            NSString *urlString= [IMAGEADDRESS stringByAppendingString:_dataModel.comment_photos[2][@"photo"]];
            NSURL *url = [NSURL URLWithString:urlString];
            [_imageView_image3 sd_setImageWithURL:url placeholderImage:IMAGE(@"evaluate_default")];
            [urlArray addObject:urlString];
        }
        if (_dataModel.comment_photos.count > 3) {
            self.imageView_image4.frame = CGRectMake(210, 0 , 60, 50);
            NSString *urlString= [IMAGEADDRESS stringByAppendingString:_dataModel.comment_photos[3][@"photo"]];
            NSURL *url = [NSURL URLWithString:urlString];
            [_imageView_image4 sd_setImageWithURL:url placeholderImage:IMAGE(@"evaluate_default")];
            [urlArray addObject:urlString];
        }
        height += 55;
    }else{
        _imageBackView.frame = CGRectZero;
        self.imageView_image1.image = IMAGE(@"");
        self.imageView_image2.image = IMAGE(@"");
        self.imageView_image3.image = IMAGE(@"");
        self.imageView_image4.image = IMAGE(@"");
        self.imageView_image1.frame = CGRectZero;
        self.imageView_image2.frame = CGRectZero;
        self.imageView_image3.frame = CGRectZero;
        self.imageView_image4.frame = CGRectZero;
    }
    if (_dataModel.reply.length > 0) {
        _arrowIV.frame = FRAME(55, height + 14, 14, 8);
        _arrowIV.image = IMAGE(@"boxarrowTop");
        _replyBackView.frame = FRAME(40, height + 20, WIDTH - 50, 30);
        _replyBackView.backgroundColor = HEX(@"E6E6E6", 1.0f);
        _replyBackView.layer.cornerRadius = 3;
        _replyBackView.layer.masksToBounds = YES;
        _replyLabel.frame = FRAME(10, 10, WIDTH - 70, 30);
        _replyLabel.font = FONT(11);
        _replyLabel.textColor = HEX(@"999999", 1.0f);
        _replyLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"回复:", nil),_dataModel.reply];
        CGFloat tem_h2 = [_replyLabel getLabelFitHeight:_replyLabel withFont:FONT(11)];
        _replyLabel.frame = FRAME(10, 5, WIDTH - 70, tem_h2 > 30 ? tem_h2 : 30);
        _replyBackView.frame = FRAME(40, height + 20, WIDTH - 50, tem_h2 + 25);
        height += (tem_h2 > 30 ? tem_h2 : 30) + 20;
        
        //添加回复时间
        _replyTimeLabel.frame = FRAME(WIDTH - 200, height + 25, 190, 20);
        _replyTimeLabel.text = [NSDateToString stringFromUnixTime:_dataModel.reply_time];
        _replyTimeLabel.textAlignment = NSTextAlignmentRight;
        _replyTimeLabel.font = FONT(11);
        _replyTimeLabel.textColor = HEX(@"999999", 1.0f);
        
        height += 45;
    }else{
        _arrowIV.frame = CGRectZero;
        _arrowIV.image = IMAGE(@"");
        _replyBackView.frame = CGRectZero;
        _replyLabel.frame = CGRectZero;
        _replyTimeLabel.frame = CGRectZero;
        
    }
    self.frame = FRAME(0, 0, WIDTH, height + 10);
}
#pragma mark - 点击iv
- (void)tapIV:(UITapGestureRecognizer *)gesture
{
    UIImageView *iv = (UIImageView *)gesture.view;
    //处理图片数组
    NSInteger tag = iv.tag;
    if (!disPlayView) {
        disPlayView = [[DisplayImageInView alloc] init];
        [disPlayView showInViewWithImageUrlArray:urlArray withIndex:tag withBlock:^{
            [disPlayView removeFromSuperview];
            disPlayView = nil;
        }];
    }
}
@end

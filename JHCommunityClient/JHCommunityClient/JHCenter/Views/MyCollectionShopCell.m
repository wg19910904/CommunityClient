//
//  MyCollectionShopCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MyCollectionShopCell.h"
#import "NSObject+CGSize.h"
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
@implementation MyCollectionShopCell
{
    NSMutableArray *_pictureArray;
    NSMutableArray *_imgArray;
    UIImageView *_img1;
    UIImageView *_img2;
    UIImageView *_img3;
    UIImageView *_img4;
    UIView *_backView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _pictureArray = [NSMutableArray array];
        _imgArray = [NSMutableArray array];
        _img1 = [[UIImageView alloc] init];
        _img2 = [[UIImageView alloc] init];
        _img3 = [[UIImageView alloc] init];
        _img4 = [[UIImageView alloc] init];
        [_imgArray addObject:_img1];
        [_imgArray addObject:_img2];
        [_imgArray addObject:_img3];
        [_imgArray addObject:_img4];
        self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 10, 50, 50)];
        self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImg.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImg];
        self.titleLabel = [[UILabel alloc] init];//WithFrame:FRAME(70, 10, 100, 15)];
        self.titleLabel.font = FONT(14);
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        self.nameLabel = [[UILabel alloc] initWithFrame:FRAME(70, 45, 150, 15)];
        self.nameLabel.font = FONT(12);
        self.nameLabel.textColor = HEX(@"666666", 1.0f);
        [self.contentView addSubview:self.nameLabel];
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = FONT(12);
        self.priceLabel.textColor = HEX(@"f85357", 1.0f);
        [self.contentView addSubview:self.priceLabel];
        self.distantImg = [[UIImageView alloc] init];
        self.distantImg.image = IMAGE(@"zuobaio2");
        [self.contentView addSubview:self.distantImg];
        self.distanLabel = [[UILabel alloc] init];
        self.distanLabel.font = FONT(12);
        self.distanLabel.textColor = HEX(@"666666", 1.0f);
        [self.contentView addSubview:self.distanLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 69.5, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thread];
        
    }
    return self;
}
- (void)setMyCollectionShopModel:(MyCollectionShopModel *)myCollectionShopModel
{
    _myCollectionShopModel = myCollectionShopModel;
    [_backView removeFromSuperview];
    _backView = nil;
    [_startView removeFromSuperview];
    _startView = nil;
    _startView = [StarView addEvaluateViewWithStarNO:[myCollectionShopModel.score floatValue]/
                                                     [myCollectionShopModel.comments floatValue]
                                        withStarSize:10 withBackViewFrame:FRAME(70, 30, 70, 10)];
    [self.contentView addSubview:_startView];
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:myCollectionShopModel.logo]];
    [self.iconImg sd_image:url plimage:IMAGE(@"shopDefault")];
    CGSize titleSize = [self currentSizeWithString:myCollectionShopModel.title font:FONT(14) withWidth:150];
    self.titleLabel.text = myCollectionShopModel.title;
    if(titleSize.width < 100)
    {
        self.titleLabel.frame = FRAME(70, 10, titleSize.width, 15);
    }
    else
    {
        self.titleLabel.frame = FRAME(70, 10, 100, 15);
    }
    _backView = [[UIView alloc] initWithFrame:FRAME(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, 0, 100, 15)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    [_pictureArray removeAllObjects];
    if([myCollectionShopModel.have_maidan isEqualToString:@"1"])
    {
        [_pictureArray addObject:@"have_maidan"];
    }
    if([myCollectionShopModel.have_quan isEqualToString:@"1"])
    {
        [_pictureArray addObject:@"have_quan"];
    }
    if([myCollectionShopModel.have_tuan isEqualToString:@"1"])
    {
        [_pictureArray addObject:@"have_tuan"];
    }
    
    if([myCollectionShopModel.have_waimai isEqualToString:@"1"])
    {
        [_pictureArray addObject:@"have_waimai"];
    }
    
    for(int i = 0 ; i < _pictureArray.count; i ++)
    {
        UIImageView *img=  nil;
        img = _imgArray[i];
        img.frame = FRAME(i * 25, 10, 15, 15);
        [_backView addSubview:img];
        if([_pictureArray[i] isEqualToString:@"have_maidan"])
        {
            img.image = IMAGE(@"hui");
        }
        else if ([_pictureArray[i] isEqualToString:@"have_quan"])
        {
            img.image = IMAGE(@"quan");
        }
        else if([_pictureArray[i] isEqualToString:@"have_tuan"])
        {
            img.image = IMAGE(@"tuan");
        }
        else if([_pictureArray[i] isEqualToString:@"have_waimai"])
        {
            img.image = IMAGE(@"wai");
        }
        else
        {
            
        }
        
    }
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"人均:￥%@", nil),myCollectionShopModel.avg_amount];
    NSRange range =[string rangeOfString:NSLocalizedString(@"人均:", nil)];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:string];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:range];
    self.priceLabel.attributedText = attributed;
    self.distanLabel.text = myCollectionShopModel.juli_label;
    self.distanLabel.frame = FRAME(WIDTH - 70, 45, 65, 15);
    self.distantImg.frame = FRAME(WIDTH - 90, 45, 12, 15);
    self.priceLabel.frame = FRAME(WIDTH - 90, 25, 85, 15);
}
@end

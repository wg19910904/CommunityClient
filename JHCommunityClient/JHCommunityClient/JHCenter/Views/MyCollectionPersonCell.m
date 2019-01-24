//
//  MyCollectionPersonCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MyCollectionPersonCell.h"
#import "NSObject+CGSize.h"
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
@implementation MyCollectionPersonCell
{
    UIView *_backView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _dataArray = [NSMutableArray array];
        _labelArray = [NSMutableArray array];
        _label1 = [[UILabel alloc] init];
        _label2 = [[UILabel alloc] init];
        _label3 = [[UILabel alloc] init];
        _label4 = [[UILabel alloc] init];
        [_labelArray addObject:_label1];
        [_labelArray addObject:_label2];
        [_labelArray addObject:_label3];
        [_labelArray addObject:_label4];
        self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 22.5, 50, 50)];
        self.iconImg.layer.cornerRadius = self.iconImg.frame.size.width / 2;
        self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImg.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImg];
        self.name = [[UILabel alloc] init];
        self.name.font = FONT(14);
        self.name.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.name];
        self.type = [[UILabel alloc] init];
        self.type.font = FONT(12);
        self.type.textAlignment = NSTextAlignmentCenter;
        self.type.textColor = [UIColor whiteColor];
        self.type.layer.cornerRadius = 4.0f;
        self.type.clipsToBounds = YES;
        [self.contentView addSubview:self.type];
        self.length = [[UILabel alloc] init];
        self.length.textColor = HEX(@"fc7400", 1.0f);
        self.length.font = FONT(11);
        [self.contentView addSubview:self.length];
        self.service = [[UILabel alloc] initWithFrame:FRAME(157, 39, 110, 10)];
        self.service.font = FONT(12);
        self.service.textColor = HEX(@"999999", 1.0f);
        [self.contentView addSubview:self.service];
        self.dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 20, 40, 10, 15)];
        self.dirImg.image = IMAGE(@"jiantou_1");
        [self.contentView addSubview:self.dirImg];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *thraed = [[UIView alloc] initWithFrame:FRAME(0, 94.5, WIDTH, 0.5)];
        thraed.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thraed];
        
    }
    return self;
}
- (void)setMyCollectionPersonModel:(MyCollectionPersonModel *)myCollectionPersonModel
{
    _myCollectionPersonModel = myCollectionPersonModel;
    [_backView removeFromSuperview];
    _backView = nil;
    [self.starView removeFromSuperview];
    self.starView = nil;
    self.starView = [StarView addEvaluateViewWithStarNO:[self.myCollectionPersonModel.score floatValue] withStarSize:10 withBackViewFrame:FRAME(70, 34, 70, 10)];
    [self.contentView addSubview:self.starView];
    [_dataArray removeAllObjects];
//    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:myCollectionPersonModel.face]] placeholderImage:IMAGE(@"touxiang")];
    self.name.text = myCollectionPersonModel.name;
    CGSize nameSize = [self currentSizeWithString:self.name.text font:FONT(14) withWidth:0];
    self.name.frame = FRAME(70, 17, nameSize.width, 15);
    self.type.text = myCollectionPersonModel.from_title;
    self.type.frame = FRAME(70 + nameSize.width + 10, 17, 30, 15);
    if([myCollectionPersonModel.from_title isEqualToString:NSLocalizedString(@"家政", nil)])
    {
        self.type.backgroundColor = HEX(@"3ac9aa", 1.0f);
        NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:myCollectionPersonModel.face]];
        [self.iconImg sd_image:url plimage:IMAGE(@"houseicon")];
    }
    else if([myCollectionPersonModel.from_title isEqualToString:NSLocalizedString(@"维修", nil)])
    {
        self.type.backgroundColor = HEX(@"586cbe", 1.0f);
        NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:myCollectionPersonModel.face]];
        [self.iconImg sd_image:url plimage:IMAGE(@"maintainheader")];
    }
    else
    {
        self.type.backgroundColor = HEX(@"ff4642", 1.0f);
    }
    NSLog(@"%@",myCollectionPersonModel.from_title);
    self.length.text = myCollectionPersonModel.juli;
    CGSize lenghtSize = [self currentSizeWithString:myCollectionPersonModel.juli font:FONT(11) withWidth:150];
    _length.frame = FRAME(WIDTH  - lenghtSize.width - 20, 17, lenghtSize.width, 15);
    //self.experience.text = [NSString stringWithFormat:@"%@年经验",];
    self.service.text = [NSString stringWithFormat:NSLocalizedString(@"服务%@次", nil),myCollectionPersonModel.orders];
    NSArray *array = myCollectionPersonModel.tags;
    NSArray *colorArray = @[@"eb6100",@"9ab500",@"00b7ee",@"8c97cb"];
    CGFloat totalSize = 0;
    _backView = [[UIView alloc] initWithFrame:FRAME(70, 63, WIDTH - 70, 15)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    if(array.count <= 4)
    {
        for(int i = 0 ; i < array.count; i ++)
        {
            UILabel * label = _labelArray[i];
            label.layer.cornerRadius = 2.0f;
            label.layer.borderColor = HEX(colorArray[i], 1.0f).CGColor;
            label.layer.borderWidth = 1.0f;
            label.font = FONT(12);
            label.text = [NSString stringWithFormat:@"%@",array[i]];
            label.textColor = HEX(colorArray[i], 1.0f);
            label.textAlignment = NSTextAlignmentCenter;
            CGSize size = [self currentSizeWithString:[NSString  stringWithFormat:@"y%@",label.text] font:FONT(12) withWidth:0];
            label.frame = FRAME(totalSize,0, size.width, 15);
            totalSize = size.width + totalSize + 5;
            if(totalSize < WIDTH)
            {
                [_backView addSubview:label];
            }
            else
            {
                break;
            }
        }
    }
    else
    {
        for(int i = 0 ; i < 4; i ++)
        {
            UILabel * label = _labelArray[i];
            label.layer.cornerRadius = 2.0f;
            label.layer.borderColor = HEX(colorArray[i], 1.0f).CGColor;
            label.layer.borderWidth = 1.0f;
            label.font = FONT(12);
            label.text = [NSString stringWithFormat:@"%@",array[i]];
            label.textColor = HEX(colorArray[i], 1.0f);
            label.textAlignment = NSTextAlignmentCenter;
            CGSize size = [self currentSizeWithString:[NSString  stringWithFormat:@"y%@",label.text] font:FONT(12) withWidth:0];
            label.frame = FRAME(totalSize, 0, size.width, 15);
            totalSize = size.width + totalSize + 5;
            if(totalSize < WIDTH)
            {
                [_backView addSubview:label];
            }
            else
            {
                break;
            }
        }
        
    }
    
}
@end

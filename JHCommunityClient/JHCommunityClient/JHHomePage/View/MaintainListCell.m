//
//  HouseKeepingCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MaintainListCell.h"
#import "NSObject+CGSize.h"
#import "StarView.h"
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
#import "MaintainListAttrModel.h"
//#import "CollectionViewCell.h"
@implementation MaintainListCell
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
        [self.contentView addSubview:_label1];
        [self.contentView addSubview:_label2];
        [self.contentView addSubview:_label3];
        [self.contentView addSubview:_label4];
        self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 22.5, 50, 50)];
        self.iconImg.layer.cornerRadius = self.iconImg.frame.size.width / 2;
        self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImg.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImg];
        self.name = [[UILabel alloc] init];
        self.name.font = FONT(14);
        self.name.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.name];
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
- (void)setListModel:(MaintainListModel *)listModel
{
    _listModel = listModel;
    [self.starView removeFromSuperview];
    self.starView = nil;
    self.starView = [StarView addEvaluateViewWithStarNO:[self.listModel.avg_score floatValue] withStarSize:10 withBackViewFrame:FRAME(70, 34, 70, 10)];
    [self.contentView addSubview:self.starView];
    [_dataArray removeAllObjects];
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:listModel.face]];
    [self.iconImg sd_image:url plimage:IMAGE(@"maintainheader")];
    self.name.text = listModel.name;
    CGSize nameSize = [self currentSizeWithString:self.name.text font:FONT(14) withWidth:0];
    self.name.frame = FRAME(70, 17, nameSize.width, 15);
    self.length.text = listModel.juli;
    CGSize lenghtSize = [self currentSizeWithString:listModel.juli_label font:FONT(11) withWidth:150];
    _length.frame = FRAME(WIDTH  - lenghtSize.width - 20, 17, lenghtSize.width, 15);
//  self.experience.text = [NSString stringWithFormat:@"%@年经验",];
    self.service.text = [NSString stringWithFormat:NSLocalizedString(@"服务%@次", nil),listModel.orders];
    for(NSDictionary *dic in [listModel.attr isKindOfClass:[NSArray class]] ?  listModel.attr : @[])
    {
        MaintainListAttrModel *model = [[MaintainListAttrModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:model];
    }
    NSArray *colorArray = @[@"eb6100",@"9ab500",@"00b7ee",@"8c97cb"];
    CGFloat totalSize = 70;
    if(_dataArray.count <= 4)
    {
        for(int i = 0 ; i < _dataArray.count; i ++)
        {
            UILabel *label = _labelArray[i];
            label.hidden = NO;
            label.layer.cornerRadius = 2.0f;
            label.layer.borderColor = HEX(colorArray[i], 1.0f).CGColor;
            label.layer.borderWidth = 1.0f;
            label.font = FONT(12);
            label.tag = 100+i;
            label.text = [_dataArray[i] cate_title];
            label.textColor = HEX(colorArray[i], 1.0f);
            label.textAlignment = NSTextAlignmentCenter;
            CGSize size = [self currentSizeWithString:[NSString  stringWithFormat:@"y%@",label.text] font:FONT(12) withWidth:0];
            label.frame = FRAME(totalSize, 63, size.width, 15);
            totalSize = size.width + totalSize + 5;
            if(totalSize < WIDTH)
            {
                //判断需要隐藏的数目
                NSInteger num = 4 - _dataArray.count;
                NSArray *temArray = [_labelArray subarrayWithRange:NSMakeRange(_dataArray.count, num)];
                for (UILabel *tem_l in temArray) {
                    tem_l.hidden = YES;
                }
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
            UILabel *label = _labelArray[i];
            label.hidden = NO;
            label.layer.cornerRadius = 2.0f;
            label.layer.borderColor = HEX(colorArray[i], 1.0f).CGColor;
            label.layer.borderWidth = 1.0f;
            label.font = FONT(12);
            label.text = [_dataArray[i] cate_title];
            label.textColor = HEX(colorArray[i], 1.0f);
            label.textAlignment = NSTextAlignmentCenter;
            CGSize size = [self currentSizeWithString:[NSString  stringWithFormat:@"y%@",label.text] font:FONT(12) withWidth:0];
            label.frame = FRAME(totalSize, 63, size.width, 15);
            totalSize = size.width + totalSize + 5;
            if(totalSize < WIDTH)
            {
                [self.contentView addSubview:label];
            }
            else
            {
                break;
            }
        }
        
    }
    
}
@end

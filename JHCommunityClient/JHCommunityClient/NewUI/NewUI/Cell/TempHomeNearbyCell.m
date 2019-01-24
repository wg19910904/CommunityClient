//
//  TempHomeNearbyCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/14.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "TempHomeNearbyCell.h"
#import <UIImageView+WebCache.h>
#import "JHTempAdvModel.h"

@implementation TempHomeNearbyCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HEX(@"cccccc", 1);
    }
    return self;
}
-(void)creatUI{

    for (int i = 0; i<_array.count; i++) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(i*(WIDTH/3+1), 0, WIDTH/3, 128*WIDTH/375)];
        JHTempAdvModel *model= [[JHTempAdvModel alloc]init];
        model =_array[i];
        bgView.backgroundColor = HEX(@"f2f2f2", 1);
        bgView.tag = i;
        [self addSubview:bgView];
        bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewClick:)];
        [bgView addGestureRecognizer:tap];
        UIImageView * imgV = [[UIImageView alloc]init];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.userInteractionEnabled = NO;
        [bgView addSubview:imgV];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset = 0;
       
        }];
        [imgV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:PHAIMAGE];

    }
    
}
-(void)bgViewClick:(UITapGestureRecognizer *)tap{
    if (self.clickBlock) {
        self.clickBlock(tap.view.tag);
    }
}
-(void)setArray:(NSArray *)array{
    _array = array;
    if (array>0) {
        [self creatUI];
    }
    
}
@end

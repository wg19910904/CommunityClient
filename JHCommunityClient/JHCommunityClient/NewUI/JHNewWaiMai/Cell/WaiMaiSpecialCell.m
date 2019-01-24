//
//  WaiMaiSpecialCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "WaiMaiSpecialCell.h"
#import <UIButton+WebCache.h>

@interface WaiMaiSpecialCell()

@end

@implementation WaiMaiSpecialCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    for (NSInteger i=0; i<2; i++) {
        
        UIButton * btn = [UIButton new];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=WIDTH/2.0 * i;
            make.top.offset=0;
            make.width.offset=WIDTH/2.0;
            make.bottom.offset=0;
        }];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            UIView *lineView=[UIView new];
            [self.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=WIDTH/2.0-0.5;
                make.top.offset=0;
                make.width.offset=1;
                make.bottom.offset=0;
            }];
            lineView.backgroundColor=LINE_COLOR;
        }
        
    }
    
}

-(void)reloadCellWith:(NSArray *)arr{
    for (NSInteger i=0; i<2; i++) {
        
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:100+ i];
        if (arr.count > i) {
            NSDictionary *dic = arr[i];
            NSString *url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"thumb"]];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:IMAGE(@"tgtopdeafault")];
        }
    }
}

-(void)clickbtn:(UIButton *)btn{
    
    if (self.clickIndex) {
        self.clickIndex(btn.tag - 100);
    }
}


@end

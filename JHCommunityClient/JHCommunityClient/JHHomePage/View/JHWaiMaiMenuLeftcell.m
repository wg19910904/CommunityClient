//
//  JHWaiMaiMenuLeftcell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHWaiMaiMenuLeftcell.h"

@implementation JHWaiMaiMenuLeftcell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BACK_COLOR;
        
        //添加子控件
        [self createSubView];
    }
    return self;
}
#pragma mark - 创建子控件
- (void)createSubView
{
    _titileLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
    _indicateLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 2, 44)];
    _indicateLabel.backgroundColor = THEME_COLOR;
    
    [self addSubview:_titileLabel];
    [self addSubview:_indicateLabel];
    
    //添加下边线
    UIView *line = [[UIView alloc]initWithFrame:FRAME(0, 43.5, 80, 0.5)];
    line.backgroundColor = LINE_COLOR;
    [self addSubview:line];
}
#pragma mark - 外部数据传入时,设置titleLabel的内容
- (void)setDataModel:(JHWaimaiMenuLeftModel *)dataModel
{
    _dataModel = dataModel;
    //设置内容
    _titileLabel.text = _dataModel.title;
    _titileLabel.textColor = HEX(@"333333", 1.0f);
    _titileLabel.font = FONT(14);
    _indicateLabel.hidden = YES;
}
@end

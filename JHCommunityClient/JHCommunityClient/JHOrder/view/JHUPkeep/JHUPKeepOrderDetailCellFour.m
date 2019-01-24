//
//  JHUPKeepOrderDetailCellFour.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHUPKeepOrderDetailCellFour.h"

@implementation JHUPKeepOrderDetailCellFour
{
    UILabel * label_line;//创建分割线
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHeight:(float)height{
    _height = height;
    if (self.myLabel == nil) {
        self.myLabel = [[UILabel alloc]init];
        self.myLabel.frame = FRAME(15, 15, WIDTH-30, height);
        self.myLabel.font = [UIFont systemFontOfSize:14];
        self.myLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        self.myLabel.numberOfLines = 0;
        [self addSubview:self.myLabel];
    }
    if(label_line == nil){
        label_line = [[UILabel alloc]init];
        label_line.frame = FRAME(0, height+29.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

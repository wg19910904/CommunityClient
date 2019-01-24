//
//  JHHeadLinesBaseCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHHeadLinesBaseCell.h"

@implementation JHHeadLinesBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (NSString *)getIdentifier{
    return @"";
}
+ (CGFloat)getHeight:(id)model{
    return 0;
}

-(void)setModel:(JHHeadLinesModel *)model{}

-(void)creatUI{}

@end

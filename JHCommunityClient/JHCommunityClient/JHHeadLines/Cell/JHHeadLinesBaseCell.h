//
//  JHHeadLinesBaseCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHeadLinesModel.h"

@interface JHHeadLinesBaseCell : UITableViewCell

-(void)setModel:(JHHeadLinesModel *)model;
- (void)creatUI;

+ (NSString *)getIdentifier;
+ (CGFloat)getHeight:(JHHeadLinesModel *)model;

@end

//
//  JHheadLinesCellFactory.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JHHeadLinesBaseCell.h"
#import "JHHeadLinesModel.h"
@interface JHheadLinesCellFactory : NSObject

+ (JHHeadLinesBaseCell *)getCell:(JHHeadLinesModel *)model withCellStyle:(UITableViewCellStyle)cellStyle withCellIdentifier:(NSString *)reuseIdentifier;

+ (NSString *)getCellIdentifier:(JHHeadLinesModel *)model;

+ (CGFloat)getCellHeight:(JHHeadLinesModel *)model;

@end

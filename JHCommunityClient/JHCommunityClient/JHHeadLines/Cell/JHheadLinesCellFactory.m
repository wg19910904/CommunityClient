//
//  JHheadLinesCellFactory.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHheadLinesCellFactory.h"
#import "JHHeadLinesOneCell.h"
#import "JHHeadLinesTwoCell.h"
#import "JHHeadLinesThreeCell.h"

@implementation JHheadLinesCellFactory

+ (JHHeadLinesBaseCell *)getCell:(JHHeadLinesModel *)model withCellStyle:(UITableViewCellStyle)cellStyle withCellIdentifier:(NSString *)reuseIdentifier {
    
    JHHeadLinesBaseCell *baseCell;
    if ([model.type isEqualToString:@"more"]) {
        baseCell = [[JHHeadLinesOneCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    } else if ([model.type isEqualToString:@"big"]) {
        baseCell = [[JHHeadLinesTwoCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    } else if ([model.type isEqualToString:@"small"]) {
        baseCell = [[JHHeadLinesThreeCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    }
    return baseCell;
}

+ (NSString *)getCellIdentifier:(JHHeadLinesModel *)model {
    if ([model.type isEqualToString:@"more"]) {
        return [JHHeadLinesOneCell getIdentifier];
    } else if ([model.type isEqualToString:@"big"]) {
        return [JHHeadLinesTwoCell getIdentifier];
    } else if ([model.type isEqualToString:@"small"]) {
        return [JHHeadLinesThreeCell getIdentifier];
    }
    return nil;
}

+ (CGFloat)getCellHeight:(JHHeadLinesModel *)model {
    if ([model.type isEqualToString:@"more"]) {
        return [JHHeadLinesOneCell getHeight:model];
    } else if ([model.type isEqualToString:@"big"]) {
        return [JHHeadLinesTwoCell getHeight:model];
    } else if ([model.type isEqualToString:@"small"]) {
        return [JHHeadLinesThreeCell getHeight:model];
    } 
    return 0;
}

@end

//
//  YFBaseTableViewCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "YFBaseTableViewCell.h"

@implementation YFBaseTableViewCell

+(instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier{
    Class class = [self class];
    YFBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[class alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end

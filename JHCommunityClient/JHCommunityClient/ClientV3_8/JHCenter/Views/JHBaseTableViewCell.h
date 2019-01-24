//
//  JHBaseTableViewCell.h
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/15.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBaseTableViewCell : UITableViewCell
+ (NSString *)getIdentifier;
+ (CGFloat)getHeight:(id)model;

@end

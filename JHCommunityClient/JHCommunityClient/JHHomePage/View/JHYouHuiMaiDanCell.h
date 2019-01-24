//
//  JHYouHuiMaiDanCell.h
//  JHCommunityClient
//
//  Created by xixixi on 16/6/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHYouHuiMaiDanCell : UITableViewCell
@property(nonatomic,copy)NSDictionary *dataDic;
+ (CGFloat)getHeight:(NSString *)string;
@end

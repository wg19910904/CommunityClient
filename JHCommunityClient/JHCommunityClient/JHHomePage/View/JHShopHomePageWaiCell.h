//
//  JHShopHomePageWaiCell.h
//  JHCommunityClient
//
//  Created by xixixi on 16/6/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHShopHomePageWaiCell : UITableViewCell
@property(nonatomic,copy)NSDictionary *dataDic;


+ (CGFloat)getHeight:(NSString *)haveWaiMai;
@end

//
//  JHShopHomePageTuanCell.h
//  JHCommunityClient
//
//  Created by xixixi on 16/6/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickMoreBtnBlock)();
@interface JHShopHomePageTuanCell : UITableViewCell
@property(nonatomic,copy)NSDictionary *dataDic;
@property(nonatomic,weak)UINavigationController *navVC;
@property(nonatomic,copy)ClickMoreBtnBlock clickMoreBtnBlock;
+ (CGFloat)getHeightWith:(NSString *)haveTuan withDic:(NSDictionary *)dic;
@end

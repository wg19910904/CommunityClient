//
//  WaiMaiShopperCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaiMaiShopperModel.h"

typedef void(^ReloadYouhuiCell)();

@interface WaiMaiShopperCell : UITableViewCell
@property(nonatomic,copy)ReloadYouhuiCell reloadYouhuiCell;
@property(nonatomic,assign)BOOL isHomePage;//是否是首页
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)void(^myBlock)(NSInteger index);
-(void)reloadCellWithModel:(WaiMaiShopperModel *)model isFliterList:(BOOL)is_fliter;
@end

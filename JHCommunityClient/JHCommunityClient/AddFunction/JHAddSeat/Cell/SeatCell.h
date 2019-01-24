//
//  SeatCell.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatModel.h"

typedef void(^ClickGoShopDetail)();

@interface SeatCell : UITableViewCell
@property(nonatomic,copy)ClickGoShopDetail clickGoShopDetail;
-(void)reloadCellWithModel:(SeatModel *)model is_detail:(BOOL)is_detail show_goShop:(BOOL)is_show;
@end

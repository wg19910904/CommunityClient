//
//  GetNumberCell.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetNumberModel.h"

typedef void(^ClickGoShopDetail)();

@interface GetNumberCell : UITableViewCell
@property(nonatomic,copy)ClickGoShopDetail clickGoShopDetail;
-(void)reloadCellWithModel:(GetNumberModel *)model is_detail:(BOOL)is_detail show_goShop:(BOOL)is_show;

@end

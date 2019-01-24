//
//  NearShopCell.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearShopModel.h"

@interface NearShopCell : UITableViewCell

-(void)reloadCellWithModel:(NearShopModel *)shop;
@end

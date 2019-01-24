//
//  JHGroupOrderListCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGroupOrderModel.h"

@interface JHGroupOrderListCell : UITableViewCell
-(void)reloadCellWithModel:(JHGroupOrderModel *)model;
@end

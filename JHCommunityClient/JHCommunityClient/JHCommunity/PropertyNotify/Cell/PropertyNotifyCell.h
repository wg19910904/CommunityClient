//
//  PropertyNotifyCell.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyNotifyModel.h"

@interface PropertyNotifyCell : UITableViewCell
-(void)reloadCellWithModel:(PropertyNotifyModel *)model;

@end

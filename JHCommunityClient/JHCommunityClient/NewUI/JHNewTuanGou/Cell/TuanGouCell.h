//
//  TuanGouCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/28.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuanGouModel.h"

@interface TuanGouCell : UITableViewCell
-(void)reloadCellWithModel:(TuanGouModel *)model;
@end

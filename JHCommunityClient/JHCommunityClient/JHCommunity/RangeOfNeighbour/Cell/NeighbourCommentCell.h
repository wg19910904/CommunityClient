//
//  NeighbourCommentCell.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeighbourCommentModel.h"

typedef void(^ClickIcon)();

@interface NeighbourCommentCell : UITableViewCell
@property(nonatomic,copy)ClickIcon clickIcon;
-(void)reloadCellWith:(NeighbourCommentModel *)model;
@end

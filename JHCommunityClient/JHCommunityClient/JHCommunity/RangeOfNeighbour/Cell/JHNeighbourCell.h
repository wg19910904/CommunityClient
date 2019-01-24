//
//  JHNeighbourCell.h
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeighbourModel.h"

typedef void(^ClickSupport)();
typedef void(^ClickComment)();

@interface JHNeighbourCell : UITableViewCell
@property(nonatomic,copy)ClickSupport clickSupport;
@property(nonatomic,copy)ClickSupport clickComment;

-(void)reloadCellWithModel:(NeighbourModel *)model is_showDes:(BOOL)is_show;
@end

//
//  JHAllOrderDetailStaffCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "JHWaiMaiModel.h"

@interface JHAllOrderDetailStaffCell : YFBaseTableViewCell
@property(nonatomic,copy)MsgBlock clickCallBlock;
-(void)reloadCellWithModel:(JHWaiMaiModel *)model;
@end

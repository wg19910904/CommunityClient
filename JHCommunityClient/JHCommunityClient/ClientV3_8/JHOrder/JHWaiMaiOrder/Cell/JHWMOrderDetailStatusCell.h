//
//  JHWMDetailStatusCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "YFBaseTableViewCell.h"

@interface JHWMOrderDetailStatusCell : YFBaseTableViewCell
@property(nonatomic,copy)NSString *statusStr;
@property(nonatomic,assign)NSInteger pay_left_time;
@property(nonatomic,copy)MsgBlock cancelOrderBlock;
@end

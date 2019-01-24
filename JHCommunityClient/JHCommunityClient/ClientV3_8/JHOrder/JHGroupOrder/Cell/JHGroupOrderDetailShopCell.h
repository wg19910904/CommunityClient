//
//  JHGroupOrderDetailShopCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "JHGroupOrderModel.h"

@interface JHGroupOrderDetailShopCell : YFBaseTableViewCell
@property(nonatomic,copy)MsgBlock telCallblock;
@property(nonatomic,copy)MsgBlock goShopDetail;
-(void)reloadCellWithModel:(JHGroupOrderModel *)model;
@end

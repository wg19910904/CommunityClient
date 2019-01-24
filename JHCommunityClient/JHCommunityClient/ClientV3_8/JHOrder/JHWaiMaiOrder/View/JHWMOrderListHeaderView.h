//
//  JHWMOrderListHeaderView.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaiMaiModel.h"

@interface JHWMOrderListHeaderView : UITableViewHeaderFooterView
@property(nonatomic,assign)BOOL is_detail;
@property(nonatomic,copy)MsgBlock clickLocationBlock;
@property(nonatomic,copy)MsgBlock clickShopBlock;
-(void)reloadViewWithModel:(JHWaiMaiModel *)model;
@end

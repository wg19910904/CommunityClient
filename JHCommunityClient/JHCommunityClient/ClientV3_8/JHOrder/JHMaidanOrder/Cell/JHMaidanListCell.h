//
//  JHMaidanListCell.h
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "JHMaiDanModel.h"

@interface JHMaidanListCell : YFBaseTableViewCell
@property(nonatomic,strong)JHMaiDanModel *cellModel;
@property(nonatomic,copy)MsgBlock clickComment;
@end

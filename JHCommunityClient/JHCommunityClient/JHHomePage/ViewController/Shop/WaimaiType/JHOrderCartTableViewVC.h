//
//  JHOrderCartTableViewVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/4/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^RefreshCartAndMenuBlock)();
typedef void(^ClickCleanBtn)();
@interface JHOrderCartTableViewVC : JHBaseVC
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,copy)RefreshCartAndMenuBlock refreshCartAndMenuBlock;
@property(nonatomic,copy)ClickCleanBtn clickCleanBtnBlock;
@property(nonatomic,assign)CGFloat interval;
//刷新数据
- (void)handleData;
@end

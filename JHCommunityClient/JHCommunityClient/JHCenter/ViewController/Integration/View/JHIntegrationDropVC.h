//
//  JHIntegrationDropVC.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/9/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
#import "IntegrationMallCateBntModel.h"
@interface JHIntegrationDropVC : JHBaseVC
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,copy)void(^selectBlock)(IntegrationMallCateBntModel *model);
- (void)showDropVC;
- (void)hideDropVC;
- (void)touch_BackView;
@end

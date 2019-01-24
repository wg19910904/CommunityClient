//
//  JHNavSortVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^RefreshBlock)(NSDictionary *paramDic);
//回调所选分类行数
typedef void(^RefreshBtnTitleBlock)(NSString *btnTitle);
@interface JHSubNavSortVC : JHBaseVC
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, copy)RefreshBlock refreshBlock;
@property(nonatomic,copy)RefreshBtnTitleBlock refreshBtnTitleBlock;
@end

//
//  JHWaiMaiSubNavClassifyVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^RefreshBlock)(NSDictionary *paramDic);
//回调所选title
typedef void(^RefreshBtnTitleBlock)(NSString *btnTitle);
@interface JHWaiMaiSubNavFilterVC : JHBaseVC
@property(nonatomic,copy)RefreshBtnTitleBlock refreshBtnTitleBlock;
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, copy)RefreshBlock refreshBlock;
@end

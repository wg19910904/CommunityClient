//
//  JHSubNavAddressVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
//刷新上个界面表视图
typedef void(^RefreshBlock)(NSDictionary *paramDic);
//回调所选title
typedef void(^RefreshBtnTitleBlock)(NSString *btnTitle);
@interface JHSubNavAddressVC : JHBaseVC
@property(nonatomic,strong)UITableView *leftTable;
@property(nonatomic,strong)UITableView *rightTable;
@property(nonatomic,copy)RefreshBlock refreshBlock;
@property(nonatomic,copy)RefreshBtnTitleBlock refreshBtnTitleBlock;
@property(nonatomic,assign)BOOL isStartSelector;
@property(nonatomic,assign)BOOL isRightStartSelector;
@end

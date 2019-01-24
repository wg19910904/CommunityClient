//
// ZQSegementViewController.h
//  ZQSegementViewController
//
//  Created by ZQ on 17/3/20.
//  Copyright © 2017年 zq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
@interface ZQSegementViewController : JHBaseVC
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *controllerArray;
@property (nonatomic, strong) UIScrollView *scroll;
@property(nonatomic,copy)NSString *cate_id;//默认选中的分类
@property(nonatomic,assign)NSInteger index;//默认选择的分类索引
@end

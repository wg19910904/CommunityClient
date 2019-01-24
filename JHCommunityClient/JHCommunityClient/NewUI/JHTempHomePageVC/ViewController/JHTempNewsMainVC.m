//
//  JHTempNewsMainVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHTempNewsMainVC.h"
#import "JHTempNewsListVC.h"
#import "JHTempHomePageViewModel.h"
#import "JHTempNewsTypeOtherModel.h"
@interface JHTempNewsMainVC ()

@end

@implementation JHTempNewsMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
}
//初始化一些数据的方法
-(void)initData{
    [self.navigationController.navigationBar setHidden:NO];
    self.view.backgroundColor = BACK_COLOR;
    self.navigationItem.title =NSLocalizedString(@"社区头条", nil);
    SHOW_HUD
    //请求新闻分类
    [JHTempHomePageViewModel postToGetNewsType:^(NSString *error, NSArray *modelArr) {
        HIDE_HUD
        if (error) {
            [self showMsg:error];
        }else{//成功
            NSMutableArray *tempTitleArr = @[].mutableCopy;
            NSMutableArray *vcArr = @[].mutableCopy;
            NSInteger num = 0;
            for (int i = 0; i < modelArr.count; i ++) {
                JHTempNewsTypeOtherModel *model = modelArr[i];
                [tempTitleArr addObject:model.title];
                JHTempNewsListVC *vc = [[JHTempNewsListVC alloc] init];
                 vc.cat_id = model.cat_id;
                if ([self.cate_id integerValue] == [model.cat_id integerValue]) {
                    num = i;
                }
                [vcArr addObject:vc];
            }
            self.index = num;
            self.titleArray = tempTitleArr;
            self.controllerArray = vcArr;
        }
    }];
}
@end

//
//  JudgeToken.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JudgeToken.h"
#import "JHLoginVC.h"
@implementation JudgeToken
+ (void)judgeTokenWithVC:(JHBaseVC *)vc withBlock:(void (^)())tokenBlock
{
    JudgeToken *judge = [[JudgeToken alloc] init];
    judge.viewContoller = vc;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if(token.length == 0)
    {
        [judge showAlertView:NSLocalizedString(@"您还没有登录,请登录", nil)];
        return;
    }
    else
    {
        if(tokenBlock)
        {
            tokenBlock();
        }
    }
}
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"去登录", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JHLoginVC *loginVC = [[JHLoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.viewContoller.navigationController pushViewController:loginVC animated:YES];
    }];
    [alertController addAction:loginAction];
    [self.viewContoller  presentViewController:alertController animated:YES completion:nil];
}

@end

//
//  JHBaseVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
#import "DSToast.h"
#import "AppDelegate.h"
#import "ShowEmptyDataView.h"
#import "JHShareModel.h"

@interface JHBaseVC ()<UIGestureRecognizerDelegate>{
    
    DSToast *toast;
    DSToast *textToast;
    DSToast *noNetToast;
    AppDelegate *_delegate;
}
@property(nonatomic,strong)ShowEmptyDataView *emptyView;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@end

@implementation JHBaseVC

-(NSMutableDictionary *)heightAtIndexPath{
    if (_heightAtIndexPath==nil) {
        _heightAtIndexPath=[[NSMutableDictionary alloc] init];
    }
    return _heightAtIndexPath;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"******************\n\n当前控制器为:\n%@\n\n\n*******************",NSStringFromClass(self.class));
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIControl * backView = [[UIControl alloc] initWithFrame:self.view.bounds];
    [backView addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    self.view = backView;
    self.view.backgroundColor = [UIColor whiteColor];

    _delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self createBackBtn];
    [self judgeShowOrHidden];
}

// 创建左边按钮
- (void)createBackBtn
{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [self.backBtn addTarget:self action:@selector(clickBackBtn)
           forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 0,13, 28);
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView: self.backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

#pragma mark====创建右边的按钮======
- (void)creatRightBtnWith:(NSString *)imageStr sel:(SEL)action edgeInsets:(UIEdgeInsets )edgeInsets{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:action
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:IMAGE(imageStr) forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = edgeInsets;
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)creatRightTitleBtn:(NSString *)titleStr titleColor:(UIColor *)titleColor sel:(SEL)action edgeInsets:(UIEdgeInsets )edgeInsets{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:action
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:titleStr forState:UIControlStateNormal];
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    rightBtn.titleEdgeInsets = edgeInsets;
    rightBtn.titleLabel.font=FONT(16);
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

#pragma mark - 判断是否需要隐藏左侧按钮
- (void)judgeShowOrHidden
{
    UINavigationController *self_nav = self.navigationController;
    if (self_nav && self_nav.viewControllers[0] == self) {
        self.backBtn.hidden = YES;
    }
}
#pragma mark - 点击导航栏左按钮
- (void)clickBackBtn
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

//点击背景的事件
- (void)touch_BackView
{
    //在不同界面按需执行代码
}

#pragma mark - 没有数据时展示
- (void)showHaveNoMoreData
{
    if (toast == nil) {
        
        toast = [[DSToast alloc] initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
        [toast showInView:_delegate.window.rootViewController.view showType:(DSToastShowTypeCenter) withBlock:^{
            toast = nil;
        }];
    }
    
}
#pragma mark--===用于提醒断网或者服务器正忙
- (void)showNoNetOrBusy:(BOOL)isNoNet{
    NSString *text = nil;
    if(isNoNet){
        text = NSLocalizedString(@"无法连接服务器,请检查网络连接是否正常", nil);
    }else{
        text = NSLocalizedString(@"服务器繁忙,请稍后再试", nil);
    }
    if (noNetToast == nil) {
        noNetToast = [[DSToast alloc] initWithText:text];
        [noNetToast showInView:_delegate.window.rootViewController.view showType:(DSToastShowTypeCenter) withBlock:^{
            noNetToast = nil;
        }];
    }
}

#pragma mark - 消息提示
-(void)showToastAlertMessageWithTitle:(NSString *)msg{
    __weak typeof(self)weakself = self;
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:msg];
        [toast showInView:_delegate.window.rootViewController.view showType:(DSToastShowTypeCenter) withBlock:^{
          [weakself removeToast];
        }];
    }
}
- (void)showMsg:(NSString *)msg{
    __weak typeof(self)weakself = self;
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:msg];
        [toast showInView:_delegate.window showType:(DSToastShowTypeCenter) withBlock:^{
            [weakself removeToast];
        }];
    }
}

- (void)removeToast{
     toast = nil;
}

#pragma mark=====打电话提示框方法========
- (void)showMobile:(NSString *)title{
    UIAlertController * alertViewController = [UIAlertController  alertControllerWithTitle:[NSString stringWithFormat:@"tel:%@",title] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"呼叫", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",title]]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [alertViewController addAction:certainAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
/**
 push到一个新的控制器
 
 @param vcName 新的控制器的名称
 */
-(void)pushToNextVcWithVcName:(NSString *)vcName{
    
    Class vc = NSClassFromString(vcName);
    if (!vc) { return; }
    [self.navigationController pushViewController:[vc new] animated:YES];
}

/**
 push到一个新的控制器
 
 @param vcName 新的控制器的名称
 @param dic 需要的参数
 */
-(void)pushToNextVcWithVcName:(NSString *)vcName params:(NSDictionary *)dic{
    
    Class vcClass = NSClassFromString(vcName);
    if (!vcClass) { return; }
    UIViewController *vc = [vcClass new];
    if (dic) {
        for (NSString *key in dic.allKeys) {
            id value = dic[key];
            [vc setValue:value forKey:key];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ======显示和隐藏没有数据的view=======
-(void)showEmptyViewWithImgName:(NSString *)imgName desStr:(NSString *)desStr btnTitle:(NSString *)btnTitle inView:(UIView *)view{
    if (imgName  && imgName.length>0)  self.emptyView.emptyImg = imgName;
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus ==NotReachable) {
        self.emptyView.desStr = NSLocalizedString(@"亲,您的网络貌似短路了哟!", nil);
        self.emptyView.emptyImg = @"404";
        btnTitle = NSLocalizedString(@"点击刷新", nil);
        
    }else if (desStr && desStr.length>0)  self.emptyView.desStr = desStr;//
    if (btnTitle  && btnTitle.length>0) {
        self.emptyView.is_showBtn=YES;
        self.emptyView.statusBtnTitle=btnTitle;
    }else  self.emptyView.is_showBtn=NO;
    [view addSubview:self.emptyView];
    [view bringSubviewToFront:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset=0;
        make.left.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
        make.centerX.offset=0;
        make.centerY.offset=0;
    }];
    
}
//-(void)showEmptyViewWithImgName:(NSString *)imgName desStr:(NSString *)desStr inView:(UIView *)view{
//
//    if (imgName  && imgName.length>0)  self.emptyView.emptyImg = imgName;
//
//    if ([JHShareModel shareModel].hostReach.currentReachabilityStatus == NotReachable) {
//        self.emptyView.desStr=@"亲,您的网络貌似短路了哟!";
//    }else if (desStr && desStr.length>0)  self.emptyView.desStr = desStr;
//
//    [view addSubview:self.emptyView];
//    self.emptyView.centerY=view.height/2.0;
//
//}

-(void)hiddenEmptyView{
    [self.emptyView removeFromSuperview];
    _emptyView=nil;
}
-(ShowEmptyDataView *)emptyView{
    if (_emptyView==nil) {
        __weak typeof(self) weakSelf=self;
        _emptyView=[[ShowEmptyDataView alloc] initWithFrame:weakSelf.view.frame];
        _emptyView.backgroundColor = BACK_COLOR;
        _emptyView.clickStatusBtn=^{
            [weakSelf clickStatusBtnAction];
        };
    }
    return _emptyView;
}

-(void)clickStatusBtnAction{
    
}

-(void)dealloc{
    NSLog(@" 我释放了%@",[self class]);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

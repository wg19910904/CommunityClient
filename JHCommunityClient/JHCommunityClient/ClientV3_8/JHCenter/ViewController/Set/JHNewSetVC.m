//
//  JHNewSetVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewSetVC.h"
#import "JHMyMessageVC.h"
#import "JHNewChangePhoneVC.h"
#import "JHNewChangePassWordVC.h"
#import "JHShareModel.h"
#import "SDImageCache.h"
 
#import "WXInfoModel.h"
#import "JHWXBindVC.h"
#import "WXApi.h"
#import "MemberInfoModel.h"
#import "MJRefresh.h"
#import "JHTempWebViewVC.h"
#import "SecurityCode.h"
#import "JHCodeVC.h"
#import "JHNewChangePassWordVC.h"
#import "JHNewForgetPasswordVC.h"
@interface JHNewSetVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titleArr;
    UITableView *_tableView;
    MJRefreshNormalHeader *_header;
    CGFloat _cacheSize;//缓存量
    BOOL _remoteNotificationType;//远程通知当前状态
    MemberInfoModel *_infoModel;
    JHShareModel * shareModel;
    WXInfoModel *_wxInfoModel;
    UIButton *_leaveBnt;
    NSMutableArray *desArr;
    SecurityCode *_control;
}

@end

@implementation JHNewSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self getCache];
    [self initData];
    [self createTableView];
   
 
}

-(void)initData{
     _control = [[SecurityCode alloc] init];
    _infoModel = [MemberInfoModel shareModel];
    _wxInfoModel = [WXInfoModel shareWXInfoModel];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWXLabel) name:@"wxbindsuccess" object:nil];
    NSString *wx = @"";//微信的状态
    NSString *phone = @"";
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"wxLabel"]){
        wx = [[NSUserDefaults standardUserDefaults] objectForKey:@"wxLabel"];
    }else{
        wx = @"未绑定";
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"phoneLabel"]){
        phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneLabel"];
    }else{
       
    }

    //左边
    titleArr = @[@[@{@"imageName":@"personal1",@"title":@"个人信息"},@{@"imageName":@"Page1",@"title":@"换绑手机"},@{@"imageName":@"Group 6",@"title":@"微信绑定"},@{@"imageName":@"lock1",@"title":@"修改密码"}],
                 
                 @[@{@"imageName":@"editor",@"title":@"意见反馈"},@{@"imageName":@"Group9",@"title":@"联系客服"}],
                 @[@{@"imageName":@"Group10",@"title":@"推送设置"},@{@"imageName":@"Group11",@"title":@"清楚缓存"},@{@"imageName":@"Group12",@"title":@"当前版本"}],
                 
                 @[@{@"imageName":@"Group13",@"title":@"关于我们"}] ,
                 @[@"退出登录"]
                 ];
    
  //描述信息
    desArr = [[NSMutableArray alloc]initWithArray: @[@[@{@"des":@""},@{@"des":phone},@{@"des":wx},@{@"des":@"修改"}],
                                                     @[@{@"des":@""},@{@"des":@""}],
                                                     @[@{@"des":@""},@{@"des":_cacheSize >= 1?[NSString stringWithFormat:@"%.2fM",_cacheSize]:[NSString stringWithFormat:@"%.2fK",_cacheSize*1024.0]},@{@"des":[NSString stringWithFormat:@"%@",[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]]}],
                                                     
                                                     @[@{@"des":@""}] ,
                                                     @[@"退出登录"]
                                                     ]];
    
  
    
}
#pragma mark======加载数据========
- (void)loadData{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/v3/member/member/info" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:desArr[0]];
             NSMutableArray *arr1 = [[NSMutableArray alloc]initWithArray:desArr[1]];
            [_infoModel setValuesForKeysWithDictionary:json[@"data"]];
           
            [arr1 replaceObjectAtIndex:1 withObject:@{@"des":json[@"data"][@"site_phone"]}];
            NSMutableString *str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"%@", nil),json[@"data"][@"mobile"]]];

            [str replaceCharactersInRange:NSMakeRange(str.length -8, 4) withString:@"****"];
            [arr replaceObjectAtIndex:1 withObject:@{@"des":str}];//手机号
            if([_wxInfoModel.wxtype isEqualToString:@"wxbind"]){
            [arr replaceObjectAtIndex:2 withObject:@{@"des":@"未绑定"}];
            }else if (_infoModel.wx_openid.length == 0){
                [arr replaceObjectAtIndex:2 withObject:@{@"des":@"未绑定"}];
            }else{
                [arr replaceObjectAtIndex:2 withObject:@{@"des":@"解绑"}];
            }
              [desArr replaceObjectAtIndex:0 withObject:arr];
            [desArr replaceObjectAtIndex:1 withObject:arr1];
            [_tableView.mj_header endRefreshing];
            [self createTableView];
            HIDE_HUD
            [UserDefaults setObject:arr[1][@"des"] forKey:@"wxLabel"];
            [UserDefaults setObject:arr[1][@"des"] forKey:@"phoneLabel"];

        }else{
            [_tableView.mj_header endRefreshing];
            [self createTableView];
            HIDE_HUD
            [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"数据更新失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        [self createTableView];
        [_tableView.mj_header endRefreshing];
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showMsg:error.localizedDescription];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _remoteNotificationType = [self pushNotificationsEnabled];
    NSArray *indexpath = @[[NSIndexPath indexPathForRow:1 inSection:0]];
    [_tableView reloadRowsAtIndexPaths:indexpath withRowAnimation: UITableViewRowAnimationNone];
     [self loadData];
}
#pragma mark===当前推送状态=====
- (BOOL)pushNotificationsEnabled {
    UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    return (types & UIUserNotificationTypeAlert);
}
#pragma mark=====获取缓存文件量========
- (void)getCache
{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSString *tempPath = NSTemporaryDirectory();
    NSLog(@"%@==%@",cachePath,tempPath);
    _cacheSize = [[SDImageCache sharedImageCache] getSize];
    _cacheSize = _cacheSize/1024.0/1024;
}
#pragma mark=======创建表视图=========
- (void)createTableView
{
    if(!_tableView){
    _tableView = [[UITableView alloc] initWithFrame:FRAME(0,NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = BACK_COLOR;
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [_tableView addSubview:thread];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                        action:@selector(showRegsterID)];
    tap.numberOfTapsRequired = 10;
    [_tableView addGestureRecognizer:tap];
    [self.view addSubview:_tableView];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
    _tableView.mj_header = _header;
    }else{
        [_tableView reloadData];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_infoModel) {
        [self hiddenEmptyView];
         return titleArr.count;
    }else{
        [self showEmptyViewWithImgName:@"" desStr:@"" btnTitle:@"" inView:tableView];
        return 0;
    }
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = titleArr[section];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == titleArr.count-1)
        return 30;
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != titleArr.count - 1) {
        NSArray *arr = titleArr[indexPath.section];
        NSArray *desA = desArr[indexPath.section];
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:FRAME(10, 9, 22, 22)];
        imgV.image = IMAGE(arr[indexPath.row][@"imageName"]);
        [cell.contentView addSubview:imgV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(40, 15, 200, 10)];
        label.text = arr[indexPath.row][@"title"];
        label.font = FONT(14);
        label.textColor = HEX(@"666666", 1.0f);
        [cell.contentView addSubview:label];
        
        UILabel * desL = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 150, 12.5, 120, 15)];
        desL.textColor = HEX(@"666666", 1.0f);
        desL.font = FONT(14);
        desL.text = desA[indexPath.row][@"des"];
        desL.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:desL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        _leaveBnt =[[UIButton alloc]init];
        _leaveBnt.frame = FRAME(0,0, WIDTH , 40);
        [_leaveBnt setTitle:NSLocalizedString(@"退出登录", nil) forState:UIControlStateNormal];
        [_leaveBnt setTitleColor:RED_COLOR forState:UIControlStateNormal];
        _leaveBnt.titleLabel.font = FONT(15);
        [_leaveBnt addTarget:self action:@selector(leaveBnt) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_leaveBnt];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                JHMyMessageVC *vc = [[JHMyMessageVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 1:{
                [self getsms];//获取验证码
            }
                break;
            case 2:{
                    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:desArr[0]];
                NSString *wx = arr[2][@"des"];
                
                if([wx isEqualToString:NSLocalizedString(@"未绑定", nil)]){
                    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"绑定微信", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"绑定微信喽!!!");
                        SendAuthReq *req = [[SendAuthReq alloc] init];
                        req.scope = @"snsapi_userinfo";
                        req.state = @"0744";
                        [WXApi sendReq:req];
                        [UserDefaults setBool:YES forKey:@"wxBangDing"];
                        
                    }];
                    [alertViewController addAction:cancelAction];
                    [alertViewController addAction:certainAction];
                    [self presentViewController:alertViewController animated:YES completion:nil];
                    
                }else{
                    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"确定要解除账号与微信的关联吗?", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"解绑喽!!!");
                        SHOW_HUD
                        [HttpTool postWithAPI:@"client/v3/member/member/nobindweixin" withParams:@{} success:^(id json) {
                            NSLog(@"json%@",json);
                            if([json[@"error"] isEqualToString:@"0"]){
                                [self showMsg:NSLocalizedString(@"微信解绑成功", nil)];
                                
                                [arr replaceObjectAtIndex:2 withObject:@{@"des":@"未绑定"}];
                                [desArr replaceObjectAtIndex:0 withObject:arr];
                                
                                NSArray *indexPath = @[[NSIndexPath indexPathForRow:2 inSection:0]];
                                [_tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
                                
                                HIDE_HUD
                            }else{
                                HIDE_HUD
                                [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"微信解绑失败,原因%@", nil),json[@"message"]]];
                            }
                            
                        } failure:^(NSError *error) {
                            HIDE_HUD
                            NSLog(@"error%@",error.localizedDescription);
                            [self showMsg:error.localizedDescription];
                        }];
                    }];
                    [alertViewController addAction:cancelAction];
                    [alertViewController addAction:certainAction];
                    [self presentViewController:alertViewController animated:YES completion:nil];
                }
              
            }
                
                break;
            case 3:{
                [self checkWay];
                
            }
                
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            JHTempWebViewVC *vc = [[JHTempWebViewVC alloc]init];
            vc.url = _infoModel.feedback_url;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self showMobile:_infoModel.site_phone];
            
        }
        
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                 [[UIApplication sharedApplication]openURL:url];
            }
            
        }else if(indexPath.row == 1){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"确定清除缓存?", nil) message:nil  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *deletAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self clearCache];
            }];
            [alertController addAction:deletAction];
            [alertController addAction:certainAction];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }else{
            
        }
    }else if(indexPath.section == 3){
        
        JHTempWebViewVC *vc = [[JHTempWebViewVC alloc]init];
        vc.url = _infoModel.about_url;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}
#pragma mark - 获取验证码
-(void)getsms{

    [[NSUserDefaults standardUserDefaults] setObject:_infoModel.mobile forKey:@"SECURITY_MOBILE"];
    [[NSUserDefaults standardUserDefaults] synchronize];

        NSDictionary *dic = @{@"mobile":_infoModel.mobile};
        [HttpTool postWithAPI:@"magic/sendsms" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            
            if ([json[@"error"] isEqualToString:@"0"]) {
                
                if ([json[@"data"][@"sms_code"] isEqualToString:@"1"]) {
                    //获取图形验证码
                    [HttpTool postWithAPI:@"magic/verify" withParams:dic success:^(id json) {
                        NSLog(@"%@",json);
                        if(json){
                            [_control showSecurityViewWithBlock:^(NSString *result, NSString *code) {
                                [_control removeFromSuperview];
                                if ([result isEqualToString:NSLocalizedString(@"正确", nil)]) {
                                    JHCodeVC *vc =[[JHCodeVC alloc]init];
                                    vc.fromVC = @"JHNewSetVC";
                                    vc.phoneS = _infoModel.mobile;
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }];
                            [_control refesh:json];
                            
                        }else{
                            [self showMsg:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                        }
                    } failure:^(NSError *error) {
                        [self showMsg:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                        NSLog(@"%@",error.localizedDescription);
                    }];
                }else{
                    JHCodeVC *vc =[[JHCodeVC alloc]init];
                    vc.fromVC = @"JHNewSetVC";
                    vc.phoneS = _infoModel.mobile;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                //获取图形验证码
            }else{
                [self  showMsg:json[@"message"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"error:%@",error.localizedDescription);
        }];
}
#pragma mark -改变微信绑定状态
-(void)changeWXLabel{
    [self loadData];
    
    
}
#pragma mark=========退出按钮点击事件=======
- (void)leaveBnt{
    
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"确认退出登录?", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
      
        
        NSLog(@"退出了");
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [JHShareModel shareModel].token = nil;
        [JHShareModel shareModel].communityModel = nil;
        [userDefaults removeObjectForKey:@"token"];
        [userDefaults removeObjectForKey:@"mobile"];
        [userDefaults removeObjectForKey:@"imageData"];
        [userDefaults removeObjectForKey:@"wxLabel"];
        [userDefaults removeObjectForKey:@"nameLabel"];
        [userDefaults removeObjectForKey:@"phoneLabel"];
        [userDefaults removeObjectForKey:@"cookie"];
        [HttpTool postWithAPI:@"client/passport/loginout"
                   withParams:@{}
                      success:^(id json) {} failure:^(NSError *error) {}];
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        
    }];
    [alertViewController addAction:cancelAction];
    [alertViewController addAction:certainAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
    
}
-(void)checkWay{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消了");
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"通过旧密码", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JHNewChangePassWordVC *vc = [[JHNewChangePassWordVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"通过手机验证", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JHNewForgetPasswordVC *vc = [[JHNewForgetPasswordVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark=======清空缓存的方法==========
- (void)clearCache
{
    SHOW_HUD
    //    [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cookie"];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSString *tempPath = NSTemporaryDirectory();
    [fileManger removeItemAtPath:cachePath error:nil];
    [fileManger removeItemAtPath:tempPath error:nil];
    _cacheSize = [[SDImageCache sharedImageCache] getSize];
    NSString *cacheText = _cacheSize >= 1?[NSString stringWithFormat:@"%.2fM",_cacheSize]:[NSString stringWithFormat:@"%.2fK",_cacheSize*1024.0];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:desArr[2]];
    [arr replaceObjectAtIndex:1 withObject:@{@"des":cacheText}];
    [desArr replaceObjectAtIndex:2 withObject:arr];
    NSArray *indexPath = @[[NSIndexPath indexPathForRow:1 inSection:2]];
    [_tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
    HIDE_HUD;
    [self showMsg:@"缓存已清空"];
}
#pragma mark - 展示regsterID
- (void)showRegsterID
{
    NSString *regID =  [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
    CopyString(regID?regID:@"")
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:@"RegsterID"
                                                                                  message:regID
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了(已复制到剪贴板)", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)showAlertView:(NSString *)title{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
@end

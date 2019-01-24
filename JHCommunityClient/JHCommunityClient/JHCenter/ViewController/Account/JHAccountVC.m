//
//  AccountVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAccountVC.h"
#import "MyTapGesture.h"
#import "JHChangeNameVC.h"
#import "JHChangePhoneVC.h"
#import "JHChangePasswordVC.h"
#import "AppDelegate.h"
#import "MemberInfoModel.h"
 
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
#import "WXInfoModel.h"
#import "JHWXBindVC.h"
#import "WXApi.h"
#import "JPUSHService.h"
#import "MJRefresh.h"
#import "JHShareModel.h"
@interface JHAccountVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    MJRefreshNormalHeader *_header;
    UIImageView *_iconImg;//头像
    UILabel *_nameLabel;//用户名
    UILabel *_phoneLabel;//手机
    UILabel *_weixinLabel;//微信
    UILabel *_passwordLabel;//密码
    UIImagePickerController *_imagePicker;
    MemberInfoModel *_infoModel;
    WXInfoModel *_wxInfoModel;
    UIButton *_leaveBnt;
    UIImage *_img;
    BOOL _isFirst;
    
}
@end

@implementation JHAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    self.title = NSLocalizedString(@"账户信息", nil);
    [self loadData];
    [self initSubViews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark=====处理控件====
- (void)initSubViews{
    _wxInfoModel = [WXInfoModel shareWXInfoModel];
    _infoModel = [MemberInfoModel shareModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelChangeNameTap) name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWXLabel) name:@"wxbindsuccess" object:nil];
    _iconImg = [[UIImageView alloc] init];
    _iconImg.frame = FRAME(WIDTH - 45, 7.5, 35, 35);
    _iconImg.layer.cornerRadius = _iconImg.frame.size.height/2;
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg.clipsToBounds = YES;
    _nameLabel = [[UILabel alloc] init];
    _phoneLabel = [[UILabel alloc] init];
    _weixinLabel = [[UILabel alloc] init];
    _passwordLabel = [[UILabel alloc] init];
    _imagePicker = [[UIImagePickerController alloc] init];
    _leaveBnt = [UIButton buttonWithType:UIButtonTypeCustom];
}
#pragma mark--==处理数据
- (void)handleData{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"phoneLabel"]){
        _phoneLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneLabel"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"wxLabel"]){
        _weixinLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"wxLabel"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]){
        _nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"imageData"]){
        _iconImg.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageData"]];
    }
}
#pragma mark======加载数据========
- (void)loadData{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/member/info" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:json[@"data"][@"face"]]];
            [_iconImg sd_image:url plimage:IMAGE(@"loginheader")];
            [_infoModel setValuesForKeysWithDictionary:json[@"data"]];
            _nameLabel.text = _infoModel.nickname;
            _img = _iconImg.image;

            NSMutableString *str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"%@ 更换", nil),_infoModel.mobile]];

            [str replaceCharactersInRange:NSMakeRange(str.length -11, 4) withString:@"****"];
            _phoneLabel.text = str;
            if([_wxInfoModel.wxtype isEqualToString:@"wxbind"]){
                _weixinLabel.text = NSLocalizedString(@"未绑定", nil);
            }else if (_infoModel.wx_openid.length == 0){
                _weixinLabel.text = NSLocalizedString(@"未绑定", nil);
            }else{
                _weixinLabel.text = NSLocalizedString(@"解绑", nil);
            }
            [_tableView.mj_header endRefreshing];
            [self createTableView];
            HIDE_HUD
            [UserDefaults setObject:_weixinLabel.text forKey:@"wxLabel"];
            [UserDefaults setObject:_nameLabel.text forKey:@"nameLabel"];
            [UserDefaults setObject:_phoneLabel.text forKey:@"phoneLabel"];
            NSData * data = UIImagePNGRepresentation(_img);
            [UserDefaults setObject:data forKey:@"imageData"];
        }else{
            [_tableView.mj_header endRefreshing];
            [self createTableView];
            [self handleData];
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据更新失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        [self createTableView];
        [self handleData];
        [_tableView.mj_header endRefreshing];
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}

#pragma mark===创建表视图====
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+10, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = BACK_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [_tableView addSubview:thread];
    }else{
        [_tableView reloadData];
    }
}

#pragma mark=====UITableViewDelegate========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 4;
    }else{
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 10;
    }else if (section == 1){
        return 60;
    }else{
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return 50;
        }else{
            return 40;
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            return  30;
        }else{
            return 40;
        }
    }else{
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *title = [[UILabel alloc] initWithFrame:FRAME(10, 20, 60, 10)];
                title.text = NSLocalizedString(@"头像", nil);
                title.font = FONT(14);
                title.textColor = HEX(@"333333", 1.0f);
                title.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:title];
                [cell.contentView addSubview:_iconImg];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                return cell;
            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *title = [[UILabel alloc] init];
                title.frame = FRAME(10, 15, 60, 10);
                title.text = NSLocalizedString(@"用户名", nil);
                title.font = FONT(14);
                title.textColor = HEX(@"333333", 1.0f);
                title.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:title];
                _nameLabel.frame = FRAME(WIDTH - 230, 12.5, 200, 15);
                _nameLabel.font = FONT(14);
                _nameLabel.textAlignment = NSTextAlignmentRight;
                _nameLabel.textColor = HEX(@"999999", 1.0f);
                [cell.contentView addSubview:_nameLabel];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                UIImageView *imge = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 18, 14, 8, 12)];
                imge.image = IMAGE(@"jiantou_1");
                [cell.contentView addSubview:imge];
                return cell;
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                 UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *title = [[UILabel alloc] init];
                title.frame = FRAME(10,7.5, 60, 15);
                title.text = NSLocalizedString(@"账户设置", nil);
                title.font = FONT(12);
                title.textColor = HEX(@"333333", 1.0f);
                title.textAlignment = NSTextAlignmentLeft;
                title.textColor = HEX(@"666666", 1.0f);
                [cell.contentView addSubview:title];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 29.5, WIDTH, 0.5)];
                thread1.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread1];
                UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
                thread2.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread2];
                return cell;

            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *title = [[UILabel alloc] init];
                title.frame = FRAME(30, 15, 60, 10);
                title.text = NSLocalizedString(@"手机", nil);
                title.font = FONT(14);
                title.textColor = HEX(@"333333", 1.0f);
                title.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:title];
                _phoneLabel.frame = FRAME(WIDTH - 180, 15, 155, 10);
                _phoneLabel.font = FONT(14);
                _phoneLabel.textAlignment = NSTextAlignmentRight;
                _phoneLabel.textColor = HEX(@"999999", 1.0f);
                [cell.contentView addSubview:_phoneLabel];
                UIImageView *img = [[UIImageView alloc] init];
                img.frame = FRAME(10, 12.5, 10, 15);
                img.image = IMAGE(@"shouji");
                [cell.contentView addSubview:img];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                UIImageView *imge = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 18, 14, 8, 12)];
                imge.image = IMAGE(@"jiantou_1");
                [cell.contentView addSubview:imge];
                return cell;

            }
                break;
            case 2:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *title = [[UILabel alloc] init];
                title.frame = FRAME(30, 15, 60, 10);
                title.text = NSLocalizedString(@"微信", nil);
                title.font = FONT(14);
                title.textColor = HEX(@"333333", 1.0f);
                title.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:title];
                UIImageView *img = [[UIImageView alloc] init];
                img.frame = FRAME(7.5, 12.5, 15, 15);
                img.image = IMAGE(@"weiixn");
                [cell.contentView addSubview:img];
                _weixinLabel.frame =  FRAME(WIDTH - 85, 15, 60, 10);
                _weixinLabel.font = FONT(14);
                _weixinLabel.textAlignment = NSTextAlignmentRight;
                _weixinLabel.textColor = HEX(@"999999", 1.0f);
                [cell.contentView addSubview:_weixinLabel];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                UIImageView *imge = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 18, 14, 8, 12)];
                imge.image = IMAGE(@"jiantou_1");
                [cell.contentView addSubview:imge];
                return cell;
            }
                break;
            case 3:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *title = [[UILabel alloc] init];
                title.frame = FRAME(30, 15, 60, 10);
                title.text = NSLocalizedString(@"密码", nil);
                title.font = FONT(14);
                title.textColor = HEX(@"333333", 1.0f);
                title.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:title];
                UIImageView *img = [[UIImageView alloc] init];
                img.frame = FRAME(10, 12.5, 12.5, 15);
                img.image = IMAGE(@"mima");
                [cell.contentView addSubview:img];
                _passwordLabel.frame = FRAME(WIDTH - 70, 15, 40, 10);
                _passwordLabel.font = FONT(14);
                _passwordLabel.textAlignment = NSTextAlignmentRight;
                _passwordLabel.textColor = HEX(@"999999", 1.0f);
                _passwordLabel.text = NSLocalizedString(@"修改", nil);
                [cell.contentView addSubview:_passwordLabel];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                UIImageView *imge = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 18, 14, 8, 12)];
                imge.image = IMAGE(@"jiantou_1");
                [cell.contentView addSubview:imge];
                return cell;
            }
                break;
            default:
                break;
        }
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        _leaveBnt.frame = FRAME(10,0, WIDTH - 20, 40);
        [_leaveBnt setTitle:NSLocalizedString(@"退出登录", nil) forState:UIControlStateNormal];
        [_leaveBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leaveBnt.layer.cornerRadius = 4.0f;
        _leaveBnt.clipsToBounds = YES;
        _leaveBnt.titleLabel.font = FONT(14);
        [_leaveBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [_leaveBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
        [_leaveBnt addTarget:self action:@selector(leaveBnt) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_leaveBnt];
        cell.backgroundColor = HEX(@"fafafa", 0.4f);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return  nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"取消了");
                }];
                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self imageFromCamera];
                }];
                UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从手机相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self imageFromAlbum];
                }];
                [alertController addAction:deleteAction];
                [alertController addAction:archiveAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case 1:
            {
                if(_isFirst){
                    
                }else{
                    JHChangeNameVC *changeName = [[JHChangeNameVC alloc] init];
                    changeName.nick_name = _nameLabel.text;
                    [self.navigationController pushViewController:changeName animated:YES];
                }
                
            }
                break;
            default:
                break;
        }
        
    }
    else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                JHChangePhoneVC *changePhone = [[JHChangePhoneVC alloc] init];
                changePhone.phone = [JHShareModel shareModel].phone;
                [changePhone setMyBlock:^(NSString * mobile) {
                    [JHShareModel shareModel].phone = mobile;
                    NSMutableString *str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"%@ 更换", nil),mobile]];


                    [str replaceCharactersInRange:NSMakeRange(str.length-11, 4) withString:@"****"];
                    _phoneLabel.text = str;
                }];
                [self.navigationController pushViewController:changePhone animated:YES];
            }
                break;
            case 2:
            {
                if([_weixinLabel.text isEqualToString:NSLocalizedString(@"未绑定", nil)]){
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
                        [HttpTool postWithAPI:@"client/member/nobindweixin" withParams:@{} success:^(id json) {
                            NSLog(@"json%@",json);
                            if([json[@"error"] isEqualToString:@"0"]){
                                [self showAlertView:NSLocalizedString(@"微信解绑成功", nil)];
                                _weixinLabel.text = NSLocalizedString(@"未绑定", nil);
                                HIDE_HUD
                            }else{
                                HIDE_HUD
                                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"微信解绑失败,原因%@", nil),json[@"message"]]];
                            }
                        } failure:^(NSError *error) {
                            HIDE_HUD
                            NSLog(@"error%@",error.localizedDescription);
                            [self showAlertView:error.localizedDescription];
                        }];
                    }];
                    [alertViewController addAction:cancelAction];
                    [alertViewController addAction:certainAction];
                    [self presentViewController:alertViewController animated:YES completion:nil];
                }

            }
                break;
            case 3:
            {
                JHChangePasswordVC *changPassword = [[JHChangePasswordVC alloc] init];
                [self.navigationController pushViewController:changPassword animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        
    }

}

#pragma mark-======修改昵称手势取消========
- (void)cancelChangeNameTap{
    _isFirst = YES;
    [self loadData];
}
#pragma mark====改变微信字段=======
- (void)changeWXLabel{
    [self loadData];
}
#pragma mark=========退出按钮点击事件=======
- (void)leaveBnt{
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
//     NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    for (int i = 0 ; i < cookies.count; i ++){
//        NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//    }
    [HttpTool postWithAPI:@"client/passport/loginout"
               withParams:@{}
                  success:^(id json) {} failure:^(NSError *error) {}];
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];

}

#pragma mark=========相册中选择=========
- (void)imageFromAlbum{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.navigationBar.barTintColor = THEME_COLOR;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma mark=========打开相机=========
- (void)imageFromCamera{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma  mark - 这是UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"哈哈");
}
#pragma  mark=======选择照片================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.allowsEditing) {
        _img = [info objectForKey:UIImagePickerControllerEditedImage];
        
    }else{
        _img = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    _img = [self scaleFromImage:_img scaledToSize:CGSizeMake(180, 180)];
    NSData * data = UIImagePNGRepresentation(_img);
    NSDictionary * dic = @{@"face":data};
    [HttpTool postWithAPI:@"client/member/updateface" params:@{} dataDic:dic success:^(id json) {
        NSLog(@"json%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            _iconImg.image = _img;
            NSArray *indeth = @[[NSIndexPath indexPathForRow:0 inSection:0]];
            [_tableView reloadRowsAtIndexPaths:indeth withRowAnimation: UITableViewRowAnimationNone];
            [self showAlertView:NSLocalizedString(@"上传头像成功", nil)];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"imageData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"上传头像失败,原因:%@", nil),json[@"message"]]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片
- (UIImage*)scaleFromImage:(UIImage*)img scaledToSize:(CGSize)newSize{
    CGSize imageSize = img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= newSize.width && height <= newSize.height){
        return img;
    }
    if (width == 0 || height == 0){
        return img;
    }
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    [img drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark===============点击取消调用========
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)showAlertView:(NSString *)title{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxbindsuccess" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

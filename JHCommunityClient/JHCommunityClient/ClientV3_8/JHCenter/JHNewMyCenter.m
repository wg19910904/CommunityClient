//
//  JHNewMyCenter.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/15.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewMyCenter.h"
#import "JHLoginVC.h"
#import "JHAccountVC.h"
#import "JHIntegrationVC.h"
#import "JHRedPacket.h"
#import "JHIntegralMallVC.h"
#import "JHMessageVC.h"
#import "JHMyCollectVC.h"
#import "JHCooperateVC.h"
#import "NSObject+CGSize.h"
#import "JHLoginVC.h"
#import "MBProgressHUD.h"
#import "UIImageView+NetStatus.h"
#import "MemberInfoModel.h"
#import "JHComplainVC.h"
#import "JHPersonEvaluationVC.h"
#import "JHShopEvaluationVC.h"
#import "JHOrderForCenter.h"
#import "JudgeToken.h"
#import "JHShareModel.h"
#import "UINavigationBar+Awesome.h"
#import "JHTempWebViewVC.h"
#import "JHSeatAndNumberListVC.h"
#import <UIImageView+WebCache.h>
#import "JHNewMyCenterOneCell.h"
#import "JHNewMyCenterTwoCell.h"
#import "JHNewMyCenterThreeCell.h"
#import "JHNewBalanceVC.h"
#import "JHTempAdvModel.h"
#import "JHMaidanOrderList.h"
#import "JHMyMessageVC.h"
#import "JHWaiMaiAddressVC.h"
#import "JHNewSetVC.h"
#import "JHTempJumpWithRouteModel.h"
@interface JHNewMyCenter ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;//表视图
    NSMutableArray *_dataArray;//数据源
    UIImageView *headIV;//表头
    UIView *_backView0;
    UIView *_backView1;
    UILabel *_messageNumberLabel;
    NSString *_token;//用于判断是否登录
    UIImageView *_icon;//登录头像
    UILabel *_loginLabel;//登录标签
    UIImageView *_headBottomImg;//下面的白的部分
    MemberInfoModel *_infoModel;
    BOOL _isNotReachable;//没有网络连接
    UIImage *_image;
    UIImageView *directionImg;
    UIBarButtonItem *itemRight2;
    UILabel *_numberLabel;
    NSMutableArray *orderArr;
//    UIView *headView;
}

@end

@implementation JHNewMyCenter

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
//        [self.navigationController.navigationBar yf_setBackgroundColor:THEME_COLOR_Alpha(0)];
      [self.navigationController.navigationBar setBackgroundImage:IMAGE(@"barBackImageRed") forBarMetrics:UIBarMetricsDefault];
    [self initData];
    [self creatItem];
    
    _messageNumberLabel = [[UILabel alloc] init];
    _image = IMAGE(@"loginheader");
    self.navigationItem.title = @"";
    [self creatTableview];
}
-(void)initData{
    orderArr = @[].mutableCopy;
   
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];//barBackImage
     [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:IMAGE(@"barBackImageRed") forBarMetrics:UIBarMetricsDefault];
   _infoModel = [MemberInfoModel new];
    _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if(_token)
    {
        NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
        _loginLabel.text = [NSString stringWithFormat:@"%@",nickName];
        [self loadData];
        //获取token
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults objectForKey:@"token"];
        [JHShareModel shareModel].token = token;
        
    }
    else
    {
         [self loadData];
        _icon.image = _image;
        _loginLabel.text = NSLocalizedString(@"登录/注册", nil);
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//创建左边和右边的按钮
-(void)creatItem{
    //设置
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *itemLeft =[[UIBarButtonItem alloc]initWithImage:IMAGE(@"Set up") style:UIBarButtonItemStylePlain target:self action:@selector(clickSet)];
    self.navigationItem.leftBarButtonItem = itemLeft;

    //消息按钮
    UIImage *cartImage = [[UIImage imageNamed:@"mailbox"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cartButton.frame = CGRectMake(0.0f, 0.0f, 44, 44);
    cartButton.backgroundColor = [UIColor clearColor];
    [cartButton setImage:cartImage forState:UIControlStateNormal];
    [cartButton addTarget:self action:@selector(clickNews:) forControlEvents:UIControlEventTouchUpInside];
    [cartButton addSubview:self.numberLabel];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cartButton];
    
//签到
    UIButton *itemRight3 = [UIButton buttonWithType:UIButtonTypeCustom];
    //修改按钮向右偏移10 point
    [itemRight3 setFrame:CGRectMake(10.0, 0.0, 44.0, 44.0)];
    [itemRight3 addTarget:self action:@selector(clickqiandao) forControlEvents:UIControlEventTouchUpInside];
    [itemRight3 setImage:[UIImage imageNamed:@"Sign in"] forState:UIControlStateNormal];
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:itemRight3];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,rightItem];
    
}
-(UILabel *)numberLabel
{
    if (!_numberLabel) {
       _numberLabel = [UILabel new];
        _numberLabel.hidden = YES;
        _numberLabel.frame = CGRectMake(30, 6, 16, 16);
        _numberLabel.backgroundColor = [UIColor redColor];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:9];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.layer.cornerRadius = 14* 0.5;
        _numberLabel.layer.masksToBounds = YES;
    }
    return _numberLabel;
}

#pragma mark - 点击设置
-(void)clickSet{
    if (!_token) {
        [self showAlertView:NSLocalizedString(@"您还未登录,请先登录", nil)];
        return;
    }
    JHNewSetVC *vc = [[JHNewSetVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 点击消息
-(void)clickNews:(UIButton *)sender{
    if (!_token) {
        [self showAlertView:NSLocalizedString(@"您还未登录,请先登录", nil)];
        return;
    }
    JHMessageVC *vc = [[JHMessageVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark - 点击签到
-(void)clickqiandao{
    if (!_token) {
        [self showAlertView:NSLocalizedString(@"您还未登录,请先登录", nil)];
        return;
    }
    JHTempWebViewVC *vc = [[JHTempWebViewVC alloc]init];
    vc.url = _infoModel.qiandao_url;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:IMAGE(@"barBackImage") forBarMetrics:UIBarMetricsDefault];
    [self refreshHeader];
    HIDE_HUD;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    for (UIImageView *imageV in self.navigationController.navigationBar.subviews) {
        if ([NSStringFromClass([imageV class]) isEqualToString:@"_UIBarBackground"]) {
            imageV.alpha = 0;
            
        }}
}
#pragma mark========更新数据=======
- (void)creatTableview
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 49) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = BACK_COLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
        //        _tableView.contentOffset = CGPointMake(0, -120);
        [self addCustomheader];
        //添加自定义表头
    }
    else
    {
        [_tableView reloadData];
    }
   
}
#pragma mark=======加载数据==========
- (void)loadData
{
    HIDE_HUD
    SHOW_HUD
    NSDictionary *dic = [[NSDictionary alloc] init];
    [HttpTool postWithAPI:@"client/v3/member/member/info" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        HIDE_HUD
        if([json[@"error"] isEqualToString:@"0"])
        {
            
            [_infoModel setValuesForKeysWithDictionary:json[@"data"]];
            NSString *nickName = _infoModel.nickname.length>0?_infoModel.nickname:@"登录/注册";
//            NSString *phone = _infoModel.mobile;
            _loginLabel.text = [NSString stringWithFormat:@"%@",nickName];
            NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_infoModel.face.length>0?_infoModel.face:@""]];
            [_icon sd_image:url plimage:_image];
            
            NSData * data = UIImagePNGRepresentation(_icon.image);
            [UserDefaults setObject:data forKey:@"imageData"];
            [[NSUserDefaults standardUserDefaults] setObject:_infoModel.mobile forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"nickname"] forKey:@"nickName"];//imageData

            [[NSUserDefaults standardUserDefaults] synchronize];
            [orderArr removeAllObjects];
            for (NSDictionary *dic in _infoModel.order_group) {
                JHTempAdvModel *model = [[JHTempAdvModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [orderArr addObject:model];
            }
            [self creatTableview];
            if ([_infoModel.msg_new_count integerValue] > 0) {
                _numberLabel.text = [_infoModel.msg_new_count integerValue] > 99?@"99+":_infoModel.msg_new_count;
                _numberLabel.adjustsFontSizeToFitWidth = YES;
                _numberLabel.hidden = NO;
            }else{
                _numberLabel.hidden = YES;
            }
        }else if([json[@"error"] integerValue] == 101){
            [self showAlert:NSLocalizedString(@"身份已过期,请重新登录", nil)];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
            [JHShareModel shareModel].token = nil;
        }else{
            [self showAlert:[NSString stringWithFormat:NSLocalizedString(@"数据更新失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.localizedDescription);
        HIDE_HUD
        [self showAlert:error.localizedDescription];
    }];
}
-(void)refreshHeader{
    headIV.frame =FRAME(0, 0, WIDTH, 180);
    directionImg.frame = FRAME(WIDTH - 30, 112, 7, 12);
    for (UIImageView *imageV in self.navigationController.navigationBar.subviews) {
        if ([NSStringFromClass([imageV class]) isEqualToString:@"_UIBarBackground"]) {
            imageV.alpha = 0;
            
        }}

    [_tableView setContentOffset:CGPointMake(0, -180) animated:NO];
}
- (void)addCustomheader
{

    headIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, WIDTH, 180)];
    headIV.image = IMAGE(@"NewCenterHeaderImg");
    headIV.userInteractionEnabled = YES;
    headIV.backgroundColor = [UIColor whiteColor];
    headIV.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [headIV addGestureRecognizer:tap];
    
    _headBottomImg = [[UIImageView alloc]init];
    [headIV addSubview:_headBottomImg];
    [_headBottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.bottom.offset = 1;
        make.height.offset = 80;
    }];
    _headBottomImg.image = IMAGE(@"NewCenterHeaderImgWhite");
    _icon = [[UIImageView alloc] init];
    [headIV addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset =-50;
        make.centerX.offset = 0;
        make.width.height.offset = 50;
    }];
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    _icon.layer.cornerRadius = 25;
    _icon.layer.masksToBounds = YES;
    _icon.clipsToBounds = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"imageData"])
    {
        _icon.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageData"]];
    }
    else
    {
        _icon.image = _image;
    }
   
    _loginLabel = [[UILabel alloc] init];
    [headIV addSubview:_loginLabel];
    [_loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_icon.mas_bottom).offset = 5;
        make.centerX.offset = 0;
        make.width.offset = 180;
        make.height.offset = 20;
    }];
    _loginLabel.textAlignment = NSTextAlignmentCenter;
    _loginLabel.textColor = HEX(@"333333", 1);
    _loginLabel.font = FONT(17);
    [self.view addSubview:headIV];
    [self.view addSubview:headIV];
     headIV.clipsToBounds = YES;
    
}
#pragma mark======登录栏点击事件=========
- (void)tap
{
    if(_token)
    {
        JHMyMessageVC *accountVC = [[JHMyMessageVC alloc] init];
        accountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountVC animated:YES];
    }else{
        JHLoginVC *login = [[JHLoginVC alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}
#pragma mark - 列表的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2+_infoModel.function_group.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1)
        return 1;
    else{
        for (int i =0; i<_infoModel.function_group.count; i++) {
            if (section == 2+i) {
                NSArray *arr =_infoModel.function_group[i];
                return arr.count;
            }
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [JHNewMyCenterOneCell getHeight:nil];
    }else if(indexPath.section == 1){
        return [JHNewMyCenterTwoCell getHeight:orderArr];
    }else
    return [JHNewMyCenterThreeCell getHeight:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0 && section != 1) {
        for (int i =0; i<_infoModel.function_group.count; i++) {
            if (section == 3+i) {
                return 12;
            }
        }
        
    }else{
        return 0.01;
    }
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf =self;
    if (indexPath.section == 0) {
         NSString *str = [JHNewMyCenterOneCell getIdentifier];
        JHNewMyCenterOneCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHNewMyCenterOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.model= _infoModel;
        
        cell.clickBlock = ^(NSInteger tag) {
            [weakSelf clickOneCell:tag];
        };
        return cell;
    }else if(indexPath.section == 1){
        NSString *str = [JHNewMyCenterTwoCell getIdentifier];
        JHNewMyCenterTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHNewMyCenterTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
            cell.array =orderArr;
        
        cell.myBlock = ^(NSInteger tag) {
            [weakSelf clickTwoCell:tag];
        };
        return cell;
    }else{
        NSString *str = [JHNewMyCenterThreeCell getIdentifier];
        JHNewMyCenterThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHNewMyCenterThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        NSArray * arr =_infoModel.function_group[indexPath.section - 2];
        cell.dic  = arr[indexPath.row];
        return cell;
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_token) {
        [self showAlertView:NSLocalizedString(@"您还未登录,请先登录", nil)];
        return;
    }
    if (indexPath.section != 0&& indexPath.section !=1 ) {
        JHBaseVC *vc;
        NSArray *arr = _infoModel.function_group[indexPath.section-2];
        vc = [JHTempJumpWithRouteModel jumpWithLink:arr[indexPath.row][@"url"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 点击余额,优惠劵等
-(void)clickOneCell:(NSInteger)tag{
    if (!_token) {
        [self showAlertView:NSLocalizedString(@"您还未登录,请先登录", nil)];
        return;
    }
    JHTempWebViewVC *vc = [[JHTempWebViewVC alloc]init];
    if (tag == 0){
        JHNewBalanceVC *vc = [[JHNewBalanceVC alloc]init];
         vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if(tag == 1){
        vc.url = _infoModel.quan_url;
    }else if(tag == 2){
        vc.url = _infoModel.youhui_url;
    }else if(tag == 3){
        vc.url = _infoModel.jifen_url;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击定单分类
-(void)clickTwoCell:(NSInteger)tag{
    if (!_token) {
        [self showAlertView:NSLocalizedString(@"您还未登录,请先登录", nil)];
        return;
    }
    JHBaseVC *vc;
    JHTempAdvModel *model =orderArr[tag];
    vc = [JHTempJumpWithRouteModel jumpWithLink:model.url];
    [self.navigationController pushViewController:vc animated:YES];    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
//    NSLog(@"%f",offset);
    if (scrollView.contentOffset.y <= -180) {
        //往下拖动时
        CGFloat iv_h = - scrollView.contentOffset.y;
        //动态改变headerIV
        headIV.frame = FRAME(0, 0, WIDTH, iv_h);
    }
    else{
        CGFloat offset_y = scrollView.contentOffset.y + 180;

        headIV.frame = FRAME(0, -offset_y, WIDTH, 180);
    }
    
    float a = 1- (-offset -60)/140.0;
    NSLog(@"%f",a);
        for (UIImageView *imageV in self.navigationController.navigationBar.subviews) {
            if ([NSStringFromClass([imageV class]) isEqualToString:@"_UIBarBackground"]) {
                if (a>=0&& a<1) {
                imageV.alpha = a;
                }else if(a<0)
                    imageV.alpha= 0;
                else
                    imageV.alpha = 1;
            }}
}
- (void)showAlert:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([title isEqualToString:NSLocalizedString(@"身份已过期,请重新登录", nil)]) {
            JHLoginVC *loginVC = [[JHLoginVC alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"去登录", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JHLoginVC *loginVC = [[JHLoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
    [alertController addAction:loginAction];
    [self  presentViewController:alertController animated:YES completion:nil];
    
}

@end

//
//  JHHouseDetailVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//维修师傅详情

#import "JHMaintainDetailVC.h"
#import "StarView.h"
#import "NSObject+CGSize.h"
#import "JHMaintainSeriverKindCell.h"
#import "JHMaintainEvaluationVC.h"
#import "JHMaintainOrderVC.h"
 
#import "MBProgressHUD.h"
#import "MaintainCommentModel.h"
#import "MaintainSeriverKindModel.h"
#import "MaintainDetailModel.h"
#import "UIImageView+NetStatus.h"
#import "GaoDe_Convert_BaiDu.h"
#import "ZQShareView.h"

@interface JHMaintainDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_detailBackView;
    UIImageView *_iconImg;
    UILabel *_nameLabel;
    UILabel *_ageLabel;
    UILabel *_servierLabel;
    UILabel *_verifyLabel;
    UIImageView *_verifyImg;
    UILabel *_distanLabel;
    UIView *_starView;
    UIButton *_lastBnt;
    UITableView *_seriverTableView;
    UILabel *_introduceLabel;
    UIView *_introduceView;
    JHMaintainEvaluationVC *_evaluationVc;
    NSMutableArray *_servierTableViewArray;
    MaintainDetailModel *_detailModel;
    NSDictionary *_countDic;
    NSMutableDictionary *_dic;
}
@property(nonatomic,strong)ZQShareView *shareView;
@end

@implementation JHMaintainDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
    self.view.backgroundColor = BACK_COLOR;
    _dic = [NSMutableDictionary dictionary];
    _servierTableViewArray = [NSMutableArray array];
    _countDic = [NSDictionary dictionary];
    _detailModel = [[MaintainDetailModel alloc] init];
    _evaluationVc = [[JHMaintainEvaluationVC alloc] init];
    _detailBackView = [UIView new];
    [self.view addSubview:_detailBackView];
    _iconImg = [UIImageView new];
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg.clipsToBounds = YES;
    _iconImg.image = IMAGE(@"touxiang");
    [_detailBackView addSubview:_iconImg];
    _nameLabel = [UILabel new];
    [_detailBackView addSubview:_nameLabel];
    _ageLabel = [UILabel new];
    [_detailBackView addSubview:_ageLabel];
    _servierLabel = [UILabel new];
    [_detailBackView addSubview:_servierLabel];
    _distanLabel = [UILabel new];
    [_detailBackView addSubview:_distanLabel];
    _verifyLabel = [UILabel new];
    [_detailBackView addSubview:_verifyLabel];
    _verifyImg = [UIImageView new];
    [_detailBackView addSubview:_verifyImg];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 69.5, WIDTH, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [_detailBackView addSubview:thread];
    [self createayiDeatil];
    [self createSelectBnt];
    [self createSeriverKind];
    [self createIntroduce];
    [self requestData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItems = nil;
    [self addShareButton];
}
- (void)addShareButton{
    [self.shareView addShareBntAndCollectionBntWithVC:self withId:self.staff_id type:@"2"];
}
#pragma mark======加载网络数据=========
- (void)requestData
{
    SHOW_HUD
    NSString *lat = nil;
    NSString *lng = nil;
    float lat_gaode = [XHMapKitManager shareManager].lat;
    float lng_gaode = [XHMapKitManager shareManager].lng;
    double baiduLat = 0.0;
    double baiduLng = 0.0;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:lat_gaode WithGD_lon:lng_gaode WithBD_lat:&baiduLat  WithBD_lon:&baiduLng];
    lat = [NSString stringWithFormat:@"%f",baiduLat];
    lng = [NSString stringWithFormat:@"%f",baiduLng];
    NSDictionary *dic = @{@"staff_id":self.staff_id,@"lat":lat,@"lng":lng};
    _dic  = [dic mutableCopy];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if(uid.length == 0)
    {
        [_dic setObject:@"" forKey:@"uid"];
    }
    else
    {
        [_dic setObject:uid forKey:@"uid"];
    }
    [HttpTool postWithAPI:@"client/weixiu/staffdetail" withParams:_dic success:^(id json) {
        NSLog(@"json%@=====message%@",json,json[@"message"]);
        if([json[@"error"] isEqualToString:@"0"])
        {
            self.shareView.shareDic = json[@"data"][@"share"];
            NSArray *attr = json[@"data"][@"attr"];
            for(NSDictionary *dic in attr)
            {
                MaintainSeriverKindModel *model = [[MaintainSeriverKindModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_servierTableViewArray addObject:model];
            }
            NSDictionary *detailDic = json[@"data"][@"detail"];
            [_detailModel setValuesForKeysWithDictionary:detailDic];
            _countDic = json[@"data"][@"count"];
            _evaluationVc.countDic = _countDic;
            _evaluationVc.staff_id = _detailModel.staff_id;
            NSLog(@"%@==%@",_countDic,_evaluationVc.countDic);
            [self createayiDeatil];
            [self createSeriverKind];
            [self createIntroduce];
             HIDE_HUD
        }else{
             HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"数据加载失败,原因:", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}
#pragma mark=====搭建UI界面==========
- (void)createayiDeatil
{
    _detailBackView.frame = FRAME(0, 64, WIDTH, 70);
    _detailBackView.backgroundColor = [UIColor whiteColor];
    _iconImg.frame = FRAME(10, 10, 50, 50);
    _iconImg.layer.cornerRadius = _iconImg.frame.size.width / 2;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:[NSString stringWithFormat:@"%@",_detailModel.face]]];
    [_iconImg sd_image:url plimage:IMAGE(@"maintainheader")];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = FONT(14);
    if(_detailModel.name.length != 0)
    {
         _nameLabel.text = _detailModel.name;
    }
    else
    {
         _nameLabel.text = NSLocalizedString(@"维修师傅", nil);
    }
   
    CGSize nameSize = [self currentSizeWithString:_nameLabel.text font:FONT(14) withWidth:200];
    _nameLabel.frame = FRAME(70, 15, nameSize.width, 15);
    _ageLabel.textColor = HEX(@"999999", 1.0f);
    _ageLabel.font = FONT(14);
//    if(_detailModel.age.length != 0)
//    {
//         _ageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@岁", nil),_detailModel.age];
//    }
//   else
//   {
//        _ageLabel.text = NSLocalizedString(@"0岁", nil);
//   }
    CGSize ageSize = [self currentSizeWithString:_ageLabel.text font:FONT(14) withWidth:200];
    _ageLabel.frame = FRAME(90  + nameSize.width, 15, ageSize.width, 15);
    _verifyImg.frame = FRAME(90 + nameSize.width + ageSize.width + 5, 17.5, 10, 10);
    if([_detailModel.verify_name isEqualToString:@"1"])
    {
        _verifyLabel.hidden = NO;
        _verifyImg.hidden = NO;
         _verifyImg.image = IMAGE(@"v");
        _verifyLabel.text = NSLocalizedString(@"已验证", nil);
    }
    else
    {
        _verifyImg.hidden = YES;
        _verifyLabel.hidden = YES;
    }
    _verifyLabel.frame = FRAME(90 + nameSize.width + ageSize.width + 20, 15, 60, 15);
    _verifyLabel.textColor = HEX(@"ffae00", 1.0f);
    _verifyLabel.font = FONT(14);
    _distanLabel.textColor = HEX(@"fc7400", 1.0f);
    _distanLabel.font = FONT(12);
    _distanLabel.text = @"";//_detailModel.juli;
    CGSize distantSize = [self currentSizeWithString:_distanLabel.text font:FONT(12) withWidth:0];
    _distanLabel.frame = FRAME(WIDTH - distantSize.width - 10, 15, distantSize.width, 15);
    _starView = [StarView addEvaluateViewWithStarNO:[_detailModel.avg_score floatValue] withStarSize:10 withBackViewFrame:FRAME(70, 30, 70, 10)];
    [_detailBackView addSubview:_starView];
    _servierLabel.frame = FRAME(70, 50, 200, 15);
    _servierLabel.textColor = HEX(@"999999", 1.0f);
    _servierLabel.font = FONT(14);
    if(_detailModel.orders.length != 0)
    {
        _servierLabel.text = [NSString stringWithFormat:NSLocalizedString(@"服务%@次", nil),_detailModel.orders];
    }
    else
    {
        _servierLabel.text = NSLocalizedString(@"服务0次", nil);
    }
    
}
#pragma mark======创建选择按钮=========
- (void)createSelectBnt
{
    UIView *backView = [[UIView alloc] initWithFrame:FRAME(15, 80 + 64, WIDTH - 30, 35)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4.0f;
    backView.clipsToBounds = YES;
    backView.layer.borderColor = THEME_COLOR.CGColor;
    backView.layer.borderWidth = 1.0f;
    [self.view addSubview:backView];
    NSArray *titles = @[NSLocalizedString(@"服务", nil),NSLocalizedString(@"简介", nil),NSLocalizedString(@"评价", nil)];
    for(int i = 0; i < 3; i ++)
    {
        UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        bnt.frame = FRAME( i * (WIDTH - 30) / 3, 0, (WIDTH - 30) / 3, 35);
        bnt.layer.cornerRadius = 4.0f;
        bnt.clipsToBounds = YES;
        bnt.tag = i + 1;
        [bnt setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [bnt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [bnt setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
        [bnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bnt setTitle:titles[i] forState:UIControlStateNormal];
        [bnt addTarget:self action:@selector(selectBnt:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:bnt];
        if(i == 0)
        {
            bnt.selected = YES;
            _lastBnt = bnt;
        }
    }
}
#pragma mark=========选择按钮点击事件============
- (void)selectBnt:(UIButton *)sender
{
    if(_lastBnt != nil){
        _lastBnt.selected = NO;
    }
    sender.selected = YES;
    _lastBnt = sender;
    if(sender.tag == 1){
        [_introduceView removeFromSuperview];
        [_evaluationVc removeFromParentViewController];
        [_evaluationVc.view removeFromSuperview];
        [self.view addSubview:_seriverTableView];
    }else if(sender.tag == 2){
        [_seriverTableView removeFromSuperview];
        [_evaluationVc removeFromParentViewController];
        [_evaluationVc.view removeFromSuperview];
        [self.view addSubview:_introduceView];
    }
    else
    {
        [_seriverTableView removeFromSuperview];
        [_introduceView removeFromSuperview];

        [self.view addSubview:_evaluationVc.view];
    }
}
#pragma mark=====创建服务类型视图===========
- (void)createSeriverKind
{
    if(_seriverTableView == nil)
    {
        _seriverTableView = [[UITableView alloc] initWithFrame:FRAME(0, 64 + 80 + 45, WIDTH, HEIGHT - 189) style:UITableViewStylePlain];
        _seriverTableView.showsVerticalScrollIndicator = NO;
        _seriverTableView.delegate = self;
        _seriverTableView.dataSource = self;
        _seriverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [_seriverTableView addSubview:thread];
        [self.view addSubview:_seriverTableView];
    }
    else
    {
        [_seriverTableView reloadData];
    }
    
}
#pragma mark=======创建维修师傅简介===========
- (void)createIntroduce
{
    _introduceView = [[UIView alloc] init];
    _introduceView.backgroundColor = [UIColor whiteColor];
    UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    thread1.backgroundColor = LINE_COLOR;
    [_introduceView addSubview:thread1];
    _introduceLabel = [[UILabel alloc] init];
    _introduceLabel.backgroundColor = [UIColor whiteColor];
    _introduceLabel.font = FONT(14);
    _introduceLabel.numberOfLines = 0;
    _introduceLabel.textColor = HEX(@"666666", 1.0f);
    _introduceLabel.text = _detailModel.intro;
    CGSize size = [self currentSizeWithString:_introduceLabel.text font:FONT(14) withWidth:20];
    _introduceLabel.frame = FRAME(10, 10, size.width,size.height);
    _introduceView.frame = FRAME(0, 64 + 80 + 45, WIDTH, size.height + 20);
    UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, size.height + 19.5, WIDTH, 0.5)];
    thread2.backgroundColor = LINE_COLOR;
    [_introduceView addSubview:thread2];
    [_introduceView addSubview:_introduceLabel];
}
#pragma mark===========UITableViewDelegate==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _servierTableViewArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    JHMaintainSeriverKindCell *cell = [_seriverTableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[JHMaintainSeriverKindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.seriverModel = _servierTableViewArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaintainSeriverKindModel *model = _servierTableViewArray[indexPath.row];
    JHMaintainOrderVC *order = [[JHMaintainOrderVC alloc] init];
    order.imgUrl = model.icon;
    order.name = model.title;
    order.price = model.price;
    order.start = model.start;
    order.unit = model.unit;
    order.index = 2;
    order.shiFuName = self.name;
    order.cate_id = model.cate_id;
    order.staff_id = _detailModel.staff_id;
    [self.navigationController pushViewController:order animated:YES];
}

#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

-(ZQShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ZQShareView alloc]init];
        _shareView.isUrlImg = YES;
        _shareView.superVC = self;
    }
    return _shareView;
}


@end

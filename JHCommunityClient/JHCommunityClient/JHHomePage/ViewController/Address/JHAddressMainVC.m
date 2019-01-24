//
//  JHAddressMainVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAddressMainVC.h"
#import "JHShareModel.h"
#import "JHChooseCityVC.h"
@interface JHAddressMainVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHAddressMainVC
{
    //导航栏
    UIView *_customNav;
    UIButton *backBtn_custom;
    UILabel *title_;
    //搜索框
    UITextField *_searchField;
    //右上角按钮
    UIButton *cityBtn;
    //statusLabel
    UILabel *_statusLabel;
    //保存后台请求的城市列表
    NSDictionary *_cityDic;
    //当前定位或者选择的城市
    NSString *currentCity;

    //周边搜索回调的地址数组
    NSArray *addressArray;
    BOOL isKeySearch;
    
    UIButton *searchBtn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = NSLocalizedString(@"选择位置", nil);
    //处理当前城
    [self handleCurrentCity];
    //添加自定义导航栏
    [self createNav];
    //添加右侧按钮
    [self createRightBtn];
    //添加搜索框
    [self createSearchField];
    //创建表视图
    [self createMainTableView];
    //后台请求城市列表
    [self performSelectorInBackground:@selector(getCities) withObject:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldTextChanged:) name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

#pragma mark - 处理当前的城市
- (void)handleCurrentCity
{
    currentCity = [JHShareModel shareModel].cityName;
}
#pragma mark - 创建左边按钮
- (void)createNav
{
    _customNav = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, NAVI_HEIGHT)];
    [self.view addSubview:_customNav];
    _customNav.backgroundColor = NEW_THEME_COLOR;
    backBtn_custom = [[UIButton alloc] initWithFrame:CGRectMake(15,STATUS_HEIGHT,44,44)];
    [backBtn_custom addTarget:self action:@selector(clickBackBtn)
             forControlEvents:UIControlEventTouchUpInside];
    [backBtn_custom setImage:[UIImage imageNamed:@"closeNew"] forState:UIControlStateNormal];
    backBtn_custom.imageEdgeInsets = UIEdgeInsetsMake(13, 0, 13, 26);
    [_customNav addSubview:backBtn_custom];
    title_ = [[UILabel alloc] initWithFrame:FRAME(0, STATUS_HEIGHT, 100, 44)];
    title_.text = NSLocalizedString(@"选择位置", nil);
    title_.font = FONT(18);
    title_.textColor = HEX(@"333333", 1);
    title_.textAlignment = NSTextAlignmentCenter;
    [_customNav addSubview:title_];
    title_.center = CGPointMake(_customNav.center.x, CGRectGetMidY(title_.frame));
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!addressArray) {
        
         [self tableView:_mainTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
   
}
#pragma mark -添加导航栏右侧按钮
- (void)createRightBtn
{
    cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityBtn setFrame:CGRectMake(WIDTH - 80 ,STATUS_HEIGHT, 70, 44)];
    [cityBtn addTarget:self action:@selector(clickHandSearch:) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    cityBtn.titleLabel.font = FONT(17);
    cityBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    NSString *cityString = [JHShareModel shareModel].cityName;
    cityString = self.cityName ? self.cityName : NSLocalizedString(@"城市", nil);
    [cityBtn setTitle:cityString forState:(UIControlStateNormal)];
    [_customNav addSubview:cityBtn];
}
#pragma mark - createSearchField
- (void)createSearchField
{
    //添加子控件
    if (!_searchField) {
        UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 45)];
        backView.backgroundColor = [UIColor whiteColor];
        _searchField = [[UITextField alloc] initWithFrame:FRAME(10, 5, WIDTH-20,35)];
        _searchField.backgroundColor = HEX(@"f7f7f7", 1.0f);
        _searchField.layer.cornerRadius = 5;
        _searchField.layer.masksToBounds = YES;
        _searchField.layer.borderColor = LINE_COLOR.CGColor;
        _searchField.layer.borderWidth = 0.7;
        _searchField.placeholder = NSLocalizedString(@"请输入位置名称", nil);
        _searchField.textColor = HEX(@"333333", 1.0);
        _searchField.font = FONT(16);
        _searchField.delegate = self;
        //添加左右按钮
        UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 35, 35)];
        leftIV.image = IMAGE(@"search");
        searchBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 60, 35)];
        [searchBtn setTitle:NSLocalizedString(@"搜索", nil) forState:(UIControlStateNormal)];
        [searchBtn setTitleColor:HEX(@"7d7d7d", 1.0f) forState:(UIControlStateNormal)];
        searchBtn.titleLabel.font = FONT(15);
        searchBtn.layer.borderColor = LINE_COLOR.CGColor;
        searchBtn.layer.borderWidth = 0.7;
        [searchBtn addTarget:self action:@selector(clickSearchBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.leftView = leftIV;
        _searchField.rightViewMode = UITextFieldViewModeAlways;
        _searchField.rightView = searchBtn;
        [backView addSubview:_searchField];
        [self.view addSubview:backView];
    }
}
#pragma mark - 点击导航栏左按钮
- (void)clickBackBtn
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - 后台请求城市列表
- (void)getCities
{
    NSLog(@"开始执行后台请求城市");
    [HttpTool postWithAPI:@"client/data/city" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        _cityDic = json[@"data"][@"items"]; //返回的数据格式还需调整
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 点击手动选择
- (void)clickHandSearch:(UIButton *)sender
{
    NSLog(@"点击了切换城市");
    JHChooseCityVC *vc = [[JHChooseCityVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.cityDic = _cityDic;
    vc.currentCity = currentCity;
    vc.refreshCityBlock = ^(NSString *cityName){
        [cityBtn setTitle:cityName forState:UIControlStateNormal];
        currentCity = cityName;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 创建表视图
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, (NAVI_HEIGHT+55), WIDTH, HEIGHT - (NAVI_HEIGHT+55)) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = BACK_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (addressArray && addressArray.count > 0) {
                return addressArray.count;
            }
            return 0;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            //添加子控件
            UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 12.5, 20, 20)];
            leftIV.image = IMAGE(@"address");
            if (!_statusLabel) {
                _statusLabel = [[UILabel alloc] initWithFrame:FRAME(35, 0, WIDTH - 45, 45)];
                _statusLabel.textColor = HEX(@"333333", 1.0f);
                _statusLabel.font = FONT(16);
                _statusLabel.textAlignment = NSTextAlignmentLeft;
                _statusLabel.numberOfLines = 2;
                _statusLabel.text = NSLocalizedString(@"正在定位您当前的位置...", nil);
            }
            //添加下划线
            UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 44.5, WIDTH, 0.5)];
            line.backgroundColor = LINE_COLOR;
            [cell addSubview:line];
            [cell addSubview:_statusLabel];
            [cell addSubview:leftIV];
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            //添加子控件
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 110, 45)];
            addressLabel.font = FONT(16);
            addressLabel.textColor = HEX(@"999999", 1.0);
            addressLabel.text = [(XHLocationInfo *)addressArray[indexPath.row] name];
            
            //添加下划线
            UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 44.5, WIDTH, 0.5)];
            line.backgroundColor = LINE_COLOR;
            [cell addSubview:line];
            [cell addSubview:addressLabel];
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.backgroundColor = BACK_COLOR;
            return cell;
        }
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (section == 0 && row == 0) {
        //创建周边搜索
        [self creatSurrondSearch];
        _searchField.text = @"";
        [self.view endEditing:YES];
        searchBtn.backgroundColor = HEX(@"f7f7f7", 1.0);
        [searchBtn setTitleColor:HEX(@"7d7d7d", 1.0f) forState:(UIControlStateNormal)];
    }else{
        //获取当前的row
        XHLocationInfo *lastPOI = (XHLocationInfo *)addressArray[row];
        [JHShareModel shareModel].cityName = lastPOI.city;
        [JHShareModel shareModel].cityCode = lastPOI.cityCode;
        [JHShareModel shareModel].lat = lastPOI.coordinate.latitude;
        [JHShareModel shareModel].lng = lastPOI.coordinate.longitude;
//        [XHMapKitManager shareManager].lat = lastPOI.coordinate.latitude;
//        [XHMapKitManager shareManager].lng = lastPOI.coordinate.longitude;
        [XHMapKitManager shareManager].currentCity = lastPOI.city;
        [JHShareModel shareModel].chooseCityName = lastPOI.city;
        [JHShareModel shareModel].lastCommunity = [lastPOI name];
        [[NSUserDefaults standardUserDefaults] setObject:@([JHShareModel shareModel].lat).description
                                                  forKey:@"app.lat"];
        [[NSUserDefaults standardUserDefaults] setObject:@([JHShareModel shareModel].lng).description
                                                  forKey:@"app.lng"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KGetLocation_Notification
                                                            object:nil];
        self.refreshBlock(); 
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - 开始拖拽时,放弃第一响应
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - 点击搜索按钮
- (void)clickSearchBtn:(UIButton *)sender{
    NSLog(@"点击了搜索按钮");
    SHOW_HUD
    //请求搜索数据
    [self.view endEditing:YES];
    [self searchFieldTextChanged:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([XHMapKitManager shareManager].is_International) {
        [self keySearchWithkey:_searchField.text];
        return NO;
    }else{
        return YES;
    }  
}

#pragma mark - searchField内容改变时
- (void)searchFieldTextChanged:(NSNotification *)noti{
    if (noti.object == nil || noti.object == _searchField) {
        [self keySearchWithkey:_searchField.text];
        if (_searchField.text.length > 0) {
            _searchField.rightView.backgroundColor = THEME_COLOR;
            [searchBtn setTitleColor:HEX(@"fffffff", 1.0f) forState:(UIControlStateNormal)];
        }else{
            _searchField.rightView.backgroundColor = HEX(@"f7f7f7", 1.0);
            [searchBtn setTitleColor:HEX(@"7d7d7d", 1.0f) forState:(UIControlStateNormal)];
        }
    }
    
}

#pragma mark - 周边搜索
-(void)creatSurrondSearch
{
    __weak typeof(self)weakself = self;
    SHOW_HUD
    [[XHPlaceTool sharePlaceTool] aroundSearchWithSuccess:^(NSArray<XHLocationInfo *> *pois) {
        HIDE_HUD
        if (pois.count == 0) {
            _statusLabel.text = NSLocalizedString(@"未定位到附近位置,点此重新搜索周边", @"JHAddressMainVC");
            addressArray = @[];
            [_mainTableView reloadData];
        }else{
            
            addressArray = pois;
            _statusLabel.text = [(XHLocationInfo *)pois[0] name];
            NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:[_statusLabel.text stringByAppendingString:@"(点此重新搜索周边)"]];
            NSMutableParagraphStyle * paragrap = [[NSMutableParagraphStyle alloc]init];
            [paragrap setLineSpacing:3];
            [attributed addAttribute:NSParagraphStyleAttributeName value:paragrap range:NSMakeRange(0, _statusLabel.text.length)];
            _statusLabel.attributedText = attributed;
//            [cityBtn setTitle:currentCity forState:(UIControlStateNormal)];
            [_mainTableView reloadData];
            //设置城市
            currentCity = [(XHLocationInfo *)pois[0] city];
//            [cityBtn setTitle:currentCity forState:(UIControlStateNormal)];
        }
        
    } failure:^(NSString *error) {
        HIDE_HUD
        [weakself showAlertWithMsg:error];
        _statusLabel.text = NSLocalizedString(@"定位失败,请重新定位", @"JHAddressMainVC");
    }];
}

#pragma mark - 关键字搜索
- (void)keySearchWithkey:(NSString *)key{
    [XHMapKitManager shareManager].currentCity = [JHShareModel shareModel].chooseCityName;
    [[XHPlaceTool sharePlaceTool] keywordsSearchWithKeyString:key success:^(NSArray<XHLocationInfo *> *pois) {
        HIDE_HUD
        if (pois.count == 0) {
            _statusLabel.text = NSLocalizedString(@"未搜索到位置,点此进行周边搜索", @"JHAddressMainVC");
            addressArray = @[];
            [_mainTableView reloadData];
        }else{
            addressArray = pois;
            _statusLabel.text = NSLocalizedString([(XHLocationInfo *)pois[0] name],nil);
            NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:[_statusLabel.text stringByAppendingString:NSLocalizedString(@"(点此重新搜索周边)",nil)]];
            NSMutableParagraphStyle * paragrap = [[NSMutableParagraphStyle alloc]init];
            [paragrap setLineSpacing:3];
            [attributed addAttribute:NSParagraphStyleAttributeName value:paragrap range:NSMakeRange(0, _statusLabel.text.length)];
            _statusLabel.attributedText = attributed;
//            [cityBtn setTitle:currentCity forState:(UIControlStateNormal)];
            [_mainTableView reloadData];
        }
    } failure:^(NSString *error) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchField resignFirstResponder];
}
- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertController *alertVC = [UIAlertController
                                        alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)
                                                        message:msg
                                                preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *canaelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:canaelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

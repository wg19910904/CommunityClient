//
//  JHChooseCityVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/21.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHChooseCityVC.h"
 
#import "JHShareModel.h"
@interface JHChooseCityVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHChooseCityVC
{
    //导航栏
    UIView *_customNav;
    UIButton *backBtn_custom;
    UILabel *title_;
    //搜索框
    UITextField *_searchField;
    //城市key组成的数组
    NSArray *keyArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建自定义导航栏
    [self createNav];
    //创建搜索框
    //[self createSearchField];
    //根据cityDic判断怎样创建主表视图
    [self createTableView];
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
    title_.text = NSLocalizedString(@"选择城市", nil);
    title_.font = FONT(18);
    title_.textColor = TEXT_COLOR;
    title_.textAlignment = NSTextAlignmentCenter;
    [_customNav addSubview:title_];
    title_.center = CGPointMake(_customNav.center.x, CGRectGetMidY(title_.frame));
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
        _searchField.placeholder = NSLocalizedString(@"请输入城市名", nil);
        _searchField.textColor = HEX(@"333333", 1.0);
        _searchField.font = FONT(16);
        _searchField.delegate = self;
        //添加左右按钮
        UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 35, 35)];
        
        leftIV.image = IMAGE(@"search");
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 60, 35)];
        [rightBtn setTitle:NSLocalizedString(@"搜索", nil) forState:(UIControlStateNormal)];
        [rightBtn setTitleColor:HEX(@"7d7d7d", 1.0f) forState:(UIControlStateNormal)];
        rightBtn.titleLabel.font = FONT(15);
        rightBtn.layer.borderColor = LINE_COLOR.CGColor;
        rightBtn.layer.borderWidth = 0.7;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.leftView = leftIV;
        _searchField.rightViewMode = UITextFieldViewModeAlways;
        _searchField.rightView = rightBtn;
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
#pragma mark - 创建表视图
- (void)createTableView
{
    if (_cityDic) {
        keyArray = [_cityDic allKeys];
        //对数组进行排序
        keyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
        [self createMainTableView];
    }else{
        //请求城市数据
        [HttpTool postWithAPI:@"client/data/city" withParams:@{} success:^(id json) {
            NSLog(@"%@",json);
            _cityDic = json[@"data"][@"items"];
            keyArray = [_cityDic allKeys];
            //对数组进行排序
            keyArray = keyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
            [self createMainTableView];
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = BACK_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.sectionIndexColor = HEX(@"666666", 1.0f);//改变索引的颜色
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cityDic.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [_cityDic[keyArray[section - 1]] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        UIView *sectionView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 30)];
        sectionView.backgroundColor = BACK_COLOR;
        //添加标签
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 5, 20, 20)];
        titleLabel.layer.borderColor = THEME_COLOR.CGColor;
        titleLabel.layer.borderWidth = 0.8;
        titleLabel.layer.cornerRadius = 3;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.text = keyArray[section - 1];
        titleLabel.font = FONT(15);
        titleLabel.textColor = THEME_COLOR;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [sectionView addSubview:titleLabel];
        //添加下划线
        UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 29.5, WIDTH, 0.5)];
        line.backgroundColor = LINE_COLOR;
        [sectionView addSubview:line];

        return sectionView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) { //定位 常用和热门城市分区
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BACK_COLOR;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 45)];
        titleLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"当前选择城市: ", nil),self.currentCity];
        titleLabel.textColor = HEX(@"666666", 1.0f);
        titleLabel.font = FONT(15);
        [cell addSubview:titleLabel];
        return cell;
    }else{ //其他分区
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 45)];
        NSDictionary *dic = _cityDic[keyArray[section - 1]][row];
        titleLabel.text = dic[@"city_name"];
        titleLabel.font = FONT(15);
        titleLabel.textColor = HEX(@"333333", 1.0f);
        [cell addSubview:titleLabel];
        //添加下划线
        UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 44.5, WIDTH, 0.5)];
        line.backgroundColor = LINE_COLOR;
        [cell addSubview:line];
        return cell;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   
    return keyArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    //获取当前选中的行的城市名和城市code
    NSDictionary *cityDic = _cityDic[keyArray[section - 1]][row];
    NSString *cityName = cityDic[@"city_name"];
    NSString *cityCode = cityDic[@"city_code"];
    NSString *cityID = cityDic[@"city_id"];
    [JHShareModel shareModel].cityName = cityName;
    [JHShareModel shareModel].chooseCityName = cityName;
    [JHShareModel shareModel].cityCode = cityCode;
    [[NSUserDefaults standardUserDefaults] setObject:cityID forKey:@"city_id"];
    self.refreshCityBlock(cityName);
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 滚动放弃第一响应
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

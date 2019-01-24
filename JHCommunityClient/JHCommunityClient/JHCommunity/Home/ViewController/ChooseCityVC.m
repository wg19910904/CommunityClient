//
//  JHChooseCityVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ChooseCityVC.h"
//#import "YFTextField.h"
#import "JHShareModel.h"
 

@interface ChooseCityVC()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *tableView;
//@property(nonatomic,weak)YFTextField *searchField;
@property(nonatomic,strong)NSDictionary *cityDic;
@property(nonatomic,strong)NSArray *indexArr;
@end

@implementation ChooseCityVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    self.view.backgroundColor=BACK_COLOR;
    self.navigationItem.title=@"城市选择";
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 80+NAVI_HEIGHT, WIDTH, HEIGHT-80-NAVI_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    [self setUpHeadView];
    [self getCityList];
}

-(void)setUpHeadView{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, 80)];
    view.backgroundColor=[UIColor whiteColor];
    
//    UIImageView *leftView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    leftView.image=IMAGE(@"address_search");
//    leftView.contentMode=UIViewContentModeCenter;
//    YFTextField *searchField=[[YFTextField alloc] initWithFrame:CGRectMake(15, 10, WIDTH-30, 30) leftView:leftView rightView:[UIView new]];
//    searchField.delegate=self;
//    searchField.backgroundColor=BACK_COLOR;
//    searchField.placeholdeColor=HEX(@"999999", 1.0);
//    searchField.font=FONT(14);
//    searchField.returnKeyType=UIReturnKeySearch;
//    searchField.placeholder=@"请输入城市名称";
//    [view addSubview:searchField];
//    searchField.font=FONT(14);
//    searchField.textColor=HEX(@"333333", 1.0);
    
    UILabel *lab=[UILabel new];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=40;
    }];
    lab.textColor=HEX(@"999999", 1.0);
    lab.text=@"  当前定位城市";
    lab.font=FONT(14);
    lab.backgroundColor=BACK_COLOR;
    
    UIImageView *addrImgView=[UIImageView new];
    [view addSubview:addrImgView];
    [addrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lab.mas_bottom).offset=10;
        make.width.offset=20;
        make.height.offset=20;
    }];
    addrImgView.image=IMAGE(@"address_position");
    
    UILabel *cityLab=[UILabel new];
    [view addSubview:cityLab];
    [cityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrImgView.mas_right).offset=10;
        make.top.equalTo(lab.mas_bottom).offset=0;
        make.width.offset=WIDTH;
        make.height.offset=40;
    }];
    cityLab.textColor=THEME_COLOR;
    cityLab.text=[JHShareModel shareModel].cityName;
    cityLab.font=FONT(14);
    
    [self.view addSubview:view];
}

-(void)getCityList{
    //请求城市数据
    SHOW_HUD
    [HttpTool postWithAPI:@"client/data/city" withParams:@{} success:^(id json) {
        HIDE_HUD
        NSLog(@"%@",json);
        if ([json[@"error"] intValue]==0) {
            self.cityDic = json[@"data"][@"items"];
            NSArray *arr = [_cityDic allKeys];
            self.indexArr = [arr sortedArrayUsingSelector:@selector(compare:)];
            [self.tableView reloadData];
        }else [self showMsg:json[@"message"]];

    } failure:^(NSError *error) {
         [self showMsg:NSLocalizedString(@"服务器繁忙,请稍后再试!", nil)];
    }];
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *str=self.indexArr[section];
    return [self.cityDic[str] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHChooseCityCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=FONT(14);
        cell.textLabel.textColor=HEX(@"333333", 1.0);
    }
    NSString *str=self.indexArr[indexPath.section];
    NSArray *arr=self.cityDic[str];
    NSDictionary *dic=arr[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@市",dic[@"city_name"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.chooseCity) {
        NSString *str=self.indexArr[indexPath.section];
        NSArray *arr=self.cityDic[str];
        NSDictionary *dic=arr[indexPath.row];
        NSString *city=[NSString stringWithFormat:@"%@市",dic[@"city_name"]];
        self.chooseCity(city,dic[@"city_id"]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    lab.textColor=HEX(@"333333", 1.0);
    lab.backgroundColor=BACK_COLOR;
    lab.font=FONT(14);
    lab.text=[NSString stringWithFormat:@"   %@",self.indexArr[section]];
    return lab;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - 收起键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark ======搜索城市=======
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
}

@end

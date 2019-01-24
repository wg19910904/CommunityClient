//
//  JHChooseCityCommunityVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHChooseCityCommunityVC.h"
#import "YFTextField.h"
#import "JHShareModel.h"
#import "ChooseCityVC.h"
#import "JHSearchVC.h"
@interface JHChooseCityCommunityVC()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,weak)UIButton *rightBtn;
@property(nonatomic,copy)NSString *city_id;
@end

@implementation JHChooseCityCommunityVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"所在小区";
    self.view.backgroundColor=BACK_COLOR;
    self.navigationController.navigationBar.hidden = NO;
    [self setUpView];
    [self getCommunityListCity_id:[JHShareModel shareModel].city_id];
   
}
-(void)setUpView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+100, WIDTH, HEIGHT-NAVI_HEIGHT-100) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    
    [self setUpNavi];
    [self setUpHeadView];
}

-(void)setUpNavi{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(chooseCity)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:IMAGE(@"community_unfold") forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -20);
    [rightBtn setTitle:[JHShareModel shareModel].cityName forState:UIControlStateNormal];
    rightBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 0);
    rightBtn.titleLabel.font=FONT(12);
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    self.rightBtn=rightBtn;
}

#pragma mark ======选择城市=======
-(void)chooseCity{
    ChooseCityVC *choose=[[ChooseCityVC alloc] init];
    choose.chooseCity=^(NSString *cityName,NSString *city_id){
        [self.rightBtn setTitle:cityName forState:UIControlStateNormal];
        [self getCommunityListCity_id:city_id];
    };
    [self.navigationController pushViewController:choose animated:YES];
}

-(void)setUpHeadView{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, 100)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *leftView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftView.image=IMAGE(@"address_search");
    YFTextField *searchField=[[YFTextField alloc] initWithFrame:CGRectMake(15, 10, WIDTH-30, 30) leftView:leftView];
    searchField.delegate=self;
    searchField.backgroundColor=BACK_COLOR;
    searchField.placeholdeColor=HEX(@"999999", 1.0);
    searchField.font=FONT(14);
    searchField.placeholder=@"请输入小区名称";
    [view addSubview:searchField];
    searchField.font=FONT(14);
    searchField.textColor=HEX(@"333333", 1.0);
    
    UILabel *lab=[UILabel new];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=50;
        make.width.offset=WIDTH;
        make.height.offset=40;
    }];
    lab.textColor=HEX(@"999999", 1.0);
    lab.text=@"  猜你住在";
    lab.font=FONT(14);
    lab.backgroundColor=BACK_COLOR;
    
    [self.view addSubview:view];
}

-(void)getCommunityListCity_id:(NSString *)city_id{
    self.city_id=city_id;
    
    SHOW_HUD
    [MineCommunityModel getCommunityListWithCity_id:city_id block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        if (arr) {
            self.dataSource=arr;
            [self.tableView reloadData];
        }else [self showMsg:msg];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHChooseCityCommunityCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UILabel *titleLab=[UILabel new];
        [cell.contentView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.top.offset=10;
            make.width.offset=WIDTH-20;
            make.height.offset=20;
        }];
        titleLab.textColor=HEX(@"333333", 1.0);
        titleLab.font=FONT(16);
        titleLab.tag=100;
        
        UILabel *desLab=[UILabel new];
        [cell.contentView addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.top.equalTo(titleLab.mas_bottom).offset=5;
            make.width.offset=WIDTH-20;
            make.height.offset=20;
        }];
        desLab.textColor=HEX(@"999999", 1.0);
        desLab.font=FONT(14);
        desLab.tag=101;
    }
    
    UILabel *titleLab=(UILabel *)[cell viewWithTag:100];
    UILabel *desLab=(UILabel *)[cell viewWithTag:101];
    MineCommunityModel *model=self.dataSource[indexPath.row];
    titleLab.text=model.title;
    desLab.text=model.addr;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.chooseCityCommunity) {
         MineCommunityModel *model=self.dataSource[indexPath.row];
        self.chooseCityCommunity(model.title,model.xiaoqu_id);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark ======搜索小区=======
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    JHSearchVC *search=[[JHSearchVC alloc] init];
    if (self.city_id) search.city_id=self.city_id;
    else search.city_id=[JHShareModel shareModel].communityModel.city_id;
    
    [self.navigationController pushViewController:search animated:YES];
    
}

@end

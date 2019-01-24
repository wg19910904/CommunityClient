//
//  JHChooseVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSearchVC.h"
#import "YFTextField.h"
#import "JHSubmitCommunityVC.h"
#import "MineCommunityModel.h"

@interface JHSearchVC()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,weak)YFTextField *searchField;
@property(nonatomic,strong)UIView *noDataView;//没有小区的view
@end

@implementation JHSearchVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=BACK_COLOR;
    [self setUpView];
}

-(void)setUpView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    [self setUpNavi];
}

-(void)setUpNavi{
    
    UIImageView *leftView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftView.image=IMAGE(@"fangdajing");
    leftView.contentMode=UIViewContentModeCenter;
    YFTextField *searchField=[[YFTextField alloc] initWithFrame:CGRectMake(-44, 0, WIDTH-44, 30) leftView:leftView rightView:[UIView new]];
    searchField.delegate=self;
    searchField.backgroundColor=HEX(@"ffffff", 0.3);
    searchField.placeholdeColor=HEX(@"ffffff", 1.0);
    searchField.font=FONT(14);
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.placeholder=@"请输入您要搜索的小区";
    searchField.font=FONT(14);
    searchField.textColor=HEX(@"ffffff", 1.0);
    searchField.layer.cornerRadius=4;
    searchField.clipsToBounds=YES;
    self.navigationItem.titleView=searchField;
    self.searchField=searchField;
    
    [self creatRightTitleBtn:NSLocalizedString(@"搜索", nil) titleColor:[UIColor whiteColor] sel:@selector(clickSearch) edgeInsets:UIEdgeInsetsMake(0, 20, 0, -10)];
}

-(void)clickSearch{
    
    [self.searchField resignFirstResponder];
    SHOW_HUD
    [MineCommunityModel getCommunitySearchListWithKeyword:self.searchField.text city_id:self.city_id ? self.city_id : @"" block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        if (arr) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:arr];
            if (self.dataSource.count==0)  [self.tableView addSubview:self.noDataView];
            else{
                [self.noDataView removeFromSuperview];
                _noDataView=nil;
                [self.tableView reloadData];
            }
        }else [self showMsg:msg];
    }];
    
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

    MineCommunityModel *model=self.dataSource[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseCommunity" object:nil userInfo:@{@"name":model.title,@"xiaoqu_id":model.xiaoqu_id}];
    NSInteger count=self.navigationController.viewControllers.count;
    UIViewController *vc=self.navigationController.viewControllers[count-3];
    [self.navigationController popToViewController:vc animated:YES];

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

-(UIView *)noDataView{
    if (_noDataView==nil) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-NAVI_HEIGHT)];
        view.backgroundColor=BACK_COLOR;
        UILabel *firstLab=[UILabel new];
        [view addSubview:firstLab];
        [firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset=0;
            make.centerY.offset=-30;
            make.width.offset=WIDTH;
            make.height.offset=20;
        }];
        firstLab.textAlignment=NSTextAlignmentCenter;
        firstLab.textColor=HEX(@"333333", 1.0);
        firstLab.font=FONT(15);
        firstLab.text=@"未搜索到该小区!";
        
        UILabel *midLab=[UILabel new];
        [view addSubview:midLab];
        [midLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset=0;
            make.centerY.offset=0;
            make.width.offset=WIDTH;
            make.height.offset=20;
        }];
        midLab.textAlignment=NSTextAlignmentCenter;
        midLab.textColor=HEX(@"333333", 1.0);
        midLab.font=FONT(15);
        midLab.text=@"请告诉我们,我们尽快添加!";
        
        UIButton *btn=[UIButton new];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset=0;
            make.centerY.offset=40;
            make.width.offset=120;
            make.height.offset=40;
        }];
        btn.layer.cornerRadius=4;
        btn.clipsToBounds=YES;
        btn.backgroundColor=[UIColor whiteColor];
        btn.layer.borderColor=HEX(@"eeeeee", 1.0).CGColor;
        btn.layer.borderWidth=1.0;
        btn.titleLabel.font=FONT(15);
        [btn setTitle:NSLocalizedString(@"提交小区", nil) forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickTiJiao) forControlEvents:UIControlEventTouchUpInside];
        _noDataView=view;
    }
    return _noDataView;
}

#pragma mark ======点击提交小区=======
-(void)clickTiJiao{
    JHSubmitCommunityVC *submit=[[JHSubmitCommunityVC alloc] init];
    [self.navigationController pushViewController:submit animated:YES];
}

-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - 收起键盘
-(void)clickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
    [self.searchField resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchField resignFirstResponder];
}

#pragma mark ======搜索城市=======
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickSearch];
    return  YES;
}

@end

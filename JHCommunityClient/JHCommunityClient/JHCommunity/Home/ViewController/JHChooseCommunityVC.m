//
//  JHChooseCommunityVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHChooseCommunityVC.h"
#import "ChooseCommunityCell.h"
#import "JHAddCommunityVC.h"
#import "JHShareModel.h"
#import "JHCommunityHomeVC.h"
#import <MJRefresh.h>
@interface JHChooseCommunityVC ()<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic,strong)
@property (nonatomic,strong)UIButton *rightBnt;//右侧管理按钮
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,strong)NSIndexPath *selectedIndexPath;//选中的cell
@property(nonatomic,copy)NSString *selectedYeZhu_id;
@end


@implementation JHChooseCommunityVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self handleNavigationBar];
    [self setUpView];
}

#pragma mark--===导航栏相关处理
- (void)handleNavigationBar{
    self.navigationItem.title=@"我的小区";
    self.backBtn.hidden = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIButton *)rightBnt{
    if(_rightBnt == nil){
        _rightBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBnt setFrame:CGRectMake(0, 0, 44, 44)];
        [_rightBnt addTarget:self action:@selector(clickEdit:)
            forControlEvents:UIControlEventTouchUpInside];
        [_rightBnt setTitle:NSLocalizedString(@"管理", nil) forState:UIControlStateNormal];
        [_rightBnt setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        _rightBnt.titleLabel.font=FONT(16);
        _rightBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _rightBnt;
}

- (void)clickBackBtn{
    if([JHShareModel shareModel].communityModel){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UITabBarController *tabbarVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        tabbarVC.selectedIndex = 0;
        if (self.myBlock) {
            self.myBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark ======获取小区列表=======
-(void)getData{
    SHOW_HUD
    [MineCommunityModel getHadCommunityListWithBlock:^(NSArray *arr, NSString *msg) {
        HIDE_HUD;
        if (arr) {
            [self.tableView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:arr];
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self showMsg:msg];
        }
    }];
}

-(void)setUpView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT,WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    __weak typeof(self) weakSelf=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
}

#pragma mark ======点击管理=======
-(void)clickEdit:(UIButton *)btn{
    
    btn.selected=!btn.isSelected;
    self.isEdit=btn.isSelected;
    if (btn.selected) [btn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    else [btn setTitle:NSLocalizedString(@"管理", nil) forState:UIControlStateNormal];
    [self.tableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section<self.dataSource.count) {
        static NSString *ID=@"JHChooseCommunityCell";
        ChooseCommunityCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[ChooseCommunityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        MineCommunityModel *model=self.dataSource[indexPath.section];
        [cell reloadCellWithModel:model withVC:self];
        
        cell.deleteAddr=^(){//删除小区
            [self deleteCommunityWithXiaoqu_id:model.yezhu_id];
        };
        
        cell.changeAddr=^(){//修改小区
            JHAddCommunityVC *add=[[JHAddCommunityVC alloc] init];
            add.is_change=YES;
            add.model=model;
            [self.navigationController pushViewController:add animated:YES];
        };
        
        if ([model.yezhu_id isEqualToString:self.selectedYeZhu_id]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        return cell;
    }else{
        static NSString *ID=@"ChooseCommunityCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIView *subView=[UIView new];
            [cell addSubview:subView];
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=0;
                make.top.offset=0;
                make.width.offset=WIDTH;
                make.height.offset=40;
            }];
            subView.backgroundColor=[UIColor whiteColor];
            
            UIImageView *imgView=[UIImageView new];
            [subView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=10;
                make.top.offset=10;
                make.width.offset=20;
                make.height.offset=20;
            }];
            imgView.image=IMAGE(@"address_add");
            
            UILabel *lab=[UILabel new];
            [subView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgView.mas_right).offset=10;
                make.top.offset=10;
                make.width.offset=WIDTH-40;
                make.height.offset=20;
            }];
            lab.font=FONT(15);
            lab.text=@"申请入驻";
            lab.textColor=THEME_COLOR;
        }
        
        return cell;
    }
    
}

#pragma mark ======删除小区=======
-(void)deleteCommunityWithXiaoqu_id:(NSString *)yezhu_id{
    SHOW_HUD
    [MineCommunityModel deleteCommunity:yezhu_id block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        if (arr) {
            [self showMsg:msg];
            [self getData];
        }else [self showMsg:msg];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section<self.dataSource.count) {
        //        self.selectedIndexPath=indexPath;
        MineCommunityModel *model=self.dataSource[indexPath.section];
        if (self.chooseCommunity) {
            [JHShareModel shareModel].communityModel=model;
            self.chooseCommunity(model);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self addCommunity];
        //        if (self.selectedIndexPath.length) {
        //            [tableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        //        }
    }
    
}

#pragma mark ======添加小区=======
-(void)addCommunity{
    JHAddCommunityVC *addCommunity=[[JHAddCommunityVC alloc] init];
    [self.navigationController pushViewController:addCommunity animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.dataSource.count+1) return 10;
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<self.dataSource.count) {
        if (self.isEdit) return 100;
        return 70;
    }
    return 40;
}

-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSIndexPath *)selectedIndexPath{
    if (_selectedIndexPath==nil) {
        if ([JHShareModel shareModel].communityModel) {
            for (NSInteger i=0; self.dataSource.count; i++) {
                if ([[self.dataSource[i] yezhu_id] isEqualToString:[JHShareModel shareModel].communityModel.yezhu_id]) {
                    _selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:i];
                    break;
                }
            }
        }else _selectedIndexPath=nil;
    }
    
    return _selectedIndexPath;
}

-(NSString *)selectedYeZhu_id{
    if (_selectedYeZhu_id==nil) {
        if ([JHShareModel shareModel].communityModel) {
            _selectedYeZhu_id = [JHShareModel shareModel].communityModel.yezhu_id;
        }else _selectedYeZhu_id=@"";
    }
    return _selectedYeZhu_id;
}

@end

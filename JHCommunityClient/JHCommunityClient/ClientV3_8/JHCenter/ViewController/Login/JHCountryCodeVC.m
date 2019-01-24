//
//  JHCountryVC.m
//  Lunch
//
//  Created by ios_yangfei on 17/8/1.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import "JHCountryCodeVC.h"
 
@interface JHCountryCodeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSDictionary *countryCodeDic;
@property(nonatomic,strong)NSArray *indexArr;
@end

@implementation JHCountryCodeVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    [self getData];

}

-(void)setUpView{
    
    self.navigationItem.title =  NSLocalizedString(@"选择国家和地区代码", NSStringFromClass([self class]));
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 40;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=[UIColor whiteColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.sectionIndexColor = THEME_COLOR_Alpha(1.0);

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
    NSString *key = self.indexArr[section];
    NSArray *arr =self.countryCodeDic[key];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHCountryCodeCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = HEX(@"333333", 1.0);
        
        UILabel *codeLab = [UILabel new];
        [cell addSubview:codeLab];
        [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-30;
            make.centerY.offset=0;
            make.height.offset=20;
            make.width.greaterThanOrEqualTo(@30);
        }];
        codeLab.layer.cornerRadius=10;
        codeLab.clipsToBounds=YES;
        codeLab.textAlignment = NSTextAlignmentCenter;
        codeLab.backgroundColor = BACK_COLOR;
        codeLab.tag = 100;
        codeLab.font = FONT(12);
        codeLab.textColor = HEX(@"666666", 1.0);
        
    }
    
    UILabel *codeLab = [cell viewWithTag:100];
    NSString *key = self.indexArr[indexPath.section];
    NSArray *arr =self.countryCodeDic[key];
    NSDictionary *dic = arr[indexPath.row];
    codeLab.text = [NSString stringWithFormat:@"+%@",dic[@"code_code"]];
    cell.textLabel.text = dic[@"code_name"];
    
    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [self.indexArr indexOfObject:title];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *key = self.indexArr[indexPath.section];
    NSArray *arr =self.countryCodeDic[key];
    NSDictionary *dic = arr[indexPath.row];
    if (self.chooseCountryCode) {
        NSString *code = dic[@"code_code"];
        self.chooseCountryCode(YES,code);
    }
    [self clickBackBtn];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [UILabel new];
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.text = self.indexArr[section];
    
    UIView *lineView=[UIView new];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UIView *lineView2=[UIView new];
    [view addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=-0.5;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView2.backgroundColor=LINE_COLOR;
    return view;
}

#pragma mark ====== Functions =======
-(void)getData{
    SHOW_HUD
    __weak typeof(self)weakself = self;
    [HttpTool postWithAPI:@"magic/get_code" withParams:@{} success:^(id json) {
        HIDE_HUD
        NSLog(@"地区code =======  %@",json);
        if (ISPostSuccess) {
            weakself.countryCodeDic = json[@"data"][@"arr"];
            weakself.indexArr = [weakself.countryCodeDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString *  obj2) {
                return  [obj1 compare:obj2];
            }];
            [weakself.tableView reloadData];
        }else{
           [weakself showToastAlertMessageWithTitle:Error_Msg];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error : %@",error.description);
        [weakself showToastAlertMessageWithTitle:NOTCONNECT_STR];
    }];
   
}

- (void)dealloc{
    NSLog(@"释放了");
}
@end

//
//  JHAddCommunityVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAddCommunityVC.h"
#import "YFTextField.h"
#import "JHChooseCityCommunityVC.h"

@interface JHAddCommunityVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,copy)NSString *community_name;
@property(nonatomic,strong)NSMutableDictionary *infoDic;
@end

@implementation JHAddCommunityVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCommunity:) name:@"ChooseCommunity" object:nil];
    if (self.is_change) {
        self.community_name=self.model.xiaoqu_title;
        self.infoDic[@"xiaoqu_id"]=self.model.xiaoqu_id;
        self.infoDic[@"yezhu_id"]=self.model.yezhu_id;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController   setNavigationBarHidden:NO animated:YES];
}
#pragma mark ======搜索界面选择的小区=======
-(void)chooseCommunity:(NSNotification *)no{
    self.infoDic[@"xiaoqu_id"]=no.userInfo[@"xiaoqu_id"];
    self.community_name=no.userInfo[@"name"];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)setUpView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 240) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.scrollEnabled=NO;
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    
    if (self.is_change) self.navigationItem.title=@"修改小区";
    else self.navigationItem.title=@"申请入驻小区";
    self.view.backgroundColor=BACK_COLOR;
    [self creatRightTitleBtn:NSLocalizedString(@"保存", nil) titleColor:TEXT_COLOR sel:@selector(clickSave) edgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
}

#pragma mark ======点击保存=======
-(void)clickSave{
    [self.view resignFirstResponder];
    if (self.community_name.length==0) {
        [self showMsg:NSLocalizedString(@"请选择小区", nil)];
        return;
    }
    
    for (NSInteger i=1; i<6; i++) {
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *field=[cell viewWithTag:101];
       
        switch (i) {
            case 1:
            {
                if (field.text.length==0) {
                    [self showMsg:NSLocalizedString(@"请填写楼栋号", nil)];
                    return;
                }else{
//                    NSRange range = [field.text rangeOfString:NSLocalizedString(@"栋", nil)];
//                    NSMutableString *str = field.text.mutableCopy;
//                    [str replaceCharactersInRange:range withString:@""];
                  self.infoDic[@"house_louhao"]= field.text;
                }
            }
                break;
            case 2:
            {
                if (field.text.length==0) {
                    [self showMsg:NSLocalizedString(@"请填写单元号", nil)];
                    return;
                }else{
//                    NSRange range = [field.text rangeOfString:NSLocalizedString(@"单元", nil)];
//                    NSMutableString *str = field.text.mutableCopy;
//                    [str replaceCharactersInRange:range withString:@""];
                   self.infoDic[@"house_danyuan"]= field.text;
                }
            }
                break;
            case 3:
            {
                if (field.text.length==0) {
                    [self showMsg:NSLocalizedString(@"请填写户号", nil)];
                     return;
                }else self.infoDic[@"house_huhao"]=field.text;
            }
                break;
            case 4:
            {
                if (field.text.length==0) {
                    [self showMsg:NSLocalizedString(@"请填写联系人", nil)];
                     return;
                }else self.infoDic[@"contact"]=field.text;
            }
                break;
            case 5:
            {
                if (field.text.length==0) {
                    [self showMsg:NSLocalizedString(@"请填写手机号", nil)];
                    return;
                }else self.infoDic[@"mobile"]=field.text;
            }
                break;
                
            default:
                break;
        }
    }
    
    SHOW_HUD
    if (self.is_change) {
        [MineCommunityModel changeCommunityWithDic:[self.infoDic copy] block:^(NSArray *arr, NSString *msg) {
            HIDE_HUD
            if (arr) {
                [self showMsg:msg];
                if (self.successAdd)  self.successAdd();
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self clickBackBtn];
                });
            }else [self showMsg:msg];
        }];
    }else{
        [MineCommunityModel addCommunityWithDic:[self.infoDic copy] block:^(NSArray *arr, NSString *msg) {
            HIDE_HUD
            if (arr) {
                [self showMsg:msg];
                if (self.successAdd)  self.successAdd();
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self clickBackBtn];
                });
            }else [self showMsg:msg];
        }];
    }
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHAddCommunityCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UILabel *titleLab=[UILabel new];
        [cell.contentView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.top.offset=10;
            make.width.offset=60;
            make.height.offset=20;
        }];
        titleLab.font=FONT(14);
        titleLab.textColor=HEX(@"333333", 1.0);
        titleLab.textAlignment=NSTextAlignmentLeft;
        
        YFTextField *field=[YFTextField new];
        [cell.contentView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLab.mas_right).offset=0;
            make.top.offset=10;
            make.right.equalTo(cell.contentView.mas_right).offset=-10;
            make.height.offset=20;
        }];
        field.tag=101;
        field.delegate=self;
        field.textColor=HEX(@"333333", 1.0);
        field.placeholdeColor=HEX(@"999999", 1.0);
        field.placeholdeFont=12;
        NSString *str;
        switch (indexPath.row) {
            case 0:
                str=@"";
                titleLab.text=@"小区名";
                break;
            case 1:
                str=@"请输入楼栋号(如A10或10)";
                titleLab.text=@"楼栋号";
                break;
            case 2:
                str=@"请输入单元号(无单元号输入0)";
                titleLab.text=@"单元号";
                field.keyboardType=UIKeyboardTypeNumberPad;
                break;
            case 3:
                str=@"请输入门牌号(如102)";
                titleLab.text=@"门牌号";
                field.keyboardType=UIKeyboardTypeNumberPad;
                break;
            case 4:
                str=@"请输入联系人";
                titleLab.text=@"联系人";
                break;
            case 5:
                str=@"请输入手机号";
                titleLab.text=@"手机号";
                field.keyboardType=UIKeyboardTypeNumberPad;
                break;
            default:
                break;
        }
        field.placeholder=str;
        field.font=FONT(14);
        if (indexPath.row==0) {
            field.text=@"请选择小区";
            field.userInteractionEnabled=NO;
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 5, 10)];
            imgView.image=IMAGE(@"address_next");
            cell.accessoryView=imgView;
        }
    }
    
    if (self.is_change) {
        YFTextField *field=(YFTextField *)[cell viewWithTag:101];
        NSString *str;
        switch (indexPath.row) {
            case 0:
                str=self.model.xiaoqu_title;
                break;
            case 1:
                str=self.model.house_louhao;
                break;
            case 2:
                str=self.model.house_danyuan;
                break;
            case 3:
                str=self.model.house_huhao;
                break;
            case 4:
                str=self.model.contact;
                break;
            case 5:
                str=self.model.mobile;
                break;
            default:
                break;
        }
        field.text=str;
    }

    if (self.community_name.length>0 && indexPath.row==0) {
        YFTextField *field=(YFTextField *)[cell viewWithTag:101];
        field.text=self.community_name;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ======点击选择小区=======
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        JHChooseCityCommunityVC *choose=[[JHChooseCityCommunityVC alloc] init];
        choose.chooseCityCommunity=^(NSString *name,NSString *xiaoqu_id){
            self.community_name=name;
            self.infoDic[@"xiaoqu_id"]=xiaoqu_id;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:choose animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(NSMutableDictionary *)infoDic{
    if (_infoDic==nil) {
        _infoDic=[[NSMutableDictionary alloc] init];
    }
    return _infoDic;
}

#pragma mark - 收起键盘
-(void)touch_BackView{
   [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell1=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *houseField=[cell1 viewWithTag:101];
    UITableViewCell *cell2=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *unitField=[cell2 viewWithTag:101];
    
    UITableViewCell *cell3=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UITextField *menField=[cell3 viewWithTag:101];
    
    if(houseField.text.length != 0 && textField == houseField && ![textField.text containsString:NSLocalizedString(@"栋", nil)]){
        houseField.text = [NSString stringWithFormat:@"%@栋",houseField.text];
    }
    
    if(unitField.text.length != 0 && textField == unitField && ![unitField.text containsString:NSLocalizedString(@"单元", nil)]){
        unitField.text = [NSString stringWithFormat:@"%@单元",unitField.text];
    }
    
    if(textField == menField && menField.text.length != 0 && ![menField.text containsString:NSLocalizedString(@"室", nil)]){
        menField.text = [NSString stringWithFormat:@"%@室",menField.text];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view resignFirstResponder];
}

@end

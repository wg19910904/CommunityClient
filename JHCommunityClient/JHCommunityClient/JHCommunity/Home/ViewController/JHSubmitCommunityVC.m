//
//  JHSubmitCommunityVC.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSubmitCommunityVC.h"
#import "YFTextField.h"
#import "ChooseCityVC.h"
#import "MineCommunityModel.h"
#import "JHShareModel.h"

@interface JHSubmitCommunityVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *infoDic;
@end

@implementation JHSubmitCommunityVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    self.view.backgroundColor=BACK_COLOR;
    self.navigationItem.title=@"开通小区";
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 200) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    tableView.scrollEnabled=NO;
    [self creatRightTitleBtn:NSLocalizedString(@"提交", nil) titleColor:[UIColor whiteColor] sel:@selector(clickTiJiao) edgeInsets:UIEdgeInsetsMake(0, 20, 0, -10)];
}

#pragma mark ======提交小区=======
-(void)clickTiJiao{
    [self.view endEditing:YES];
    if ([self.infoDic[@"city_id"] length]==0) {
        [self showMsg:NSLocalizedString(@"请选择城市", nil)];
        return;
    }
    UITableViewCell *xiaoquCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    YFTextField *field=(YFTextField *)[xiaoquCell viewWithTag:100];
    if (field.text.length==0) {
        [self showMsg:NSLocalizedString(@"请填写小区", nil)];
        return;
    }else self.infoDic[@"title"]=field.text;
    
    UITableViewCell *contactCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    YFTextField *field2=(YFTextField *)[contactCell viewWithTag:100];
    if (field2.text.length==0) {
        [self showMsg:NSLocalizedString(@"请填写联系人", nil)];
        return;
    }else self.infoDic[@"contact"]=field2.text;
    
    UITableViewCell *mobileCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    YFTextField *field3=(YFTextField *)[mobileCell viewWithTag:100];
    if (field3.text.length==0) {
        [self showMsg:NSLocalizedString(@"请填写联系方式", nil)];
        return;
    }else self.infoDic[@"mobile"]=field3.text;
    
    SHOW_HUD
    [MineCommunityModel kaiTongCommunityWithDic:self.infoDic block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        if (arr) {
            [self showMsg:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([JHShareModel shareModel].communityModel) {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
                }else{
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }
            });
        }else [self showMsg:msg];
    }];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
        field.delegate=self;
        field.tag=100;
        field.textColor=HEX(@"333333", 1.0);
        field.placeholdeColor=HEX(@"999999", 1.0);
        field.placeholdeFont=12;
        NSString *str;
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                str=@"";
                titleLab.text=@"城市";
                field.text=@"请选择小区所在城市";
                field.userInteractionEnabled=NO;
                UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 5, 10)];
                imgView.image=IMAGE(@"address_next");
                cell.accessoryView=imgView;
            }else{
                titleLab.text=@"小区名";
                str=@"请填写小区完整名字";
            }
        }else{
            if (indexPath.row==0) {
                titleLab.text=@"联系人";
                str=@"请填写物业名称";
            }else{
                titleLab.text=@"联系方式";
                str=@"请填写您的联系方式";
                field.keyboardType=UIKeyboardTypeNumberPad;
            }
        }
        field.font=FONT(14);
        field.placeholder=str;
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==0) {
        ChooseCityVC *choose=[[ChooseCityVC alloc] init];
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        YFTextField *field=(YFTextField *)[cell viewWithTag:100];
        choose.chooseCity=^(NSString *cityName,NSString *city_id){
            field.text=cityName;
            self.infoDic[@"city_id"]=city_id;
        };
        [self.navigationController pushViewController:choose animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        view.backgroundColor=BACK_COLOR;
        UILabel *lab=[UILabel new];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.top.offset=10;
            make.width.offset=WIDTH-20;
            make.height.offset=20;
        }];
        lab.text=@"请您留下联系方式,我们会及时通知处理沟通";
        lab.textColor=HEX(@"333333", 1.0);
        lab.font=FONT(12);
        return view;
    }else return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0)  return CGFLOAT_MIN;
    else return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)clickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
    [self.view resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
}

-(void)touch_BackView{
     [self.view endEditing:YES];
}

@end

//
//  JHPublishUsedVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//发布二手

#import "JHPublishUsedVC.h"
#import "JHPublishIntroCell.h"
#import "JHPublishImgCell.h"
#import "YFTextView.h"
#import "JHPublishHeadLineCell.h"
#import "JHPublishUsedCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "SelectImageVC.h"
#import "JHChooseCommunityVC.h"
#import "CommunityHttpTool.h"
#import "JHNeighbourDetailVC.h"
#import "JHShareModel.h"
#import "JHBaseNavVC.h"
#define  space  (WIDTH - 105) / 4
@interface JHPublishUsedVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_publishUsedTableView;
    UIButton *_publishBnt;//发布按钮
    YFTextView *_intro;//发布的内容
    UIImagePickerController *_imagePicker;
    NSMutableArray *_imgArray;
    NSMutableArray *_imgDataArray;//作为参数
    UITextField *_headLine;//标题
    SelectImageVC *_selectImg;
    MineCommunityModel *_model;
    NSString *_title;//参数(用于请求数据)
    NSString *_price;//参数(用于请求数据)
    NSString *_mobile;//参数(用于请求数据)
    NSString *_house;//参数(用于请求数据)
    NSString *_name;//参数(用于请求数据)
    JHShareModel *_shareModel;
}
@end

@implementation JHPublishUsedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"发布二手", nil);
    [self initSubViews];
    [self createRightPublishButton];
    [self createPulishUsedTableView];
}
#pragma mark--===初始化子控件
- (void)initSubViews{
    _shareModel = [JHShareModel shareModel];
    _selectImg = [[SelectImageVC alloc] init];
    _imgArray = [@[] mutableCopy];
    _imgDataArray = [@[] mutableCopy];
    _intro = [[YFTextView alloc] initWithFrame:FRAME(0.5, 0.5, WIDTH - 32, 120)];
    _intro.maxCount=10000;
    _intro.hiddenCountLab=YES;
    _intro.textFont=14;
    _intro.placeholderColor=HEX(@"999999", 1.0f);
    _intro.placeholderFont=14;
    _intro.placeholderStr=@"描述你的宝贝";
}
#pragma mark--==创建右侧发布按钮
- (void)createRightPublishButton{
    _publishBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _publishBnt.frame = FRAME(0, 0, 44, 44);
    _publishBnt.titleLabel.font = FONT(14);
    _publishBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_publishBnt setTitle:NSLocalizedString(@"发布", nil) forState:0];
    [_publishBnt setTitleColor:TEXT_COLOR forState:0];
    [_publishBnt addTarget:self action:@selector(clickPublishButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_publishBnt];
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark--===发布按钮点击事件
- (void)clickPublishButton{
    NSLog(@"发布二手");
    [self getParamsData];
    if(_title.length == 0 || _title == nil){
        [self showAlertView:NSLocalizedString(@"标题没有写哦", nil)];
    }else if(_intro.inputText.length == 0 || _intro.inputText == nil){
        [self showAlertView:NSLocalizedString(@"描述你的宝贝哦", nil)];
    }else if (_price.length == 0 || _price == nil){
        [self showAlertView:NSLocalizedString(@"价格是多少呢?", nil)];
    }else if(_name.length == 0 || _name == nil){
        [self showAlertView:NSLocalizedString(@"还没有联系人呢?", nil)];
    }else if (_mobile.length == 0 || _mobile == nil){
        [self showAlertView:NSLocalizedString(@"电话多少呢?", nil)];
    }else{
      SHOW_HUD
        NSDictionary *dic = nil;
        if(_house.length == 0 || _house == nil){
            dic = @{@"from":@"trade",@"title":_title,@"content":_intro.inputText,@"mobile":_mobile,@"price":_price,@"yezhu_id":_shareModel.communityModel.yezhu_id,@"contact":_name};
        }else{
            dic = @{@"xiaoqu_id":_model.xiaoqu_id,@"from":@"trade",@"title":_title,@"content":_intro.inputText,@"mobile":_mobile,@"price":_price,@"yezhu_id":_shareModel.communityModel.yezhu_id,@"contact":_name};
        }
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        if(_imgDataArray.count != 0){
            for(int i = 0; i < _imgDataArray.count ; i++)
            {
                [dataDic setObject:_imgDataArray[i] forKey:[NSString stringWithFormat:@"photo%d",i + 1]];
            }
        }
        
        [CommunityHttpTool postWithAPI:@"client/xiaoqu/tieba/create" params:dic fromMoreDataDic:dataDic success:^(id json) {
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
//                JHNeighbourDetailVC *detail = [[JHNeighbourDetailVC alloc] init];
//                [self.navigationController pushViewController:detail animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.success)  self.success();
            }else{
                HIDE_HUD
                [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"发布二手失败,原因:%@", nil),json[@"message"]]];
            }

        } failure:^(NSError *error) {
            HIDE_HUD
            [self showNoNetOrBusy:YES];
        }];
    }
    
}
#pragma mark--===获取请求参数
- (void)getParamsData{
    JHPublishHeadLineCell *cell = [_publishUsedTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _title = cell.headLine.text;
    
    JHPublishUsedCell *cell1 = [_publishUsedTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    _price = cell1.introLabel.text;
    
    JHPublishUsedCell *cell2 = [_publishUsedTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    _name = cell2.introLabel.text;
    
    JHPublishUsedCell *cell3 = [_publishUsedTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    _mobile = cell3.introLabel.text;
    
    JHPublishUsedCell *cell4 = [_publishUsedTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    _house = cell4.introLabel.text;
    
}
#pragma mark--===创建发布邻里圈表视图
- (void)createPulishUsedTableView{
    _publishUsedTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    _publishUsedTableView.showsVerticalScrollIndicator = NO;
    _publishUsedTableView.delegate = self;
    _publishUsedTableView.dataSource = self;
    _publishUsedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACK_COLOR;
    _publishUsedTableView.backgroundView = view;
    [self.view addSubview:_publishUsedTableView];
}
#pragma mark--===UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
       return 3;
    else
        return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 0)
                return 50;
            else if(indexPath.row == 1)
                return 120;
            else
                return space + 30;
        }
            break;
        case 1:
        {
            return 50;
        }
            break;
  
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1)
        return 0.5;
    else
        return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        UILabel *label = [UILabel new];
        label.backgroundColor= LINE_COLOR;
        return label;
    }else
        return nil;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if(indexPath.row == 0){
                JHPublishHeadLineCell *cell = [[JHPublishHeadLineCell alloc] init];
                return cell;
            }else if(indexPath.row == 1){
                JHPublishIntroCell *cell = [[JHPublishIntroCell alloc] init];
                [cell.backView addSubview:_intro];
                return cell;
            }else{
                JHPublishImgCell *cell = [[JHPublishImgCell alloc] init];
                [cell.addImgBnt addTarget:self action:@selector(selectedImg) forControlEvents:UIControlEventTouchUpInside];
                __unsafe_unretained typeof(_publishUsedTableView)weakTableView = _publishUsedTableView;
                [cell setRefreshImgCellBlock:^(NSArray *imgArray, NSArray *imgDataArray) {
                    _imgArray = [imgArray mutableCopy];
                    _imgDataArray = [imgDataArray mutableCopy];
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                [cell setImgArray:_imgArray imgDataArray:_imgDataArray];
                return cell;
            }
        }
            break;
        case 1:{
            static NSString*identifier = @"introCell";
            JHPublishUsedCell *cell = [_publishUsedTableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil){
                cell = [[JHPublishUsedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.indexPath = indexPath;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row == 3){
        //选择小区
        JHPublishUsedCell *cell = [_publishUsedTableView cellForRowAtIndexPath:indexPath];
        JHChooseCommunityVC *choose = [[JHChooseCommunityVC alloc] init];
        choose.chooseCommunity = ^(MineCommunityModel *model){
           _model = model;
           cell.introLabel.text = model.xiaoqu_title;
        };
        JHBaseNavVC *navVC = [[JHBaseNavVC alloc] initWithRootViewController:choose];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
    }
}
#pragma mark--===选择图片
- (void)selectedImg{
    
    [_selectImg createImagePickerWithImgArray:_imgArray imgDataArray:_imgDataArray selectImgSuccessBlock:^(NSMutableArray *imgArray, NSMutableArray *imgDataArray) {
        _imgArray = imgArray;
        _imgDataArray = imgDataArray;
        __unsafe_unretained typeof(_publishUsedTableView)weakTableView = _publishUsedTableView;
        [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

@end

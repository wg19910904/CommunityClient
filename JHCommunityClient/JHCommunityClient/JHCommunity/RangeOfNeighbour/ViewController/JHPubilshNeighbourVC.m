//
//  JHPubilshNeighbourVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//发布邻里圈

#import "JHPubilshNeighbourVC.h"
 
#import "YFTextView.h"
#import "JHPublishImgCell.h"
#import "JHPublishIntroCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "SelectImageVC.h"
#import "JHChooseCommunityVC.h"
#import "CommunityHttpTool.h"
#import "JHNeighbourDetailVC.h"
#import "JHShareModel.h"
#import "JHBaseNavVC.h"
#define space (WIDTH - 105) / 4
@interface JHPubilshNeighbourVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_publishNeighbourTableView;
    UIButton *_publishBnt;//发布按钮
    YFTextView *_intro;//发布的内容
    NSMutableArray *_imgArray;
    NSMutableArray *_imgDataArray;//作为参数
    UITextField *_selectHouse;//勾选小区
    UILabel *_house;//所在小区
    UIImageView *_dirImg;//箭头
    SelectImageVC *_selectImg;
    MineCommunityModel *_model;
    JHShareModel *_shareModel;
}
@end

@implementation JHPubilshNeighbourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"发布邻里圈", nil);
    [self initSubViews];
    [self createRightPublishButton];
    [self createNeighbourTableView];
}
#pragma mark--===初始化子控件
- (void)initSubViews{
    _shareModel = [JHShareModel shareModel];
    _model = [[MineCommunityModel alloc] init];
     _selectImg = [[SelectImageVC alloc] init];
    _imgArray = [@[] mutableCopy];
    _imgDataArray = [@[] mutableCopy];
    _intro = [[YFTextView alloc] initWithFrame:FRAME(0.5, 0.5, WIDTH - 32, 120)];
    _intro.maxCount=10000;
    _intro.hiddenCountLab=YES;
    _intro.textFont=14;
    _intro.placeholderColor=HEX(@"999999", 1.0f);
    _intro.placeholderFont=14;
    _intro.placeholderStr=@"有什么新鲜事跟邻居说道说道";
    _house = [UILabel new];
    _house.frame = FRAME(15, 0, 60, 50);
    _house.font = FONT(15);
    _house.text = NSLocalizedString(@"所在小区", nil);
    _house.width=getSize(@"所在小区", 50, 15).width;
    _house.textColor = HEX(@"191a19", 1.0f);
    _selectHouse = [UITextField new];
    _selectHouse.frame = FRAME(90,0, WIDTH - _house.width, 50);
    _selectHouse.font = FONT(15);
    _selectHouse.textColor = HEX(@"191a19", 1.0f);
    _selectHouse.placeholder = NSLocalizedString(@"可勾选显示所在小区", nil);
    _selectHouse.userInteractionEnabled = NO;
    _dirImg = [UIImageView new];
    _dirImg.frame = FRAME(WIDTH - 23, 17.5, 8, 15);
    _dirImg.image = IMAGE(@"jiantou_1");
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
    NSLog(@"发布邻里圈");
    if(_intro.inputText.length == 0 || _intro.inputText == nil){
        [self showAlertView:NSLocalizedString(@"还没分享心情哦", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = nil;
        if(_selectHouse.text.length == 0){
            dic = @{@"from":@"topic",@"content":_intro.inputText,@"yezhu_id":_shareModel.communityModel.yezhu_id};
        }else{
            dic = @{@"from":@"topic",@"content":_intro.inputText,@"xiaoqu_id":_model.xiaoqu_id,@"yezhu_id":_shareModel.communityModel.yezhu_id};
        }
        
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        if(_imgDataArray.count != 0){
            for(int i = 0; i < _imgDataArray.count ; i++)
            {
                [dataDic setObject:_imgDataArray[i] forKey:[NSString stringWithFormat:@"photo%d",i + 1]];
            }
        }
        
        [CommunityHttpTool postWithAPI:@"client/xiaoqu/tieba/create" params:dic fromMoreDataDic:dataDic success:^(id json) {
            NSLog(@"%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
               HIDE_HUD
                [self.navigationController popViewControllerAnimated:YES];
                if (self.success)  self.success();
                
//                JHNeighbourDetailVC *detail = [[JHNeighbourDetailVC alloc] init];
//                [self.navigationController pushViewController:detail animated:YES];
            }else{
                HIDE_HUD
                [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"发布邻里圈失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showNoNetOrBusy:YES];
        }];
    }
}
#pragma mark--===创建发布邻里圈表视图
- (void)createNeighbourTableView{
    _publishNeighbourTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    _publishNeighbourTableView.showsVerticalScrollIndicator = NO;
    _publishNeighbourTableView.delegate = self;
    _publishNeighbourTableView.dataSource = self;
    _publishNeighbourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACK_COLOR;
    _publishNeighbourTableView.backgroundView = view;
    [self.view addSubview:_publishNeighbourTableView];
}
#pragma mark--====UITableViewDelegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 0)
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if(indexPath.row == 0){
                JHPublishIntroCell *cell = [[JHPublishIntroCell alloc] init];
                [cell.backView addSubview:_intro];
                return cell;
            }else{
                JHPublishImgCell *cell = [[JHPublishImgCell alloc] init];
                [cell.addImgBnt addTarget:self action:@selector(selectedImg) forControlEvents:UIControlEventTouchUpInside];
                __unsafe_unretained typeof(_publishNeighbourTableView)weakTableView = _publishNeighbourTableView;
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
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *topLine = [UILabel new];
            topLine.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:topLine];
            [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(WIDTH, 0.5));
                make.top.offset = 0;
                make.left.offset = 0;
            }];
            UILabel *bottomLine = [UILabel new];
            bottomLine.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(WIDTH, 0.5));
                make.bottom.offset = 0;
                make.left.offset = 0;
            }];
            [cell.contentView addSubview:_house];
            [cell.contentView addSubview:_dirImg];
            [cell.contentView addSubview:_selectHouse];
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row == 0){
        //选择小区
        JHChooseCommunityVC *choose = [[JHChooseCommunityVC alloc] init];
        choose.chooseCommunity = ^(MineCommunityModel *model){
            _model = model;
            _selectHouse.text = model.xiaoqu_title;
        };
        JHBaseNavVC *navVC = [[JHBaseNavVC alloc] initWithRootViewController:choose];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
    }
}

#pragma mark--===选择图片
- (void)selectedImg{
    
    [_selectImg createImagePickerWithImgArray:_imgArray imgDataArray:_imgDataArray selectImgSuccessBlock:^(NSMutableArray *imgArray, NSMutableArray *imgDataArray) {
        _imgDataArray = imgDataArray;
        _imgArray = imgArray;
        __unsafe_unretained typeof(_publishNeighbourTableView)weakTableView = _publishNeighbourTableView;
        [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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

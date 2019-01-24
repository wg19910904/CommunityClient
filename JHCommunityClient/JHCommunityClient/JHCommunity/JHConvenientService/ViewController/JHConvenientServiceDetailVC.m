//
//  JHConvenientServiceDetailVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHConvenientServiceDetailVC.h"
#import "NSObject+CGSize.h"
#import <Masonry/Masonry.h>
#import "JHConvenientServiceInformVC.h"
#import "JHPathMapVC.h"
#import "GaoDe_Convert_BaiDu.h"
@interface JHConvenientServiceDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_convenientServiceDetailTableView;
    UILabel *_title;//标题
    UILabel *_useNumber;//使用次数
    UILabel *_intro;//介绍
    UILabel *_mobile;//电话
    UILabel *_addr;//地址
    UIButton *_mobileBtn;//打电话按钮
    UIButton *_locationBtn;//坐标按钮
    CGSize _addSize;//地址尺寸
    CGSize _introSize;//介绍尺寸
}
@end

@implementation JHConvenientServiceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _dataModel.title;
    [self initSubViews];
    [self createConvenientServiceDetailTableView];
    [self createInformButton];
}
#pragma mark-====创建举报按钮
- (void)createInformButton{
    UIButton *informBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    informBtn.frame = FRAME(0,0,44, 44);
    informBtn.titleLabel.font = FONT(14);
    informBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [informBtn setTitle:NSLocalizedString(@"举报", nil) forState:UIControlStateNormal];
    [informBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [informBtn addTarget:self action:@selector(clickInformButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:informBtn];
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark--==举报按钮点击事件
- (void)clickInformButton{
    NSLog(@"举报了");
    JHConvenientServiceInformVC *inform = [[JHConvenientServiceInformVC alloc] init];
    inform.bianmin_id = _dataModel.bianmin_id;
    [self.navigationController pushViewController:inform animated:YES];
}
#pragma mark--==初始化子视图
- (void)initSubViews{
    _title = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 30, 16)];
    _title.font = FONT(16);
    _title.textColor = HEX(@"191a19", 1.0f);
    _title.text = _dataModel.title;
    _useNumber = [[UILabel alloc] initWithFrame:FRAME(15, 39, WIDTH - 30, 14)];
    _useNumber.font = FONT(12);
    _useNumber.textColor = HEX(@"666666", 1.0f);
    _useNumber.text = [NSString  stringWithFormat:@"%@次使用",_dataModel.views];
    
    _intro = [[UILabel alloc] init];
    _intro.font = FONT(14);
    _intro.numberOfLines = 0;
    _intro.textColor = HEX(@"333333", 1.0f);
    _intro.text = _dataModel.intro;
    _introSize = [self currentSizeWithString:_intro.text font:FONT(14) withWidth:25];
    _intro.frame = FRAME(15, 48, _introSize.width , _introSize.height);
    
    
    _mobile = [[UILabel alloc] initWithFrame:FRAME(15,15, WIDTH - 60, 16)];
    _mobile.textColor = HEX(@"333333", 1.0f);
    _mobile.font = FONT(14);
    _mobile.text = _dataModel.phone;
    
    _mobileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mobileBtn.frame = FRAME(WIDTH - 35, 0, 35, 40);
    _mobileBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 15);
    [_mobileBtn setImage:IMAGE(@"neighbourhood_dial") forState:UIControlStateNormal];
    [_mobileBtn setImage:IMAGE(@"neighbourhood_dial") forState:UIControlStateHighlighted];
    [_mobileBtn setImage:IMAGE(@"neighbourhood_dial") forState:UIControlStateSelected];
    [_mobileBtn addTarget:self action:@selector(clickMobileButton) forControlEvents:UIControlEventTouchUpInside];
    
    _addr = [[UILabel alloc] init];
    _addr.numberOfLines = 0;
    _addr.textColor = HEX(@"3333333",1.0f);
    _addr.font = FONT(14);
    _addr.text = _dataModel.addr;
    _addSize = [self currentSizeWithString:_addr.text font:FONT(14) withWidth:50];
    _addr.frame = FRAME(15, 10, WIDTH - 60, _addSize.height);
    
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.frame = FRAME(WIDTH - 35, 0, 35, 20 + _addSize.height);
    _locationBtn.imageEdgeInsets = UIEdgeInsetsMake(_addSize.height / 2, 0, _addSize.height / 2, 15);
    [_locationBtn setImage:IMAGE(@"serve_position") forState:UIControlStateNormal];
    [_locationBtn setImage:IMAGE(@"serve_position") forState:UIControlStateHighlighted];
    [_locationBtn setImage:IMAGE(@"serve_position") forState:UIControlStateSelected];
    [_locationBtn addTarget:self action:@selector(clickLocationButton) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark--===电话按钮点击事件
- (void)clickMobileButton{
    NSLog(@"打电话啦");
    [self showMobile:_dataModel.phone];
}
#pragma mark--==坐标按钮点击事件
- (void)clickLocationButton{
    JHPathMapVC *pathMap = [[JHPathMapVC alloc] init];
    double gaoLat = 0.0;
    double gaoLng = 0.0;
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[_dataModel.lat doubleValue] WithBD_lon:[_dataModel.lng doubleValue] WithGD_lat:&gaoLat WithGD_lon:&gaoLng];
    pathMap.lat = @(gaoLat).stringValue;
    pathMap.lng = @(gaoLng).stringValue;
    pathMap.shopName =_dataModel.title;
    pathMap.shopAddr = _dataModel.addr;
    [self.navigationController pushViewController:pathMap animated:YES];
    
}
#pragma mark--==初始化创建便民服务详情视图
- (void)createConvenientServiceDetailTableView{
    if(_convenientServiceDetailTableView == nil){
        _convenientServiceDetailTableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
        _convenientServiceDetailTableView.delegate = self;
        _convenientServiceDetailTableView.dataSource = self;
        _convenientServiceDetailTableView.showsVerticalScrollIndicator = NO;
        _convenientServiceDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BACK_COLOR;
        _convenientServiceDetailTableView.backgroundView = view;
        [self.view addSubview:_convenientServiceDetailTableView];
    }else{
        [_convenientServiceDetailTableView reloadData];
    }
}
#pragma mark--======UITableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
       if(indexPath.row == 0)
           return 60;
        else
            return 63 + _introSize.height;
    }else{
        if (indexPath.row == 0)
            return 46;
        else
            return 20 + _addSize.height;
            
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 0){
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_title];
                [cell.contentView addSubview:_useNumber];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *line = [UIView new];
                line.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset = 0;
                    make.width.offset = WIDTH;
                    make.bottom.offset = 0;
                    make.height.offset = 0.5;
                }];
                return cell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *title = [UILabel new];
                [cell.contentView addSubview:title];
                [title mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset = 15;
                    make.top.offset = 15;
                    make.width.offset = WIDTH - 30;
                    make.height.offset = 14;
                }];
                title.font = FONT(14);
                title.textColor = HEX(@"666666", 1.0f);
                title.text = NSLocalizedString(@"相关介绍", nil);
                [cell.contentView addSubview:_intro];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *line = [UIView new];
                [cell.contentView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset = 0;
                    make.width.offset = WIDTH;
                    make.bottom.offset = 0;
                    make.height.offset = 0.5;
                }];
                line.backgroundColor = LINE_COLOR;
                return cell;
            }
        }
            break;
        case 1:
        {
            if(indexPath.row == 0){
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_mobile];
                [cell.contentView addSubview:_mobileBtn];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *line = [UIView new];
                [cell.contentView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset = 0;
                    make.width.offset = WIDTH;
                    make.bottom.offset = 0;
                    make.height.offset = 0.5;
                }];
                line.backgroundColor = LINE_COLOR;
                return cell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_addr];
                [cell.contentView addSubview:_locationBtn];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                UIView *line = [UIView new];
                [cell.contentView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset = 0;
                    make.width.offset = WIDTH;
                    make.bottom.offset = 0;
                    make.height.offset = 0.5;
                }];
                line.backgroundColor = LINE_COLOR;
                return cell;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}
@end

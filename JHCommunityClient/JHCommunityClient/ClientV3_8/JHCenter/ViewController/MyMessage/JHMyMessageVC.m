//
//  JHMyMessageVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/18.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMyMessageVC.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+NetStatus.h"
 
#import "JHChangeNameVC.h"
#import "MemberInfoModel.h"
#import <MJRefresh.h>

@interface JHMyMessageVC ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate>{
    UITableView *_tableView;
    MJRefreshNormalHeader *_header;
    UIImagePickerController *_imagePicker;
    UIImageView *_iconImg;//头像
    UIImage *_img;
    UILabel *_nameLabel;//用户名
    MemberInfoModel *_infoModel;
    BOOL _isFirst;
}

@end

@implementation JHMyMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
self.title = NSLocalizedString(@"个人信息", nil);
    [self createTableView];
    [self initSubViews];
    [self loadData];
}
- (void)initSubViews{
    _infoModel = [MemberInfoModel shareModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelChangeNameTap) name:@"changeName" object:nil];

    _iconImg = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];

    _imagePicker = [[UIImagePickerController alloc] init];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark-======修改昵称手势取消========
- (void)cancelChangeNameTap{
    _isFirst = YES;
    [self loadData];
}
#pragma mark--==处理数据
- (void)handleData{

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]){
        _nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"imageData"]){
        _iconImg.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageData"]];
    }
}
- (void)loadData{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/v3/member/member/info" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            [_infoModel setValuesForKeysWithDictionary:json[@"data"]];
            [_tableView.mj_header endRefreshing];
            [self createTableView];
            HIDE_HUD
            NSData * data = UIImagePNGRepresentation(_img);
            [UserDefaults setObject:data forKey:@"imageData"];
        }else{
            [_tableView.mj_header endRefreshing];
            [self createTableView];
            [self handleData];
            HIDE_HUD
            [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"数据更新失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        [self createTableView];
        [self handleData];
        [_tableView.mj_header endRefreshing];
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showMsg:error.localizedDescription];
    }];
}
#pragma mark===创建表视图====
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT- NAVI_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = BACK_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [_tableView addSubview:thread];
    }else{
        [_tableView reloadData];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(20, 15, 200, 10)];
        label.text = @"头像";
        label.font = FONT(15);
        label.textColor = HEX(@"333333", 1.0f);
        [cell.contentView addSubview:label];
        
        _iconImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 100, 6, 38, 38)];
        _iconImg.layer.cornerRadius = _iconImg.frame.size.width/2;
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
        _iconImg.layer.masksToBounds = YES;
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:_infoModel.face] placeholderImage:[UIImage imageNamed:@"loginheader"]];
        [cell.contentView addSubview:_iconImg];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [cell.contentView addSubview:thread];
        return cell;
        
        
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(20, 15, 100, 10)];
        label.text = @"昵称";
        label.font = FONT(15);
        label.textColor = HEX(@"333333", 1.0f);
        [cell.contentView addSubview:label];
        
        _nameLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 200, 15, 140, 15)];
        _nameLabel.textColor = HEX(@"666666", 1.0f);
        _nameLabel.font = FONT(14);
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.text= _infoModel.nickname;
        [cell.contentView addSubview:_nameLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
        thread.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [cell.contentView addSubview:thread];
        return cell;
    }
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消了");
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self imageFromCamera];
        }];
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从手机相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self imageFromAlbum];
        }];
        [alertController addAction:deleteAction];
        [alertController addAction:archiveAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        if(_isFirst){
            
        }else{
        JHChangeNameVC *changeName = [[JHChangeNameVC alloc] init];
        changeName.nick_name = _nameLabel.text;
        [self.navigationController pushViewController:changeName animated:YES];
        
        }
    }
    
    
}
#pragma mark=========相册中选择=========
- (void)imageFromAlbum{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.navigationBar.barTintColor = THEME_COLOR;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma mark=========打开相机=========
- (void)imageFromCamera{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma  mark - 这是UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"哈哈");
}
#pragma  mark=======选择照片================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.allowsEditing) {
        _img = [info objectForKey:UIImagePickerControllerEditedImage];
        
    }else{
        _img = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    _img = [self scaleFromImage:_img scaledToSize:CGSizeMake(180, 180)];
    NSData * data = UIImagePNGRepresentation(_img);
    NSDictionary * dic = @{@"face":data};
    [HttpTool postWithAPI:@"client/v3/member/member/updateface" params:@{} dataDic:dic success:^(id json) {
        NSLog(@"json%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            _iconImg.image = _img;
            NSArray *indeth = @[[NSIndexPath indexPathForRow:0 inSection:0]];
            [_tableView reloadRowsAtIndexPaths:indeth withRowAnimation: UITableViewRowAnimationNone];
            [self showMsg:NSLocalizedString(@"上传头像成功", nil)];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"imageData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"上传头像失败,原因:%@", nil),json[@"message"]]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [self showMsg:error.localizedDescription];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片
- (UIImage*)scaleFromImage:(UIImage*)img scaledToSize:(CGSize)newSize{
    CGSize imageSize = img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= newSize.width && height <= newSize.height){
        return img;
    }
    if (width == 0 || height == 0){
        return img;
    }
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    [img drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark===============点击取消调用========
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)showAlertView:(NSString *)title{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeName" object:nil];
}
@end

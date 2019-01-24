//
//  JHHouseKeepingSubCateVc.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//分类按钮视图

#import "JHMaintainSubCateVc.h"
#import "JHMaintainCateCell.h"
#import "MaintainHomeCateModel.h"
 
#import "MBProgressHUD.h"
#import "MaintainHomeCateProductModel.h"
#import "NSObject+CGSize.h"
#import <UIImageView+WebCache.h>
@interface JHMaintainSubCateVc ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_leftTabelView;
    UITableView *_rightTabelView;
    NSMutableArray *_leftDataArray;
    NSMutableArray *_rightDataArray;
}
@end

@implementation JHMaintainSubCateVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT - (NAVI_HEIGHT+40));
    self.view.backgroundColor = HEX(@"000000", 0.3);
    _leftDataArray = [NSMutableArray array];
    _rightDataArray = [NSMutableArray array];
    [self createTableView];
    [self requestData];
}
#pragma mark====加载数据========
- (void)requestData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/weixiu/cate" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            HIDE_HUD
            NSArray *items = json[@"data"][@"items"];
            NSLog(@"%@",items);
            for(NSDictionary *dic in items)
            {
                MaintainHomeCateModel *cateModel = [[MaintainHomeCateModel alloc] init];
                [cateModel setValuesForKeysWithDictionary:dic];
                for(NSDictionary *dicc in cateModel.products)
                {
                    MaintainHomeCateProductModel *productModel = [[MaintainHomeCateProductModel alloc] init];
                    [productModel setValuesForKeysWithDictionary:dicc];
                    [cateModel.productArray addObject:productModel];
                    NSLog(@"%@",cateModel.productArray);
                }
                [_leftDataArray addObject:cateModel];
            }
            NSLog(@"%@",_leftDataArray);
            [self createTableView];
        }
        else
        {
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"加载数据失败,原因:", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];

}
#pragma mark======创建表视图============
- (void)createTableView
{
    if(_leftTabelView == nil){
        _leftTabelView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH / 5 * 2,360) style:UITableViewStylePlain];
        _leftTabelView.delegate = self;
        _leftTabelView.dataSource = self;
        _leftTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTabelView.showsVerticalScrollIndicator = NO;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        _leftTabelView.backgroundView = view;
        [self.view addSubview:_leftTabelView];
    }else{
        [_leftTabelView reloadData];
    }
    
    if(_rightTabelView == nil){
        _rightTabelView = [[UITableView alloc] initWithFrame:FRAME(WIDTH / 5 * 2, 0, WIDTH / 5 * 3, 360) style:UITableViewStylePlain];
        _rightTabelView.delegate = self;
        _rightTabelView.dataSource = self;
        _rightTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTabelView.showsVerticalScrollIndicator = NO;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
;
        _rightTabelView.backgroundView = view;
        [self.view addSubview:_rightTabelView];
    }else{
        [_rightTabelView reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _leftTabelView){
        NSLog(@"%ld",(unsigned long)_leftDataArray.count);
        return _leftDataArray.count + 1;
    }else
        return _rightDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _leftTabelView)
    {
        static NSString *identifier = @"leftCell";
        JHMaintainCateCell *cell = [_leftTabelView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[JHMaintainCateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(indexPath.row == 0){
            cell.titleLbel.text = NSLocalizedString(@"全部分类", nil);
            cell.iconImg.image = IMAGE(@"all");
            cell.dirImg.hidden = YES;
        }else{
            MaintainHomeCateModel *cateModel = _leftDataArray[indexPath.row - 1];
            cell.titleLbel.text = cateModel.title;
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:cateModel.icon]] placeholderImage:IMAGE(@"shop_cate_default")];
        }
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH / 5 * 3 - 45, 40)];
        titleLabel.font = FONT(12);
        titleLabel.textColor = HEX(@"333333", 1.0f);
        //        if ([[_selectRowDic allKeys] containsObject:@"rightRow"] &&
        //            indexPath.row == [_selectRowDic[@"rightRow"] integerValue]) {
        //            titleLabel.textColor = THEME_COLOR;
        //        }
        titleLabel.text = [_rightDataArray[indexPath.row] title];
        titleLabel.tag = 100;
        UIImageView *dirImg = [[UIImageView alloc] init];
        dirImg.image = IMAGE(@"selected-0");
        dirImg.tag = 200;
        [cell.contentView addSubview:dirImg];
        [dirImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.size.mas_equalTo(CGSizeMake(15,10));
            make.top.offset = 15;
        }];
        dirImg.hidden = YES;
        //添加下边线
        UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH / 5 * 3, 0.5)];
        line.backgroundColor = LINE_COLOR;
        if(indexPath.row != 0){
            [cell.contentView addSubview:line];
        }
        [cell addSubview:titleLabel];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _leftTabelView){
        JHMaintainCateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(indexPath.row == 0){
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
            NSDictionary *dic = @{@"name":@"cate",@"title":NSLocalizedString(@"全部分类", nil),@"cate_id":@""};
            [[NSNotificationCenter  defaultCenter] postNotificationName:@"updateMaintainList" object:nil userInfo:dic];
            _rightDataArray = @[].mutableCopy;
            [_rightTabelView reloadData];
        }else{
            _rightDataArray = [_leftDataArray[indexPath.row - 1] productArray];
            [_rightTabelView reloadData];
            cell.dirImg.hidden = YES;
        }
        cell.titleLbel.textColor = THEME_COLOR;
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *dirImg = [cell.contentView viewWithTag:200];
        dirImg.hidden = NO;
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        NSDictionary *dic = @{@"name":@"cate",@"title":[_rightDataArray[indexPath.row] title],@"cate_id":[_rightDataArray[indexPath.row] cate_id]};
        [[NSNotificationCenter  defaultCenter] postNotificationName:@"updateMaintainList" object:nil userInfo:dic];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _leftTabelView){
        JHMaintainCateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.titleLbel.textColor = HEX(@"333333", 1.0f);
        cell.dirImg.hidden = NO;
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
        titleLabel.textColor = HEX(@"333333", 1.0f);
        UIImageView *dirImg = [cell.contentView viewWithTag:200];
        dirImg.hidden =  YES;
    }
}
- (void)touch_BackView
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"updateMaintainList" object:nil userInfo:@{}];
    
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
